{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Windows ASPI32                          }
{           version 8.6 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_WnASPI32;

interface

uses Classes, Windows, SysUtils;

type
  TASPIConfig = record
    AdapterCount: DWORD;
    Adapter,ID,Vendor,Product,Typ,Status,Spec,Revision: TStringList;
  end;

function InitASPI: Boolean;
procedure FreeASPI;

function ExecuteASPI32Test(var ASPIConfig: TASPIConfig): DWORD;

type
  TGetASPI32SupportInfo = function :DWORD; cdecl;
  TSendASPI32Command = function (ASPI32CommandPointer: Pointer): DWORD; cdecl;

var
  GetASPI32SupportInfo: TGetASPI32SupportInfo = nil;
  SendASPI32Command: TSendASPI32Command = nil;

const
  ASPI_DLL = 'wnaspi32.dll';

// SCSI MISCELLANEOUS EQUATES

    MAX_ADAPTER = 16; { Maximum number of adapters supported by ASPI }
    MAX_TARGET = 7; { Maximum number of targets per adapter supported by ASPI }
    MAX_TARGET_WIDE = 15; { Maximum number of targets per adapter (wide SCSI enabled) supported by ASPI }
    MAX_LUN = 64; { Maximum number of logical units supported by ASPI }

    SENSE_LEN = 14; { Default sense buffer length }

    SRB_DIR_SCSI = $00; { Direction determined by SCSI }
    SRB_POSTING = $01; { Enable ASPI posting }
    SRB_ENABLE_RESIDUAL_COUNT = $04; { Enable residual byte count reporting }
    SRB_DIR_IN = $08; { Transfer from SCSI target to host }
    SRB_DIR_OUT = $10; { Transfer from host to SCSI target }
    SRB_EVENT_NOTIFY = $40; { Enable ASPI event notification }

    RESIDUAL_COUNT_SUPPORTED = $02; { Extended buffer flag }

    MAX_SRB_TIMEOUT = 108000; { 30 hour maximum timeout in half seconds }
    DEFAULT_SRB_TIMEOUT = 108000; { Max timeout by default }


// ASPI Command Definitions

    SC_HA_INQUIRY = $00; { Host adapter inquiry }
    SC_GET_DEV_TYPE = $01; { Get device type }
    SC_EXEC_SCSI_CMD = $02; { Execute SCSI command }
    SC_ABORT_SRB = $03; { Abort an SRB }
    SC_RESET_DEV = $04; { SCSI bus device reset }
    SC_SET_HA_PARMS = $05; { Set HA parameters }
    SC_GET_DISK_INFO = $06; { Get Disk information }
    SC_RESCAN_SCSI_BUS = $07; { ReBuild SCSI device map }
    SC_GETSET_TIMEOUTS = $08; { Get/Set target timeouts }

// SRB Status

    SS_PENDING = $00; { SRB being processed }
    SS_COMP = $01; { SRB completed without error }
    SS_ABORTED = $02; { SRB aborted }
    SS_ABORT_FAIL = $03; { Unable to abort SRB }
    SS_ERR = $04; { SRB completed with error }

    SS_INVALID_CMD = $80; { Invalid ASPI command }
    SS_INVALID_HA = $81; { Invalid host adapter number }
    SS_NO_DEVICE = $82; { SCSI device not installed }

    SS_INVALID_SRB = $E0; { Invalid parameter set in SRB }
    SS_OLD_MANAGER = $E1; { ASPI manager doesn't support Windows }
    SS_BUFFER_ALIGN = $E1; { Buffer not aligned (replaces OLD_MANAGER in Win32) }
    SS_ILLEGAL_MODE = $E2; { Unsupported Windows mode }
    SS_NO_ASPI = $E3; { No ASPI managers resident }
    SS_FAILED_INIT = $E4; { ASPI for windows failed init }
    SS_ASPI_IS_BUSY = $E5; { No resources available to execute cmd }
    SS_BUFFER_TO_BIG = $E6; { Buffer size to big to handle! }
    SS_MISMATCHED_COMPONENTS = $E7; { The DLLs/EXEs of ASPI don't version check }
    SS_NO_ADAPTERS = $E8; { No host adapters to manage }
    SS_INSUFFICIENT_RESOURCES = $E9; { Couldn't allocate resources needed to init }
    SS_ASPI_IS_SHUTDOWN = $EA; { Call came to ASPI after PROCESS_DETACH }
    SS_BAD_INSTALL = $EB; { The DLL or other components are installed wrong }

// Host Adapter Status
    HASTAT_OK = $00; { Host adapter did not detect an error }
    HASTAT_SEL_TO = $11; { Selection Timeout }
    HASTAT_DO_DU = $12; { Data overrun data underrun }
    HASTAT_BUS_FREE = $13; { Unexpected bus free }
    HASTAT_PHASE_ERR = $14; { Target bus phase sequence failure  }
    HASTAT_TIMEOUT = $09; { Timed out while SRB was waiting to beprocessed }
    HASTAT_COMMAND_TIMEOUT = $0B; { Adapter timed out processing SRB }
    HASTAT_MESSAGE_REJECT = $0D; { While processing SRB, the adapter received a MESSAGE }
    HASTAT_BUS_RESET = $0E; { A bus reset was detected }
    HASTAT_PARITY_ERROR = $0F; { A parity error was detected }
    HASTAT_REQUEST_SENSE_FAILED = $10; { The adapter failed in issuing }


type

// SRB - HOST ADAPTER INQUIRY - SC_HA_INQUIRY (0)

  {TSRB_HAInquiry record will be passed to ASPI Mgr to retreive information about
   ASPI state on the machine, number of installed ASPI adapters etc.}
  PTSRB_HAInquiry = ^TSRB_HAInquiry;
  TSRB_HAInquiry = packed record
    SRB_Cmd : BYTE; { 00/000 ASPI command code = SC_HA_INQUIRY }
    SRB_Status : BYTE; { 01/001 ASPI command status byte }
    SRB_HaId : BYTE; { 02/002 ASPI host adapter number }
    SRB_Flags : BYTE; { 03/003 ASPI request flags }
    SRB_Hdr_Rsvd : DWORD; { 04/004 Reserved, MUST = 0 }
    HA_Count : BYTE; { 08/008 Number of host adapters present }
    HA_SCSI_ID : BYTE; { 09/009 SCSI ID of host adapter }
    HA_ManagerId : array [0..15] of BYTE; { 0A/010 String describing the manager }
    HA_Identifier : array [0..15] of BYTE; { 1A/026 String describing the host adapter }
    HA_Unique : array [0..15] of BYTE; { 2A/042 Host Adapter Unique parameters }
    HA_Rsvd1 : WORD; { 3A/058 Reserved, MUST = 0 }
  end;

// SRB - GET DEVICE TYPE - SC_GET_DEV_TYPE (1)

  {TSRB_GDEVBlock record will be passed to ASPI Mgr to retreive information about device.}
  PTSRB_GDEVBlock = ^TSRB_GDEVBlock;
  TSRB_GDEVBlock = packed record
    SRB_Cmd : BYTE; { 00/000 ASPI command code = SC_GET_DEV_TYPE }
    SRB_Status : BYTE; { 01/001 ASPI command status byte }
    SRB_HaId : BYTE; { 02/002 ASPI host adapter number }
    SRB_Flags : BYTE; { 03/003 Reserved, MUST = 0 }
    SRB_Hdr_Rsvd : DWORD; { 04/004 Reserved, MUST = 0 }
    SRB_Target : BYTE; { 08/008 Target's SCSI ID }
    SRB_Lun : BYTE; { 09/009 Target's LUN number }
    SRB_DeviceType : BYTE; { 0A/010 Target's peripheral device type }
    SRB_Rsvd1 : BYTE; { 0B/011 Reserved, MUST = 0 }
  end;

// SRB - EXECUTE SCSI COMMAND - SC_EXEC_SCSI_CMD (2)

  {TSRB_ExecSCSICmd record will be passed to ASPI Mgr to execute SCSI command on SCSI device.}
  PTSRB_ExecSCSICmd = ^TSRB_ExecSCSICmd;
  TSRB_ExecSCSICmd = packed record
    SRB_Cmd : BYTE; { 00/000 ASPI command code = SC_EXEC_SCSI_CMD }
    SRB_Status : BYTE; { 01/001 ASPI command status byte }
    SRB_HaId : BYTE; { 02/002 ASPI host adapter number }
    SRB_Flags : BYTE; { 03/003 ASPI request flags }
    SRB_Hdr_Rsvd : DWORD; { 04/004 Reserved }
    SRB_Target : BYTE; { 08/008 Target's SCSI ID }
    SRB_Lun : BYTE; { 09/009 Target's LUN number }
    SRB_Rsvd1 : WORD; { 0A/010 Reserved for Alignment }
    SRB_BufLen : DWORD; { 0C/012 Data Allocation Length }
    SRB_BufPointer : Pointer; { 10/016 Data Buffer Pointer }
    SRB_SenseLen : BYTE; { 14/020 Sense Allocation Length }
    SRB_CDBLen : BYTE; { 15/021 CDB Length }
    SRB_HaStat : BYTE; { 16/022 Host Adapter Status }
    SRB_TargStat : BYTE; { 17/023 Target Status }
    SRB_PostProc : Pointer; { 18/024 Post routine }
    SRB_Rsvd2 : array [0..19] of BYTE; { 1C/028 Reserved, MUST = 0 }
    CDBByte : array [0..15] of BYTE; { 30/048 SCSI CDB }
    SenseArea : array [0..(SENSE_LEN+1)] of BYTE; { 50/064 Request Sense buffer }
  end;

// SRB - ABORT AN SRB - SC_ABORT_SRB (3)

  PTSRB_Abort = ^TSRB_Abort;
  TSRB_Abort = packed record
    SRB_Cmd : BYTE; { 00/000 ASPI command code = SC_ABORT_SRB }
    SRB_Status : BYTE; { 01/001 ASPI command status byte }
    SRB_HaId : BYTE; { 02/002 ASPI host adapter number }
    SRB_Flags : BYTE; { 03/003 Reserved }
    SRB_Hdr_Rsvd : DWORD; { 04/004 Reserved }
    SRB_ToAbort : Pointer; { PVOID } { 08/008 Pointer to SRB to abort }
  end;

// SRB - RESCAN SCSI BUS(ES) ON SCSIPORT

  {TSRB_RescanPort record will be passed to ASPI Mgr to initiate SCSI bus rescan on the port.}
  PTSRB_RescanPort = ^TSRB_RescanPort;
  TSRB_RescanPort = packed record
    SRB_Cmd : BYTE; { 00/000 ASPI command code = SC_RESCAN_SCSI_BUS }
    SRB_Status : BYTE; { 01/001 ASPI command status byte }
    SRB_HaId : BYTE; { 02/002 ASPI host adapter number }
    SRB_Flags : BYTE; { 03/003 Reserved, MUST = 0 }
    SRB_Hdr_Rsvd : DWORD; { 04/004 Reserved, MUST = 0 }
  end;

// SRB - GET/SET TARGET TIMEOUTS

  {TSRB_GetSetTimeouts record will be passed to ASPI Mgr to get/set timeouts on SCSI device.}
  PTSRB_GetSetTimeouts = ^TSRB_GetSetTimeouts;
  TSRB_GetSetTimeouts = packed record
    SRB_Cmd : BYTE; { 00/000 ASPI command code = SC_GETSET_TIMEOUTS }
    SRB_Status : BYTE; { 01/001 ASPI command status byte }
    SRB_HaId : BYTE; { 02/002 ASPI host adapter number }
    SRB_Flags : BYTE; { 03/003 ASPI request flags }
    SRB_Hdr_Rsvd : DWORD; { 04/004 Reserved, MUST = 0 }
    SRB_Target : BYTE; { 08/008 Target's SCSI ID }
    SRB_Lun : BYTE; { 09/009 Target's LUN number }
    SRB_Timeout : DWORD; { 0A/010 Timeout in half seconds }
  end;

implementation

var
  ASPIHandle: THandle;

function InitASPI: Boolean;
begin
  ASPIHandle:=GetModuleHandle(ASPI_DLL);
  if ASPIHandle=0 then
    ASPIHandle:=LoadLibrary(ASPI_DLL);
  if ASPIHandle<>0 then begin
    @GetASPI32SupportInfo:=getprocaddress(ASPIHandle,pchar('GetASPI32SupportInfo'));
    @SendASPI32Command:=getprocaddress(ASPIHandle,pchar('SendASPI32Command'));
  end;
  result:=(ASPIHandle<>0) and Assigned(GetASPI32SupportInfo);
end;

procedure FreeASPI;
begin
  if ASPIHandle<>0 then begin
    if not FreeLibrary(ASPIHandle) then
      Exception.Create('Unload Error: '+ASPI_DLL+' ('+inttohex(getmodulehandle(ASPI_DLL),8)+')')
    else
      ASPIHandle:=0;
  end;
end;

function ExecuteASPI32Test;
var
  ASPI32SupportInfo: DWORD;
  i,j: ULONG;
  SRB_HaInquiry: TSRB_HaInquiry;
  SRB_GDEVBlock: TSRB_GDEVBlock;
  SRB_ExecSCSICmd: TSRB_ExecSCSICmd;
  Status: DWORD;
  Storage: array[0..127] of BYTE;
  h: THandle;
  Inquiry: array[0..99] of BYTE;
begin
  if not InitASPI then
    Exit;
  ASPIConfig.Adapter.Clear;
  ASPIConfig.ID.Clear;
  ASPIConfig.Vendor.Clear;
  ASPIConfig.Typ.Clear;
  ASPIConfig.Product.Clear;
  ASPIConfig.Status.Clear;
  ASPIConfig.Revision.Clear;
  ASPIConfig.Spec.Clear;
  ASPI32SupportInfo:=GetASPI32SupportInfo;
  Result:=ASPI32SupportInfo;
  if HIBYTE(LOWORD(ASPI32SupportInfo))=SS_COMP then begin
    ASPIConfig.AdapterCount:=LOBYTE(LOWORD(ASPI32SupportInfo));
    for i:=0 to ASPIConfig.AdapterCount-1 do  begin
      ZeroMemory(@SRB_HaInquiry,SizeOf(TSRB_HaInquiry));
      SRB_HaInquiry.SRB_Cmd:=SC_HA_INQUIRY;
      SRB_HaInquiry.SRB_HaId:=Byte(i);
      Status:=SendASPI32Command(Pointer(@SRB_HaInquiry));
      if Status=SS_COMP then begin
        ZeroMemory(@Storage,SizeOf(Storage));
        MoveMemory(@Storage,@SRB_HaInquiry.HA_ManagerId,SizeOf(SRB_HaInquiry.HA_ManagerId));
        ZeroMemory(@Storage,SizeOf(Storage));
        MoveMemory(@Storage,@SRB_HaInquiry.HA_Identifier[0],SizeOf(SRB_HaInquiry.HA_Identifier));
        for j:=0 to MAX_TARGET_WIDE do begin
          ZeroMemory(@SRB_GDEVBlock,SizeOf(SRB_GDEVBlock));
          SRB_GDEVBlock.SRB_Cmd:=SC_GET_DEV_TYPE;
          SRB_GDEVBlock.SRB_HaId:=Byte(i);
          SRB_GDEVBlock.SRB_Target:=BYTE(j);
          Status:=SendASPI32Command(Pointer(@SRB_GDEVBlock));
          if Status=SS_COMP then begin
            ASPIConfig.Adapter.Add(IntToStr(i));
            ASPIConfig.ID.Add(IntToStr(j));
            ASPIConfig.Typ.Add(IntToStr(SRB_GDEVBlock.SRB_DeviceType));
            ASPIConfig.Status.Add('');
            ASPIConfig.Vendor.Add('');
            ASPIConfig.Product.Add('');
            ASPIConfig.Revision.Add('');
            ASPIConfig.Spec.Add('');
            h:=DWORD(CreateEvent(nil,True,False,nil));
            if h<>0 then begin
              ZeroMemory(@SRB_ExecSCSICmd,SizeOf(SRB_ExecSCSICmd));
              SRB_ExecSCSICmd.SRB_Cmd:=SC_EXEC_SCSI_CMD;
              SRB_ExecSCSICmd.SRB_HaId:=Byte(i);
              SRB_ExecSCSICmd.SRB_Flags:=SRB_EVENT_NOTIFY;
              SRB_ExecSCSICmd.SRB_Target:=BYTE(j);
              SRB_ExecSCSICmd.SRB_SenseLen:=SENSE_LEN;
              SRB_ExecSCSICmd.SRB_PostProc:=Pointer(h);
              SRB_ExecSCSICmd.SRB_CDBLen:=6;
              Status:=SendASPI32Command(Pointer(@SRB_ExecSCSICmd));
              if Status=SS_PENDING then
                WaitForSingleObject(h,INFINITE);
              ASPIConfig.Status[ASPIConfig.Status.Count-1]:=IntToStr(SRB_ExecSCSICmd.SRB_Status);
              ResetEvent(h);
              ZeroMemory(@SRB_ExecSCSICmd,SizeOf(SRB_ExecSCSICmd));
              ZeroMemory(@Inquiry,SizeOf(Inquiry));
              SRB_ExecSCSICmd.SRB_Cmd:=SC_EXEC_SCSI_CMD;
              SRB_ExecSCSICmd.SRB_HaId := BYTE(i);
              SRB_ExecSCSICmd.SRB_Flags:=SRB_EVENT_NOTIFY or SRB_DIR_IN;
              SRB_ExecSCSICmd.SRB_Target:=Byte(j);
              SRB_ExecSCSICmd.SRB_SenseLen:=SENSE_LEN;
              SRB_ExecSCSICmd.SRB_PostProc:=Pointer(h);
              SRB_ExecSCSICmd.SRB_CDBLen:=6;
              SRB_ExecSCSICmd.SRB_BufLen:=SizeOf(Inquiry);
              SRB_ExecSCSICmd.SRB_BufPointer:=Pointer(@Inquiry[0]);
              SRB_ExecSCSICmd.CDBByte[0]:=$12; // SCSI inquiry
              SRB_ExecSCSICmd.CDBByte[4]:=SizeOf(Inquiry);
              Status:=SendASPI32Command(Pointer(@SRB_ExecSCSICmd));
              if Status=SS_PENDING then
                WaitForSingleObject(h,INFINITE);
              ASPIConfig.Status[ASPIConfig.Status.Count-1]:=IntToStr(SRB_ExecSCSICmd.SRB_Status);
              if SRB_ExecSCSICmd.SRB_Status=SS_COMP then begin
                ZeroMemory(@Storage,SizeOf(Storage));
                MoveMemory(@Storage,Pointer(@Inquiry[8]),8);
                ASPIConfig.Vendor[ASPIConfig.Vendor.Count-1]:=PChar(@Storage[0]);
                ZeroMemory(@Storage,SizeOf(Storage));
                MoveMemory(@Storage,Pointer(@Inquiry[16]),16);
                ASPIConfig.Product[ASPIConfig.Product.Count-1]:=PChar(@Storage[0]);
                ZeroMemory(@Storage,SizeOf(Storage));
                MoveMemory(@Storage,Pointer(@Inquiry[32]),4);
                ASPIConfig.Revision[ASPIConfig.Revision.Count-1]:=PChar(@Storage[0]);
                ZeroMemory(@Storage,SizeOf(Storage));
                MoveMemory(@Storage,Pointer(@Inquiry[36]),20);
                ASPIConfig.Spec[ASPIConfig.Spec.Count-1]:=PChar(@Storage[0]);
              end;
              CloseHandle(h);
            end;
          end;
        end;
      end;
    end;
  end;
end;

initialization
finalization
  FreeASPI;
end.
