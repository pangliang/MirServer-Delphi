object dlgExceptionStack: TdlgExceptionStack
  Left = 355
  Top = 454
  BorderStyle = bsDialog
  Caption = 'Exception Stack'
  ClientHeight = 419
  ClientWidth = 642
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel7: TPanel
    Left = 0
    Top = 378
    Width = 642
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object Panel10: TPanel
      Left = 537
      Top = 0
      Width = 105
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      Caption = ' '
      TabOrder = 0
      object bOK: TButton
        Left = 11
        Top = 8
        Width = 79
        Height = 25
        Cursor = crHandPoint
        Cancel = True
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
    end
    object Button1: TButton
      Left = 12
      Top = 7
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Caption = 'Clear'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object ClientPanel: TPanel
    Left = 0
    Top = 49
    Width = 642
    Height = 305
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    Caption = ' '
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 10
      Top = 116
      Width = 622
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object List: TListView
      Left = 10
      Top = 10
      Width = 622
      Height = 106
      Align = alClient
      Columns = <
        item
          Caption = 'Timestamp'
          Width = 125
        end
        item
          Caption = 'Exception Class'
          Width = 100
        end
        item
          Alignment = taRightJustify
          Caption = 'Code'
          Width = 75
        end
        item
          Caption = 'Message'
          Width = 300
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = ListSelectItem
    end
    object Memo: TMemo
      Left = 10
      Top = 119
      Width = 622
      Height = 176
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 1
      WordWrap = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 642
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    Color = 16764804
    TabOrder = 2
    object Image1: TImage
      Left = 9
      Top = 2
      Width = 32
      Height = 32
      AutoSize = True
      Picture.Data = {
        055449636F6E0000010001002020040000000000E80200001600000028000000
        2000000040000000010004000000000000020000000000000000000000000000
        0000000000000000000080000080000000808000800000008000800080800000
        80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
        FFFFFF0000000000000007777777700000000000000000000077777777777777
        0000000000000000077111111117777770000000000000071119999999911177
        7770000000000071999999999999991777770000000001199999999999999991
        1777700000001999999999999999999991777000000199999999999999999999
        9917770000019999999999999999999999177770001999999F9999999999F999
        9991777001999999FFF99999999FFF99999917700199999FFFFF999999FFFFF9
        9999177701999999FFFFF9999FFFFF9999991777199999999FFFFF99FFFFF999
        999991771999999999FFFFFFFFFF99999999917719999999999FFFFFFFF99999
        99999177199999999999FFFFFF99999999999177199999999999FFFFFF999999
        9999917719999999999FFFFFFFF99999999991771999999999FFFFFFFFFF9999
        99999170199999999FFFFF99FFFFF9999999917001999999FFFFF9999FFFFF99
        999917700199999FFFFF999999FFFFF99999170001999999FFF99999999FFF99
        99991000001999999F9999999999F99999917000000199999999999999999999
        9917000000019999999999999999999999100000000019999999999999999999
        9100000000000119999999999999999110000000000000019999999999999910
        0000000000000000111999999991110000000000000000000001111111100000
        00000000FFF807FFFFC000FFFF80007FFE00001FFC00000FF8000007F0000007
        E0000003E0000001C00000018000000180000000800000000000000000000000
        0000000000000000000000000000000000000001000000018000000180000003
        80000007C0000007E000000FE000001FF000003FF800007FFE0001FFFF0003FF
        FFE01FFF}
    end
    object Bevel1: TBevel
      Left = 0
      Top = 47
      Width = 642
      Height = 2
      Align = alBottom
      Shape = bsTopLine
    end
    object lApplication: TLabel
      Left = 68
      Top = 7
      Width = 83
      Height = 16
      Caption = 'lApplication'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lMSIC: TLabel
      Left = 79
      Top = 26
      Width = 28
      Height = 13
      Caption = 'lMSIC'
    end
    object AppIcon: TImage
      Left = 30
      Top = 12
      Width = 32
      Height = 32
      AutoSize = True
      Transparent = True
    end
  end
  object LogPanel: TPanel
    Left = 0
    Top = 354
    Width = 642
    Height = 24
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '    Journal file:'
    TabOrder = 3
    DesignSize = (
      642
      24)
    object eLog: TEdit
      Left = 71
      Top = 1
      Width = 556
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ParentColor = True
      ReadOnly = True
      TabOrder = 0
    end
  end
end
