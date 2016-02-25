object FrmShopItem: TFrmShopItem
  Left = 270
  Top = 245
  HorzScrollBar.ParentColor = False
  BorderStyle = bsDialog
  Caption = #21830#21697#32534#36753
  ClientHeight = 381
  ClientWidth = 759
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 577
    Height = 281
    Caption = #21830#21697#21015#34920
    TabOrder = 0
    object ListViewItemList: TListView
      Left = 8
      Top = 14
      Width = 561
      Height = 257
      Columns = <
        item
          Caption = #21830#21697#21517#31216
          Width = 100
        end
        item
          Caption = #20215#26684
          Width = 70
        end
        item
          Caption = #31867#22411
        end
        item
          Caption = #21160#30011#36215#22987
          Width = 60
        end
        item
          Caption = #21160#30011#32467#26463
          Width = 60
        end
        item
          Caption = #38480#21046#25968#37327
          Width = 60
        end
        item
          Caption = #31616#20171
          Width = 100
        end
        item
          Caption = #27880#37322
          Width = 155
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewItemListClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 592
    Top = 8
    Width = 161
    Height = 281
    Caption = #29289#21697#21015#34920
    TabOrder = 6
    object ListBoxItemList: TListBox
      Left = 8
      Top = 16
      Width = 145
      Height = 257
      ItemHeight = 12
      TabOrder = 0
      OnClick = ListBoxItemListClick
    end
  end
  object ButtonChgShopItem: TButton
    Left = 674
    Top = 295
    Width = 75
    Height = 25
    Caption = #20462#25913'(&C)'
    TabOrder = 2
    OnClick = ButtonChgShopItemClick
  end
  object ButtonDelShopItem: TButton
    Left = 599
    Top = 319
    Width = 75
    Height = 25
    Caption = #21024#38500'(&D)'
    TabOrder = 3
    OnClick = ButtonDelShopItemClick
  end
  object ButtonAddShopItem: TButton
    Left = 599
    Top = 295
    Width = 75
    Height = 25
    Caption = #22686#21152'(&A)'
    TabOrder = 1
    OnClick = ButtonAddShopItemClick
  end
  object ButtonLoadShopItemList: TButton
    Left = 599
    Top = 351
    Width = 150
    Height = 25
    Caption = #37325#26032#21152#36733#21830#21697#21015#34920'(&R)'
    TabOrder = 5
    OnClick = ButtonLoadShopItemListClick
  end
  object ButtonSaveShopItemList: TButton
    Left = 674
    Top = 319
    Width = 75
    Height = 25
    Caption = #20445#23384'(&S)'
    TabOrder = 4
    OnClick = ButtonSaveShopItemListClick
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 288
    Width = 577
    Height = 88
    TabOrder = 7
    object Label5: TLabel
      Left = 8
      Top = 16
      Width = 54
      Height = 12
      Caption = #21830#21697#31867#22411':'
    end
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 54
      Height = 12
      Caption = #21830#21697#21517#31216':'
    end
    object Label2: TLabel
      Left = 168
      Top = 16
      Width = 54
      Height = 12
      Caption = #21830#21697#20215#26684':'
    end
    object Label74: TLabel
      Left = 168
      Top = 40
      Width = 54
      Height = 12
      Caption = #29289#21697#25968#37327':'
    end
    object Label6: TLabel
      Left = 492
      Top = 16
      Width = 72
      Height = 12
      Caption = #23454#38469#29289#21697#28436#31034
    end
    object Label8: TLabel
      Left = 320
      Top = 16
      Width = 90
      Height = 12
      Caption = 'Effect.wil'#24207#21495':'
    end
    object Label9: TLabel
      Left = 320
      Top = 40
      Width = 90
      Height = 12
      Caption = 'Effect.wil'#25968#37327':'
    end
    object Label7: TLabel
      Left = 492
      Top = 40
      Width = 72
      Height = 12
      Caption = #28436#31034#22270#29255#24352#25968
    end
    object Label3: TLabel
      Left = 8
      Top = 64
      Width = 54
      Height = 12
      Caption = #29289#21697#31616#20171':'
    end
    object Label4: TLabel
      Left = 168
      Top = 64
      Width = 54
      Height = 12
      Caption = #29289#21697#35828#26126':'
    end
    object shopitemJobeit: TComboBox
      Left = 64
      Top = 13
      Width = 89
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 0
      Text = #35013#39280
      Items.Strings = (
        #35013#39280
        #34917#32473
        #24378#21270
        #22909#21451
        #38480#37327
        #22855#29645#27036)
    end
    object EditShopItemName: TEdit
      Left = 64
      Top = 37
      Width = 89
      Height = 20
      ReadOnly = True
      TabOrder = 1
    end
    object SpinEditPrice: TSpinEdit
      Left = 224
      Top = 12
      Width = 89
      Height = 21
      MaxValue = 100000000
      MinValue = 1
      TabOrder = 2
      Value = 200
    end
    object shopitemAnim: TSpinEdit
      Left = 224
      Top = 36
      Width = 89
      Height = 21
      Hint = #36141#20080#21518#32473#22810#23569#20214#29289#21697#12290
      MaxValue = 100
      MinValue = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Value = 1
    end
    object SpinEdit1: TSpinEdit
      Left = 412
      Top = 12
      Width = 73
      Height = 21
      MaxValue = 50000
      MinValue = 0
      TabOrder = 4
      Value = 0
    end
    object SpinEdit2: TSpinEdit
      Left = 412
      Top = 36
      Width = 73
      Height = 21
      MaxValue = 50000
      MinValue = 0
      TabOrder = 5
      Value = 0
    end
    object Memo1: TEdit
      Left = 64
      Top = 60
      Width = 89
      Height = 20
      Hint = #26368#22810#36755#20837'14'#20010#23383#33410#12290
      MaxLength = 14
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object Memo2: TEdit
      Left = 224
      Top = 60
      Width = 337
      Height = 20
      Hint = #26368#22810#36755#20837'50'#20010#23383#33410#65292#26174#31034#20998#34892#29992#8220'\'#8221#31526#21495#34920#31034#12290
      MaxLength = 50
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
    end
  end
end
