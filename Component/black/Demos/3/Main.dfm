object Form2: TForm2
  Left = 423
  Top = 488
  Width = 596
  Height = 456
  Caption = 'Memory Viewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    588
    429)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 10
    Top = 379
    Width = 569
    Height = 6
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
  end
  object bShow: TButton
    Left = 14
    Top = 392
    Width = 135
    Height = 24
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = 'Show Physical Memory'
    TabOrder = 1
    OnClick = bShowClick
  end
  object Memo: TMemo
    Left = 17
    Top = 59
    Width = 555
    Height = 307
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object bClose: TButton
    Left = 501
    Top = 392
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 2
    OnClick = bCloseClick
  end
  object pTitle: TPanel
    Left = 17
    Top = 14
    Width = 555
    Height = 40
    Alignment = taLeftJustify
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvLowered
    Caption = ' '
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Image1: TImage
      Left = 5
      Top = 4
      Width = 32
      Height = 32
      AutoSize = True
      Center = True
      Picture.Data = {
        055449636F6E0000010001002020040000000000E80200001600000028000000
        2000000040000000010004000000000000020000000000000000000000000000
        0000000000000000000080000080000000808000800000008000800080800000
        80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
        FFFFFF0000000000000000000000000000000000000777770000000000000000
        0000000000877777700000000000000000000000008B37777700000000000000
        00000000008BB3777770000000000000000000000008BB377777000000000000
        0000000000008BB3777770000000000000000000000008BB3777700000000000
        000000000000008BB3777700777770000000000000777777BB37777777887747
        77777700006444467B877788FFFFF8744466670000888888888878FFFFFFFFF7
        67887700006FFFFFFF888FFFFFFFFFFF778F8700006FFFFFFF8888888888888F
        877F8700006F8888888888888888888F877F8700006FFFFFF888F88FFFFFFFFF
        F7788700006FFFFFF888888888888888F8788700006F88888888888888888888
        877F8700006FFFFFFF88FFF8FFFFFFFFF77F8700006FF888888888888888888F
        878F8700006F88888888888888888888778F8700006FFFFFFFF88FFFFF88FFF8
        78FF8700006FF8888888788FFF88888788FF8700006FF8888888887888888878
        F8FF8700006FFFFFFFFFFFF8778888FFFFFF8700006FF8888888888888888888
        88FF8700006FF88888888888888888FFFFFF8700006FFFFFFFFFFFFFFFFFFFFF
        FFFF870000777777777777777777777777776700006666666666666666666666
        66776700006666666666666666666EEEE6776700000666666666666666666666
        66667000FFFFFFFFE0FFFFFFC07FFFFFC03FFFFFC01FFFFFE00FFFFFF007FFFF
        F807FFFFFC0307FFC0000003C0000003C0000003C0000003C0000003C0000003
        C0000003C0000003C0000003C0000003C0000003C0000003C0000003C0000003
        C0000003C0000003C0000003C0000003C0000003C0000003C0000003C0000003
        E0000007}
    end
    object LabelAddress: TLabel
      Left = 52
      Top = 14
      Width = 41
      Height = 13
      Caption = 'Address:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LabelLength: TLabel
      Left = 208
      Top = 14
      Width = 36
      Height = 13
      Caption = 'Length:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object EditAddress: TEdit
      Left = 104
      Top = 10
      Width = 85
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '$F0800'
    end
    object EditLength: TEdit
      Left = 256
      Top = 10
      Width = 85
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '1024'
    end
  end
  object bSave: TButton
    Left = 156
    Top = 392
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = 'Save...'
    Enabled = False
    TabOrder = 4
    OnClick = bSaveClick
  end
  object sd: TSaveDialog
    DefaultExt = 'dmp'
    Filter = 'Dump files|*.dmp|All files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 278
    Top = 204
  end
end
