object FrmOnLineHum: TFrmOnLineHum
  Left = 301
  Top = 287
  BorderStyle = bsDialog
  Caption = #22312#32447#20154#29289
  ClientHeight = 320
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 489
    Height = 273
    Caption = #22312#32447#20154#29289
    TabOrder = 0
    object ListViewOnLine: TListView
      Left = 8
      Top = 16
      Width = 473
      Height = 249
      Columns = <
        item
          Caption = #24207#21495
        end
        item
          Caption = #30331#38470'IP'#22320#22336
          Width = 100
        end
        item
          Caption = #20250#35805#26631#35782
          Width = 80
        end
        item
          Caption = #25968#25454#38271#24230
          Width = 80
        end
        item
          Caption = #24403#21069#29366#24577
          Width = 150
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewOnLineClick
    end
  end
  object ButtonRef: TButton
    Left = 8
    Top = 288
    Width = 75
    Height = 25
    Caption = #21047#26032'(&R)'
    TabOrder = 1
    OnClick = ButtonRefClick
  end
  object ButtonKick: TButton
    Left = 88
    Top = 288
    Width = 75
    Height = 25
    Caption = #36386#19979#32447'(&T)'
    TabOrder = 2
    OnClick = ButtonKickClick
  end
  object ButtonAddTempList: TButton
    Left = 232
    Top = 288
    Width = 129
    Height = 25
    Caption = #21152#20837#21160#24577#36807#28388#21015#34920'(&A)'
    TabOrder = 3
    OnClick = ButtonAddTempListClick
  end
  object ButtonAddBlockList: TButton
    Left = 368
    Top = 288
    Width = 129
    Height = 25
    Caption = #21152#20837#27704#20037#36807#28388#21015#34920'(&D)'
    TabOrder = 4
    OnClick = ButtonAddBlockListClick
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 184
    Top = 288
  end
end
