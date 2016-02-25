unit PlugInManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SDK;

type
  TftmPlugInManage = class(TForm)
    ListBoxPlugin: TListBox;
    ButtonConfig: TButton;
    procedure ListBoxPluginClick(Sender: TObject);
    procedure ButtonConfigClick(Sender: TObject);
    procedure ListBoxPluginDblClick(Sender: TObject);
  private
    procedure RefPlugin();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  ftmPlugInManage: TftmPlugInManage;
  StartProc: TStartProc;
implementation

uses M2Share, PlugIn, PlugOfEngine;

{$R *.dfm}

procedure TftmPlugInManage.Open;
begin
  ButtonConfig.Enabled:=False;
  RefPlugin();
  Self.ShowModal;
end;

procedure TftmPlugInManage.RefPlugin;
var
  i: Integer;
begin
  ListBoxPlugin.Clear;
  for i := 0 to PlugInEngine.PlugList.Count - 1 do begin
    ListBoxPlugin.Items.AddObject(PlugInEngine.PlugList.Strings[i], PlugInEngine.PlugList.Objects[i]);
  end;
end;

procedure TftmPlugInManage.ListBoxPluginClick(Sender: TObject);
var
  Module: THandle;
begin
  try
    StartProc := nil;
    Module := pTPlugInfo(ListBoxPlugin.Items.Objects[ListBoxPlugin.ItemIndex]).Module;
    StartProc := GetProcAddress(Module, 'Config');
    if Assigned(StartProc) then ButtonConfig.Enabled := True else ButtonConfig.Enabled := False;
  except
    ButtonConfig.Enabled := False;
    StartProc := nil;
  end;
end;

procedure TftmPlugInManage.ButtonConfigClick(Sender: TObject);
begin
  if Assigned(StartProc) then TStartProc(StartProc);
end;

procedure TftmPlugInManage.ListBoxPluginDblClick(Sender: TObject);
begin
  if Assigned(StartProc) then TStartProc(StartProc);
end;

end.

