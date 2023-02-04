unit ColorEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Menus, Colors, Math;

const
  CAPT = 'Colors Editor';

type
  TFakeControl = class( TControl ); // to see DragMode
  
  TFrEditColors = class(TForm)
    btImport: TBitBtn;
    btOpen: TBitBtn;
    btSaveAs: TBitBtn;
    btClose: TBitBtn;
    btRemove: TSpeedButton;
    btAdd: TSpeedButton;
    pnColors: TPanel;
    ColorDialog1: TColorDialog;
    Image1: TImage;
    Label1: TLabel;
    Image2: TImage;
    Label2: TLabel;
    Image3: TImage;
    Label3: TLabel;
    Image4: TImage;
    Label4: TLabel;
    Image5: TImage;
    Label5: TLabel;
    Image6: TImage;
    Label6: TLabel;
    Image7: TImage;
    Label7: TLabel;
    Image8: TImage;
    Label8: TLabel;
    sbFirst: TSpeedButton;
    sbPrev: TSpeedButton;
    sbNext: TSpeedButton;
    sbLast: TSpeedButton;
    imGlobal: TImage;
    pmDestColor: TPopupMenu;
    EqualPrevious1: TMenuItem;
    EqualNext1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    pmOrig: TPopupMenu;
    Insert1: TMenuItem;
    Delete1: TMenuItem;
    RandomizeAll1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    cbDistrib: TComboBox;
    Label13: TLabel;
    Label9: TLabel;
    cbApplication: TComboBox;
    Label10: TLabel;
    cbMethod: TComboBox;
    btNew: TBitBtn;
    pnLast: TPanel;
    Label11: TLabel;
    pnFileName: TPanel;
    EqualAllprevious1: TMenuItem;
    EqualallNext1: TMenuItem;
    btApply: TBitBtn;
    Label12: TLabel;
    Bevel1: TBevel;
    procedure btCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EqualPrevious1Click(Sender: TObject);
    procedure EqualNext1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure sbFirstClick(Sender: TObject);
    procedure sbPrevClick(Sender: TObject);
    procedure sbNextClick(Sender: TObject);
    procedure sbLastClick(Sender: TObject);
    procedure btRemoveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RandomizeAll1Click(Sender: TObject);
    procedure cdDistribClick(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
    procedure btSaveAsClick(Sender: TObject);
    procedure cbAllExit(Sender: TObject);
    procedure cbApplicationClick(Sender: TObject);
    procedure cbMethodClick(Sender: TObject);
    procedure btNewClick(Sender: TObject);
    procedure EqualAllprevious1Click(Sender: TObject);
    procedure EqualallNext1Click(Sender: TObject);
    procedure CommonPanelDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure CommonPanelEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure CommonPanelStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure btApplyClick(Sender: TObject);
    procedure btImportClick(Sender: TObject);
    procedure CommonImageDrag(Sender: TObject;
      var DragObject: TDragObject);
  private
    ColorDrag: integer;
    function FromNameToNumColor(AComponentName: string): integer;
    function FromNumColorToColor(ANumColor: integer): TColor;
    procedure MostraGradiente(AImage: TImage; NumCol: integer);
    procedure MostraSpettro(AImage: TImage);
    procedure UpdateColors;
    procedure UpdateMainForm;
  public
    Colors: TColorize;
    procedure LoadColorsFromFile( AFileName: string );
    procedure ImportMapFromFile( AFileName: string );
  end;

var
  FrEditColors: TFrEditColors;

implementation

uses
  Main;

{$R *.DFM}

procedure TFrEditColors.btCloseClick(Sender: TObject);
  begin
  Close;
  end;

procedure TFrEditColors.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
  Action := caFree;
  end;

procedure TFrEditColors.UpdateColors;
  var
    fc, nc, k: integer;
    n: string;
    l : TLabel;
    p : TPanel;
    i : TImage;
  begin
  fc := strtointdef( label1.Caption, 1 );
  if fc = 1 then
    begin
    sbFirst.Enabled := false;
    sbPrev.Enabled := false;
    end
  else
    begin
    sbFirst.Enabled := true;
    sbPrev.Enabled := true;
    end;
   
  if fc > colors.ColorsNumber - 8 then
    begin
    sbLast.Enabled := false;
    sbNext.Enabled := false;
    end
  else
    begin
    sbLast.Enabled := true;
    sbNext.Enabled := true;
    end;

  for k := 1 to 8 do
    begin
    n := 'Label' + IntToStr( k );
    nc := fc + k - 1;
    l := ( FindComponent( n ) as TLabel );
    i := ( FindComponent( 'Image' + IntToStr( k ) ) as TImage );
    if nc > colors.ColorsNumber  then
      begin
      l.visible := false;
      i.visible := false;
      end
    else
      begin
      l.visible := true;
      l.Caption := IntToStr( nc );
      i.visible := true;
      MostraGradiente( i , fc + k - 2 );
      end;
    end;

  for k := 1 to 16 do
    begin
    n := 'Panel' + IntToStr( k );
    nc := FromNameToNumColor( n );
    p := ( FindComponent( n ) as TPanel );
    if nc >= colors.ColorsNumber * 2 then
      p.visible := false
    else
      begin
      p.visible := true;
      p.Color := FromNumColorToColor( nc );
      end;
    end;
  pnLast.Color := Colors.LastColor;

  MostraSpettro( imGlobal );
  end;

procedure TFrEditColors.EqualPrevious1Click(Sender: TObject);
  var
    i: integer;
  begin
  i := FromNameToNumColor( pmDestColor.PopupComponent.Name );
  i := ( i - 1 ) div 2;
  colors.DestColors[ i ] := colors.OrigColors[ i ];
  UpdateColors;
  end;

function TFrEditColors.FromNameToNumColor( AComponentName: string ): integer;
  begin // color orig are even, color dest are odds, return -1 if wrong name
  if AComponentName = 'pnLast' then
    Result := -1
  else if ( Copy( AComponentName, 1, 5 ) = 'Panel' ) and ( FindComponent( AComponentName ) is TPanel ) then
    begin
    Result := strtointdef( Copy( AComponentName, 6, 2 ), 1 );
    if Result <= 8 then
      Result := ( Result + strtointdef( Label1.Caption, 1 ) - 2 ) * 2
    else
      Result := ( Result - 10  + strtointdef( Label1.Caption, 1 ) ) * 2 + 1;
    end
  else
    Result := -2;
  end;


function TFrEditColors.FromNumColorToColor( ANumColor: integer ): TColor;
  begin
  if ANumColor mod 2 = 0 then
    Result := colors.OrigColors[ ANumColor div 2 ]
  else
    Result := colors.DestColors[ ( ANumColor - 1) div 2 ];
  end;
  
procedure TFrEditColors.EqualNext1Click(Sender: TObject);
  var
    i: integer;
  begin
  i := FromNameToNumColor( pmDestColor.PopupComponent.Name );
  i := ( i + 1 ) div 2;
  if i < colors.ColorsNumber then 
    colors.DestColors[ i - 1 ] := colors.OrigColors[ i ]
  else
    colors.DestColors[ i - 1 ] := colors.OrigColors[ 0 ];
  UpdateColors;
  end;


procedure TFrEditColors.FormCreate(Sender: TObject);
  var
    i: integer;
  begin
  Caption := CAPT;
  pnFileName.Caption := '( New )';
  Colors := TColorize.Create( 100 );
  Colors.DefaultPath := ColorsPath;
  btApply.Enabled := false;
  ColorDrag := -1;
  cbDistrib.ItemIndex := 0;
  cbApplication.ItemIndex := 0;
  cbMethod.ItemIndex := 0;
  UpdateColors;
  for i := 0 to componentcount - 1 do
    if ( components[ i ] is TControl ) and ( TFakeControl( Components[ i ] ).DragMode = dmAutomatic ) then
      begin
      TFakeControl( Components[ i ] ).cursor := crDragBegin;
      TFakeControl( Components[ i ] ).dragcursor := crDragEnd;
      end;
    
  end;

procedure TFrEditColors.btAddClick(Sender: TObject);
  begin
  colors.AddColor( clBlack, clBlack );
  UpdateColors;
  sbLast.Click;
  end;

procedure TFrEditColors.sbFirstClick(Sender: TObject);
  begin
  label1.Caption := '1';
  UpdateColors;
  end;

procedure TFrEditColors.sbPrevClick(Sender: TObject);
  begin
  label1.Caption := IntToStr( strtointdef( label1.Caption, 2 ) - 1 );
  UpdateColors;
  end;

procedure TFrEditColors.sbNextClick(Sender: TObject);
  begin
  label1.Caption := IntToStr( strtointdef( label1.Caption, 0 ) + 1 );
  UpdateColors;
  end;

procedure TFrEditColors.sbLastClick(Sender: TObject);
  begin
  if Colors.ColorsNumber > 7 then
    label1.Caption := IntToStr( Colors.ColorsNumber - 7 )
  else
    label1.Caption := '1';
  UpdateColors;
  end;

procedure TFrEditColors.btRemoveClick(Sender: TObject);
  begin
  Colors.RemoveColor( Colors.ColorsNumber - 1 );
  UpdateColors;
  sbLast.Click;
  end;

procedure TFrEditColors.MostraGradiente( AImage: TImage; NumCol: integer );
	var
		iternorm : extended;
		x, y : integer;
		Bmp : TBitmap;
		MCol, SCol, ECol : TRGBTriple;

  begin
	SCol := ColToRGBTriple( Colors.OrigColors[ NumCol ] );
	ECol := ColToRGBTriple( Colors.DestColors[ NumCol ] );

	Bmp :=  AImage.Picture.Bitmap;
	Bmp.Width := AImage.Width;
	Bmp.Height := AImage.Height;
	Bmp.PixelFormat := pf24bit;
	for x := 0 to bmp.Width - 1 do
		begin
		iternorm := x / ( bmp.Width - 1 );

  case colors.OrdMethod of
    cmRGB:
      MCol := FindGradientColorRGB( SCol, ECol, iternorm );
    cmHSV:
      MCol := FindGradientColorHSV( SCol, ECol, iternorm );
    else
      MCol := FindGradientColorHSL( SCol, ECol, iternorm );
    end;

 		SwitchRB( MCol );

		for y := 0 to bmp.Height - 1 do
			PRGBArray( Bmp.ScanLine[ y ] )[x] := MCol;
		end;
  AImage.invalidate;
  end;
  

procedure TFrEditColors.FormDestroy(Sender: TObject);
  begin
  colors.Free;
  end;

procedure TFrEditColors.MostraSpettro(AImage: TImage);
	var
		x, y : integer;
		Bmp : TBitmap;
		MCol : TRGBTriple;
    sl : PRGBArray;
    n: Extended;
  begin
	Bmp :=  AImage.Picture.Bitmap;
	Bmp.Width := AImage.Width;
	Bmp.Height := AImage.Height;
	Bmp.PixelFormat := pf24bit;
  n := 100 / bmp.Height;
	for y := 0 to bmp.Height - 1 do
		begin
		MCol := Colors.FromIterToColor( ( y + 1 ) * n );
		SwitchRB( MCol );
    sl := PRGBArray( Bmp.ScanLine[ y ] );
		for x := 0 to bmp.Width - 1 do
			sl[x] := MCol;
		end;
  AImage.invalidate;
  end;

procedure TFrEditColors.RandomizeAll1Click(Sender: TObject);
  var 
    k: integer;
  begin
  Randomize;
  with Colors do
    begin
    for k := 0 to ColorsNumber - 1 do
      begin
      OrigColors[ k ] := Random( 256 * 256 * 256 );
      DestColors[ k ] := Random( 256 * 256 * 256 );
      end;
    LastColor := Random( 256 * 256 * 256 );
    end;
  UpdateColors;
  end;

procedure TFrEditColors.cdDistribClick(Sender: TObject);
  begin
  Colors.Distribution := cbDistrib.Text;
  UpdateColors;
  end;

procedure TFrEditColors.btOpenClick(Sender: TObject);
  begin
  sbFirst.Click;
  with OpenDialog1 do
    begin
    Filter := '*.mnc|*.mnc';
    InitialDir := ColorsPath;
    FileName := '';
    if Execute then
      begin
      LoadColorsFromFile( FileName );
      UpDateMainForm;
      end;
    end;
  end;

procedure TFrEditColors.LoadColorsFromFile( AFileName: string );
  begin
  if Colors.LoadFromFile( AFileName, true ) then
    begin
    cbDistrib.ItemIndex := cbDistrib.Items.IndexOf( Colors.distribution );
    cbApplication.ItemIndex := cbApplication.Items.IndexOf( Colors.ApplyTo );
    cbMethod.ItemIndex := cbMethod.Items.IndexOf( Colors.Method );
    UpdateColors;
    pnFileName.Caption := ChangeFileExt( ExtractFileName( AFileName ), '' );
    btApply.Enabled := ( FileGetAttr( AFileName ) and ( faReadOnly	or faHidden	or faSysFile ) = 0 );
    end;
  end;  
  
procedure TFrEditColors.btSaveAsClick(Sender: TObject);
  begin
  with SaveDialog1 do
    begin
    Filter := '*.mnc|*.mnc';
    DefaultExt := 'mnc';
    InitialDir := ColorsPath;
    FileName := pnFileName.Caption;
    if Execute then
      begin
      Colors.SaveToFile( FileName, false ); // there's a message
      pnFileName.Caption := ExtractFileName( ChangeFileExt( FileName, '' ) );
      btApply.Enabled := true;
      end;
    end;
  end;


procedure TFrEditColors.cbAllExit(Sender: TObject);
  var
    i: integer;
  begin
  if Sender is TComboBox then
    with TComboBox( Sender ) do
      begin
      i := Items.IndexOf( Text );
      i := Max( i, 0 ); // if not present choose the first
      ItemIndex := i;
      end;
  end;

procedure TFrEditColors.cbApplicationClick(Sender: TObject);
  begin
  Colors.ApplyTo := cbApplication.Text;
  UpdateColors;
  end;

procedure TFrEditColors.cbMethodClick(Sender: TObject);
  begin
  Colors.Method := cbMethod.Text;
  UpdateColors;
  end;

procedure TFrEditColors.btNewClick(Sender: TObject);
  begin
  sbFirst.Click;
  Colors.Free;
  FormCreate( self );
  end;

procedure TFrEditColors.EqualAllprevious1Click(Sender: TObject);
  var
    i: integer;
  begin
  for i := 0 to Colors.ColorsNumber - 1 do
    colors.DestColors[ i ] := colors.OrigColors[ i ];
  UpdateColors;
  end;

procedure TFrEditColors.EqualallNext1Click(Sender: TObject);
  var
    i: integer;
  begin
  for i := 0 to Colors.ColorsNumber - 2 do
    colors.DestColors[ i ] := colors.OrigColors[ i + 1 ];
  colors.DestColors[ Colors.ColorsNumber - 1 ] := colors.OrigColors[ 0 ];
  UpdateColors;
  end;

procedure TFrEditColors.CommonPanelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
  begin
  Accept := ( ColorDrag >= 0 );
  end;

procedure TFrEditColors.CommonPanelEndDrag(Sender, Target: TObject; X, Y: Integer);
  var
    i: integer;
  begin
  if ( Target = Sender ) and ( Target is TPanel ) then
    begin
    ColorDrag := -1;
    i := FromNameToNumColor( TPanel( Sender ).Name );
    if i = -1 then
      ColorDialog1.Color := Colors.LastColor
    else if i mod 2 = 0 then
      ColorDialog1.Color := colors.OrigColors[ i div 2 ]
    else
      ColorDialog1.Color := colors.DestColors[ i div 2 ];

    if ColorDialog1.Execute then
      begin
      if i = -1 then
        Colors.LastColor := ColorDialog1.Color
      else if i mod 2 = 0 then
        colors.OrigColors[ i div 2 ] := ColorDialog1.Color
      else
        colors.DestColors[ i div 2 ] := ColorDialog1.Color;
      UpdateColors;
      end;
    end
  else if ( ColorDrag >= 0 ) and ( Target is TPanel ) then
    begin
    i := FromNameToNumColor( TPanel( Target ).Name );
    if i = -1 then
      Colors.LastColor := ColorDrag
    else if i mod 2 = 0 then
      colors.OrigColors[ i div 2 ] := ColorDrag
    else
      colors.DestColors[ i div 2 ] := ColorDrag;
    ColorDrag := -1;
    UpdateColors;
    end;
  end;

procedure TFrEditColors.CommonPanelStartDrag(Sender: TObject; var DragObject: TDragObject);
  var
    i: integer;
  begin
  if Sender is TPanel then
    begin
    i := FromNameToNumColor( TPanel( Sender ).Name );
    if i = -1 then
      ColorDrag := Colors.LastColor
    else if i mod 2 = 0 then
      ColorDrag := colors.OrigColors[ i div 2 ]
    else
      ColorDrag := colors.DestColors[ i div 2 ];
    end;
  end;

procedure TFrEditColors.btApplyClick(Sender: TObject);
  begin
  Colors.SaveToFile( pnFileName.Caption, false ); // save a new copy
  UpDateMainForm;
  end;

procedure TFrEditColors.UpdateMainForm;
  begin
  with MainForm do
    begin
    LoadcbColors;
    cbColors.ItemIndex := cbColors.Items.IndexOf( pnFileName.Caption );
    cbColorsChange( cbColors );
    end;
  end;

procedure TFrEditColors.btImportClick(Sender: TObject);
  begin
  sbFirst.Click;
  with OpenDialog1 do
    begin
    Filter := '*.map|*.map';
    InitialDir := ColorsPath;
    FileName := '';
    if Execute then
      try
        Screen.Cursor := crHourGlass;
        ImportMapFromFile( FileName );
      finally
        Screen.Cursor := crDefault;
      end;
    end;
  end;

procedure TFrEditColors.ImportMapFromFile(AFileName: string);
  begin
  if Colors.ImportMap( AFileName, true ) then
    begin
    cbDistrib.ItemIndex := cbDistrib.Items.IndexOf( Colors.distribution );
    cbApplication.ItemIndex := cbApplication.Items.IndexOf( Colors.ApplyTo );
    cbMethod.ItemIndex := cbMethod.Items.IndexOf( Colors.Method );
    UpdateColors;
    pnFileName.Caption := ChangeFileExt( ExtractFileName( AFileName ), '' );
    btApply.Enabled := true;
    end;
  end;

procedure TFrEditColors.CommonImageDrag(Sender: TObject; var DragObject: TDragObject);
  var
    p: tpoint;
  begin
  if Sender is TImage then
    begin
    GetCursorPos( p );
    p := TImage( Sender ).ScreenToClient( p );
    ColorDrag := TImage( Sender ).Canvas.Pixels[ p.x, p.y ];
    end;
  end;

end.
