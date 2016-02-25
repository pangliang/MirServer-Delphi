object FrmSrvMsg: TFrmSrvMsg
  Left = 627
  Top = 421
  Width = 193
  Height = 120
  Caption = 'FrmSrvMsg'
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object MsgServer: TServerSocket
    Active = False
    Address = '0.0.0.0'
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = MsgServerClientConnect
    OnClientDisconnect = MsgServerClientDisconnect
    OnClientRead = MsgServerClientRead
    OnClientError = MsgServerClientError
    Left = 27
    Top = 16
  end
end
