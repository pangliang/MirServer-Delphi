object FrmAbout: TFrmAbout
  Left = 348
  Top = 266
  BorderStyle = bsDialog
  Caption = #20851#20110
  ClientHeight = 289
  ClientWidth = 401
  Color = clSilver
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Label2: TLabel
    Left = 8
    Top = 248
    Width = 288
    Height = 36
    Caption = #26412#31243#24207#21482#36866#29992#20110#20013#21326#20154#27665#20849#21644#22269#27861#24459#20801#35768#33539#22260#20869#30340#20010#20154#13#23089#20048#65292#19981#24471#29992#20110#21830#19994#30408#21033#24615#32463#33829#65292#22914#22240#27492#36896#25104#30340#21518#26524#33258#13#36127#19982#26412#36719#20214#26080#20851#12290
    Font.Charset = GB2312_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object ButtonOK: TButton
    Left = 320
    Top = 256
    Width = 75
    Height = 25
    Caption = #30830#23450'(&O)'
    TabOrder = 0
    OnClick = ButtonOKClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 160
    Width = 385
    Height = 81
    Caption = #29256#26435#22768#26126
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 348
      Height = 36
      Caption = 
        #26412#35745#31639#26426#31243#24207#21463#20013#21326#20154#27665#20849#21644#22269#30693#35782#20135#26435#19982#29256#26435#20445#25252#65292#22914#26410#32463#25480#26435#13#32780#25797#33258#22797#21046#25110#20256#25773#26412#31243#24207#65288#25110#20854#20013#20219#20309#37096#20998#65289#65292#23558#21463#21040#20005#21385#30340#27665#20107#13#21450#21009#20107#21046 +
        #35009#65292#24182#22312#27861#24459#35768#21487#30340#33539#22260#20869#21463#21040#26368#22823#21487#33021#30340#36215#35785#12290
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 385
    Height = 145
    Caption = #29256#26412#20449#24687
    TabOrder = 2
    object Label3: TLabel
      Left = 8
      Top = 16
      Width = 54
      Height = 12
      Caption = #36719#20214#21517#31216':'
    end
    object Label4: TLabel
      Left = 8
      Top = 36
      Width = 54
      Height = 12
      Caption = #36719#20214#29256#26412':'
    end
    object Label5: TLabel
      Left = 8
      Top = 56
      Width = 54
      Height = 12
      Caption = #26356#26032#26085#26399':'
    end
    object Label6: TLabel
      Left = 8
      Top = 76
      Width = 54
      Height = 12
      Caption = #31243#24207#21046#20316':'
    end
    object Label7: TLabel
      Left = 8
      Top = 96
      Width = 54
      Height = 12
      Caption = #31243#24207#32593#31449':'
    end
    object Label8: TLabel
      Left = 8
      Top = 116
      Width = 54
      Height = 12
      Caption = #31243#24207#35770#22363':'
    end
    object EditProductName: TEdit
      Left = 64
      Top = 16
      Width = 313
      Height = 20
      BorderStyle = bsNone
      Color = clSilver
      Ctl3D = True
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 0
      Text = 'EditProductName'
    end
    object EditVersion: TEdit
      Left = 64
      Top = 36
      Width = 313
      Height = 20
      BorderStyle = bsNone
      Color = clSilver
      ReadOnly = True
      TabOrder = 1
      Text = 'EditVersion'
    end
    object EditUpDateTime: TEdit
      Left = 64
      Top = 56
      Width = 313
      Height = 20
      BorderStyle = bsNone
      Color = clSilver
      ReadOnly = True
      TabOrder = 2
      Text = 'EditUpDateTime'
    end
    object EditProgram: TEdit
      Left = 64
      Top = 76
      Width = 313
      Height = 20
      BorderStyle = bsNone
      Color = clSilver
      ReadOnly = True
      TabOrder = 3
      Text = 'EditProgram'
    end
    object EditWebSite: TEdit
      Left = 64
      Top = 96
      Width = 313
      Height = 20
      BorderStyle = bsNone
      Color = clSilver
      ReadOnly = True
      TabOrder = 4
      Text = 'EditWebSite'
    end
    object EditBbsSite: TEdit
      Left = 64
      Top = 116
      Width = 313
      Height = 20
      BorderStyle = bsNone
      Color = clSilver
      ReadOnly = True
      TabOrder = 5
      Text = 'EditBbsSite'
    end
  end
end
