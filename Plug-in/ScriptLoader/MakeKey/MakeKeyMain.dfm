object FrmMakeKey: TFrmMakeKey
  Left = 406
  Top = 280
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FrmMakeKey'
  ClientHeight = 132
  ClientWidth = 306
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
    Top = 20
    Width = 48
    Height = 12
    Caption = #26426#22120#30721#65306
  end
  object Label2: TLabel
    Left = 16
    Top = 44
    Width = 48
    Height = 12
    Caption = #27880#20876#30721#65306
  end
  object Label3: TLabel
    Left = 96
    Top = 104
    Width = 192
    Height = 12
    Caption = #31243#24207#21046#20316#65306#21494#38543#39118#39128' QQ'#65306'240621028'
  end
  object Label4: TLabel
    Left = 16
    Top = 64
    Width = 36
    Height = 12
    Caption = #23494#30721#65306
  end
  object EditRegisterName: TEdit
    Left = 64
    Top = 16
    Width = 233
    Height = 20
    TabOrder = 0
  end
  object ButtonOK: TButton
    Left = 8
    Top = 96
    Width = 75
    Height = 25
    Caption = #35745#31639
    TabOrder = 1
    OnClick = ButtonOKClick
  end
  object EditRegisterCode: TEdit
    Left = 64
    Top = 40
    Width = 233
    Height = 20
    TabOrder = 2
  end
  object EditPassword: TEdit
    Left = 64
    Top = 64
    Width = 233
    Height = 20
    TabOrder = 3
  end
end
