{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Disk Detection Part                     }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Disk;

interface

uses
  MSI_Common, SysUtils, Windows, Classes, MiTeC_Routines;

type
  TDisk = class(TPersistent)
  private
    FDisk: TDiskSign;
    {$IFNDEF D6PLUS}
    FMediaPresent: Boolean;
    {$ENDIF}
    FDriveType: TMediaType;
    FSectorsPerCluster: DWORD;
    FBytesPerSector: DWORD;
    FFreeClusters: DWORD;
    FTotalClusters: DWORD;
    FFileFlags: TFileFlags;
    FVolumeLabel: string;
    FSerialNumber: string;
    FFileSystem: string;
    FFreeSpace: int64;
    FCapacity: int64;
    FAvailDisks: string;
    FSerial: dword;
    FModes: TExceptionModes;
    function GetMediaPresent: Boolean;
    procedure SetMode(const Value: TExceptionModes);
  protected
    procedure SetDisk(const Value: TDiskSign);
  public
    constructor Create;
    procedure GetInfo;
    procedure GetFileFlagsStr(var AFileFlags :TStringList);
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
    function GetCD :byte;
    function GetMediaTypeStr(MT: TMediaType): string;
    property Serial :dword read FSerial {$IFNDEF D6PLUS} write FSerial {$ENDIF} stored false;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property Drive :TDiskSign read FDisk Write SetDisk stored false;
    property AvailableDisks :string read FAvailDisks {$IFNDEF D6PLUS} write FAvailDisks {$ENDIF} stored false;
    property MediaPresent :Boolean read GetMediaPresent {$IFNDEF D6PLUS} write FMediaPresent {$ENDIF} stored false;
    property MediaType :TMediaType read FDriveType {$IFNDEF D6PLUS} write FDriveType {$ENDIF} stored false;
    property FileFlags :TFileFlags read FFileFlags {$IFNDEF D6PLUS} write FFileFlags {$ENDIF} stored false;
    property FileSystem :string read FFileSystem {$IFNDEF D6PLUS} write FFileSystem {$ENDIF} stored false;
    property FreeClusters :DWORD read FFreeClusters {$IFNDEF D6PLUS} write FFreeClusters {$ENDIF} stored false;
    property TotalClusters :DWORD read FTotalClusters {$IFNDEF D6PLUS} write FTotalClusters {$ENDIF} stored false;
    // FreeSpace and Capacity returns good results for Win95 OSR2, Win98, NT and 2000
    // for Win95 there can be bad sizes for drives over 2GB
    property FreeSpace :int64 read FFreeSpace {$IFNDEF D6PLUS} write FFreeSpace {$ENDIF} stored false;
    property Capacity :int64 read FCapacity {$IFNDEF D6PLUS} write FCapacity {$ENDIF} stored false;
    property SerialNumber :string read FSerialNumber {$IFNDEF D6PLUS} write FSerialNumber {$ENDIF} stored false;
    property VolumeLabel :string read FVolumeLabel {$IFNDEF D6PLUS} write FVolumeLabel {$ENDIF} stored false;
    property SectorsPerCluster :DWORD read FSectorsPerCluster {$IFNDEF D6PLUS} write FSectorsPerCluster {$ENDIF} stored false;
    property BytesPerSector :DWORD read FBytesPerSector {$IFNDEF D6PLUS} write FBytesPerSector {$ENDIF} stored false;
  end;

implementation

{ TDisk }

function TDisk.GetCD: byte;
var
  i :integer;
  root :pchar;
begin
  result:=0;
  root:=stralloc(255);
  for i:=1 to length(FAvailDisks) do begin
    strpcopy(root,copy(FAvailDisks,i,1)+':\');
    if getdrivetype(root)=drive_cdrom then begin
      result:=i;
      break;
    end;
  end;
  strdispose(root);
end;

procedure TDisk.GetFileFlagsStr;
begin
  with AFileFlags do begin
    Add(Format('Case Is Preserved=%d',[integer(fsCaseIsPreserved in FileFlags)]));
    Add(Format('Case Sensitive=%d',[integer(fsCaseSensitive in FileFlags)]));
    Add(Format('Unicode stored On Disk=%d',[integer(fsUnicodeStoredOnDisk in FileFlags)]));
    Add(Format('Persistent Acls=%d',[integer(fsPersistentAcls in FileFlags)]));
    Add(Format('File Compression=%d',[integer(fsFileCompression in FileFlags)]));
    Add(Format('Volume Is Compressed=%d',[integer(fsVolumeIsCompressed in FileFlags)]));
    Add(Format('Long Filenames=%d',[integer(fsLongFileNames in FileFlags)]));
    Add(Format('Encrypted File System Support=%d',[integer(fsEncryptedFileSystemSupport in FileFlags)]));
    Add(Format('Object IDs Support=%d',[integer(fsObjectIDsSupport in FileFlags)]));
    Add(Format('Reparse Points Support=%d',[integer(fsReparsePointsSupport in FileFlags)]));
    Add(Format('Sparse Files Support=%d',[integer(fsSparseFilesSupport in FileFlags)]));
    Add(Format('Disk Quotas Support=%d',[integer(fsDiskQuotasSupport in FileFlags)]));
  end;
end;

procedure TDisk.GetInfo;
var
  i,n :integer;
  buf :pchar;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  buf:=stralloc(255);
  n:=GetLogicalDriveStrings(255,buf);
  FAvailDisks:='';
  for i:=0 to n do
    if buf[i]<>#0 then begin
      if (ord(buf[i]) in [$41..$5a]) or (ord(buf[i]) in [$61..$7a]) then
        FAvailDisks:=FAvailDisks+upcase(buf[i])
    end else
      if buf[i+1]=#0 then
        break;
  strdispose(buf);

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;


function TDisk.GetMediaPresent :Boolean;
begin
  Result:=MiTeC_Routines.GetMediaPresent(FDisk);
end;

procedure TDisk.Report;
var
  i :integer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<Disk classname="TDisk">');

    Add(Format('<data name="AvailableLogicalDisks" type="string">%s</data>',[AvailableDisks]));
    for i:=1 to Length(AvailableDisks) do begin
      SetDisk(copy(AvailableDisks,i,1)+':');
      Add(Format('<section name="Disk_%s">',[copy(AvailableDisks,i,1)]));
      Add(Format('<data name="VolumeLabel" type="string">%s</data>',[CheckXMLValue(VolumeLabel)]));
      Add(Format('<data name="FileSystem" type="string">%s</data>',[FileSystem]));
      Add(Format('<data name="Type" type="string">%s</data>',[CheckXMLValue(GetMediaTypeStr(MediaType))]));
      Add(Format('<data name="UNC" type="string">%s</data>',[CheckXMLValue(ExpandUNCFilename(Drive))]));
      Add(Format('<data name="SerialNumber" type="string">%s</data>',[SerialNumber]));
      Add(Format('<data name="Capacity" type="integer" unit="B">%d</data>',[Self.Capacity]));
      Add(Format('<data name="FreeSpace" type="integer" unit="B">%d</data>',[FreeSpace]));
      Add(Format('<data name="BytesPerSector" type="integer">%d</data>',[BytesPerSector]));
      Add(Format('<data name="SectorsPerCluster" type="integer">%d</data>',[SectorsPerCluster]));
      Add(Format('<data name="FreeClusters" type="integer">%d</data>',[FreeClusters]));
      Add(Format('<data name="TotalClusters" type="integer">%d</data>',[TotalClusters]));
      Add('<section name="Flags">');
      Add(Format('<data name="CaseIsPreserved" type="boolean">%d</data>',[integer(fsCaseIsPreserved in FileFlags)]));
      Add(Format('<data name="CaseSensitive" type="boolean">%d</data>',[integer(fsCaseSensitive in FileFlags)]));
      Add(Format('<data name="UnicodeStoredOnDisk" type="boolean">%d</data>',[integer(fsUnicodeStoredOnDisk in FileFlags)]));
      Add(Format('<data name="PersistentACLs" type="boolean">%d</data>',[integer(fsPersistentAcls in FileFlags)]));
      Add(Format('<data name="FileCompression" type="boolean">%d</data>',[integer(fsFileCompression in FileFlags)]));
      Add(Format('<data name="VolumeIsCompressed" type="boolean">%d</data>',[integer(fsVolumeIsCompressed in FileFlags)]));
      Add(Format('<data name="LongFilenames" type="boolean">%d</data>',[integer(fsLongFileNames in FileFlags)]));
      Add(Format('<data name="EncryptedFileSystemSupport" type="boolean">%d</data>',[integer(fsEncryptedFileSystemSupport in FileFlags)]));
      Add(Format('<data name="ObjectODsSupport" type="boolean">%d</data>',[integer(fsObjectIDsSupport in FileFlags)]));
      Add(Format('<data name="ReparsePointsSupport" type="boolean">%d</data>',[integer(fsReparsePointsSupport in FileFlags)]));
      Add(Format('<data name="SparseFilesSupport" type="boolean">%d</data>',[integer(fsSparseFilesSupport in FileFlags)]));
      Add(Format('<data name="DiskQuotasSupport" type="boolean">%d</data>',[integer(fsDiskQuotasSupport in FileFlags)]));
      Add('</section>');
      Add('</section>');
    end;

    Add('</Disk>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TDisk.SetDisk(const Value: TDiskSign);
var
  DI: TDiskInfo;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'SetDisk');{$ENDIF}

  FDisk:=Value;
  DI:=GetDiskInfo(Value);
  FDriveType:=DI.MediaType;
  FFileFlags:=DI.FileFlags;
  FCapacity:=DI.Capacity;
  FFreeSpace:=DI.FreeSpace;
  FBytesPerSector:=DI.BytesPerSector;
  FTotalClusters:=DI.TotalClusters;
  FFreeClusters:=DI.FreeClusters;
  FSectorsPerCluster:=DI.SectorsPerCluster;
  FVolumeLabel:=DI.VolumeLabel;
  FFileSystem:=DI.FileSystem;
  FSerialNumber:=DI.SerialNumber;
  FSerial:=DI.Serial;

  {$IFDEF ERROR_INTERCEPT}PopTrace; {$ENDIF}
end;



function TDisk.GetMediaTypeStr(MT: TMediaType): string;
begin
  case MT of
    dtUnknown     :result:='<unknown>';
    dtNotExists   :result:='<not exists>';
    dtRemovable   :result:='Removable';
    dtFixed       :result:='Fixed';
    dtRemote      :result:='Remote';
    dtCDROM       :result:='CDROM';
    dtRAMDisk     :result:='RAM';
  end;
end;

procedure TDisk.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

constructor TDisk.Create;
begin
  ExceptionModes:=[emExceptionStack];
end;

end.
