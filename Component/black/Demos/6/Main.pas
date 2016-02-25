unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MSI_Processes, ComCtrls, ExtCtrls, StdCtrls, MSI_Common;

type
  Twnd_Main = class(TForm)
    List: TListView;
    pTitle: TPanel;
    Image1: TImage;
    Bevel1: TBevel;
    bRefresh: TButton;
    bSave: TButton;
    bClose: TButton;
    Label1: TLabel;
    Label2: TLabel;
    eName: TEdit;
    ePri: TEdit;
    sd: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure ListAdvancedCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure TimerTimer(Sender: TObject);
    procedure bRefreshClick(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure ListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure bSaveClick(Sender: TObject);
  private
    ProcList: TProcessList;
  public
    procedure RefreshData;
  end;

var
  wnd_Main: Twnd_Main;

implementation

uses MiTeC_CtrlRtns, MiTeC_Datetime;

{$R *.dfm}

procedure Twnd_Main.FormCreate(Sender: TObject);
begin
  ProcList:=TProcessList.Create;
  if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
    List.Columns[2].Caption:='Threads';
    List.Columns[3].Caption:='Usage';
  end;
  RefreshData;
end;

procedure Twnd_Main.FormDestroy(Sender: TObject);
begin
  ProcList.Destroy;
end;

procedure Twnd_Main.RefreshData;
var
  i: Integer;
begin
  with ProcList do
    try
      List.Items.BeginUpdate;
      List.Items.Clear;
      //Screen.Cursor:=crHourglass;
      GetInfo;
      for i:=0 to ProcessCount-1 do
        with List.Items.Add do begin
          Caption:=Processes[i].Name;
          if Win32Platform<>VER_PLATFORM_WIN32_NT then begin
            SubItems.Add(Format('%x',[Processes[i].PID]));
            SubItems.Add(Format('%d',[Processes[i].ThreadCount]));
            SubItems.Add(Format('%d',[Processes[i].Usage]));
          end else begin
            SubItems.Add(Format('%d',[Processes[i].PID]));
            SubItems.Add(FormatSeconds((Processes[i].UserTime.QuadPart+Processes[i].KernelTime.QuadPart)/10000000,True,False,True));
            SubItems.Add(Format('%d KB',[Processes[i].VMCounters.WorkingSetSize div 1024]));
          end;
        end;
    finally
      List.Items.EndUpdate;
      pTitle.Caption:=Format('               %d processes',[List.Items.Count]);
      //Screen.Cursor:=crDefault;
    end;
end;

procedure Twnd_Main.ListCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
  Compare:=ListView_CustomSort(Item1,Item2,ListView_SortColumn);
  if ListView_SortDescending then
    Compare:=-Compare;
end;

procedure Twnd_Main.ListColumnClick(Sender: TObject; Column: TListColumn);
begin
  TListView(Sender).SortType:=stNone;
  if Column.Index<>ListView_SortColumn then begin
    ListView_SortColumn:=Column.Index;
    ListView_SortDescending:=False;
  end else
    ListView_SortDescending:=not ListView_SortDescending;
  TListView(Sender).SortType:=stText;
end;

procedure Twnd_Main.ListAdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
begin
  if ListView_SortColumn=0 then
    Sender.Canvas.Brush.Color:=clInfoBk
  else
    Sender.Canvas.Brush.Color:=clWhite
end;

procedure Twnd_Main.ListAdvancedCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  if ListView_SortColumn=SubItem then
    Sender.Canvas.Brush.Color:=clInfoBk
  else
    Sender.Canvas.Brush.Color:=clWhite
end;

procedure Twnd_Main.TimerTimer(Sender: TObject);
begin
  RefreshData;
end;

procedure Twnd_Main.bRefreshClick(Sender: TObject);
begin
  RefreshData;
end;

procedure Twnd_Main.bCloseClick(Sender: TObject);
begin
  Close;
end;

procedure Twnd_Main.ListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
  idx: Integer;
  pid: DWORD;
begin
  idx:=-1;
  if Assigned(Item) and Selected then begin
    if Win32Platform<>VER_PLATFORM_WIN32_NT then
      pid:=StrToInt('$'+Item.SubItems[0])
    else
      pid:=StrToInt(Item.SubItems[0]);
    idx:=ProcList.FindProcess(pid);
    if idx<>-1 then begin
      eName.Text:=ProcList.Processes[idx].ImageName;
      ePri.Text:=Format('%d',[ProcList.Processes[idx].Priority]);
    end;
  end;
  if idx=-1 then begin
    eName.Text:='';
    ePri.Text:='';
  end;
end;

procedure Twnd_Main.bSaveClick(Sender: TObject);
var
  sl: TStringList;
begin
  sl:=TStringList.Create;
  if sd.Execute then begin
    ProcList.Report(sl,True);
    sl.SaveToFile(sd.FileName);
  end;
  sl.Free;
end;

end.
