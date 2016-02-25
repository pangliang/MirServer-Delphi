{*******************************************************}
{                                                       }
{         MiTeC System Information Component            }
{                USB Device Enumeration                 }
{           version 8.6.4 for Delphi 5,6,7              }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}


{$INCLUDE MITEC_DEF.INC}

unit MSI_USB;

interface

uses MSI_Common, SysUtils, Windows, Classes, MiTeC_USB;

type
  TUSB= class(TPersistent)
  private
    FUSBNodes: TUSBNodes;
    {$IFNDEF D6PLUS}
    FCD: Byte;
    {$ENDIF}
    FModes: TExceptionModes;
    function GetConnectedDevices: Byte;
    function GetUSBNode(Index: integer): TUSBNode;
    function GetUSBNodeCount: Integer;
    procedure SetMode(const Value: TExceptionModes);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl: TStringList; Standalone: Boolean = True); virtual;
    property USBNodeCount: Integer read GetUSBNodeCount;
    property USBNodes[Index: integer]: TUSBNode read GetUSBNode;
  published
    property ExceptionModes: TExceptionModes read FModes Write SetMode;
    property ConnectedDevices: Byte read GetConnectedDevices {$IFNDEF D6PLUS} Write FCD {$ENDIF} stored False;
  end;

implementation

{ TUSB }

constructor TUSB.Create;
begin
  ExceptionModes:=[emExceptionStack];
end;

destructor TUSB.Destroy;
begin
  SetLength(FUSBNodes,0);
  inherited;
end;

function TUSB.GetConnectedDevices: Byte;
var
  i: Integer;
begin
  Result:=0;
  for i:=0 to High(FUSBNodes) do
    if (FUSBNodes[i].USBDevice.ConnectionStatus=1) and
       (FUSBNodes[i].USBClass in [usbReserved..usbStorage,usbVendorSpec]) then
      Inc(Result);
end;

procedure TUSB.GetInfo;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'GetInfo'); {$ENDIF}

  EnumUSBDevices(FUSBNodes);

  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

function TUSB.GetUSBNode;
begin
  ZeroMemory(@Result,SizeOf(TUSBNode));
  Result.USBClass:=usbUnknown;
  if (Index>=0) and (Index<Length(FUSBNodes)) then
    Result:=FUSBNodes[Index];
end;

function TUSB.GetUSBNodeCount: Integer;
begin
  Result:=Length(FUSBNodes);
end;

procedure TUSB.Report(var sl: TStringList; Standalone: Boolean);

var sc: Integer;

procedure OpenSection(ANAme: string);
begin
  sl.Add(Format('<section name="%s">',[CheckXMLValue(AName)]));
  Inc(sc);
end;

procedure CloseSection;
begin
  sl.Add('</section>');
  Dec(sc);
end;

var
  eb,i,c: integer;
  s: string;
begin
  {$IFDEF ERROR_INTERCEPT}PushTrace(FModes,Self,'Report'); {$ENDIF}
  sc:=0;
  c:=USBNodeCount;
  with sl do begin
    if Standalone then ReportHeader(sl);
    Add('<USB classname="TUSB">');

    Add(Format('<data name="Count" type="integer">%d</data>',[c]));
    Add(Format('<data name="ConnectedDevices" type="integer">%d</data>',[ConnectedDevices]));

    if c>0 then begin
    eb:=0;
    for i:=0 to c-1 do
      case USBNodes[i].USBClass of
        usbHostController: begin
          if eb>0 then begin
            Dec(eb);
            CloseSection;
          end;
          if i>0 then begin
            CloseSection;
            CloseSection;
          end;
          s:=Format('%s %d',[ClassNames[Integer(USBNodes[i].USBClass)],USBNodes[i].USBDevice.Port]);
          OpenSection(s);
          Add(Format('<data name="ConnectionName" type="string">%s</data>',[CheckXMLValue(USBNodes[i].ConnectionName)]));
          Add(Format('<data name="DriveKeyName" type="string">%s</data>',[CheckXMLValue(USBNodes[i].KeyName)]));
        end;
        usbHub: begin
          if eb>0 then begin
            Dec(eb);
            CloseSection;
          end;
          s:=Format('%s on HC %d',[ClassNames[Integer(USBNodes[i].USBClass)],USBNodes[i].USBDevice.Port]);
          OpenSection(s);
          Add(Format('<data name="ConnectionName" type="string">%s</data>',[CheckXMLValue(USBNodes[i].ConnectionName)]));
          Add(Format('<data name="DriveKeyName" type="string">%s</data>',[CheckXMLValue(USBNodes[i].KeyName)]));
        end;
        else begin
          if (eb>0) and (USBNodes[i].ParentIndex<USBNodes[i-1].ParentIndex) then begin
            Dec(eb);
            CloseSection;
          end;
          if USBNodes[i].USBDevice.ConnectionStatus=1 then begin
            if USBNodes[i].USBClass=usbExternalHub then begin
              Inc(eb);
              s:=Format('Port[%d]: %s',[USBNodes[i].USBDevice.Port,ClassNames[Integer(USBNodes[i].USBClass)]]);
              OpenSection(s);
              Add(Format('<data name="ConnectionName" type="string">%s</data>',[CheckXMLValue(USBNodes[i].ConnectionName)]));
              Add(Format('<data name="DriveKeyName" type="string">%s</data>',[CheckXMLValue(USBNodes[i].KeyName)]));
            end else begin
              s:=Format('Port[%d]: %s',[USBNodes[i].USBDevice.Port,USBNodes[i].USBDevice.Product]);
              OpenSection(s);
              Add(Format('<data name="ConnectionName" type="string">%s</data>',[CheckXMLValue(USBNodes[i].ConnectionName)]));
              Add(Format('<data name="DriveKeyName" type="string">%s</data>',[CheckXMLValue(USBNodes[i].KeyName)]));
              Add(Format('<data name="Classname" type="string">%s</data>',[CheckXMLValue(ClassNames[Integer(USBNodes[i].USBClass)])]));
              Add(Format('<data name="Manufacturer" type="string">%s</data>',[CheckXMLValue(USBNodes[i].USBDevice.Manufacturer)]));
              Add(Format('<data name="Serial" type="string">%s</data>',[CheckXMLValue(USBNodes[i].USBDevice.Serial)]));
              Add(Format('<data name="Power Consumption" type="integer" unit="mA">%d</data>',[USBNodes[i].USBDevice.MaxPower]));
              Add(Format('<data name="Specification" type="string">%d.%d</data>',[USBNodes[i].USBDevice.Majorversion,USBNodes[i].USBDevice.Minorversion]));
              Add(Format('<data name="VendorID" type="integer">%d</data>',[USBNodes[i].USBDevice.VendorID]));
              Add(Format('<data name="ProductID" type="integer">%d</data>',[USBNodes[i].USBDevice.ProductID]));
              CloseSection;
            end;
          end else begin
            s:=Format('Port[%d]: %s',[USBNodes[i].USBDevice.Port,ConnectionStates[USBNodes[i].USBDevice.ConnectionStatus]]);
            OpenSection(s);
            CloseSection;
          end;
        end;
      end;
    CloseSection;
    CloseSection;
    end;

    if sc>0 then
      for i:=0 to sc-1 do
        CloseSection;
    Add('</USB>');
    if Standalone then ReportFooter(sl);
  end;
  {$IFDEF ERROR_INTERCEPT}PopTrace;{$ENDIF}
end;

procedure TUSB.SetMode(const Value: TExceptionModes);
begin
  FModes := Value;
end;

end.
