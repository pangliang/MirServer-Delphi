unit EngineRegister;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, svMain, IniFiles, RzButton, Mask, RzEdit;

type
  TFrmRegister = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditUserName: TRzEdit;
    EditRegisterName: TRzEdit;
    EditRegisterCode: TRzEdit;
    RzBitBtnRegister: TRzBitBtn;
    procedure RzBitBtnRegisterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open();
  end;

var
  FrmRegister: TFrmRegister;

implementation
uses M2Share, SDK;
{$R *.dfm}
procedure TFrmRegister.Open();
var
  sRegisterName:array [0..99] of Char;
begin
  EditRegisterName.Text := '';
  try
    if (nGetRegisterName >= 0) and Assigned(PlugProcArray[nGetRegisterName].nProcAddr) then begin
      if PlugProcArray[nGetRegisterName].nCheckCode = 3 then begin
        FillChar(sRegisterName,SizeOf(sRegisterName),0);
        TGetStrProc(PlugProcArray[nGetRegisterName].nProcAddr)(@sRegisterName);
        EditRegisterName.Text := StrPas(@sRegisterName);
      end;
    end;
  except
  end;
  ShowModal;
end;

procedure TFrmRegister.RzBitBtnRegisterClick(Sender: TObject);
type
  TGetLicense = function(var nUserLicense:Integer; var wErrorCode: Word): Integer; stdcall;
var
  sRegisterName, sUserName, sRegisterCode: string;
  nRegister, nM2Crc: Integer;
  m_nUserLicense:Integer;
  m_nErrorCode:Word;
begin
  sRegisterName := Trim(EditRegisterName.Text);
  sUserName := Trim(EditUserName.Text);
  sRegisterCode := Trim(EditRegisterCode.Text);
  if (sRegisterName <> '') and (sUserName <> '') and (sRegisterCode <> '') then begin
    if (nStartRegister >= 0) and Assigned(PlugProcArray[nStartRegister].nProcAddr) then begin
      if PlugProcArray[nStartRegister].nCheckCode = 4 then begin
        nRegister := TStartRegister(PlugProcArray[nStartRegister].nProcAddr)(PChar(sRegisterCode), PChar(sUserName));
        //Showmessage(IntToStr(nRegister));
        case nRegister of
          1, 2: begin
              if (g_nGetLicenseInfo >= 0) and Assigned(PlugProcArray[g_nGetLicenseInfo].nProcAddr) and (PlugProcArray[g_nGetLicenseInfo].nCheckCode = 20) then begin
                nM2Crc := TGetLicense(PlugProcArray[g_nGetLicenseInfo].nProcAddr)(m_nUserLicense, m_nErrorCode);
                {if (nStartModule >= 0) and Assigned(PlugProcArray[nStartModule].nProcAddr) then begin
                  if PlugProcArray[nStartModule].nCheckCode = 1 then begin
                    TStartProc(PlugProcArray[nStartModule].nProcAddr);
                  end;
                end; }
              end;
            end;
        end;
      end;
    end;
  end;
  Close;
end;

end.

