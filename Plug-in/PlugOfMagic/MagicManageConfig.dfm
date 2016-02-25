object FrmMagicManage: TFrmMagicManage
  Left = 161
  Top = 21
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #33258#23450#20041#39764#27861#32534#36753
  ClientHeight = 578
  ClientWidth = 848
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
    Width = 833
    Height = 257
    Caption = #39764#27861#21015#34920
    TabOrder = 0
    object ListViewMagic: TListView
      Left = 8
      Top = 16
      Width = 817
      Height = 233
      Columns = <
        item
          Caption = 'MagID'
        end
        item
          Caption = 'MagName'
          Width = 80
        end
        item
          Caption = 'EffectType'
          Width = 65
        end
        item
          Caption = 'Effect'
          Width = 65
        end
        item
          Caption = 'Spell'
          Width = 65
        end
        item
          Caption = 'Power'
          Width = 65
        end
        item
          Caption = 'MaxPower'
          Width = 65
        end
        item
          Caption = 'DefSpell'
          Width = 65
        end
        item
          Caption = 'DefPower'
          Width = 65
        end
        item
          Caption = 'DefMaxPower'
          Width = 65
        end
        item
          Caption = 'Job'
          Width = 65
        end
        item
          Caption = 'NeedL1'
          Width = 65
        end
        item
          Caption = 'L1Train'
          Width = 65
        end
        item
          Caption = 'NeedL2'
          Width = 65
        end
        item
          Caption = 'L2Train'
          Width = 65
        end
        item
          Caption = 'NeedL3'
          Width = 65
        end
        item
          Caption = 'L3Train'
          Width = 65
        end
        item
          Caption = 'Delay'
          Width = 65
        end
        item
          Caption = 'Descr'
          Width = 100
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewMagicClick
    end
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 272
    Width = 833
    Height = 265
    ActivePage = TabSheet2
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #39764#27861#25968#25454#24211#32534#36753
      object GroupBox2: TGroupBox
        Left = 8
        Top = 5
        Width = 809
        Height = 212
        Caption = #39764#27861#25968#25454#32534#36753
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 24
          Width = 36
          Height = 12
          Caption = 'MagID:'
        end
        object Label2: TLabel
          Left = 120
          Top = 24
          Width = 48
          Height = 12
          Caption = 'MagName:'
        end
        object Label3: TLabel
          Left = 288
          Top = 24
          Width = 66
          Height = 12
          Caption = 'EffectType:'
        end
        object Label4: TLabel
          Left = 424
          Top = 24
          Width = 42
          Height = 12
          Caption = 'Effect:'
        end
        object Label5: TLabel
          Left = 552
          Top = 24
          Width = 36
          Height = 12
          Caption = 'Spell:'
        end
        object Label6: TLabel
          Left = 656
          Top = 24
          Width = 36
          Height = 12
          Caption = 'Power:'
        end
        object Label7: TLabel
          Left = 8
          Top = 48
          Width = 54
          Height = 12
          Caption = 'MaxPower:'
        end
        object Label8: TLabel
          Left = 120
          Top = 48
          Width = 54
          Height = 12
          Caption = 'DefSpell:'
        end
        object Label9: TLabel
          Left = 288
          Top = 48
          Width = 54
          Height = 12
          Caption = 'DefPower:'
        end
        object Label10: TLabel
          Left = 424
          Top = 48
          Width = 72
          Height = 12
          Caption = 'DefMaxPower:'
        end
        object Label11: TLabel
          Left = 552
          Top = 48
          Width = 24
          Height = 12
          Caption = 'Job:'
        end
        object Label12: TLabel
          Left = 656
          Top = 48
          Width = 42
          Height = 12
          Caption = 'NeedL1:'
        end
        object Label13: TLabel
          Left = 8
          Top = 72
          Width = 48
          Height = 12
          Caption = 'L1Train:'
        end
        object Label14: TLabel
          Left = 120
          Top = 72
          Width = 42
          Height = 12
          Caption = 'NeedL2:'
        end
        object Label15: TLabel
          Left = 288
          Top = 72
          Width = 48
          Height = 12
          Caption = 'L2Train:'
        end
        object Label16: TLabel
          Left = 424
          Top = 72
          Width = 42
          Height = 12
          Caption = 'NeedL3:'
        end
        object Label17: TLabel
          Left = 552
          Top = 72
          Width = 48
          Height = 12
          Caption = 'L3Train:'
        end
        object Label18: TLabel
          Left = 656
          Top = 72
          Width = 36
          Height = 12
          Caption = 'Delay:'
        end
        object Label19: TLabel
          Left = 8
          Top = 96
          Width = 36
          Height = 12
          Caption = 'Descr:'
        end
        object SpinEditMagID: TSpinEdit
          Left = 64
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 100
          TabOrder = 0
          Value = 100
        end
        object EditMagName: TEdit
          Left = 176
          Top = 20
          Width = 105
          Height = 20
          TabOrder = 1
          Text = #28459#22825#28779#38632
        end
        object SpinEditEffectType: TSpinEdit
          Left = 360
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 2
          Value = 4
        end
        object SpinEditEffect: TSpinEdit
          Left = 496
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 3
          Value = 20
        end
        object SpinEditPower: TSpinEdit
          Left = 704
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 4
          Value = 1
        end
        object SpinEditMaxPower: TSpinEdit
          Left = 64
          Top = 44
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 5
          Value = 1
        end
        object SpinEditDefSpell: TSpinEdit
          Left = 176
          Top = 44
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 6
          Value = 25
        end
        object SpinEditDefPower: TSpinEdit
          Left = 360
          Top = 44
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 7
          Value = 1
        end
        object SpinEditDefMaxPower: TSpinEdit
          Left = 496
          Top = 44
          Width = 49
          Height = 21
          MaxValue = 1000000
          MinValue = 0
          TabOrder = 8
          Value = 1
        end
        object SpinEditJob: TSpinEdit
          Left = 600
          Top = 44
          Width = 49
          Height = 21
          MaxValue = 2
          MinValue = 0
          TabOrder = 9
          Value = 1
        end
        object SpinEditNeedL1: TSpinEdit
          Left = 704
          Top = 44
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 10
          Value = 24
        end
        object SpinEditSpell: TSpinEdit
          Left = 600
          Top = 20
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 11
          Value = 20
        end
        object SpinEditL1Train: TSpinEdit
          Left = 64
          Top = 68
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 12
          Value = 50
        end
        object SpinEditNeedL2: TSpinEdit
          Left = 176
          Top = 68
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 13
          Value = 29
        end
        object SpinEditL2Train: TSpinEdit
          Left = 360
          Top = 68
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 14
          Value = 100
        end
        object SpinEditNeedL3: TSpinEdit
          Left = 496
          Top = 68
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 15
          Value = 33
        end
        object SpinEditL3Train: TSpinEdit
          Left = 600
          Top = 68
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 16
          Value = 150
        end
        object SpinEditDelay: TSpinEdit
          Left = 704
          Top = 68
          Width = 49
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 17
          Value = 80
        end
        object EditDescr: TEdit
          Left = 64
          Top = 92
          Width = 217
          Height = 20
          TabOrder = 18
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #39764#27861#21151#33021#35774#32622
      ImageIndex = 1
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 313
        Height = 225
        Caption = #36873#25321#19968#20010#39764#27861#25928#26524
        TabOrder = 0
        object ListBoxMagic: TListBox
          Left = 8
          Top = 16
          Width = 121
          Height = 201
          Hint = #36873#25321#19968#20010#39764#27861#25928#26524
          ItemHeight = 12
          TabOrder = 0
          OnClick = ListBoxMagicClick
        end
        object GroupBox6: TGroupBox
          Left = 136
          Top = 16
          Width = 169
          Height = 201
          Caption = #39764#27861#35774#32622
          TabOrder = 1
          object LabelSelMagic: TLabel
            Left = 8
            Top = 24
            Width = 72
            Height = 12
            Caption = #20320#36873#25321#30340#26159#65306
          end
          object Label21: TLabel
            Left = 8
            Top = 80
            Width = 54
            Height = 12
            Caption = #39764#27861#25968#37327':'
          end
          object LabelSelMagicName: TLabel
            Left = 8
            Top = 48
            Width = 6
            Height = 12
          end
          object SpinEditMagicCount: TSpinEdit
            Left = 64
            Top = 76
            Width = 97
            Height = 21
            MaxValue = 100
            MinValue = 0
            TabOrder = 0
            Value = 1
          end
        end
      end
      object GroupBox5: TGroupBox
        Left = 480
        Top = 8
        Width = 337
        Height = 225
        Caption = #34987#25915#20987#23545#35937
        TabOrder = 1
        Visible = False
        object CheckBoxHP: TCheckBox
          Left = 104
          Top = 24
          Width = 33
          Height = 17
          Caption = 'HP'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object CheckBoxMP: TCheckBox
          Left = 144
          Top = 24
          Width = 33
          Height = 17
          Caption = 'MP'
          TabOrder = 1
        end
        object CheckBoxAbil: TCheckBox
          Left = 104
          Top = 48
          Width = 215
          Height = 17
          Caption = #25353#29031#32844#19994#20998#21035#22686#21152#25110#20943#23569'DC'#65292'MC'#65292'SC'
          TabOrder = 2
        end
        object CheckBoxAC: TCheckBox
          Left = 184
          Top = 24
          Width = 41
          Height = 17
          Caption = 'AC'
          TabOrder = 3
        end
        object CheckBoxMC: TCheckBox
          Left = 224
          Top = 24
          Width = 33
          Height = 17
          Caption = 'MC'
          TabOrder = 4
        end
        object RadioGroupWay: TRadioGroup
          Left = 8
          Top = 16
          Width = 89
          Height = 201
          Caption = #25915#20987#26041#24335
          ItemIndex = 1
          Items.Strings = (
            #22686#21152#23646#24615
            #20943#23569#23646#24615
            #31227#21160#30446#26631
            #25512#21160#30446#26631
            #40635#30201#30446#26631
            #21484#21796#23453#23453
            #35825#24785#30446#26631
            #32473#30446#26631#25918#27602)
          TabOrder = 5
          Visible = False
          OnClick = RadioGroupWayClick
        end
      end
      object RadioGroupAttackRange: TRadioGroup
        Left = 328
        Top = 8
        Width = 145
        Height = 89
        Caption = #25915#20987#33539#22260
        ItemIndex = 1
        Items.Strings = (
          #21333#20010#30446#26631
          #19968#20010#33539#22260#30340#25152#26377#30446#26631
          #20840#23631#25915#20987)
        TabOrder = 2
        Visible = False
      end
      object RadioGroupMagicNeed: TRadioGroup
        Left = 328
        Top = 104
        Width = 145
        Height = 129
        Caption = #26045#23637#39764#27861
        ItemIndex = 0
        Items.Strings = (
          #38656#35201#39764#27861
          #38656#35201#31526#21650
          #38656#35201#27602#33647)
        TabOrder = 3
        Visible = False
      end
    end
  end
  object ButtonLoadMagic: TButton
    Left = 648
    Top = 544
    Width = 195
    Height = 25
    Caption = #37325#26032#21152#36733#33258#23450#20041#39764#27861#25968#25454#24211'(&R)'
    TabOrder = 2
    OnClick = ButtonLoadMagicClick
  end
  object ButtonSaveMagic: TButton
    Left = 568
    Top = 544
    Width = 75
    Height = 25
    Caption = #20445#23384'(&S)'
    TabOrder = 3
    OnClick = ButtonSaveMagicClick
  end
  object ButtonChgMagic: TButton
    Left = 328
    Top = 544
    Width = 75
    Height = 25
    Caption = #20462#25913'(&C)'
    TabOrder = 4
    OnClick = ButtonChgMagicClick
  end
  object ButtonDelMagic: TButton
    Left = 408
    Top = 544
    Width = 75
    Height = 25
    Caption = #21024#38500'(&D)'
    TabOrder = 5
    OnClick = ButtonDelMagicClick
  end
  object ButtonAddMagic: TButton
    Left = 488
    Top = 544
    Width = 75
    Height = 25
    Caption = #22686#21152'(&A)'
    TabOrder = 6
    OnClick = ButtonAddMagicClick
  end
end
