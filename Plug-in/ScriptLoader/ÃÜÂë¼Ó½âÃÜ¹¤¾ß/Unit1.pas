unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
const
  SuperUser = 240621028; //飘飘网络
  UserKey1 = 13677866; //飞尔世界
  UserKey2 = 987355; //亿众网络业务
  UserKey3 = 548262000; //弘智网络     //此QQ后已经增加三个0 不加会导致无法注册
  UserKey4 = 19639454; //封神网
  UserKey5 = 240272000; //速网科技      //此QQ后已经增加三个0 不加会导致无法注册
  UserKey6 = 137792942;//泡泡龙
  UserKey7 = 635455000;//翎风数据       //此QQ后已经增加三个0 不加会导致无法注册
  UserKey8 = 358722000; //杨继元        //此QQ后已经增加三个0 不加会导致无法注册
  UserKey9 = 240621028; //飘飘网络
  UserKey10 = 240621028; //飘飘网络
  Version = UserKey8;
implementation
uses EncryptUnit;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Edit2.Text := EncodeString_3des(Edit1.Text, IntToStr(Version * 5));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Edit1.Text := DecodeString_3des(Edit2.Text, IntToStr(Version * 5));
end;

end.

