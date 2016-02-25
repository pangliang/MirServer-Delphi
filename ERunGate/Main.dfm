object FrmMain: TFrmMain
  Left = 245
  Top = 167
  Width = 311
  Height = 191
  Caption = 'FrmMain'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object MemoLog: TMemo
    Left = 0
    Top = 65
    Width = 303
    Height = 80
    Align = alClient
    ScrollBars = ssHorizontal
    TabOrder = 0
    OnChange = MemoLogChange
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 303
    Height = 65
    Align = alTop
    BorderOuter = fsNone
    Color = clSilver
    TabOrder = 1
    object LabelUserInfo: TLabel
      Left = 88
      Top = 32
      Width = 60
      Height = 12
      Caption = #29992#25143' 0/0/0'
    end
    object LabelRefConsoleMsg: TLabel
      Left = 179
      Top = 48
      Width = 78
      Height = 12
      Caption = '0/0/0/0/0/0/0'
    end
    object LabelCheckServerTime: TLabel
      Left = 8
      Top = 48
      Width = 18
      Height = 12
      Caption = '0/0'
    end
    object LabelMsg: TLabel
      Left = 8
      Top = 32
      Width = 18
      Height = 12
      Caption = '0/0'
    end
    object LabelProcessMsg: TLabel
      Left = 88
      Top = 48
      Width = 42
      Height = 12
      Caption = '0/0/0/0'
    end
    object CheckBoxShowData: TCheckBox
      Left = 8
      Top = 8
      Width = 73
      Height = 17
      Caption = #26174#31034#23553#21253
      Enabled = False
      TabOrder = 0
    end
  end
  object ServerSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = ServerSocketClientConnect
    OnClientDisconnect = ServerSocketClientDisconnect
    OnClientRead = ServerSocketClientRead
    OnClientError = ServerSocketClientError
    Left = 34
    Top = 80
  end
  object SendTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = SendTimerTimer
    Left = 61
    Top = 80
  end
  object ClientSocket: TClientSocket
    Active = False
    Address = '127.0.0.1'
    ClientType = ctNonBlocking
    Port = 50000
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Left = 10
    Top = 80
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 92
    Top = 80
  end
  object DecodeTimer: TTimer
    Interval = 1
    OnTimer = DecodeTimerTimer
    Left = 154
    Top = 80
  end
  object MainMenu: TMainMenu
    Left = 211
    Top = 80
    object MENU_CONTROL: TMenuItem
      Caption = #25511#21046'(&C)'
      object MENU_CONTROL_START: TMenuItem
        Caption = #21551#21160#26381#21153'(&S)'
        OnClick = MENU_CONTROL_STARTClick
      end
      object MENU_CONTROL_STOP: TMenuItem
        Caption = #20572#27490#26381#21153'(&T)'
        OnClick = MENU_CONTROL_STOPClick
      end
      object MENU_CONTROL_RECONNECT: TMenuItem
        Caption = #21047#26032#36830#25509'(&R)'
        OnClick = MENU_CONTROL_RECONNECTClick
      end
      object MENU_CONTROL_RELOADCONFIG: TMenuItem
        Caption = #37325#21152#36733#37197#32622'(&R)'
        OnClick = MENU_CONTROL_RELOADCONFIGClick
      end
      object MENU_CONTROL_CLEAELOG: TMenuItem
        Caption = #28165#38500#26085#24535'(&C)'
        OnClick = MENU_CONTROL_CLEAELOGClick
      end
      object MENU_CONTROL_EXIT: TMenuItem
        Caption = #36864#20986'(&E)'
        OnClick = MENU_CONTROL_EXITClick
      end
    end
    object MENU_VIEW: TMenuItem
      Caption = #26597#30475'(&V)'
      object MENU_VIEW_LOGMSG: TMenuItem
        Caption = #22312#32447#20154#29289'(&L)'
        OnClick = MENU_VIEW_LOGMSGClick
      end
    end
    object MENU_OPTION: TMenuItem
      Caption = #36873#39033'(&O)'
      object MENU_OPTION_GENERAL: TMenuItem
        Caption = #22522#26412#35774#32622'(&G)'
        OnClick = MENU_OPTION_GENERALClick
      end
      object MENU_OPTION_PERFORM: TMenuItem
        Caption = #24615#33021#35774#32622'(&P)'
        OnClick = MENU_OPTION_PERFORMClick
      end
      object MENU_OPTION_FILTERMSG: TMenuItem
        Caption = #28040#24687#36807#28388'(&C)'
        OnClick = MENU_OPTION_FILTERMSGClick
      end
      object MENU_OPTION_IPFILTER: TMenuItem
        Caption = #23433#20840#36807#28388'(&S)'
        OnClick = MENU_OPTION_IPFILTERClick
      end
      object MENU_OPTION_WAIGUA: TMenuItem
        Caption = #22806#25346#25511#21046'(&W)'
        OnClick = MENU_OPTION_WAIGUAClick
      end
    end
    object H1: TMenuItem
      Caption = #24110#21161'(&H)'
      object I1: TMenuItem
        Caption = #20851#20110'(&I)'
        OnClick = I1Click
      end
    end
  end
  object StartTimer: TTimer
    Interval = 200
    OnTimer = StartTimerTimer
    Left = 124
    Top = 80
  end
  object PopupMenu: TPopupMenu
    Left = 184
    Top = 80
    object POPMENU_PORT: TMenuItem
      AutoHotkeys = maManual
      Caption = #31471#21475
    end
    object POPMENU_CONNSTAT: TMenuItem
      AutoHotkeys = maManual
      Caption = #36830#25509#29366#24577
    end
    object POPMENU_CONNCOUNT: TMenuItem
      AutoHotkeys = maManual
      Caption = #36830#25509#25968
    end
    object POPMENU_CHECKTICK: TMenuItem
      AutoHotkeys = maManual
      Caption = #36890#35759#36229#26102
    end
    object N1: TMenuItem
      Caption = '--------------------'
    end
    object POPMENU_OPEN: TMenuItem
      Caption = #25171#24320#31383#21475'(&O)'
    end
    object POPMENU_START: TMenuItem
      Caption = #21551#21160#26381#21153'(&S)'
      OnClick = MENU_CONTROL_STARTClick
    end
    object POPMENU_CONNSTOP: TMenuItem
      Caption = #20572#27490#26381#21153'(&T)'
      OnClick = MENU_CONTROL_STOPClick
    end
    object POPMENU_RECONN: TMenuItem
      Caption = #21047#26032#36830#25509'(&R)'
      OnClick = MENU_CONTROL_RECONNECTClick
    end
    object POPMENU_EXIT: TMenuItem
      Caption = #36864#20986'(&X)'
      OnClick = MENU_CONTROL_EXITClick
    end
  end
end
