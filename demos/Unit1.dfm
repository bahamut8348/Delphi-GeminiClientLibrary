object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 499
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 427
    Height = 453
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #25991#26412
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 402
        Height = 13
        AutoSize = False
        Caption = #21457#36865#20869#23481#65306
      end
      object Label2: TLabel
        Left = 8
        Top = 56
        Width = 402
        Height = 13
        AutoSize = False
        Caption = #25509#25910#20869#23481#65306
      end
      object Edit1: TEdit
        Left = 8
        Top = 27
        Width = 321
        Height = 21
        TabOrder = 0
      end
      object Button2: TButton
        Left = 335
        Top = 25
        Width = 75
        Height = 25
        Caption = #21457#36865
        TabOrder = 1
        OnClick = Button2Click
      end
      object Memo1: TMemo
        Left = 8
        Top = 75
        Width = 402
        Height = 340
        ScrollBars = ssBoth
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = #20250#35805
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        Left = 8
        Top = 8
        Width = 402
        Height = 13
        AutoSize = False
        Caption = #21457#36865#20869#23481#65306
      end
      object Label4: TLabel
        Left = 8
        Top = 56
        Width = 402
        Height = 13
        AutoSize = False
        Caption = #25509#25910#20869#23481#65306
      end
      object Edit2: TEdit
        Left = 8
        Top = 27
        Width = 321
        Height = 21
        TabOrder = 0
      end
      object Button3: TButton
        Left = 335
        Top = 25
        Width = 75
        Height = 25
        Caption = #21457#36865
        TabOrder = 1
        OnClick = Button3Click
      end
      object Memo2: TMemo
        Left = 8
        Top = 75
        Width = 402
        Height = 313
        ScrollBars = ssBoth
        TabOrder = 2
      end
      object Button4: TButton
        Left = 254
        Top = 394
        Width = 75
        Height = 25
        Caption = #21551#21160#20250#35805
        TabOrder = 3
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 335
        Top = 394
        Width = 75
        Height = 25
        Caption = #32467#26463#20250#35805
        TabOrder = 4
        OnClick = Button5Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = #21015#34920
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lvModelList: TListView
        Left = 8
        Top = 8
        Width = 402
        Height = 380
        Columns = <
          item
            Caption = #21517#31216
          end
          item
            Caption = #29256#26412
          end
          item
            Caption = #26174#31034#21517
          end
          item
            AutoSize = True
            Caption = #35828#26126
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Button6: TButton
        Left = 335
        Top = 394
        Width = 75
        Height = 25
        Caption = #21047#26032
        TabOrder = 1
        OnClick = Button6Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = #35774#32622
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label5: TLabel
        Left = 16
        Top = 16
        Width = 387
        Height = 13
        AutoSize = False
        Caption = 'API'#25509#21475#22522#30784#22320#22336#65306
      end
      object Label6: TLabel
        Left = 16
        Top = 72
        Width = 387
        Height = 13
        AutoSize = False
        Caption = 'API'#29256#26412#21495#65306
      end
      object Label7: TLabel
        Left = 16
        Top = 128
        Width = 387
        Height = 13
        AutoSize = False
        Caption = 'API'#23494#38053#65306
      end
      object Label8: TLabel
        Left = 16
        Top = 224
        Width = 387
        Height = 13
        AutoSize = False
        Caption = #20195#29702#26381#21153#22120#22320#22336#65306
      end
      object Label9: TLabel
        Left = 16
        Top = 280
        Width = 387
        Height = 13
        AutoSize = False
        Caption = #20195#29702#26381#21153#22120#36134#21495#65306
      end
      object Label10: TLabel
        Left = 16
        Top = 336
        Width = 387
        Height = 13
        AutoSize = False
        Caption = #20195#29702#26381#21153#22120#23494#30721#65306
      end
      object edtApiBaseUrl: TEdit
        Left = 16
        Top = 36
        Width = 387
        Height = 21
        TabOrder = 0
        Text = 'https://generativelanguage.googleapis.com'
      end
      object edtApiVersion: TEdit
        Left = 16
        Top = 92
        Width = 387
        Height = 21
        TabOrder = 1
        Text = 'v1beta'
      end
      object edtApiKey: TEdit
        Left = 16
        Top = 148
        Width = 387
        Height = 21
        TabOrder = 2
      end
      object cbUsedProxy: TCheckBox
        Left = 16
        Top = 200
        Width = 387
        Height = 17
        Caption = #26159#21542#20351#29992#20195#29702
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = cbUsedProxyClick
      end
      object edtProxyAddress: TEdit
        Left = 16
        Top = 244
        Width = 387
        Height = 21
        TabOrder = 4
        Text = 'socks5://127.0.0.1:1080'
      end
      object edtProxyUsername: TEdit
        Left = 16
        Top = 300
        Width = 387
        Height = 21
        TabOrder = 5
      end
      object edtProxyPassword: TEdit
        Left = 16
        Top = 356
        Width = 387
        Height = 21
        TabOrder = 6
      end
      object Button7: TButton
        Left = 335
        Top = 394
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 7
        OnClick = Button7Click
      end
    end
  end
  object Button1: TButton
    Left = 360
    Top = 467
    Width = 75
    Height = 25
    Caption = #20851#38381
    TabOrder = 1
    OnClick = Button1Click
  end
end
