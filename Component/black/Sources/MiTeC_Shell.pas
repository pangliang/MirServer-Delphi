{*******************************************************}
{                                                       }
{             MiTeC Shell Routines                      }
{           version 1.0 for Delphi 5,6,7                }
{                                                       }
{           Copyright © 2002,2004 Michal Mutl           }
{                                                       }
{*******************************************************}


unit MiTeC_Shell;

interface

uses Windows, Registry, SysUtils;

type
  TNewEntryType = (etNullFile, etFileName, etCommand);

procedure RegisterFileType(Extension, RegistryKey, Description, Icon, EXEName :string);
procedure UnRegisterFileType(Extension: string);
function GetShellExtension(Extension: string): string;
procedure AddCMAction(RegistryKey, ActionName, MenuCaption, Action: string);
procedure RemoveCMAction(RegistryKey, ActionName: string);
procedure AddCMNew(Extension, Params: string; EntryType: TNewEntryType);
procedure RemoveCMNew(Extension: string);

implementation

procedure RegisterFileType;
var
  p: integer;
begin
  p:=pos('.',Extension);
  while p>0 do begin
    Delete(Extension,p,1);
    p:=pos('.',Extension);
  end;
  if (Extension='') or (EXEName='') then
    Exit;
  Extension:='.'+Extension;
  with TRegINIFile.Create('') do
    try
      RootKey:=HKEY_CLASSES_ROOT;
      if RegistryKey='' then
        RegistryKey:=Copy(Extension,2,MaxInt)+'_auto_file';
      WriteString(Extension,'',RegistryKey);
      WriteString(RegistryKey,'',Description);
      if Icon<>'' then
        WriteString(RegistryKey+'\DefaultIcon','',Icon);
      WriteString(RegistryKey+'\shell\open\command','',EXEName+' "%1"');
    finally
      Free;
    end;
end;

procedure UnRegisterFileType;
var
  s: string;
begin
  with TRegistry.Create do
    try
      RootKey:=HKEY_CLASSES_ROOT;
      if OpenKey(Extension,False) then begin
        s:=ReadString('');
        CloseKey;
        DeleteKey(Extension);
        DeleteKey(s);
      end;
    finally
      Free;
    end;
end;

procedure AddCMAction;
begin
  with TRegistry.Create do
    try
      RootKey:=HKEY_CLASSES_ROOT;
      if ActionName='' then
        ActionName:=MenuCaption;
      if Copy(RegistryKey,1,1)='.' then
        RegistryKey:=Copy(RegistryKey,2,MaxInt)+'_auto_file';
      if Copy(RegistryKey,Length(RegistryKey),1)<>'\' then
        RegistryKey:=RegistryKey+'\';
      if Copy(ActionName,Length(ActionName),1)<>'\' then
        ActionName:=ActionName+'\';
      if OpenKey(RegistryKey+'Shell\'+ActionName,True) then begin
        WriteString('',MenuCaption);
        CloseKey;
      end;
      if OpenKey(RegistryKey+'Shell\'+ActionName+'Command\',True) then
        WriteString('',ActionName);
    finally
      Free;
    end;
end;

procedure RemoveCMAction;
begin
  with TRegistry.Create do
    try
      RootKey:=HKEY_CLASSES_ROOT;
      if Copy(RegistryKey,1,1)='.' then
        RegistryKey:=Copy(RegistryKey,2,MaxInt)+'_auto_file';
      if Copy(RegistryKey,Length(RegistryKey),1)<>'\' then
        RegistryKey:=RegistryKey+'\';
      if OpenKey('\'+RegistryKey+'shell\',True) then begin
        if KeyExists(ActionName) then
          DeleteKey(ActionName);
        CloseKey;
      end;
    finally
      Free;
    end;
end;

procedure AddCMNew;
begin
  with TRegistry.Create do
    try
      RootKey:=HKEY_CLASSES_ROOT;
      if KeyExists(Extension) then begin
        if OpenKey(Extension+'\ShellNew',True) then
          case EntryType of
            etNullFile: WriteString('NullFile', '');
            etFileName: WriteString('FileName',Params);
            etCommand: WriteString('Command',Params);
          end;
          CloseKey;
        end;
    finally
      Free;
    end;
end;

procedure RemoveCMNew;
begin
  with TRegistry.Create do
    try
      RootKey:=HKEY_CLASSES_ROOT;
      if KeyExists(Extension) then
        if OpenKey(Extension,True) then begin
          if KeyExists('ShellNew') then
            DeleteKey('ShellNew');
          CloseKey;
        end;
    finally
      Free;
    end;
end;

function GetShellExtension;
var
  i: Integer;
  s: string;
begin
  Result:='';
  with TRegistry.Create do
    try
      RootKey:=HKEY_CLASSES_ROOT;
      if OpenKeyReadOnly(Extension) then begin
        s:=ReadString('');
        CloseKey;
        if OpenKeyReadOnly(s+'\shell\open\command') then begin
          Result:=ReadString('');
          CloseKey;
        end;
      end;
    finally
      Free;
    end;
  i:=Pos('"',Result);
  if i=1 then begin
    Result:=Copy(Result,i+1,Length(Result)-1);
    i:=Pos('"',Result);
    Result:=Copy(Result,1,i-1);
  end else
    Result:=Trim(Copy(Result,1,i-1));
end;

end.
