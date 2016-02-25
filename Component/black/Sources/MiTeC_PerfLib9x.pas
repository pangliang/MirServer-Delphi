{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{           Performance Library for Win9x               }
{           version 7.0 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2002 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_PerfLib9x;

interface

uses Windows, Classes, SysUtils, Registry;

type
  TPerfLib9x = class(TPersistent)
  private
    FActive   : Boolean;
    FRegistry : TRegistry;
    FCounters: TStringList;
    function GetSysData(Key: string): Integer;
    function GetSysDataDesc(Key: string): string;
    function GetSysDataName(Key: string): string;
    function GetSysDataDiff(Key: string): boolean;
    procedure GetSysCounters;
  public
    procedure Open;
    procedure Close;
    constructor Create;
    destructor Destroy; override;
    property Names: TStringList read FCounters;
    property SysData[Key: string]: Integer read GetSysData;
    property SysDataDesc[Key: string]: string read GetSysDataDesc;
    property SysDataName[Key: string]: string read GetSysDataName;
    property SysDataDiff[Key: string]: boolean read GetSysDataDiff;
    property Active: Boolean read FActive;
  end;

const
  cPerfIndex95 = {HKEY_LOCAL_MACHINE\}'System\CurrentControlSet\Control\PerfStats\Enum';
  cPerfData95 = {HKEY_DYN_DATA\}'PerfStats\StatData';
  cPerfStart95 = {HKEY_DYN_DATA\}'PerfStats\StartStat';
  cPerfStop95 = {HKEY_DYN_DATA\}'PerfStats\StopStat';

implementation

{ TPerfLib9x }

procedure TPerfLib9x.Close;
var
  KeysList : TStringList;
  i        : Integer;
  Dummy    : Integer;
begin
  if (FActive) then
    with FRegistry do begin
      RootKey := HKEY_DYN_DATA;
      if OpenKeyReadOnly(cPerfStop95) then begin
        KeysList := TStringList.Create;
        try
          GetValueNames(KeysList);
          for i:=0 to KeysList.Count-1 do
            ReadBinaryData(KeysList.Strings[i], Dummy, 4);
        finally
          KeysList.Free;
        end;
        FActive := False;
        CloseKey;
      end;
    end;
end;

constructor TPerfLib9x.Create;
begin
  FActive:=False;
  FRegistry:=TRegistry.Create;
  FCounters:=TStringList.Create;
  GetSysCounters;
end;

destructor TPerfLib9x.Destroy;
begin
  Close;
  FRegistry.Free;
  FCounters.Free;
  inherited;
end;

procedure TPerfLib9x.GetSysCounters;
begin
  with FRegistry do begin
    RootKey := HKEY_DYN_DATA;
    if OpenKeyReadOnly(cPerfData95) then begin
      GetValueNames(FCounters);
      CloseKey;
    end else
      raise Exception.Create('Error opening key: '+cPerfData95);
  end;
end;

function TPerfLib9x.GetSysData(Key: string): Integer;
begin
  with FRegistry do begin
    RootKey := HKEY_DYN_DATA;
    if OpenKeyReadOnly(cPerfData95) then begin
      ReadBinaryData(Key, Result, 4);
      CloseKey;
    end else
      raise Exception.Create('Error opening key: '+Key);
  end;
end;

function TPerfLib9x.GetSysDataDesc(Key: string): string;
var
  akey,avalue :string;
  p :integer;
begin
  with FRegistry do begin
    RootKey := HKEY_LOCAL_MACHINE;
    p:=pos('\',key);
    if p>0 then begin
      akey:=cPerfIndex95+'\'+copy(key,1,p-1)+'\'+copy(key,p+1,255);
      avalue:='Description';
    end else begin
      akey:=cPerfIndex95+'\'+key;
      avalue:='Name';
    end;
    if OpenKeyReadOnly(akey) then begin
      result:=ReadString(avalue);
      CloseKey;
    end else
      raise Exception.Create('Error opening key: '+Key);
  end;
end;

function TPerfLib9x.GetSysDataDiff(Key: string): boolean;
var
  akey,avalue :string;
  p :integer;
begin
  with FRegistry do begin
    RootKey := HKEY_LOCAL_MACHINE;
    p:=pos('\',key);
    if p>0 then begin
      akey:=cPerfIndex95+'\'+copy(key,1,p-1)+'\'+copy(key,p+1,255);
      avalue:='Differentiate';
      if OpenKeyReadOnly(akey) then begin
        if ReadString(avalue)='TRUE' then
          result:=true
        else
          result:=false;
        CloseKey;
      end else
        raise Exception.Create('Error opening key: '+Key);
    end else begin
      result:=false;
    end;
  end;
end;

function TPerfLib9x.GetSysDataName(Key: string): string;
var
  akey,avalue :string;
  p :integer;
begin
  with FRegistry do begin
    RootKey := HKEY_LOCAL_MACHINE;
    p:=pos('\',key);
    if p>0 then begin
      akey:=cPerfIndex95+'\'+copy(key,1,p-1)+'\'+copy(key,p+1,255);
      avalue:='Name';
    end else begin
      akey:=cPerfIndex95+'\'+key;
      avalue:='Name';
    end;
    if OpenKeyReadOnly(akey) then begin
      result:=ReadString(avalue);
      CloseKey;
    end else
      raise Exception.Create('Error opening key: '+Key);
  end;
end;

procedure TPerfLib9x.Open;
var
  KeysList : TStringList;
  i        : Integer;
  Dummy    : Integer;
begin
  if (not FActive) then
    with FRegistry do begin
      RootKey := HKEY_DYN_DATA;
      if OpenKeyReadOnly(cPerfStart95) then begin
        KeysList := TStringList.Create;
        try
          GetValueNames(KeysList);
          for i:=0 to KeysList.Count-1 do
            ReadBinaryData(KeysList.Strings[i], Dummy, 4);
        finally
         KeysList.Free;
        end;
        FActive := True;
        CloseKey;
      end;
    end;
end;

end.
