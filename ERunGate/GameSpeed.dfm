object FrmGameSpeed: TFrmGameSpeed
  Left = 352
  Top = 242
  BorderStyle = bsDialog
  Caption = #22806#25346#25511#21046
  ClientHeight = 319
  ClientWidth = 504
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 489
    Height = 305
    Caption = #21442#25968#35774#32622
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 128
      Top = 16
      Width = 113
      Height = 145
      Caption = #38388#38548#25511#21046'('#27627#31186')'
      TabOrder = 0
      object Label1: TLabel
        Left = 11
        Top = 24
        Width = 27
        Height = 13
        Caption = #25915#20987':'
      end
      object Label2: TLabel
        Left = 11
        Top = 48
        Width = 27
        Height = 13
        Caption = #39764#27861':'
      end
      object Label3: TLabel
        Left = 11
        Top = 72
        Width = 27
        Height = 13
        Caption = #36305#27493':'
      end
      object Label4: TLabel
        Left = 11
        Top = 96
        Width = 27
        Height = 13
        Caption = #36208#36335':'
      end
      object Label6: TLabel
        Left = 11
        Top = 120
        Width = 27
        Height = 13
        Caption = #36716#21521':'
      end
      object EditHitIntervalTime: TSpinEdit
        Left = 44
        Top = 20
        Width = 61
        Height = 22
        EditorEnabled = False
        Increment = 10
        MaxValue = 2000
        MinValue = 10
        TabOrder = 0
        Value = 900
        OnChange = EditHitIntervalTimeChange
      end
      object EditMagicHitIntervalTime: TSpinEdit
        Left = 44
        Top = 44
        Width = 61
        Height = 22
        EditorEnabled = False
        Increment = 10
        MaxValue = 2000
        MinValue = 10
        TabOrder = 1
        Value = 800
        OnChange = EditMagicHitIntervalTimeChange
      end
      object EditRunIntervalTime: TSpinEdit
        Left = 44
        Top = 68
        Width = 61
        Height = 22
        EditorEnabled = False
        Increment = 10
        MaxValue = 2000
        MinValue = 10
        TabOrder = 2
        Value = 600
        OnChange = EditRunIntervalTimeChange
      end
      object EditWalkIntervalTime: TSpinEdit
        Left = 44
        Top = 92
        Width = 61
        Height = 22
        EditorEnabled = False
        Increment = 10
        MaxValue = 2000
        MinValue = 10
        TabOrder = 3
        Value = 600
        OnChange = EditWalkIntervalTimeChange
      end
      object EditTurnIntervalTime: TSpinEdit
        Left = 44
        Top = 116
        Width = 61
        Height = 22
        EditorEnabled = False
        Increment = 10
        MaxValue = 2000
        MinValue = 10
        TabOrder = 4
        Value = 600
        OnChange = EditTurnIntervalTimeChange
      end
    end
    object GroupBox3: TGroupBox
      Left = 248
      Top = 16
      Width = 89
      Height = 145
      Caption = #20801#35768#21152#36895#27425#25968
      TabOrder = 1
      object Label7: TLabel
        Left = 11
        Top = 24
        Width = 27
        Height = 13
        Caption = #25915#20987':'
      end
      object Label8: TLabel
        Left = 11
        Top = 48
        Width = 27
        Height = 13
        Caption = #39764#27861':'
      end
      object Label9: TLabel
        Left = 11
        Top = 72
        Width = 27
        Height = 13
        Caption = #36305#27493':'
      end
      object Label10: TLabel
        Left = 11
        Top = 96
        Width = 27
        Height = 13
        Caption = #36208#36335':'
      end
      object Label12: TLabel
        Left = 11
        Top = 120
        Width = 27
        Height = 13
        Caption = #36716#21521':'
      end
      object EditMaxHitMsgCount: TSpinEdit
        Left = 44
        Top = 20
        Width = 29
        Height = 22
        Hint = #20801#35768#21152#36895#30340#27425#25968#65292#27492#21442#25968#40664#35748#20026'1'#65292#36229#36807#35774#23450#20540#23558#35302#21457#36895#24230#25511#21046
        EditorEnabled = False
        MaxValue = 50
        MinValue = 1
        TabOrder = 0
        Value = 2
        OnChange = EditMaxHitMsgCountChange
      end
      object EditMaxSpellMsgCount: TSpinEdit
        Left = 44
        Top = 44
        Width = 29
        Height = 22
        Hint = #20801#35768#21152#36895#30340#27425#25968#65292#27492#21442#25968#40664#35748#20026'1'#65292#36229#36807#35774#23450#20540#23558#35302#21457#36895#24230#25511#21046
        EditorEnabled = False
        MaxValue = 50
        MinValue = 1
        TabOrder = 1
        Value = 2
        OnChange = EditMaxSpellMsgCountChange
      end
      object EditMaxRunMsgCount: TSpinEdit
        Left = 44
        Top = 68
        Width = 29
        Height = 22
        Hint = #20801#35768#21152#36895#30340#27425#25968#65292#27492#21442#25968#40664#35748#20026'1'#65292#36229#36807#35774#23450#20540#23558#35302#21457#36895#24230#25511#21046
        EditorEnabled = False
        MaxValue = 50
        MinValue = 1
        TabOrder = 2
        Value = 2
        OnChange = EditMaxRunMsgCountChange
      end
      object EditMaxWalkMsgCount: TSpinEdit
        Left = 44
        Top = 92
        Width = 29
        Height = 22
        Hint = #20801#35768#21152#36895#30340#27425#25968#65292#27492#21442#25968#40664#35748#20026'1'#65292#36229#36807#35774#23450#20540#23558#35302#21457#36895#24230#25511#21046
        EditorEnabled = False
        MaxValue = 50
        MinValue = 1
        TabOrder = 3
        Value = 2
        OnChange = EditMaxWalkMsgCountChange
      end
      object EditMaxTurnMsgCount: TSpinEdit
        Left = 44
        Top = 116
        Width = 29
        Height = 22
        Hint = #20801#35768#21152#36895#30340#27425#25968#65292#27492#21442#25968#40664#35748#20026'1'#65292#36229#36807#35774#23450#20540#23558#35302#21457#36895#24230#25511#21046
        EditorEnabled = False
        MaxValue = 50
        MinValue = 1
        TabOrder = 4
        Value = 2
        OnChange = EditMaxTurnMsgCountChange
      end
    end
    object GroupBox15: TGroupBox
      Left = 8
      Top = 16
      Width = 113
      Height = 145
      Caption = #36895#24230#25511#21046
      TabOrder = 2
      object CheckBoxSpell: TCheckBox
        Left = 8
        Top = 31
        Width = 97
        Height = 17
        Caption = #39764#27861#36895#24230#25511#21046
        TabOrder = 0
        OnClick = CheckBoxSpellClick
      end
      object CheckBoxHit: TCheckBox
        Left = 8
        Top = 15
        Width = 97
        Height = 17
        Caption = #25915#20987#36895#24230#25511#21046
        TabOrder = 1
        OnClick = CheckBoxHitClick
      end
      object CheckBoxRun: TCheckBox
        Left = 8
        Top = 47
        Width = 97
        Height = 17
        Caption = #36305#27493#36895#24230#25511#21046
        TabOrder = 2
        OnClick = CheckBoxRunClick
      end
      object CheckBoxWalk: TCheckBox
        Left = 8
        Top = 63
        Width = 97
        Height = 17
        Caption = #36208#36335#36895#24230#25511#21046
        TabOrder = 3
        OnClick = CheckBoxWalkClick
      end
      object CheckBoxTurn: TCheckBox
        Left = 8
        Top = 79
        Width = 97
        Height = 17
        Caption = #36716#21521#36895#24230#25511#21046
        TabOrder = 4
        OnClick = CheckBoxTurnClick
      end
    end
    object GroupBox4: TGroupBox
      Left = 344
      Top = 16
      Width = 137
      Height = 145
      Caption = #36895#24230#25511#21046#27169#24335
      TabOrder = 3
      object RadioButtonDelyMode: TRadioButton
        Left = 8
        Top = 16
        Width = 97
        Height = 17
        Hint = #23558#36229#36807#36895#24230#30340#25805#20316#36827#34892#24310#26102#22788#29702#65292#20197#20445#25345#27491#24120#36895#24230#65292#20351#29992#27492#31181#27169#24335#23458#25143#31471#20351#29992#21152#36895#23558#36896#25104#21345#30340#29616#35937#12290
        Caption = #20572#39039#25805#20316#22788#29702
        TabOrder = 0
        OnClick = RadioButtonDelyModeClick
      end
      object RadioButtonFilterMode: TRadioButton
        Left = 8
        Top = 32
        Width = 97
        Height = 17
        Hint = #23558#36229#36807#36895#24230#30340#25805#20316#30452#25509#36807#28388#22788#29702#65292#20002#24323#36229#36895#24230#30340#25805#20316#65292#20351#29992#27492#31181#27169#24335#23458#25143#31471#20351#29992#21152#36895#23558#36896#25104#21345#20992#65292#21453#24377#30340#29616#35937#12290
        Caption = #21453#24377#21345#20992#22788#29702
        TabOrder = 1
        OnClick = RadioButtonDelyModeClick
      end
    end
    object CheckBoxSpeedShowMsg: TCheckBox
      Left = 8
      Top = 178
      Width = 73
      Height = 17
      Caption = #21152#36895#25552#31034
      TabOrder = 4
      OnClick = CheckBoxSpeedShowMsgClick
    end
    object EditSpeedMsg: TEdit
      Left = 80
      Top = 176
      Width = 401
      Height = 21
      TabOrder = 5
      OnChange = EditSpeedMsgChange
    end
    object ButtonRef: TButton
      Left = 248
      Top = 272
      Width = 75
      Height = 25
      Caption = #40664#35748'(&R)'
      TabOrder = 6
    end
    object ButtonSave: TButton
      Left = 328
      Top = 272
      Width = 75
      Height = 25
      Caption = #20445#23384'(&S)'
      TabOrder = 7
      OnClick = ButtonSaveClick
    end
    object ButtonClose: TButton
      Left = 408
      Top = 272
      Width = 75
      Height = 25
      Caption = #20851#38381'(&E)'
      TabOrder = 8
      OnClick = ButtonCloseClick
    end
    object RadioGroupMsgColor: TRadioGroup
      Left = 8
      Top = 208
      Width = 73
      Height = 89
      Caption = #20449#24687#39068#33394
      Items.Strings = (
        #32418#33394
        #34013#33394
        #32511#33394)
      TabOrder = 9
      OnClick = RadioGroupMsgColorClick
    end
  end
end
