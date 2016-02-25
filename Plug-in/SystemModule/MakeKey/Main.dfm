object FrmMakeKey: TFrmMakeKey
  Left = 451
  Top = 158
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'M2'#27880#20876#26426' '#26356#26032#26085#26399' [2006-11-12]'
  ClientHeight = 240
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label4: TLabel
    Left = 8
    Top = 164
    Width = 48
    Height = 12
    Caption = #29992#25143#21517#65306
  end
  object Label9: TLabel
    Left = 8
    Top = 184
    Width = 48
    Height = 12
    Caption = #27880#20876#30721#65306
  end
  object LabelInfo: TLabel
    Left = 128
    Top = 216
    Width = 192
    Height = 12
    Caption = #31243#24207#21046#20316#65306#21494#38543#39118#39128' QQ'#65306'240621028'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 313
    Height = 145
    Caption = #27880#20876#20449#24687
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 48
      Height = 12
      Caption = #26426#22120#30721#65306
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 60
      Height = 12
      Caption = #21040#26399#26102#38388#65306
    end
    object Label6: TLabel
      Left = 8
      Top = 96
      Width = 60
      Height = 12
      Caption = #38480#21046#27425#25968#65306
    end
    object Label5: TLabel
      Left = 8
      Top = 48
      Width = 60
      Height = 12
      Caption = #27880#20876#26085#26399#65306
    end
    object Label2: TLabel
      Left = 8
      Top = 120
      Width = 60
      Height = 12
      Caption = #27880#20876#20154#25968#65306
    end
    object UserKeyEdit: TEdit
      Left = 72
      Top = 20
      Width = 233
      Height = 20
      TabOrder = 0
    end
    object UserDateTimeEdit: TRzDateTimeEdit
      Left = 72
      Top = 68
      Width = 233
      Height = 20
      EditType = etDate
      TabOrder = 1
    end
    object SpinEditCount: TSpinEdit
      Left = 72
      Top = 92
      Width = 233
      Height = 21
      MaxValue = 111111111
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object RzDateTimeEditRegister: TRzDateTimeEdit
      Left = 72
      Top = 44
      Width = 233
      Height = 20
      EditType = etDate
      TabOrder = 3
      OnChange = RzDateTimeEditRegisterChange
    end
    object SpinEditPersonCount: TSpinEdit
      Left = 72
      Top = 116
      Width = 233
      Height = 21
      MaxValue = 1111111111
      MinValue = 0
      TabOrder = 4
      Value = 1
    end
  end
  object UserModeRadioGroup: TRadioGroup
    Left = 328
    Top = 8
    Width = 105
    Height = 145
    Caption = #27880#20876#31867#22411
    ItemIndex = 1
    Items.Strings = (
      #27425#25968#38480#21046
      #26085#26399#38480#21046
      #26080#38480#21046)
    TabOrder = 1
  end
  object EditUserName: TEdit
    Left = 56
    Top = 160
    Width = 377
    Height = 20
    TabOrder = 2
    Text = 'www.51ggame.com'
  end
  object EditEnterKey: TEdit
    Left = 56
    Top = 184
    Width = 377
    Height = 20
    TabOrder = 3
  end
  object MakeKeyButton: TButton
    Left = 8
    Top = 208
    Width = 97
    Height = 25
    Caption = #35745#31639#27880#20876#30721'(&M)'
    TabOrder = 4
    OnClick = MakeKeyButtonClick
  end
  object ButtonExit: TButton
    Left = 336
    Top = 208
    Width = 99
    Height = 25
    Caption = #20851#38381'(&E)'
    TabOrder = 5
    OnClick = ButtonExitClick
  end
  object RadioGroupLicDay: TRadioGroup
    Left = 440
    Top = 8
    Width = 89
    Height = 225
    Caption = #25480#26435#22825#25968
    ItemIndex = 2
    Items.Strings = (
      #19968#20010#26376
      #21322#24180
      #19968#24180
      #19968#24180#21322
      #20108#24180)
    TabOrder = 6
    OnClick = RadioGroupLicDayClick
  end
end
