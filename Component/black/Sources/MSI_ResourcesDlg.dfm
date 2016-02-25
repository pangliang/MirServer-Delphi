object dlgResources: TdlgResources
  Left = 358
  Top = 339
  BorderStyle = bsDialog
  Caption = 'Resources'
  ClientHeight = 343
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 302
    Width = 674
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object Panel2: TPanel
      Left = 583
      Top = 0
      Width = 91
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object bOK: TButton
        Left = 5
        Top = 8
        Width = 75
        Height = 25
        Cursor = crHandPoint
        Cancel = True
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
    end
  end
  object Panel3: TPanel
    Left = 9
    Top = 10
    Width = 320
    Height = 18
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderWidth = 5
    Caption = ' DMA'
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object DMAList: TListView
    Left = 9
    Top = 29
    Width = 320
    Height = 73
    Columns = <
      item
        Caption = 'Channel'
        Width = 150
      end
      item
        Caption = 'Port'
        Width = 150
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
  end
  object Panel4: TPanel
    Left = 9
    Top = 107
    Width = 320
    Height = 18
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderWidth = 5
    Caption = ' IRQ'
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object IRQList: TListView
    Left = 9
    Top = 126
    Width = 320
    Height = 73
    Columns = <
      item
        Caption = 'Vector'
        Width = 75
      end
      item
        Caption = 'Level'
        Width = 75
      end
      item
        Caption = 'Affinity'
        Width = 75
      end
      item
        Caption = 'Type'
        Width = 75
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 4
    ViewStyle = vsReport
  end
  object pMem: TPanel
    Left = 341
    Top = 11
    Width = 320
    Height = 18
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderWidth = 5
    Caption = ' Memory'
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object MemList: TListView
    Left = 341
    Top = 30
    Width = 320
    Height = 73
    Columns = <
      item
        Caption = 'Physical Address'
        Width = 100
      end
      item
        Caption = 'Length'
        Width = 100
      end
      item
        Caption = 'Access'
        Width = 100
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 6
    ViewStyle = vsReport
  end
  object Panel6: TPanel
    Left = 341
    Top = 107
    Width = 320
    Height = 18
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderWidth = 5
    Caption = ' Port'
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
  end
  object PortList: TListView
    Left = 341
    Top = 126
    Width = 320
    Height = 73
    Columns = <
      item
        Caption = 'Physical Address'
        Width = 100
      end
      item
        Caption = 'Length'
        Width = 100
      end
      item
        Caption = 'Type'
        Width = 100
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 8
    ViewStyle = vsReport
  end
  object Panel7: TPanel
    Left = 9
    Top = 206
    Width = 320
    Height = 18
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderWidth = 5
    Caption = ' Device Specific Data'
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
  end
  object DSDList: TListView
    Left = 9
    Top = 225
    Width = 320
    Height = 73
    Columns = <
      item
        Caption = 'Reserved1'
        Width = 100
      end
      item
        Caption = 'Reserved2'
        Width = 100
      end
      item
        Caption = 'Data Size'
        Width = 100
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 10
    ViewStyle = vsReport
  end
  object GroupBox1: TGroupBox
    Left = 341
    Top = 206
    Width = 320
    Height = 93
    Caption = ' General '
    TabOrder = 11
    object lIntfType: TLabel
      Left = 16
      Top = 20
      Width = 41
      Height = 13
      Caption = 'lIntfType'
    end
    object lBusNumber: TLabel
      Left = 16
      Top = 37
      Width = 57
      Height = 13
      Caption = 'lBusNumber'
    end
    object lVersion: TLabel
      Left = 16
      Top = 54
      Width = 37
      Height = 13
      Caption = 'lVersion'
    end
    object lRevision: TLabel
      Left = 16
      Top = 71
      Width = 43
      Height = 13
      Caption = 'lRevision'
    end
  end
end
