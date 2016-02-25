object frmGeneralConfig: TfrmGeneralConfig
  Left = 387
  Top = 312
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #22522#26412#35774#32622
  ClientHeight = 158
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBoxNet: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 113
    Caption = #32593#32476#35774#32622
    TabOrder = 0
    object LabelGateIPaddr: TLabel
      Left = 8
      Top = 20
      Width = 54
      Height = 12
      Caption = #32593#20851#22320#22336':'
    end
    object LabelGatePort: TLabel
      Left = 8
      Top = 44
      Width = 54
      Height = 12
      Caption = #32593#20851#31471#21475':'
    end
    object LabelServerPort: TLabel
      Left = 8
      Top = 92
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#31471#21475':'
    end
    object LabelServerIPaddr: TLabel
      Left = 8
      Top = 68
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#22320#22336':'
    end
    object EditGateIPaddr: TEdit
      Left = 80
      Top = 16
      Width = 97
      Height = 20
      Hint = 
        #27492#22320#22336#19968#33324#40664#35748#20026' 0.0.0.0 '#65292#36890#24120#19981#38656#35201#26356#25913#12290#13#10#22914#26524#21333#26426#19978#26377#22810#20010'IP'#22320#22336#26102#65292#21487#35774#32622#20026#26412#26426#20854#13#10#20013#19968#20010'IP'#65292#20197#23454#29616#21516#31471#21475#19981 +
        #21516'IP'#30340#32465#23450#12290
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '0.0.0.0'
    end
    object EditGatePort: TEdit
      Left = 80
      Top = 40
      Width = 41
      Height = 20
      Hint = #32593#20851#23545#22806#24320#25918#30340#31471#21475#21495#65292#27492#31471#21475#26631#20934#20026' 7200'#65292#13#10#27492#31471#21475#21487#26681#25454#33258#24049#30340#35201#27714#36827#34892#20462#25913#12290
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '7200'
    end
    object EditServerPort: TEdit
      Left = 80
      Top = 88
      Width = 41
      Height = 20
      Hint = #28216#25103#26381#21153#22120#30340#31471#21475#65292#27492#31471#21475#26631#20934#20026' 5000'#65292#13#10#22914#26524#20351#29992#30340#28216#25103#26381#21153#22120#31471#20462#25913#36807#65292#21017#25913#20026#13#10#30456#24212#30340#31471#21475#23601#34892#20102#12290
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '5000'
    end
    object EditServerIPaddr: TEdit
      Left = 80
      Top = 64
      Width = 97
      Height = 20
      Hint = #28216#25103#26381#21153#22120#30340'IP'#22320#22336#65292#22914#26524#26159#21333#26426#36816#34892#26381#21153#13#10#22120#31471#26102#65292#19968#33324#23601#29992' 127.0.0.1 '#12290
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '127.0.0.1'
    end
  end
  object GroupBoxInfo: TGroupBox
    Left = 200
    Top = 8
    Width = 161
    Height = 113
    Caption = #22522#26412#21442#25968
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 30
      Height = 12
      Caption = #26631#39064':'
    end
    object LabelShowLogLevel: TLabel
      Left = 8
      Top = 44
      Width = 78
      Height = 12
      Caption = #26174#31034#26085#24535#31561#32423':'
    end
    object LabelShowBite: TLabel
      Left = 8
      Top = 92
      Width = 78
      Height = 12
      Caption = #27969#37327#26174#31034#21333#20301':'
    end
    object EditTitle: TEdit
      Left = 40
      Top = 16
      Width = 105
      Height = 20
      Hint = #31243#24207#26631#39064#19978#26174#31034#30340#21517#31216#65292#27492#21517#31216#21482#29992#20110#26174#31034#13#10#26242#26102#19981#20570#20854#23427#29992#36884#12290
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = #39128#39128#32593#32476
    end
    object TrackBarLogLevel: TTrackBar
      Left = 8
      Top = 56
      Width = 145
      Height = 25
      Hint = #31243#24207#36816#34892#26085#24535#26174#31034#35814#32454#31561#32423#12290
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object ComboBoxShowBite: TComboBox
      Left = 88
      Top = 88
      Width = 57
      Height = 20
      Hint = #31243#24207#20027#20171#38754#19978#26174#31034#30340#30417#25511#25968#25454#27969#37327#26174#31034#21333#20301#12290
      Style = csDropDownList
      ItemHeight = 12
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Items.Strings = (
        'KB'
        'B')
    end
  end
  object ButtonOK: TButton
    Left = 296
    Top = 128
    Width = 65
    Height = 25
    Hint = #20445#23384#24403#21069#35774#32622#65292#32593#32476#35774#32622#20110#19979#19968#27425#21551#21160#13#10#26381#21153#26102#29983#25928#12290
    Caption = #30830#23450'(&O)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = ButtonOKClick
  end
end
