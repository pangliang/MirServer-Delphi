unit MiTeC_Params;

interface

uses SysUtils, Classes, Windows;

type
  TFindParamOption = (fpMatchCase, fpPartial);

  TFindParamOptions = set of TFindParamOption;

  TApplicationParameters = class
  private
    FParamList: TStringList;
    function GetParamCount: Byte;
    function GetParameter(Index: Byte): string;
    procedure ReadParameters;
    function GetCmdLine: string;
    function GetIsNumber(Index: Byte): boolean;
  public
    constructor Create;
    destructor Destroy; override;

    property Parameters[Index: Byte]: string read GetParameter;
    property ParamIsNumber[Index: Byte]: boolean read GetIsNumber;
    property ParamCount: Byte read GetParamCount;
    property CommandLine: string read GetCmdLine;

    function IndexOf(Value: string; Options: TFindParamOptions = []): integer;
  end;

implementation

{ TApplicationParameters }

constructor TApplicationParameters.Create;
begin
  FParamList:=TStringList.Create;
  ReadParameters;
end;

destructor TApplicationParameters.Destroy;
begin
  FParamList.Free;
  inherited;
end;

function TApplicationParameters.IndexOf;
var
  i: Integer;
  s: string;
begin
  Result:=-1;
  if not(fpMatchCase in Options) then
    Value:=UpperCase(Value);
  for i:=0 to FParamList.Count-1 do begin
    if not(fpMatchCase in Options) then
      s:=UpperCase(FParamList[i])
    else
      s:=FParamList[i];
    if fpPartial in Options then begin
      if Pos(Value,s)=0 then begin
        Result:=i;
        Break;
      end;
    end else
      if Value=s then begin
        Result:=i;
        Break;
      end;
  end;
end;

function TApplicationParameters.GetCmdLine: string;
begin
  Result:=GetCommandLine;
end;

function TApplicationParameters.GetParamCount: Byte;
begin
  Result:=FParamList.Count;
end;

function TApplicationParameters.GetParameter(Index: Byte): string;
begin
  if (Index<FParamList.Count) then
    Result:=FParamList[Index]
  else
    Result:='';
end;

procedure TApplicationParameters.ReadParameters;
var
  i: Integer;
begin
  FParamList.Clear;
  i:=0;
  while ParamStr(i)<>'' do begin
    FParamList.Add(ParamStr(i));
    Inc(i);
  end;
end;

function TApplicationParameters.GetIsNumber(Index: Byte): boolean;
begin
  try
    StrToInt(FParamList[Index]);
    Result:=True;
  except
    Result:=False;
  end;
end;

end.
