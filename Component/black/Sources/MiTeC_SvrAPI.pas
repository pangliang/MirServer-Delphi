{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{                Windows 9x SVR API                     }
{           version 8.6 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_SvrAPI;

interface

uses Windows, SysUtils;

const
  LM20_NNLEN = 12;
  SHPWLEN = 8;

  STYPE_DISKTREE = 0;
  STYPE_PRINTQ   = 1;
  STYPE_DEVICE   = 2;
  STYPE_IPC      = 3;

  STYPE_SPECIAL  = $80000000;

type
  _share_info_50 = record
    shi50_netname: array [0..LM20_NNLEN] of char;
    shi50_type: BYTE;
    shi50_flags: WORD;
    shi50_remark: PChar;
    shi50_path: PChar;
    shi50_rw_password: array[0..SHPWLEN] of char;
    shi50_ro_password: array[0..SHPWLEN] of char;
  end;

  pshare_info_50 = ^share_info_50;
  share_info_50 = _share_info_50;

  _session_info_50 = record
    sesi50_cname: Pchar;
    sesi50_username: PChar;
    sesi50_key: DWORD;
    sesi50_num_conns: WORD;
    sesi50_num_opens: WORD;
    sesi50_time: DWORD;
    sesi50_idle_time: DWORD;
    sesi50_protocol: PChar;
    pad1: PChar;
  end;

  psession_info_50 = ^session_info_50;
  session_info_50 = _session_info_50;

  _file_info_50 = record
    fi50_id: DWORD;
    fi50_permissions: WORD;
    fi50_num_locks: WORD;
    fi50_pathname: PChar;
    fi50_username: PChar;
    fi50_sharename: PChar;
  end;

  pfile_info_50 = ^file_info_50;
  file_info_50 = _file_info_50;

  _connection_info_1 = record
    coni1_id: word;
    coni1_type: word;
    coni1_num_opens: word;
    coni1_num_users: word;
    coni1_time: dword;
    coni1_username: PChar;
    coni1_netname: PChar;
  end;

  pconnection_info_1 = ^connection_info_1;
  connection_info_1 = _connection_info_1;


  _connection_info_50 = record
    coni50_type: Word;
    coni50_num_opens: Word;
    coni50_time: dword;
    coni50_netname: PChar;
    coni50_username: PChar;
  end;

  pconnection_info_50 = ^connection_info_50;
  connection_info_50 = _connection_info_50;


function InitSvrAPI: Boolean;
procedure FreeSvrAPI;

type
  TNetFileEnum = function(const pszServer: PChar;
                     const pszBasePath: PChar;
                     sLevel: short;
                     var pbBuffer: PChar;
                     cbBuffer: Word;
                     var pcEntriesRead: Word;
                     var pcTotalAvail: WORD): DWORD; stdcall;

  TNetSessionEnum = function(const pszServer: PChar;
                        sLevel: short;
                        var pbBuffer: PChar;
                        cbBuffer: Word;
                        var pcEntriesRead: Word;
                        var pcTotalAvail: WORD): DWORD; stdcall;

  TNetShareEnum = function(const pszServer: PChar;
                      sLevel: short;
                      var pbBuffer: PChar;
                      cbBuffer: Word;
                      var pcEntriesRead: Word;
                      var pcTotalAvail: WORD): DWORD; stdcall;

  TNetConnectionEnum = function(const pszServer: PChar;
                           const pszQualifier: PChar;
                           sLevel: short;
                           var pbBuffer: PChar;
                           cbBuffer: Word;
                           var pcEntriesRead: Word;
                           var pcTotalAvail: Word): DWORD; stdcall;

var
  NetShareEnum: TNetShareEnum;
  NetSessionEnum: TNetSessionEnum;
  NetFileEnum: TNetFileEnum;
  NetConnectionEnum: TNetConnectionEnum;

implementation

const
  SVRAPI_DLL = 'svrapi.dll';

var
  SvrAPIHandle: THandle;

function InitSvrAPI: Boolean;
begin
  SvrAPIHandle:=GetModuleHandle(SvrAPI_DLL);
  if SvrAPIHandle=0 then
    SvrAPIHandle:=loadlibrary(SvrAPI_DLL);
  if SvrAPIHandle<>0 then begin
    @NetShareEnum:=GetProcAddress(SvrAPIHandle,PChar('NetShareEnum'));
    @NetSessionEnum:=GetProcAddress(SvrAPIHandle,PChar('NetSessionEnum'));
    @NetFileEnum:=GetProcAddress(SvrAPIHandle,PChar('NetFileEnum'));
    @NetConnectionEnum:=GetProcAddress(SvrAPIHandle,PChar('NetConnectionEnum'));
  end;
  result:=(SvrAPIHandle<>0) and Assigned(NetShareEnum);
end;

procedure FreeSvrAPI;
begin
  if SvrAPIHandle<>0 then begin
    if not FreeLibrary(SvrAPIHandle) then
      Exception.Create('Unload Error: '+SvrAPI_DLL+' ('+inttohex(getmodulehandle(SvrAPI_DLL),8)+')')
    else
      SvrAPIHandle:=0;
  end;
end;

initialization
finalization
  FreeSvrAPI;
end.
