object frmGrobalSession: TfrmGrobalSession
  Left = 290
  Top = 332
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26597#30475#20840#23616#20250#35805
  ClientHeight = 208
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonRefGrid: TButton
    Left = 320
    Top = 176
    Width = 73
    Height = 25
    Caption = #21047#26032'(&R)'
    TabOrder = 0
  end
  object PanelStatus: TPanel
    Left = 4
    Top = 8
    Width = 393
    Height = 161
    TabOrder = 1
    object GridSession: TStringGrid
      Left = 0
      Top = 0
      Width = 393
      Height = 161
      ColCount = 6
      DefaultRowHeight = 18
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      ColWidths = (
        34
        83
        86
        56
        44
        58)
    end
  end
end
