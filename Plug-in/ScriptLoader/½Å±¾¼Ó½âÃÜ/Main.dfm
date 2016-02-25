object FrmMain: TFrmMain
  Left = 233
  Top = 166
  Width = 688
  Height = 459
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = #33050#26412#21152#35299#23494#24037#20855
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    680
    425)
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 392
    Top = 212
    Width = 36
    Height = 13
    AutoSize = False
    Caption = #23494#30721#65306
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Terminal'
    Font.Style = []
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 681
    Height = 201
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      #31243#24207#21046#20316#65306#21494#38543#39118#39128
      #32852#31995'QQ'#65306'240621028'
      #31243#24207#32593#22336#65306'http://www.51ggame.com')
    PopupMenu = PopupMenu1
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 0
    Top = 240
    Width = 681
    Height = 185
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      #31243#24207#21046#20316#65306#21494#38543#39118#39128
      #32852#31995'QQ'#65306'240621028'
      #31243#24207#32593#22336#65306'http://www.51ggame.com')
    PopupMenu = PopupMenu2
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Button1: TButton
    Left = 8
    Top = 208
    Width = 105
    Height = 25
    Caption = #25171#24320#21152#23494#33050#26412
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Terminal'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 120
    Top = 208
    Width = 105
    Height = 25
    Caption = #25171#24320#26222#36890#33050#26412
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Terminal'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 432
    Top = 210
    Width = 233
    Height = 20
    TabOrder = 4
  end
  object Button3: TButton
    Left = 312
    Top = 208
    Width = 75
    Height = 25
    Caption = #21152#23494
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Terminal'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 232
    Top = 208
    Width = 75
    Height = 25
    Caption = #35299#23494
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Terminal'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = Button4Click
  end
  object EditEncodeStr: TEdit
    Left = 160
    Top = 284
    Width = 337
    Height = 20
    TabOrder = 7
    Text = ';+++++++----------------'
    Visible = False
  end
  object OpenDialog1: TOpenDialog
    Filter = #25991#26412#25991#20214'|*.txt'
    Left = 208
    Top = 16
  end
  object PopupMenu1: TPopupMenu
    Left = 304
    Top = 72
    object N1: TMenuItem
      Caption = #28165#38500
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #20445#23384
      OnClick = N2Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 344
    Top = 312
    object N3: TMenuItem
      Caption = #28165#38500
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #20445#23384
      OnClick = N4Click
    end
  end
end
