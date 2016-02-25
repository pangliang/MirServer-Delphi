unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList, MiTeC_USB, MSI_USB, ExtCtrls;

type
  TForm1 = class(TForm)
    bRefresh: TButton;
    Tree: TTreeView;
    ilUSB: TImageList;
    bClose: TButton;
    Label1: TLabel;
    eName: TEdit;
    Label2: TLabel;
    eKey: TEdit;
    Bevel1: TBevel;
    bSave: TButton;
    sd: TSaveDialog;
    pTitle: TPanel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure bRefreshClick(Sender: TObject);
    procedure TreeDeletion(Sender: TObject; Node: TTreeNode);
    procedure TreeCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure bCloseClick(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure cmSave(Sender: TObject);
  private
    USB: TUSB;
    function FindNode(AIndex: Integer): TTreeNode;
  public
    procedure RefreshData;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.RefreshData;
var
  ii,i: Integer;
  s: string;
  pi: PInteger;
  r,n: TTreeNode;
begin
  USB.GetInfo;
  pTitle.Caption:=Format('              %d connected device(s)',[USB.ConnectedDevices]);
  Tree.Items.Clear;
  for i:=0 to USB.USBNodeCount-1 do
    with USB.USBNodes[i] do begin
      s:='';
      ii:=Integer(USBClass);
      case USBClass of
        usbHostController: s:=s+Format('%s %d',[ClassNames[Integer(USBClass)],USBDevice.Port]);
        usbHub: s:=s+ClassNames[Integer(USBClass)];
        else begin
          if USBDevice.ConnectionStatus=1 then begin
            if USBClass=usbExternalHub then
              s:=s+Format('Port[%d]: %s',[USBDevice.Port,ClassNames[Integer(USBClass)]])
            else
              s:=s+Format('Port[%d]: %s',[USBDevice.Port,USBDevice.Product]);
          end else begin
            s:=s+Format('Port[%d]: %s',[USBDevice.Port,ConnectionStates[USBDevice.ConnectionStatus]]);
            ii:=13;
          end;
        end;
      end;
      r:=FindNode(ParentIndex);
      new(pi);
      pi^:=i;
      n:=Tree.Items.AddChildObject(r,s,pi);
      n.ImageIndex:=ii;
      n.SelectedIndex:=n.ImageIndex;
      if Assigned(r) then
        r.Expand(False);
      r:=n;
      if (USBClass in [usbReserved..usbStorage,usbVendorSpec,usbError]) and (USBDevice.ConnectionStatus=1) then begin
        ii:=15;
        n:=Tree.Items.AddChild(r,Format('Class: %s',[ClassNames[Integer(USBClass)]]));
        n.ImageIndex:=ii;
        n.SelectedIndex:=n.ImageIndex;
        n:=Tree.Items.AddChild(r,Format('Manufacturer: %s',[USBDevice.Manufacturer]));
        n.ImageIndex:=ii;
        n.SelectedIndex:=n.ImageIndex;
        n:=Tree.Items.AddChild(r,Format('Serial: %s',[USBDevice.Serial]));
        n.ImageIndex:=ii;
        n.SelectedIndex:=n.ImageIndex;
        n:=Tree.Items.AddChild(r,Format('Power consumption: %d mA',[USBDevice.MaxPower]));
        n.ImageIndex:=ii;
        n.SelectedIndex:=n.ImageIndex;
        n:=Tree.Items.AddChild(r,Format('Specification version: %d.%d',[USBDevice.MajorVersion,USBDevice.MinorVersion]));
        n.ImageIndex:=ii;
        n.SelectedIndex:=n.ImageIndex;
      end;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  USB:=TUSB.Create;
  RefreshData;
end;

procedure TForm1.bRefreshClick(Sender: TObject);
begin
  RefreshData;
  Tree.SetFocus;
end;

function TForm1.FindNode(AIndex: Integer): TTreeNode;
var
  n: TTreeNode;
begin
  Result:=nil;
  n:=Tree.Items.GetFirstNode;
  while Assigned(n) do begin

    if Assigned(n.Data) and (PInteger(n.Data)^=AIndex) then begin
      Result:=n;
      Break;
    end;
    n:=n.GetNext;
  end;
end;

procedure TForm1.TreeDeletion(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node.Data) then
    Dispose(PInteger(Node.Data));
end;

procedure TForm1.TreeCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  n: TUSBNode;
begin
  if Assigned(Node) then begin
    if Assigned(Node.data) then begin
      n:=USB.USBNodes[PInteger(Node.Data)^];
      if n.USBClass in [usbReserved..usbStorage,usbVendorSpec,usbError] then begin
        if n.USBDevice.ConnectionStatus=1 then
          Sender.Canvas.Font.Style:=[fsBold];
      end;
    end else begin
      if cdsselected in State then
        Sender.Canvas.Font.Color:=clWhite
      else
        Sender.Canvas.Font.Color:=clNavy;
    end;
  end;
end;

procedure TForm1.bCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node) and Assigned(Node.Data) then begin
    eName.Text:=USB.USBNodes[PInteger(Node.Data)^].connectionname;
    eKey.Text:=USB.USBNodes[PInteger(Node.Data)^].keyname;
  end;
end;

procedure TForm1.cmSave(Sender: TObject);
var
  sl: TStringList;
begin
  sl:=TStringList.Create;
  if sd.Execute then begin
    USB.Report(sl,True);
    sl.SaveToFile(sd.FileName);
  end;
  sl.Free;
end;

end.
