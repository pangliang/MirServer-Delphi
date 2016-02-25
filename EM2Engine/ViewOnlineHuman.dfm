object frmViewOnlineHuman: TfrmViewOnlineHuman
  Left = 273
  Top = 420
  Caption = #22312#32447#20154#29289
  ClientHeight = 418
  ClientWidth = 818
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object PanelStatus: TPanel
    Left = 0
    Top = 0
    Width = 818
    Height = 362
    Align = alClient
    Caption = #27491#22312#35835#21462#25968#25454'...'
    TabOrder = 0
    ExplicitWidth = 929
    ExplicitHeight = 472
    object GridHuman: TStringGrid
      Left = 1
      Top = 1
      Width = 816
      Height = 360
      Align = alClient
      ColCount = 16
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 25
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      OnDblClick = GridHumanDblClick
      ExplicitWidth = 927
      ExplicitHeight = 470
      ColWidths = (
        33
        78
        31
        44
        39
        37
        47
        74
        89
        32
        138
        59
        55
        57
        64
        285)
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 362
    Width = 818
    Height = 56
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 472
    ExplicitWidth = 929
    object Label1: TLabel
      Left = 104
      Top = 20
      Width = 30
      Height = 12
      Caption = #25490#24207':'
    end
    object ButtonRefGrid: TButton
      Left = 8
      Top = 15
      Width = 73
      Height = 25
      Caption = #21047#26032'(&R)'
      TabOrder = 0
      OnClick = ButtonRefGridClick
    end
    object ComboBoxSort: TComboBox
      Left = 144
      Top = 20
      Width = 113
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 1
      OnClick = ComboBoxSortClick
      Items.Strings = (
        #21517#31216
        #24615#21035
        #32844#19994
        #31561#32423
        #22320#22270
        #65321#65328
        #26435#38480
        #25152#22312#22320#21306)
    end
    object EditSearchName: TEdit
      Left = 272
      Top = 20
      Width = 129
      Height = 20
      TabOrder = 2
    end
    object ButtonSearch: TButton
      Left = 416
      Top = 15
      Width = 73
      Height = 25
      Caption = #25628#32034'(&S)'
      TabOrder = 3
      OnClick = ButtonSearchClick
    end
    object ButtonView: TButton
      Left = 496
      Top = 15
      Width = 81
      Height = 25
      Caption = #20154#29289#20449#24687'(&H)'
      TabOrder = 4
      OnClick = ButtonViewClick
    end
    object Button1: TButton
      Left = 584
      Top = 16
      Width = 137
      Height = 25
      Caption = #36386#38500#31163#32447#25346#26426#20154#29289'(&K)'
      TabOrder = 5
      OnClick = Button1Click
    end
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 280
    Top = 392
  end
end
