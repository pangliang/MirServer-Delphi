unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MiTeC_WinIOCTL, StdCtrls, ComCtrls, ExtCtrls, ImgList, MSI_Storage;

type
  Twnd_dv_Main = class(TForm)
    Tree: TTreeView;
    pTitle: TPanel;
    bRefresh: TButton;
    bSave: TButton;
    bClose: TButton;
    Bevel1: TBevel;
    ImageList1: TImageList;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    eSerial: TEdit;
    eRev: TEdit;
    sd: TSaveDialog;
    procedure cmRefresh(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TreeDeletion(Sender: TObject; Node: TTreeNode);
    procedure TreeCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure bSaveClick(Sender: TObject);
  private
    Storage: TStorage;
  public
  end;

var
  wnd_dv_Main: Twnd_dv_Main;

implementation

uses MiTeC_StrUtils;

{$R *.dfm}

procedure Twnd_dv_Main.cmRefresh(Sender: TObject);
var
  i,j: Integer;
  n,r: TTreeNode;
  pi: PInteger;
begin
  with Storage do
    try
      Screen.Cursor:=crHourGlass;
      GetInfo;
      Tree.Items.Clear;
      for i:=0 to DeviceCount-1 do begin
        New(pi);
        pi^:=i;
        r:=Tree.Items.AddChildObject(nil,Format('%s %s - %d MB',[MiTeC_WinIOCTL.GetMediaTypeStr(Devices[i].Geometry.MediaType),Devices[i].Model,(Devices[i].Capacity div 1024) div 1024]),pi);
        case Devices[i].Geometry.MediaType of
          Fixedmedia: r.ImageIndex:=0;
          Removablemedia: r.ImageIndex:=1;
          else r.ImageIndex:=1;
        end;
        r.SelectedIndex:=r.ImageIndex;
        for j:=0 to High(Devices[i].Layout) do begin
          n:=Tree.Items.AddChild(r,Format('%s / %s - %d MB',[
                               GetPartitionType(Devices[i].Layout[j].PartitionNumber,Devices[i].Layout[j].PartitionType),
                               GetPartitionSystem(Devices[i].Layout[j].PartitionType),
                               (Devices[i].Layout[j].PartitionLength.QuadPart div 1024) div 1024]));
          n.ImageIndex:=r.ImageIndex;
          n.SelectedIndex:=n.ImageIndex;
        end;
        r.Expand(False);
      end;
      pTitle.Caption:=Format('              %d connected device(s)',[ConnectedDevices]);
    finally
      Screen.Cursor:=crDefault;
    end;
end;

procedure Twnd_dv_Main.bCloseClick(Sender: TObject);
begin
  Close;
end;

procedure Twnd_dv_Main.FormCreate(Sender: TObject);
begin
  Storage:=TStorage.Create;
  cmRefresh(nil);
end;

procedure Twnd_dv_Main.TreeDeletion(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node.Data) then
    Dispose(PInteger(Node.Data));
end;

procedure Twnd_dv_Main.TreeCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Assigned(Node) then
    if Assigned(Node.data) then
      Sender.Canvas.Font.Style:=[fsBold];
end;

procedure Twnd_dv_Main.FormDestroy(Sender: TObject);
begin
  Storage.Free;
end;

procedure Twnd_dv_Main.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node) and Assigned(Node.Data) then begin
    eSerial.Text:=Storage.Devices[PInteger(Node.Data)^].SerialNumber;
    eRev.Text:=Storage.Devices[PInteger(Node.Data)^].Revision;
  end else begin
    eSerial.Text:='';
    eRev.Text:='';
  end;
end;

procedure Twnd_dv_Main.bSaveClick(Sender: TObject);
var
  sl: TStringList;
begin
  sl:=TStringList.Create;
  if sd.Execute then begin
    Storage.Report(sl,True);
    sl.SaveToFile(sd.FileName);
  end;
  sl.Free;
end;

end.
