object dlgMSI_Detail: TdlgMSI_Detail
  Left = 326
  Top = 330
  BorderStyle = bsDialog
  ClientHeight = 450
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonPanel: TPanel
    Left = 0
    Top = 408
    Width = 409
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel: TPanel
      Left = 319
      Top = 0
      Width = 90
      Height = 42
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bOK: TButton
        Left = 4
        Top = 6
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
  object ClientPanel: TPanel
    Left = 0
    Top = 0
    Width = 409
    Height = 408
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    Caption = ' '
    TabOrder = 1
    object pc: TPageControl
      Left = 10
      Top = 10
      Width = 389
      Height = 388
      ActivePage = TabSheet1
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = ' Properties '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 381
          Height = 360
          Align = alClient
          BevelInner = bvLowered
          BevelOuter = bvNone
          BorderWidth = 10
          Caption = ' '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object Notebook: TNotebook
            Left = 11
            Top = 11
            Width = 359
            Height = 338
            Align = alClient
            PageIndex = 3
            TabOrder = 0
            object TPage
              Left = 0
              Top = 0
              Caption = 'Memo'
              object Memo: TMemo
                Left = 0
                Top = 0
                Width = 359
                Height = 321
                Align = alClient
                BorderStyle = bsNone
                Color = clBtnFace
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
            end
            object TPage
              Left = 0
              Top = 0
              Caption = 'CheckBox'
              object clb: TCheckListBox
                Left = 0
                Top = 0
                Width = 359
                Height = 338
                OnClickCheck = clbClickCheck
                Align = alClient
                BorderStyle = bsNone
                Color = clBtnFace
                IntegralHeight = True
                ItemHeight = 13
                TabOrder = 0
              end
            end
            object TPage
              Left = 0
              Top = 0
              Caption = 'Listbox'
              object lb: TListBox
                Left = 0
                Top = 0
                Width = 359
                Height = 338
                Align = alClient
                BorderStyle = bsNone
                Color = clBtnFace
                ItemHeight = 13
                TabOrder = 0
              end
            end
            object TPage
              Left = 0
              Top = 0
              Caption = 'ListView'
              object lv: TListView
                Left = 0
                Top = 0
                Width = 359
                Height = 338
                Align = alClient
                BorderStyle = bsNone
                Color = clBtnFace
                Columns = <
                  item
                    Caption = 'Variable'
                    Width = 150
                  end
                  item
                    AutoSize = True
                    Caption = 'Value'
                  end>
                ColumnClick = False
                HideSelection = False
                HotTrackStyles = [htHandPoint, htUnderlineHot]
                ReadOnly = True
                RowSelect = True
                ParentShowHint = False
                ShowColumnHeaders = False
                ShowHint = True
                TabOrder = 0
                ViewStyle = vsReport
                OnAdvancedCustomDrawItem = lvAdvancedCustomDrawItem
                OnAdvancedCustomDrawSubItem = lvAdvancedCustomDrawSubItem
              end
            end
          end
        end
      end
    end
  end
end
