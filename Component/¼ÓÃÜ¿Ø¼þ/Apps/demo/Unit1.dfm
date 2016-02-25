object Form1: TForm1
  Left = 511
  Top = 182
  Width = 513
  Height = 540
  Caption = #21152#23494#28436#31034
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox3: TGroupBox
    Left = 8
    Top = 288
    Width = 489
    Height = 177
    Caption = #21152#23494#26126#25991
    TabOrder = 4
    object Memo2: TMemo
      Left = 8
      Top = 16
      Width = 473
      Height = 153
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 489
    Height = 193
    Caption = #35299#23494#26126#25991
    TabOrder = 3
    object Memo1: TMemo
      Left = 8
      Top = 16
      Width = 473
      Height = 169
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 208
    Width = 489
    Height = 73
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 57
      Height = 13
      Caption = #21152#23494#31639#27861'   '
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 60
      Height = 13
      Caption = #21152#23494#23494#38053'    '
    end
    object RzLabel1: TRzLabel
      Left = 280
      Top = 48
      Width = 60
      Height = 13
      Caption = #23494#30721#38271#24230#65306
    end
    object ComboBox1: TComboBox
      Left = 72
      Top = 16
      Width = 129
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'blowfish'
    end
    object Edit3: TEdit
      Left = 72
      Top = 40
      Width = 201
      Height = 21
      TabOrder = 1
      Text = '12d3fg4g3h32j4k4j32'
    end
    object ComboBox2: TComboBox
      Left = 344
      Top = 16
      Width = 137
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'HAVAL'
    end
    object Button5: TButton
      Left = 416
      Top = 40
      Width = 65
      Height = 25
      Caption = #29983#25104#23494#30721
      TabOrder = 3
      OnClick = Button5Click
    end
    object RzSpinner1: TRzSpinner
      Left = 344
      Top = 46
      Width = 65
      Max = 120
      Min = 20
      Value = 20
      ParentColor = False
      TabOrder = 4
    end
  end
  object Button1: TButton
    Left = 280
    Top = 472
    Width = 73
    Height = 25
    Caption = #21152#23494
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 400
    Top = 472
    Width = 73
    Height = 25
    Caption = #32467#26463
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 160
    Top = 472
    Width = 73
    Height = 25
    Caption = 'HASH'#21152#23494
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 32
    Top = 472
    Width = 75
    Height = 25
    Caption = #35299#23494
    TabOrder = 6
    OnClick = Button4Click
  end
  object DCP_blowfish1: TDCP_blowfish
    Id = 5
    Algorithm = 'Blowfish'
    MaxKeySize = 448
    BlockSize = 64
    Left = 32
    Top = 360
  end
  object DCP_cast1281: TDCP_cast128
    Id = 7
    Algorithm = 'Cast128'
    MaxKeySize = 128
    BlockSize = 64
    Left = 64
    Top = 360
  end
  object DCP_cast2561: TDCP_cast256
    Id = 15
    Algorithm = 'Cast256'
    MaxKeySize = 256
    BlockSize = 128
    Left = 96
    Top = 360
  end
  object DCP_des1: TDCP_des
    Id = 23
    Algorithm = 'DES'
    MaxKeySize = 64
    BlockSize = 64
    Left = 128
    Top = 360
  end
  object DCP_3des1: TDCP_3des
    Id = 24
    Algorithm = '3DES'
    MaxKeySize = 192
    BlockSize = 64
    Left = 160
    Top = 360
  end
  object DCP_gost1: TDCP_gost
    Id = 8
    Algorithm = 'Gost'
    MaxKeySize = 256
    BlockSize = 64
    Left = 200
    Top = 360
  end
  object DCP_ice1: TDCP_ice
    Id = 20
    Algorithm = 'Ice'
    MaxKeySize = 64
    BlockSize = 64
    Left = 232
    Top = 360
  end
  object DCP_ice21: TDCP_ice2
    Id = 22
    Algorithm = 'Ice2'
    MaxKeySize = 128
    BlockSize = 64
    Left = 264
    Top = 360
  end
  object DCP_thinice1: TDCP_thinice
    Id = 21
    Algorithm = 'Thin Ice'
    MaxKeySize = 64
    BlockSize = 64
    Left = 296
    Top = 360
  end
  object DCP_idea1: TDCP_idea
    Id = 12
    Algorithm = 'IDEA'
    MaxKeySize = 128
    BlockSize = 64
    Left = 328
    Top = 360
  end
  object DCP_mars1: TDCP_mars
    Id = 13
    Algorithm = 'Mars'
    MaxKeySize = 1248
    BlockSize = 128
    Left = 360
    Top = 360
  end
  object DCP_misty11: TDCP_misty1
    Id = 11
    Algorithm = 'Misty1'
    MaxKeySize = 128
    BlockSize = 64
    Left = 32
    Top = 392
  end
  object DCP_rc21: TDCP_rc2
    Id = 1
    Algorithm = 'RC2'
    MaxKeySize = 1024
    BlockSize = 64
    Left = 64
    Top = 392
  end
  object DCP_rc41: TDCP_rc4
    Id = 19
    Algorithm = 'RC4'
    MaxKeySize = 2048
    Left = 96
    Top = 392
  end
  object DCP_rc61: TDCP_rc6
    Id = 4
    Algorithm = 'RC6'
    MaxKeySize = 2048
    BlockSize = 128
    Left = 104
    Top = 136
  end
  object DCP_rc51: TDCP_rc5
    Id = 3
    Algorithm = 'RC5'
    MaxKeySize = 2048
    BlockSize = 64
    Left = 128
    Top = 392
  end
  object DCP_rijndael1: TDCP_rijndael
    Id = 9
    Algorithm = 'Rijndael'
    MaxKeySize = 256
    BlockSize = 128
    Left = 40
    Top = 128
  end
  object DCP_twofish1: TDCP_twofish
    Id = 6
    Algorithm = 'Twofish'
    MaxKeySize = 256
    BlockSize = 128
    Left = 40
    Top = 96
  end
  object DCP_sha11: TDCP_sha1
    Id = 2
    Algorithm = 'SHA1'
    HashSize = 160
    Left = 40
    Top = 32
  end
  object DCP_ripemd1601: TDCP_ripemd160
    Id = 10
    Algorithm = 'RipeMD-160'
    HashSize = 160
    Left = 104
    Top = 32
  end
  object DCP_md51: TDCP_md5
    Id = 16
    Algorithm = 'MD5'
    HashSize = 128
    Left = 40
    Top = 64
  end
  object DCP_md41: TDCP_md4
    Id = 17
    Algorithm = 'MD4'
    HashSize = 128
    Left = 104
    Top = 64
  end
  object DCP_haval1: TDCP_haval
    Id = 14
    Algorithm = 'Haval'
    HashSize = 256
    Left = 104
    Top = 104
  end
end
