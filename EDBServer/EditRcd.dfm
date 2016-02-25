object frmEditRcd: TfrmEditRcd
  Left = 407
  Top = 294
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #32534#36753#20154#29289#25968#25454
  ClientHeight = 331
  ClientWidth = 451
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl: TPageControl
    Left = 10
    Top = 8
    Width = 433
    Height = 284
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #26222#36890
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 409
        Height = 246
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #20154#29289#21517#31216':'
        end
        object Label2: TLabel
          Left = 8
          Top = 68
          Width = 54
          Height = 12
          Caption = #30331#24405#24080#21495':'
        end
        object Label3: TLabel
          Left = 8
          Top = 92
          Width = 54
          Height = 12
          Caption = #20179#24211#23494#30721':'
        end
        object Label4: TLabel
          Left = 8
          Top = 116
          Width = 54
          Height = 12
          Caption = #37197#20598#21517#31216':'
        end
        object Label5: TLabel
          Left = 8
          Top = 140
          Width = 54
          Height = 12
          Caption = #24072#24466#21517#31216':'
        end
        object Label11: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #32034#24341#21495#30721':'
        end
        object Label12: TLabel
          Left = 168
          Top = 20
          Width = 54
          Height = 12
          Caption = #24403#21069#22320#22270':'
        end
        object Label13: TLabel
          Left = 168
          Top = 44
          Width = 54
          Height = 12
          Caption = #24403#21069#24231#26631':'
        end
        object Label14: TLabel
          Left = 168
          Top = 68
          Width = 54
          Height = 12
          Caption = #22238#22478#22320#22270':'
        end
        object Label15: TLabel
          Left = 168
          Top = 92
          Width = 54
          Height = 12
          Caption = #22238#22478#24231#26631':'
        end
        object EditChrName: TEdit
          Left = 64
          Top = 40
          Width = 97
          Height = 20
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 0
        end
        object EditAccount: TEdit
          Left = 64
          Top = 64
          Width = 97
          Height = 20
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 1
        end
        object EditPassword: TEdit
          Left = 64
          Top = 88
          Width = 97
          Height = 20
          TabOrder = 2
          OnChange = EditPasswordChange
        end
        object EditDearName: TEdit
          Left = 64
          Top = 112
          Width = 97
          Height = 20
          TabOrder = 3
          OnChange = EditPasswordChange
        end
        object EditMasterName: TEdit
          Left = 64
          Top = 136
          Width = 97
          Height = 20
          TabOrder = 4
          OnChange = EditPasswordChange
        end
        object EditIdx: TEdit
          Left = 64
          Top = 16
          Width = 97
          Height = 20
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 5
        end
        object EditCurMap: TEdit
          Left = 224
          Top = 16
          Width = 97
          Height = 20
          TabOrder = 6
          OnChange = EditPasswordChange
        end
        object EditCurX: TSpinEdit
          Left = 224
          Top = 40
          Width = 49
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 7
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditCurY: TSpinEdit
          Left = 272
          Top = 40
          Width = 49
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 8
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditHomeMap: TEdit
          Left = 224
          Top = 64
          Width = 97
          Height = 20
          TabOrder = 9
          OnClick = EditPasswordChange
        end
        object EditHomeX: TSpinEdit
          Left = 224
          Top = 88
          Width = 49
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 10
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditHomeY: TSpinEdit
          Left = 272
          Top = 88
          Width = 49
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 11
          Value = 0
          OnChange = EditPasswordChange
        end
        object CheckBoxIsMaster: TCheckBox
          Left = 64
          Top = 160
          Width = 57
          Height = 17
          Caption = #24072#29238
          TabOrder = 12
          OnClick = EditPasswordChange
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #25968#25454
      ImageIndex = 1
      object GroupBox2: TGroupBox
        Left = 8
        Top = 8
        Width = 409
        Height = 246
        TabOrder = 0
        object Label6: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 12
          Caption = #31561#32423':'
        end
        object Label7: TLabel
          Left = 8
          Top = 44
          Width = 30
          Height = 12
          Caption = #37329#24065':'
        end
        object Label8: TLabel
          Left = 8
          Top = 68
          Width = 42
          Height = 12
          Caption = #28216#25103#24065':'
        end
        object Label9: TLabel
          Left = 8
          Top = 92
          Width = 42
          Height = 12
          Caption = #28216#25103#28857':'
        end
        object Label16: TLabel
          Left = 8
          Top = 140
          Width = 42
          Height = 12
          Caption = #22768#26395#28857':'
        end
        object Label10: TLabel
          Left = 8
          Top = 116
          Width = 42
          Height = 12
          Caption = #20805#20540#28857':'
        end
        object Label17: TLabel
          Left = 8
          Top = 164
          Width = 30
          Height = 12
          Caption = 'PK'#28857':'
        end
        object Label18: TLabel
          Left = 8
          Top = 188
          Width = 42
          Height = 12
          Caption = #36129#29486#24230':'
        end
        object Label19: TLabel
          Left = 148
          Top = 19
          Width = 54
          Height = 12
          Caption = #32463#39564#20493#29575':'
        end
        object Label20: TLabel
          Left = 148
          Top = 43
          Width = 54
          Height = 12
          Caption = #32463#39564#26102#38388':'
        end
        object Label21: TLabel
          Left = 8
          Top = 211
          Width = 42
          Height = 12
          Caption = #23646#24615#28857':'
        end
        object EditLevel: TSpinEdit
          Left = 64
          Top = 16
          Width = 65
          Height = 21
          MaxValue = 65535
          MinValue = 0
          TabOrder = 0
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditGold: TSpinEdit
          Left = 64
          Top = 40
          Width = 65
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditGameGold: TSpinEdit
          Left = 64
          Top = 64
          Width = 65
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 2
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditGamePoint: TSpinEdit
          Left = 64
          Top = 88
          Width = 65
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 3
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditCreditPoint: TSpinEdit
          Left = 64
          Top = 136
          Width = 65
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 4
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditPayPoint: TSpinEdit
          Left = 64
          Top = 112
          Width = 65
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 5
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditPKPoint: TSpinEdit
          Left = 64
          Top = 160
          Width = 65
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 6
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditContribution: TSpinEdit
          Left = 64
          Top = 184
          Width = 65
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 7
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditExpRate: TSpinEdit
          Left = 208
          Top = 16
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 8
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditExpTime: TSpinEdit
          Left = 208
          Top = 40
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 9
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditBonusPoint: TSpinEdit
          Left = 64
          Top = 208
          Width = 65
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 10
          Value = 0
          OnChange = EditPasswordChange
        end
        object GroupBox6: TGroupBox
          Left = 148
          Top = 64
          Width = 197
          Height = 139
          Caption = #24050#20998#37197#23646#24615#28857
          TabOrder = 11
          object Label22: TLabel
            Left = 11
            Top = 20
            Width = 18
            Height = 12
            Caption = 'DC:'
          end
          object Label23: TLabel
            Left = 11
            Top = 42
            Width = 18
            Height = 12
            Caption = 'MC:'
          end
          object Label24: TLabel
            Left = 11
            Top = 65
            Width = 18
            Height = 12
            Caption = 'SC:'
          end
          object Label25: TLabel
            Left = 11
            Top = 87
            Width = 18
            Height = 12
            Caption = 'AC:'
          end
          object Label26: TLabel
            Left = 11
            Top = 111
            Width = 24
            Height = 12
            Caption = 'MAC:'
          end
          object Label27: TLabel
            Left = 95
            Top = 20
            Width = 18
            Height = 12
            Caption = 'HP:'
          end
          object Label28: TLabel
            Left = 95
            Top = 43
            Width = 18
            Height = 12
            Caption = 'MP:'
          end
          object Label29: TLabel
            Left = 95
            Top = 65
            Width = 24
            Height = 12
            Caption = 'Hit:'
          end
          object Label30: TLabel
            Left = 95
            Top = 87
            Width = 36
            Height = 12
            Caption = 'Speed:'
          end
          object Label31: TLabel
            Left = 95
            Top = 111
            Width = 18
            Height = 12
            Caption = 'X2:'
          end
          object EditDC: TSpinEdit
            Left = 35
            Top = 16
            Width = 54
            Height = 21
            Enabled = False
            MaxValue = 0
            MinValue = 0
            TabOrder = 0
            Value = 0
            OnChange = EditPasswordChange
          end
          object EditMC: TSpinEdit
            Left = 35
            Top = 38
            Width = 54
            Height = 21
            Enabled = False
            MaxValue = 0
            MinValue = 0
            TabOrder = 1
            Value = 0
            OnChange = EditPasswordChange
          end
          object EditSC: TSpinEdit
            Left = 35
            Top = 60
            Width = 54
            Height = 21
            Enabled = False
            MaxValue = 0
            MinValue = 0
            TabOrder = 2
            Value = 0
            OnChange = EditPasswordChange
          end
          object EditAC: TSpinEdit
            Left = 35
            Top = 84
            Width = 54
            Height = 21
            Enabled = False
            MaxValue = 0
            MinValue = 0
            TabOrder = 3
            Value = 0
            OnChange = EditPasswordChange
          end
          object EditMAC: TSpinEdit
            Left = 35
            Top = 108
            Width = 54
            Height = 21
            Enabled = False
            MaxValue = 0
            MinValue = 0
            TabOrder = 4
            Value = 0
            OnChange = EditPasswordChange
          end
          object EditHP: TSpinEdit
            Left = 130
            Top = 16
            Width = 54
            Height = 21
            Enabled = False
            MaxValue = 0
            MinValue = 0
            TabOrder = 5
            Value = 0
            OnChange = EditPasswordChange
          end
          object EditMP: TSpinEdit
            Left = 130
            Top = 38
            Width = 54
            Height = 21
            Enabled = False
            MaxValue = 0
            MinValue = 0
            TabOrder = 6
            Value = 0
            OnChange = EditPasswordChange
          end
          object EditHit: TSpinEdit
            Left = 130
            Top = 60
            Width = 54
            Height = 21
            Enabled = False
            MaxValue = 0
            MinValue = 0
            TabOrder = 7
            Value = 0
            OnChange = EditPasswordChange
          end
          object EditSpeed: TSpinEdit
            Left = 130
            Top = 84
            Width = 54
            Height = 21
            Enabled = False
            MaxValue = 0
            MinValue = 0
            TabOrder = 8
            Value = 0
            OnChange = EditPasswordChange
          end
          object EditX2: TSpinEdit
            Left = 130
            Top = 108
            Width = 54
            Height = 21
            Enabled = False
            MaxValue = 0
            MinValue = 0
            TabOrder = 9
            Value = 0
            OnChange = EditPasswordChange
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #25216#33021
      ImageIndex = 2
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 409
        Height = 246
        TabOrder = 0
        object ListViewMagic: TListView
          Left = 8
          Top = 16
          Width = 393
          Height = 217
          Columns = <
            item
              Caption = #24207#21495
              Width = 40
            end
            item
              Caption = #25216#33021
            end
            item
              Caption = #25216#33021#21517#31216
              Width = 100
            end
            item
              Caption = #31561#32423
              Width = 40
            end
            item
              Caption = #20462#28860#28857
              Width = 60
            end
            item
              Caption = #24555#25463#38190
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #35013#22791
      ImageIndex = 3
      object GroupBox4: TGroupBox
        Left = 8
        Top = 8
        Width = 409
        Height = 246
        TabOrder = 0
        object ListViewUserItem: TListView
          Left = 8
          Top = 16
          Width = 393
          Height = 217
          Columns = <
            item
              Caption = #24207#21495
              Width = 40
            end
            item
              Caption = #26631#35782#24207#21495
              Width = 80
            end
            item
              Caption = #29289#21697
            end
            item
              Caption = #29289#21697#21517#31216
              Width = 90
            end
            item
              Alignment = taCenter
              Caption = #25345#20037
              Width = 90
            end
            item
              Caption = #21442#25968
              Width = 220
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = #20179#24211
      ImageIndex = 4
      object GroupBox5: TGroupBox
        Left = 8
        Top = 8
        Width = 409
        Height = 246
        TabOrder = 0
        object ListViewStorage: TListView
          Left = 8
          Top = 16
          Width = 393
          Height = 217
          Columns = <
            item
              Caption = #24207#21495
              Width = 40
            end
            item
              Caption = #26631#35782#24207#21495
              Width = 80
            end
            item
              Caption = #29289#21697
            end
            item
              Caption = #29289#21697#21517#31216
              Width = 90
            end
            item
              Alignment = taCenter
              Caption = #25345#20037
              Width = 90
            end
            item
              Caption = #21442#25968
              Width = 220
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
  end
  object ButtonSaveData: TButton
    Left = 8
    Top = 298
    Width = 81
    Height = 25
    Caption = #20445#23384#20462#25913'(&S)'
    TabOrder = 1
    OnClick = ButtonExportDataClick
  end
  object ButtonExportData: TButton
    Left = 95
    Top = 298
    Width = 81
    Height = 25
    Caption = #23548#20986#25968#25454'(&E)'
    TabOrder = 2
    OnClick = ButtonExportDataClick
  end
  object ButtonImportData: TButton
    Left = 182
    Top = 298
    Width = 81
    Height = 25
    Caption = #23548#20837#25968#25454'(&I)'
    TabOrder = 3
    OnClick = ButtonExportDataClick
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'hum'
    Filter = #20154#29289#25968#25454' (*.hum)|*.hum'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 296
    Top = 280
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'hum'
    Filter = #20154#29289#25968#25454' (*.hum)|*.hum'
    Left = 336
    Top = 280
  end
end
