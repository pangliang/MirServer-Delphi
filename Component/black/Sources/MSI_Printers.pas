{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Printer Detection Part                  }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2003 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Printers;

interface

uses
  MSI_Common, SysUtils, Windows, Classes;

type
  TPrinters = class(TPersistent)
  private
    FPrinter, FPort: TStringlist;
    FDI: integer;
    FModes: TExceptionModes;
    function GetPorts: TStrings;
    function GetPrinters: TStrings;
    {$IFNDEF D6PLUS}
    procedure SetPorts(const Value: TStrings);
    procedure SetPrinters(const Value: TStrings);
    {$ENDIF}
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList; Standalone: Boolean = True); virtual;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property DefaultIndex: integer read FDI {$IFNDEF D6PLUS} write FDI {$ENDIF} stored False;
    property Names :TStrings read GetPrinters {$IFNDEF D6PLUS} write SetPrinters {$ENDIF} stored false;
    property Ports: TStrings read GetPorts {$IFNDEF D6PLUS} write SetPorts {$ENDIF} stored False;
  end;

implementation

uses Printers, MiTeC_Routines, Registry;

{ TPrinters }

constructor TPrinters.Create;
begin
  FPort:=TStringList.Create;
  FPrinter:=TStringList.Create;
  ExceptionModes:=[emExceptionStack];
end;

destructor TPrinters.Destroy;
begin
  FPrinter.Free;
  FPort.Free;
  inherited;
end;

procedure TPrinters.GetInfo;
var
  i :integer;
  Device, Driver, Port: PChar;
  Mode: THandle;

function Replace(Data:String): String;
var
  i: Word;
begin
 for i:=1 to Length(Data) do begin
   if Data[i]='\' then begin
     Insert(',',Data,i);
     Delete(Data,i+1,1);
   end;
 end;
 Result:=Data;
end;

const
  rk = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Printers\';

begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  GetMem(Device,MAX_PATH+1);
  GetMem(Driver,MAX_PATH+1);
  GetMem(Port,MAX_PATH+1);
  FPrinter.Clear;
  FPort.Clear;
  if Printer.Printers.Count>0 then
    with TRegistry.Create do begin
      RootKey:=HKEY_LOCAL_MACHINE;
      Access:=KEY_READ;
      for i:=0 to Printer.Printers.count-1 do begin
        Printer.PrinterIndex:=i;
        Printer.GetPrinter(Device,Driver,Port,Mode);
        FPrinter.Add(Device);
        if IsNT then begin
          if OpenKey(rk+Replace(Device),False) then begin
            FPort.Add(ReadString('Port'));
            CloseKey;
          end else
            FPort.Add('');
        end else
         FPort.Add(Port);
      end;
      Free;
    end;

  try
    Printer.PrinterIndex:=-1;
    Printer.GetPrinter(Device,Driver,Port,Mode);
  except
  end;

  FDI:=FPrinter.IndexOf(Device);
  FreeMem(Device);
  FreeMem(Port);
  FreeMem(Driver);

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

function TPrinters.GetPorts: TStrings;
begin
  Result:=FPort;
end;

function TPrinters.GetPrinters: TStrings;
begin
  Result:=FPrinter;
end;

procedure TPrinters.Report;
var
  i: integer;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<Printers classname="TPrinters">');

    Add(Format('<data name="Count" type="integer">%d</data>',[Self.Names.Count]));
    for i:=0 to Self.Names.Count-1 do
      if DefaultIndex=i then
        Add(Format('<data name="%s (Default)" type="string">%s</data>',[CheckXMLValue(Self.Names[i]),CheckXMLValue(Self.Ports[i])]))
      else
        Add(Format('<data name="%s" type="string">%s</data>',[CheckXMLValue(Self.Names[i]),CheckXMLValue(Self.Ports[i])]));

    Add('</Printers>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TPrinters.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

{$IFNDEF D6PLUS}
procedure TPrinters.SetPorts(const Value: TStrings);
begin

end;

procedure TPrinters.SetPrinters(const Value: TStrings);
begin

end;
{$ENDIF}

end.
