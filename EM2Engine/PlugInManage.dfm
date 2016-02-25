object ftmPlugInManage: TftmPlugInManage
  Left = 530
  Top = 262
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #21151#33021#25554#20214
  ClientHeight = 230
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object ListBoxPlugin: TListBox
    Left = 8
    Top = 16
    Width = 329
    Height = 201
    ItemHeight = 12
    TabOrder = 0
    OnClick = ListBoxPluginClick
    OnDblClick = ListBoxPluginDblClick
  end
  object ButtonConfig: TButton
    Left = 352
    Top = 16
    Width = 75
    Height = 25
    Caption = #37197#21046'(&C)'
    TabOrder = 1
    OnClick = ButtonConfigClick
  end
end
