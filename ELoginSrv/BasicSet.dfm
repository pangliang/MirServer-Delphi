object FrmBasicSet: TFrmBasicSet
  Left = 648
  Top = 183
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #22522#26412#35774#32622
  ClientHeight = 240
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 401
    Height = 193
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #26222#36890#35774#32622
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 177
        Height = 73
        Caption = #21151#33021#35774#32622
        TabOrder = 0
        object CheckBoxTestServer: TCheckBox
          Left = 16
          Top = 16
          Width = 97
          Height = 17
          Caption = #27979#35797#27169#24335
          TabOrder = 0
          OnClick = CheckBoxTestServerClick
        end
        object CheckBoxEnableMakingID: TCheckBox
          Left = 16
          Top = 32
          Width = 97
          Height = 17
          Caption = #20801#35768#21019#24314#36134#21495
          TabOrder = 1
          OnClick = CheckBoxEnableMakingIDClick
        end
        object CheckBoxEnableGetbackPassword: TCheckBox
          Left = 16
          Top = 48
          Width = 97
          Height = 17
          Caption = #20801#35768#21462#22238#23494#30721
          TabOrder = 2
          OnClick = CheckBoxEnableGetbackPasswordClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 200
        Top = 8
        Width = 185
        Height = 73
        Caption = #28165#29702#36134#21495#35774#32622
        TabOrder = 1
        object Label1: TLabel
          Left = 16
          Top = 40
          Width = 54
          Height = 12
          Caption = #28165#29702#38388#38548':'
        end
        object Label2: TLabel
          Left = 144
          Top = 40
          Width = 12
          Height = 12
          Caption = #31186
        end
        object CheckBoxAutoClear: TCheckBox
          Left = 16
          Top = 16
          Width = 97
          Height = 17
          Caption = #33258#21160#28165#29702#36134#21495
          TabOrder = 0
          OnClick = CheckBoxAutoClearClick
        end
        object SpinEditAutoClearTime: TSpinEdit
          Left = 72
          Top = 36
          Width = 65
          Height = 21
          MaxValue = 1000000
          MinValue = 1
          TabOrder = 1
          Value = 1
          OnChange = SpinEditAutoClearTimeChange
        end
      end
      object ButtonRestoreBasic: TButton
        Left = 320
        Top = 136
        Width = 67
        Height = 25
        Caption = #40664#35748'(&D)'
        TabOrder = 2
        OnClick = ButtonRestoreBasicClick
      end
      object GroupBox7: TGroupBox
        Left = 8
        Top = 88
        Width = 177
        Height = 65
        Caption = #33258#21160#35299#38500#38145#23450#36134#21495
        TabOrder = 3
        object Label9: TLabel
          Left = 8
          Top = 40
          Width = 78
          Height = 12
          Caption = #35299#38500#31561#24453#26102#38388':'
        end
        object Label10: TLabel
          Left = 160
          Top = 40
          Width = 12
          Height = 12
          Caption = #20998
        end
        object CheckBoxAutoUnLockAccount: TCheckBox
          Left = 8
          Top = 16
          Width = 121
          Height = 17
          Caption = #33258#21160#35299#38500#38145#23450#36134#21495
          TabOrder = 0
          OnClick = CheckBoxAutoUnLockAccountClick
        end
        object SpinEditUnLockAccountTime: TSpinEdit
          Left = 88
          Top = 36
          Width = 65
          Height = 21
          MaxValue = 1000000
          MinValue = 1
          TabOrder = 1
          Value = 1
          OnChange = SpinEditUnLockAccountTimeChange
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #32593#32476#35774#32622
      ImageIndex = 1
      object ButtonRestoreNet: TButton
        Left = 320
        Top = 136
        Width = 67
        Height = 25
        Caption = #40664#35748'(&D)'
        TabOrder = 0
        OnClick = ButtonRestoreNetClick
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 185
        Height = 65
        Caption = #32593#20851#35774#32622
        TabOrder = 1
        object Label3: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #32465#23450#22320#22336':'
        end
        object Label4: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 12
          Caption = #32593#20851#31471#21475':'
        end
        object EditGateAddr: TEdit
          Left = 72
          Top = 14
          Width = 105
          Height = 20
          TabOrder = 0
          OnChange = EditGateAddrChange
        end
        object EditGatePort: TEdit
          Left = 72
          Top = 38
          Width = 57
          Height = 20
          TabOrder = 1
          OnChange = EditGatePortChange
        end
      end
      object GroupBox4: TGroupBox
        Left = 200
        Top = 8
        Width = 185
        Height = 65
        Caption = #36828#31243#30417#25511#35774#32622
        TabOrder = 2
        object Label5: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #32465#23450#22320#22336':'
        end
        object Label6: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 12
          Caption = #32593#20851#31471#21475':'
        end
        object EditMonAddr: TEdit
          Left = 72
          Top = 14
          Width = 105
          Height = 20
          TabOrder = 0
          OnChange = EditMonAddrChange
        end
        object EditMonPort: TEdit
          Left = 72
          Top = 38
          Width = 57
          Height = 20
          TabOrder = 1
          OnChange = EditMonPortChange
        end
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 88
        Width = 185
        Height = 65
        Caption = #26381#21153#22120#32593#32476#35774#32622
        TabOrder = 3
        object Label7: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #32465#23450#22320#22336':'
        end
        object Label8: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 12
          Caption = #20351#29992#31471#21475':'
        end
        object EditServerAddr: TEdit
          Left = 72
          Top = 14
          Width = 105
          Height = 20
          TabOrder = 0
          OnChange = EditServerAddrChange
        end
        object EditServerPort: TEdit
          Left = 72
          Top = 38
          Width = 57
          Height = 20
          TabOrder = 1
          OnChange = EditServerPortChange
        end
      end
      object GroupBox6: TGroupBox
        Left = 200
        Top = 88
        Width = 113
        Height = 41
        Caption = #21160#24577#22495#21517#27169#24335
        TabOrder = 4
        object CheckBoxDynamicIPMode: TCheckBox
          Left = 16
          Top = 16
          Width = 73
          Height = 17
          Caption = #21160#24577#22495#21517
          TabOrder = 0
          OnClick = CheckBoxDynamicIPModeClick
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #30446#24405#35774#32622
      ImageIndex = 2
    end
  end
  object ButtonSave: TButton
    Left = 248
    Top = 208
    Width = 75
    Height = 25
    Caption = #20445#23384'(&S)'
    TabOrder = 1
    OnClick = ButtonSaveClick
  end
  object ButtonClose: TButton
    Left = 334
    Top = 208
    Width = 75
    Height = 25
    Caption = #30830#23450'(&O)'
    TabOrder = 2
    OnClick = ButtonCloseClick
  end
end
