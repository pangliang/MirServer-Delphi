object MainForm: TMainForm
  Left = 301
  Top = 140
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MainForm'
  ClientHeight = 126
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 36
    Height = 12
    Caption = #26126#25991#65306
  end
  object Label2: TLabel
    Left = 16
    Top = 56
    Width = 36
    Height = 12
    Caption = #23494#25991#65306
  end
  object Button1: TButton
    Left = 16
    Top = 88
    Width = 75
    Height = 25
    Caption = #21152#23494
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 384
    Top = 88
    Width = 75
    Height = 25
    Caption = #35299#23494
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 56
    Top = 24
    Width = 401
    Height = 20
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 56
    Top = 56
    Width = 401
    Height = 20
    TabOrder = 3
  end
end
