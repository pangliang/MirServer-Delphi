{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{         Installed Software Detection Part             }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Software;

interface

uses
  MSI_Common, SysUtils, Windows, Classes;

type
  TSoftware = class(TPersistent)
  private
    FProducts: TStrings;
    FVersions: TStrings;
    FUninstalls: TStrings;
    FModes: TExceptionModes;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
    property Uninstalls: TStrings read FUninstalls {$IFNDEF D6PLUS} write FUninstalls {$ENDIF} stored False;
    property Versions: TStrings read FVersions {$IFNDEF D6PLUS} write FVersions {$ENDIF} stored False;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property Products: TStrings read FProducts {$IFNDEF D6PLUS} write FProducts {$ENDIF} stored false;
  end;

implementation

uses Registry, MiTeC_Routines;

{ TSoftware }

constructor TSoftware.Create;
begin
  ExceptionModes:=[emExceptionStack];
  FProducts:=TStringList.Create;
  FVersions:=TStringList.Create;
  FUninstalls:=TStringList.Create;
end;

destructor TSoftware.Destroy;
begin
  FProducts.Free;
  FVersions.Free;
  FUninstalls.Free;
  inherited;
end;

procedure TSoftware.GetInfo;
const
  rk = {HKEY_LOCAL_MACHINE}'\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  rvDN = 'DisplayName';
  rvDV = 'DisplayVersion';
  rvUS = 'UninstallString';
var
  i: integer;
  sl: TStringList;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  FProducts.Clear;
  FUninstalls.Clear;
  with TRegistry.Create do
    try
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(rk) then begin
        sl:=TStringList.Create;
        GetKeyNames(sl);
        CloseKey;
        for i:=0 to sl.Count-1 do
          if OpenKeyReadOnly(rk+'\'+sl[i]) then begin
            if ValueExists(rvDN) then begin
              FProducts.Add(ReadString(rvDN));
              if ValueExists(rvDV) then
                FVersions.Add(ReadString(rvDV))
              else
                FVersions.Add('');
              if ValueExists(rvUS) then
                FUninstalls.Add(ReadString(rvUS))
              else
                FUninstalls.Add('');
            end;
            CloseKey;
          end;
        sl.Free;
      end;
    finally
      Free;
    end;

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TSoftware.Report;
var
  i: integer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<Software classname="TSoftware">');

    for i:=0 to Products.Count-1 do
      Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(Products[i]),CheckXMLValue(Uninstalls[i])]));

    Add('</Software>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TSoftware.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.
