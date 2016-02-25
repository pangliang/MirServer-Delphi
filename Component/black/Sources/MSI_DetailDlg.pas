{*******************************************************}
{                                                       }
{          MiTeC System Information Component           }
{                Detail Info Dialog                     }
{           version 8.5 for Delphi 5,6                  }
{                                                       }
{       Copyright © 1997,2002 Michal Mutl               }
{                                                       }
{*******************************************************}


unit MSI_DetailDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CheckLst, ComCtrls;

type
  TdlgMSI_Detail = class(TForm)
    ButtonPanel: TPanel;
    Panel: TPanel;
    bOK: TButton;
    ClientPanel: TPanel;
    Notebook: TNotebook;
    Memo: TMemo;
    clb: TCheckListBox;
    lb: TListBox;
    lv: TListView;
    pc: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    procedure clbClickCheck(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lvAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure lvAdvancedCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
  private
  public
  end;

var
  dlgMSI_Detail: TdlgMSI_Detail;

implementation

uses MiTeC_CtrlRtns;

{$R *.DFM}

procedure TdlgMSI_Detail.clbClickCheck(Sender: TObject);
var
  OCC: TNotifyEvent;
  idx: integer;
  p: TPoint;
begin
  with TCheckListBox(Sender) do begin
    OCC:=OnClickCheck;
    OnClickCheck:=nil;
    GetCursorPos(p);
    p:=ScreenToClient(p);
    idx:=ItemAtPos(p,True);
    if idx>-1 then
      Checked[idx]:=not Checked[idx];
    OnClickCheck:=OCC;
  end;
end;

procedure TdlgMSI_Detail.FormCreate(Sender: TObject);
begin
  caption:=Application.Title;
end;

procedure TdlgMSI_Detail.FormActivate(Sender: TObject);
begin
  lv.Width:=0;
end;

procedure TdlgMSI_Detail.lvAdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
begin
  DefaultDraw:=True;
  with TListView(Sender) do begin
    Canvas.Font.Style:=[];
    if Item.ImageIndex=-3 then
      Canvas.Font.Style:=[fsBold];
    Canvas.Font.Color:=clBlack;
    if cdsHot in State then begin
      Canvas.Font.Color:=clBlue;
      Canvas.Font.Style:=Canvas.Font.Style+[fsUnderLine];
    end else
      Canvas.Font.Style:=Canvas.Font.Style-[fsUnderLine];
    if Item.ImageIndex=-2 then
      ListView_DrawLine(Sender,Item,State,DefaultDraw,clGray);
  end;
end;

procedure TdlgMSI_Detail.lvAdvancedCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
begin
  with TListView(Sender) do begin
    Canvas.Font.Style:=[];
    if Item.ImageIndex=-3 then
      Canvas.Font.Style:=[fsBold];
    Canvas.Font.Color:=clBlack;
    if Item.ImageIndex=-4 then
      ListView_DrawCheckBox(Sender,Item,SubItem,State,DefaultDraw,'1')
    else
      Canvas.Brush.Color:=Color;
    if cdsHot in State then
      Canvas.Font.Style:=Canvas.Font.Style+[fsUnderline]
    else
      Canvas.Font.Style:=Canvas.Font.Style-[fsUnderline];
  end;
end;

end.
