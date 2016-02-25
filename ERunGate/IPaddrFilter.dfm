object frmIPaddrFilter: TfrmIPaddrFilter
  Left = 376
  Top = 266
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #32593#32476#23433#20840#36807#28388
  ClientHeight = 297
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 377
    Height = 281
    ActivePage = TabSheet2
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #36807#28388#21015#34920
      object LabelTempList: TLabel
        Left = 8
        Top = 8
        Width = 54
        Height = 12
        Caption = #21160#24577#36807#28388':'
      end
      object Label1: TLabel
        Left = 136
        Top = 8
        Width = 54
        Height = 12
        Caption = #27704#20037#36807#28388':'
      end
      object ListBoxTempList: TListBox
        Left = 8
        Top = 24
        Width = 121
        Height = 225
        Hint = #21160#24577#36807#28388#21015#34920#65292#22312#27492#21015#34920#20013#30340'IP'#23558#26080#27861#24314#31435#36830#25509#65292#20294#22312#31243#24207#37325#26032#21551#21160#26102#27492#21015#34920#30340#20449#24687#23558#34987#28165#31354
        ItemHeight = 12
        Items.Strings = (
          '888.888.888.888')
        ParentShowHint = False
        PopupMenu = TempBlockListPopupMenu
        ShowHint = True
        Sorted = True
        TabOrder = 0
      end
      object ListBoxBlockList: TListBox
        Left = 136
        Top = 24
        Width = 121
        Height = 225
        Hint = #27704#20037#36807#28388#21015#34920#65292#22312#27492#21015#34920#20013#30340'IP'#23558#26080#27861#24314#31435#36830#25509#65292#27492#21015#34920#23558#20445#23384#20110#37197#32622#25991#20214#20013#65292#22312#31243#24207#37325#26032#21551#21160#26102#20250#37325#26032#21152#36733#27492#21015#34920
        ItemHeight = 12
        Items.Strings = (
          '888.888.888.888')
        ParentShowHint = False
        PopupMenu = BlockListPopupMenu
        ShowHint = True
        Sorted = True
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = #25915#20987#20445#25252
      ImageIndex = 1
      object Label2: TLabel
        Left = 8
        Top = 20
        Width = 54
        Height = 12
        Caption = #36830#25509#38480#21046':'
      end
      object Label3: TLabel
        Left = 136
        Top = 20
        Width = 42
        Height = 12
        Caption = #36830#25509'/IP'
      end
      object Label9: TLabel
        Left = 8
        Top = 44
        Width = 54
        Height = 12
        Caption = #36830#25509#36229#26102':'
      end
      object Label10: TLabel
        Left = 135
        Top = 44
        Width = 12
        Height = 12
        Caption = #31186
      end
      object Label7: TLabel
        Left = 241
        Top = 181
        Width = 120
        Height = 12
        Caption = #20197#19978#21442#25968#35843#21518#31435#21363#29983#25928
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object EditMaxConnect: TSpinEdit
        Left = 64
        Top = 16
        Width = 65
        Height = 21
        Hint = #21333#20010'IP'#22320#22336#65292#26368#22810#21487#20197#24314#31435#36830#25509#25968#65292#36229#36807#25351#23450#36830#25509#25968#23558#25353#19979#38754#30340#25805#20316#22788#29702
        EditorEnabled = False
        MaxValue = 1000
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Value = 50
        OnChange = EditMaxConnectChange
      end
      object EditClientTimeOutTime: TSpinEdit
        Left = 64
        Top = 40
        Width = 65
        Height = 21
        EditorEnabled = False
        MaxValue = 10
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Value = 5
        OnChange = EditClientTimeOutTimeChange
      end
      object GroupBox4: TGroupBox
        Left = 192
        Top = 8
        Width = 169
        Height = 161
        Caption = #27969#37327#25511#21046
        TabOrder = 2
        object Label6: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #26368#22823#38480#21046':'
        end
        object Label8: TLabel
          Left = 8
          Top = 68
          Width = 54
          Height = 12
          Caption = #25968#37327#38480#21046':'
        end
        object Label5: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #20020#30028#22823#23567':'
        end
        object Label11: TLabel
          Left = 8
          Top = 92
          Width = 78
          Height = 12
          Caption = #38450'CC'#25915#20987#26102#38388':'
        end
        object Label12: TLabel
          Left = 8
          Top = 116
          Width = 78
          Height = 12
          Caption = 'CC'#25915#20987#20020#30028#25968':'
        end
        object EditMaxSize: TSpinEdit
          Left = 64
          Top = 40
          Width = 65
          Height = 21
          Hint = #25509#25910#21040#30340#25968#25454#20449#24687#26368#22823#38480#21046#65292#22914#26524#36229#36807#27492#22823#23567#65292#21017#34987#35270#20026#25915#20987#12290
          EditorEnabled = False
          Increment = 10
          MaxValue = 10000
          MinValue = 1
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Value = 6000
          OnChange = EditMaxSizeChange
        end
        object EditMaxClientMsgCount: TSpinEdit
          Left = 64
          Top = 64
          Width = 65
          Height = 21
          Hint = #19968#27425#25509#25910#21040#25968#25454#20449#24687#30340#25968#37327#22810#23569#65292#36229#36807#25351#23450#25968#37327#23558#34987#35270#20026#25915#20987#12290
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Value = 5
          OnChange = EditMaxClientMsgCountChange
        end
        object CheckBoxLostLine: TCheckBox
          Left = 64
          Top = 136
          Width = 97
          Height = 17
          Hint = #25171#24320#27492#21151#33021#21518#65292#22914#26524#23458#25143#31471#30340#21457#36865#30340#25968#25454#36229#36807#25351#23450#38480#21046#23558#20250#30452#25509#23558#20854#25481#32447
          BiDiMode = bdLeftToRight
          Caption = #24322#24120#25481#32447#22788#29702
          ParentBiDiMode = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = CheckBoxLostLineClick
        end
        object EditNomSize: TSpinEdit
          Left = 64
          Top = 16
          Width = 65
          Height = 21
          Hint = #25509#25910#21040#30340#25968#25454#20449#24687#20020#30028#22823#23567#65292#22914#26524#36229#36807#27492#22823#23567#65292#23558#34987#29305#27530#22788#29702#12290
          EditorEnabled = False
          Increment = 10
          MaxValue = 1000
          MinValue = 1
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Value = 100
          OnChange = EditNomSizeChange
        end
        object SpinEditAttackTick: TSpinEdit
          Left = 88
          Top = 88
          Width = 65
          Height = 21
          Increment = 10
          MaxValue = 6000
          MinValue = 100
          TabOrder = 4
          Value = 200
          OnChange = SpinEditAttackTickChange
        end
        object SpinEditAttackCount: TSpinEdit
          Left = 88
          Top = 112
          Width = 65
          Height = 21
          MaxValue = 100
          MinValue = 1
          TabOrder = 5
          Value = 10
          OnChange = SpinEditAttackCountChange
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 72
        Width = 169
        Height = 73
        Caption = #25915#20987#25805#20316
        TabOrder = 3
        object RadioAddBlockList: TRadioButton
          Left = 16
          Top = 48
          Width = 129
          Height = 17
          Hint = #23558#27492#36830#25509#30340'IP'#21152#20837#27704#20037#36807#28388#21015#34920#65292#24182#23558#27492'IP'#30340#25152#26377#36830#25509#24378#34892#20013#26029
          Caption = #21152#20837#27704#20037#36807#28388#21015#34920
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = RadioAddBlockListClick
        end
        object RadioAddTempList: TRadioButton
          Left = 16
          Top = 32
          Width = 129
          Height = 17
          Hint = #23558#27492#36830#25509#30340'IP'#21152#20837#21160#24577#36807#28388#21015#34920#65292#24182#23558#27492'IP'#30340#25152#26377#36830#25509#24378#34892#20013#26029
          Caption = #21152#20837#21160#24577#36807#28388#21015#34920
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = RadioAddTempListClick
        end
        object RadioDisConnect: TRadioButton
          Left = 16
          Top = 16
          Width = 129
          Height = 17
          Hint = #23558#36830#25509#31616#21333#30340#26029#24320#22788#29702
          Caption = #26029#24320#36830#25509
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = RadioDisConnectClick
        end
      end
      object ButtonOK: TButton
        Left = 264
        Top = 208
        Width = 89
        Height = 25
        Caption = #30830#23450'(&O)'
        Default = True
        TabOrder = 4
        OnClick = ButtonOKClick
      end
    end
  end
  object BlockListPopupMenu: TPopupMenu
    OnPopup = BlockListPopupMenuPopup
    Left = 168
    Top = 144
    object BPOPMENU_REFLIST: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = BPOPMENU_REFLISTClick
    end
    object BPOPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = BPOPMENU_SORTClick
    end
    object BPOPMENU_ADD: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = BPOPMENU_ADDClick
    end
    object BPOPMENU_ADDTEMPLIST: TMenuItem
      Caption = #21152#20837#21160#24577#36807#28388#21015#34920'(&A)'
      OnClick = BPOPMENU_ADDTEMPLISTClick
    end
    object BPOPMENU_DELETE: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = BPOPMENU_DELETEClick
    end
  end
  object TempBlockListPopupMenu: TPopupMenu
    OnPopup = TempBlockListPopupMenuPopup
    Left = 40
    Top = 144
    object TPOPMENU_REFLIST: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = TPOPMENU_REFLISTClick
    end
    object TPOPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = TPOPMENU_SORTClick
    end
    object TPOPMENU_ADD: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = TPOPMENU_ADDClick
    end
    object TPOPMENU_BLOCKLIST: TMenuItem
      Caption = #21152#20837#27704#20037#36807#28388#21015#34920'(&D)'
      OnClick = TPOPMENU_BLOCKLISTClick
    end
    object TPOPMENU_DELETE: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = TPOPMENU_DELETEClick
    end
  end
end
