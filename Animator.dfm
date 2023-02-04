object FrAnimator: TFrAnimator
  Left = 269
  Top = 185
  BorderStyle = bsToolWindow
  Caption = 'Animator'
  ClientHeight = 426
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    393
    426)
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 68
    Top = 348
    Width = 105
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = 'Fixed part of filenames'
  end
  object Label9: TLabel
    Left = 6
    Top = 375
    Width = 75
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = 'Directory of files'
  end
  object SpeedButton1: TSpeedButton
    Left = 258
    Top = 373
    Width = 23
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = '...'
    OnClick = SpeedButton1Click
  end
  object Label1: TLabel
    Left = 143
    Top = 405
    Width = 83
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = 'Number of frames'
  end
  object Label4: TLabel
    Left = 289
    Top = 6
    Width = 95
    Height = 125
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 
      'Animator helps you to build animations in fractal world. It star' +
      'ts from coordinates of starting point and goes to destination po' +
      'int in the number of steps you decide.'
    WordWrap = True
  end
  object Label5: TLabel
    Left = 289
    Top = 130
    Width = 95
    Height = 85
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 
      'Note that you can choose same coordinates but change magnificati' +
      'on for a "zoom" effect.'
    WordWrap = True
  end
  object Label6: TLabel
    Left = 289
    Top = 214
    Width = 95
    Height = 59
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 
      'All the other image'#39's data (color, size, etc.) are taken from cu' +
      'rrent image.'
    WordWrap = True
  end
  object Label15: TLabel
    Left = 99
    Top = 322
    Width = 74
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = 'Starting number'
  end
  object Label16: TLabel
    Left = 7
    Top = 404
    Width = 75
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = 'Frames per sec.'
  end
  object Label11: TLabel
    Left = 3
    Top = 149
    Width = 97
    Height = 16
    Caption = 'Destination point'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 3
    Top = 3
    Width = 77
    Height = 16
    Caption = 'Starting point'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label17: TLabel
    Left = 289
    Top = 272
    Width = 95
    Height = 69
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 
      'With the two buttons you can paste the params stored into the cl' +
      'ipboard (Ctrl+P).'
    WordWrap = True
  end
  object btCancel: TBitBtn
    Left = 309
    Top = 368
    Width = 77
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 8
    Kind = bkCancel
  end
  object BtOK: TBitBtn
    Left = 309
    Top = 398
    Width = 77
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 9
    OnClick = BtOKClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object PnDestinationPoint: TPanel
    Left = 8
    Top = 166
    Width = 273
    Height = 125
    BevelInner = bvSpace
    BevelOuter = bvLowered
    TabOrder = 1
    object Label12: TLabel
      Left = 8
      Top = 13
      Width = 90
      Height = 14
      Caption = 'Real part of center'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 8
      Top = 48
      Width = 115
      Height = 14
      Caption = 'Imaginary part of center'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 113
      Top = 83
      Width = 105
      Height = 14
      Caption = 'Magnification (Y axis)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object btPasteDest: TSpeedButton
      Left = 188
      Top = 6
      Width = 79
      Height = 19
      Caption = 'Paste values'
      Flat = True
      OnClick = btPasteDestClick
    end
    object Label18: TLabel
      Left = 9
      Top = 83
      Width = 44
      Height = 14
      Caption = 'Iterations'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edRPoC2: TEdit
      Left = 3
      Top = 27
      Width = 264
      Height = 21
      Hint = 'Coordinate X of image center'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'edRPoC2'
    end
    object edIPoC2: TEdit
      Left = 3
      Top = 62
      Width = 264
      Height = 21
      Hint = 'Coordinate Y of image center'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'edIPoC2'
    end
    object edMagnit2: TEdit
      Left = 106
      Top = 97
      Width = 161
      Height = 21
      Hint = 'Range to show. Tips: high values need high iteractions usually'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'edMagnit2'
    end
    object edMaxIter2: TEdit
      Left = 4
      Top = 97
      Width = 99
      Height = 21
      Hint = 'Range to show. Tips: high values need high iteractions usually'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'edMaxIter2'
    end
  end
  object PnStartingPoint: TPanel
    Left = 8
    Top = 20
    Width = 273
    Height = 125
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label7: TLabel
      Left = 8
      Top = 13
      Width = 90
      Height = 14
      Caption = 'Real part of center'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 8
      Top = 48
      Width = 115
      Height = 14
      Caption = 'Imaginary part of center'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 110
      Top = 83
      Width = 105
      Height = 14
      Caption = 'Magnification (Y axis)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object btPasteStart: TSpeedButton
      Left = 188
      Top = 6
      Width = 79
      Height = 19
      Caption = 'Paste values'
      Flat = True
      OnClick = btPasteStartClick
    end
    object Label19: TLabel
      Left = 9
      Top = 83
      Width = 44
      Height = 14
      Caption = 'Iterations'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edRPoC1: TEdit
      Left = 3
      Top = 27
      Width = 264
      Height = 21
      Hint = 'Coordinate X of image center'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'edRPoC1'
    end
    object edIPoC1: TEdit
      Left = 3
      Top = 62
      Width = 264
      Height = 21
      Hint = 'Coordinate Y of image center'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'edIPoC1'
    end
    object edMagnit1: TEdit
      Left = 106
      Top = 97
      Width = 161
      Height = 21
      Hint = 'Range to show. Tips: high values need high iteractions usually'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'edMagnit1'
    end
    object edMaxIter1: TEdit
      Left = 4
      Top = 97
      Width = 99
      Height = 21
      Hint = 'Range to show. Tips: high values need high iteractions usually'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'edMaxIter1'
    end
  end
  object edName: TEdit
    Left = 185
    Top = 346
    Width = 96
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    Text = 'edName'
  end
  object edDir: TEdit
    Left = 86
    Top = 373
    Width = 167
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 5
    Text = 'edDir'
  end
  object edNum: TEdit
    Left = 233
    Top = 401
    Width = 48
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 7
    Text = 'edNum'
  end
  object edStarting: TEdit
    Left = 185
    Top = 320
    Width = 96
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    Text = 'edStarting'
  end
  object CbAvi: TCheckBox
    Left = 8
    Top = 296
    Width = 81
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Create Avi'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = CbAviClick
  end
  object edFPS: TEdit
    Left = 87
    Top = 401
    Width = 48
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 6
    Text = 'edFPS'
  end
  object cbDeleteBmp: TCheckBox
    Left = 196
    Top = 296
    Width = 85
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Delete Bmps'
    Checked = True
    State = cbChecked
    TabOrder = 10
  end
  object cbPlayAvi: TCheckBox
    Left = 102
    Top = 296
    Width = 67
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Play Avi'
    Checked = True
    State = cbChecked
    TabOrder = 11
  end
end
