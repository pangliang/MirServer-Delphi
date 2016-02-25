unit DiaLogMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmDiaLog = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EditUserName: TEdit;
    EditEnterKey: TEdit;
    LabelMsg: TLabel;
    ButtonOK: TButton;
    ButtonClose: TButton;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open();
  end;

var
  FrmDiaLog: TFrmDiaLog;

implementation
uses Share, PlugMain;
{$R *.dfm}
procedure TFrmDiaLog.Open();
begin
  EditUserName.Text := m_sRegisterName;
  LabelMsg.Caption := Trim(sMsg);
  ShowModal;
end;

procedure TFrmDiaLog.ButtonOKClick(Sender: TObject);
var
  sRegisterCode: string;
begin
  sRegisterCode := Trim(EditEnterKey.Text);
  if sRegisterCode <> '' then begin
    if StartRegisterLicense(sRegisterCode) then begin
      Application.MessageBox('注册成功,请保存好你的注册码！！！', '提示信息', MB_OK + MB_ICONASTERISK);
    end;
  end;
  Close;
end;

procedure TFrmDiaLog.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmDiaLog.Button1Click(Sender: TObject);
begin
  EditUserName.Text := GetRegisterName;
end;

end.

