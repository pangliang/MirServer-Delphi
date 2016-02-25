object Form1: TForm1
  Left = 337
  Top = 265
  Width = 631
  Height = 476
  Caption = 'MSIC DLL Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 623
    Height = 449
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    BorderStyle = bsSingle
    Caption = ' '
    Color = clWhite
    TabOrder = 0
    DesignSize = (
      619
      445)
    object Image1: TImage
      Left = 9
      Top = 10
      Width = 32
      Height = 32
      AutoSize = True
      Center = True
      Picture.Data = {
        055449636F6E0000010001002020100000000000E80200001600000028000000
        2000000040000000010004000000000080020000000000000000000010000000
        0000000000000000000080000080000000808000800000008000800080800000
        C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
        FFFFFF0000000000000000000000000000000000000000000000000077000000
        0000000000000000000000777788000000000000000000000000777007888800
        000000000000000000777007FF8888880000000000000000777077FF77778888
        88000000000000777077FF7777777788888800000000777777FF777778877777
        88888800807777C7FF7777800000887777888880077797FF77770088007F8087
        7777888007B7FF7777007800777F77708777778007FF777700770077777F7778
        007777000F777770880077F0077F777880080000807777800077F804077F7778
        888000000080770077F80444077F77788888080000000077F8044444077F7778
        88888000000007F804444444077F7778888880000000070444444444077F7778
        8888800000000704C4444444077F7778888880000000070464444444077F7778
        888880000000070464444444077F7778888880000000070464444440877F7778
        88888000000007046444408777FF77788888800000000704C4408777FF77FF78
        7888800000000704408777FF777777F887880000000007808777FF7777777787
        777080000000077777FF7F7F777788777000000000000777FFF7F7F7F7887770
        00000000000007FF7F7F7F77887770000000000000008077F7F7F78877700000
        00000000000000887F7F00077000000000000000000000008880000000000000
        00000000FFFF3FFFFFFC0FFFFFF003FFFFC000FFFF00003FFC00000FF0000003
        C000000000000000000000000000000000000000000000030000000FC0000003
        F0000003F0000003F0000003F0000003F0000003F0000003F0000003F0000003
        F0000003F0000003F0000007F000001FF000007FF00001FFF00007FFFC001FFF
        FF1E7FFF}
    end
    object Label1: TLabel
      Left = 51
      Top = 9
      Width = 162
      Height = 20
      Caption = 'System Information'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 68
      Top = 29
      Width = 82
      Height = 13
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'System Overview'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Label2Click
      OnMouseEnter = Label2MouseEnter
      OnMouseLeave = Label2MouseLeave
    end
    object Memo: TMemo
      Left = 10
      Top = 54
      Width = 599
      Height = 381
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      ReadOnly = True
      TabOrder = 0
      WordWrap = False
    end
  end
  object Timer: TTimer
    Left = 176
    Top = 146
  end
end
