unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Tabs, Gauges;

type
  TForm1 = class(TForm)
    Memo: TMemo;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Label2MouseEnter(Sender: TObject);
    procedure Label2MouseLeave(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

uses
  MSIC_Intf, XMLDoc, XMLIntf, XmlDom, MSI_CPUUsage;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  s: string;
  XMLDoc: IXMLDocument;
begin
  if Assigned(GenerateXMLReport) then begin
    s:=ChangeFileExt(Application.ExeName,'.xml');
    GenerateXMLReport(SO_OS,PChar(s));

    XMLDoc:=NewXMLDocument;
    XMLDoc.LoadFromFile(s);
    with XMLDoc.DocumentElement.ChildNodes[0] do
      for i:=0 to ChildNodes.Count-1 do
        if SameText(ChildNodes[i].NodeName,'data') then
          Memo.Lines.Add(Format('%s: %s',[ChildNodes[i].GetAttribute('name'),ChildNodes[i].Text]));
  end else
    MessageDlg('Library not found.',mtError,[mbOK],0);
end;

procedure TForm1.Label2MouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Style:=[fsUnderline];
end;

procedure TForm1.Label2MouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Style:=[];
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
  if Assigned(ShowSystemOverviewModal) then
    ShowSystemOverviewModal
  else
    MessageDlg('Library not found.',mtError,[mbOK],0);
end;

end.
