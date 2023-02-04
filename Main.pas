unit Main;

interface

uses
	Windows, SysUtils, Messages, Classes, Graphics, Controls,
	Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, Inifiles, Printers,
  ExtDlgs, ComCtrls, Grids, Mandelbrot, Colors;

const
	CVersion='2.8.2';
	CProductName='Fractal Forge';
	crLenPlus=1;
	crLenMinus=2;
	crLen=3;
  crDragBegin=4;
  crDragEnd=5;
  ININAME='FractalForge.ini';
  HELPNAME ='FractalForge.chm';
  WM_STARTMANDEL = WM_APP + 101;
  LAST_MANDELBASE = 1000;
  ALGO_MP = 'BoundsMP';

type
	TMainForm = class(TForm)
		SaveDialog1: TSaveDialog;
		MainMenu1: TMainMenu;
		File1: TMenuItem;
		Open1: TMenuItem;
		Save1: TMenuItem;
		N1: TMenuItem;
		Exit1: TMenuItem;
		Fractal1: TMenuItem;
		Start1: TMenuItem;
		Pause1: TMenuItem;
		Help1: TMenuItem;
		About1: TMenuItem;
		SaveImage1: TMenuItem;
		N2: TMenuItem;
		Options1: TMenuItem;
		TestSpeed1: TMenuItem;
		Restoreoldvalues1: TMenuItem;
		N3: TMenuItem;
		N4: TMenuItem;
		DefaultValues1: TMenuItem;
		OpenDialog1: TOpenDialog;
		SaveList1: TMenuItem;
		AddList1: TMenuItem;
		SelectStartingFractal1: TMenuItem;
		Summary1: TMenuItem;
		N7: TMenuItem;
		Savefilein83format1: TMenuItem;
		Edit1: TMenuItem;
		CopyImage1: TMenuItem;
		CopyValues1: TMenuItem;
		UndoFractal1: TMenuItem;
		N8: TMenuItem;
		N9: TMenuItem;
		Print1: TMenuItem;
		PrinterSetupDialog1: TPrinterSetupDialog;
		PrinterSetup1: TMenuItem;
		EditColors1: TMenuItem;
		pnParam: TPanel;
		pnCommand: TPanel;
		pcParameters: TPageControl;
		tsHistory: TTabSheet;
    tsData: TTabSheet;
		sbStart: TSpeedButton;
    sbZoomIn: TSpeedButton;
    sbPause: TSpeedButton;
    sbZoomOut: TSpeedButton;
    sbZoom: TSpeedButton;
    sbSave: TSpeedButton;
    sbOpenDoc: TSpeedButton;
    sbSaveDoc: TSpeedButton;
    ScrollBox1: TScrollBox;
    Image1: TImage;
		Shape1: TShape;
    SquareSE: TShape;
    SquareNO: TShape;
    SquareNE: TShape;
    SquareSO: TShape;
    pnInfo: TPanel;
		Percent: TProgressBar;
    Label1: TLabel;
		Label2: TLabel;
		Label3: TLabel;
    Bevel2: TBevel;
    State: TPanel;
    Crono: TPanel;
    stReal: TStaticText;
    stImag: TStaticText;
    stIter: TStaticText;
    Label4: TLabel;
		Label5: TLabel;
    Label6: TLabel;
    stR: TStaticText;
    stG: TStaticText;
    stB: TStaticText;
    edComment: TMemo;
    sgHistory: TStringGrid;
    pnTopList: TPanel;
    cbHistory: TComboBox;
    btPrev: TSpeedButton;
    btDel: TSpeedButton;
    btRestore: TSpeedButton;
    btDefault: TSpeedButton;
		pnTopData: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
		Label10: TLabel;
    Label12: TLabel;
		Label19: TLabel;
    Label17: TLabel;
    Label15: TLabel;
    Label13: TLabel;
    Label11: TLabel;
    Comments: TLabel;
		edRPoC: TEdit;
    edIPoC: TEdit;
    edMagnit: TEdit;
    edIter: TEdit;
		edName: TEdit;
    cbJulia: TCheckBox;
    btDelta: TSpeedButton;
    cbFormula: TComboBox;
    cbApply: TComboBox;
    edImagPerturbation: TEdit;
    edRealPerturbation: TEdit;
    edBailout: TEdit;
		ShowcontrolPanel1: TMenuItem;
    PopupImage: TPopupMenu;
    Showorbits1: TMenuItem;
    ShowRectangles1: TMenuItem;
    CenterHere1: TMenuItem;
    N6: TMenuItem;
    ZoomIn2: TMenuItem;
    ZoomOut2: TMenuItem;
    ZoomRect1: TMenuItem;
    Zoom21: TMenuItem;
    ZoomOutNow1: TMenuItem;
    tsSize: TTabSheet;
    pnClientColor: TPanel;
    Label14: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    edWidth: TEdit;
    edHeight: TEdit;
    edAspectR: TEdit;
    lbFormats: TListBox;
    SavetoDesktop1: TMenuItem;
    N10: TMenuItem;
    Colors1: TMenuItem;
    mmimage2: TMenuItem;
    N11: TMenuItem;
    Area1: TMenuItem;
    Filter1: TMenuItem;
    Edge1: TMenuItem;
    Bumper1: TMenuItem;
    Heights1: TMenuItem;
    Noise1: TMenuItem;
    None1: TMenuItem;
    Lines1: TMenuItem;
    Crystals1: TMenuItem;
    Equalizecolors1: TMenuItem;
    FullScreenMode1: TMenuItem;
    ShowJulia1: TMenuItem;
    Tools1: TMenuItem;
    Animator1: TMenuItem;
    SuperPoster2: TMenuItem;
    CopyCoordinates1: TMenuItem;
    Colorbumper1: TMenuItem;
    Sharpenedges1: TMenuItem;
    New1: TMenuItem;
    N5: TMenuItem;
    JuliaHere1: TMenuItem;
    Average1: TMenuItem;
    tsColors: TTabSheet;
    Label20: TLabel;
    cbAlgo: TComboBox;
    Label22: TLabel;
    ttOffset: TTrackBar;
    btRew: TSpeedButton;
    btStop: TSpeedButton;
    btFFor: TSpeedButton;
    Label21: TLabel;
    cbColors: TComboBox;
    cbPreview: TCheckBox;
    btEditColors: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure Start1Click(Sender: TObject);
    procedure Pause1Click(Sender: TObject);
		procedure TestSpeed1Click(Sender: TObject);
		procedure SaveImage1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
		procedure Save1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
		procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
		procedure ZoomWindow1Click(Sender: TObject);
    procedure ZoomIn1Click(Sender: TObject);
    procedure ZoomOut1Click(Sender: TObject);
    procedure DefaultValues1Click(Sender: TObject);
    procedure Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Restoreoldvalues1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
		procedure SaveList1Click(Sender: TObject);
    procedure AddList1Click(Sender: TObject);
		procedure SelectStartingFractal1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Summary1Click(Sender: TObject);
		procedure Savefilein83format1Click(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure UndoFractal1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
		procedure CopyImage1Click(Sender: TObject);
    procedure CopyValues1Click(Sender: TObject);
    procedure PrinterSetup1Click(Sender: TObject);
		procedure SquareSOMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SquareSOMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SquareSOMouseUp(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
    procedure SquareNEMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
		procedure SquareNOMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SquareSEMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SquareSEMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SquareNOMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
		procedure SquareNEMouseUp(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
		procedure SquareNEMouseDown(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
		procedure SquareNOMouseDown(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
		procedure SquareSEMouseDown(Sender: TObject; Button: TMouseButton;
			Shift: TShiftState; X, Y: Integer);
		procedure EditColors1Click(Sender: TObject);
		procedure sbStartClick(Sender: TObject);
		procedure sbPauseClick(Sender: TObject);
		procedure sbZoomInClick(Sender: TObject);
		procedure sbZoomOutClick(Sender: TObject);
		procedure sbZoomClick(Sender: TObject);
		procedure ControlPanel1Click(Sender: TObject);
		procedure ScrollBox1Resize(Sender: TObject);
    procedure btRestoreClick(Sender: TObject);
    procedure edWidthChange(Sender: TObject);
    procedure lbFormatsClick(Sender: TObject);
		procedure btDefaultClick(Sender: TObject);
    procedure edHeightChange(Sender: TObject);
    procedure edAspectRChange(Sender: TObject);
		procedure edIterChange(Sender: TObject);
    procedure cbJuliaClick(Sender: TObject);
    procedure cbHistoryChange(Sender: TObject);
		procedure btDelClick(Sender: TObject);
    procedure btDeltaClick(Sender: TObject);
    procedure cbColorsChange(Sender: TObject);
    procedure Showorbits1Click(Sender: TObject);
    procedure ShowRectangles1Click(Sender: TObject);
    procedure btEditColorsClick(Sender: TObject);
    procedure Center(Sender: TObject);
    procedure ZoomIn2Click(Sender: TObject);
    procedure Zoom21Click(Sender: TObject);
    procedure ZoomOut2Click(Sender: TObject);
    procedure ZoomRect1Click(Sender: TObject);
    procedure ZoomOutNow1Click(Sender: TObject);
    procedure cbPreviewClick(Sender: TObject);
    procedure btRewClick(Sender: TObject);
    procedure btFForClick(Sender: TObject);
    procedure SavetoDesktop1Click(Sender: TObject);
    procedure Colors1Click(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btPrevClick(Sender: TObject);
    procedure Area1Click(Sender: TObject);
    procedure Edge1Click(Sender: TObject);
    procedure Bumper1Click(Sender: TObject);
    procedure Heights1Click(Sender: TObject);
    procedure Noise1Click(Sender: TObject);
    procedure None1Click(Sender: TObject);
    procedure Lines1Click(Sender: TObject);
    procedure Crystals1Click(Sender: TObject);
    procedure Equalizecolors1Click(Sender: TObject);
    procedure ttOffsetChange(Sender: TObject);
    procedure FullScreen1Click(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure ShowJulia1Click(Sender: TObject);
    procedure SuperPoster2Click(Sender: TObject);
    procedure Animator1Click(Sender: TObject);
    procedure CopyCoordinates1Click(Sender: TObject);
    procedure Colorbumper1Click(Sender: TObject);
    procedure Sharpenedges1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure cbFormulaClick(Sender: TObject);
    procedure cbApplyClick(Sender: TObject);
    procedure cbAlgoClick(Sender: TObject);
    procedure JuliaHere1Click(Sender: TObject);
    procedure PopupImagePopup(Sender: TObject);
    procedure Average1Click(Sender: TObject);
	private
    FFSMRect: Trect; // used for Full Screen Mode
		XV,YV : integer;
		oldcol : string;
		UserChangedW : Boolean; //used for custom image size
		UserChangedH : Boolean;
		UserChangedA : Boolean;
    AviPath: string;
    NAvi: Cardinal;
    procedure DoEvents( Sender: TObject; var Continue: boolean; Progress: Extended = -1 );
    procedure ColorPreview;
    procedure UpdateHistory;
    procedure WMDropFiles(var Msg: TWMDROPFILES); message WM_DROPFILES;
    procedure WMStartMandel(var Msg: TWMDROPFILES); message WM_STARTMANDEL;
    function LoadFile(FileName: string): boolean;
    procedure ShowHideMenu;
    procedure UpdateMandelState( MandState: TMandelState );
    function GetDataAsText(MouseCoords: Boolean): string;
    procedure SavePng(AFileName: string);
		procedure MandelSetToRUParameters;
		procedure UpdateMandelSet;
    procedure DrawLoadedFile;
    procedure SaveJpg(AFileName: string);
    procedure CreateAviFromDir(DirName, AviName: string; Fps: integer; DelFiles, PlayAvi: Boolean);
    procedure AviCreating(Sender: TObject; Percent: integer;
      var Continue: Boolean);
    procedure AviSaving(Sender: TObject; Percent: integer;
      var Continue: Boolean);
    procedure PrepareCaption(percent: integer = -1; Info: string = '');
    procedure ZoomInCursor;
    procedure ShapeInImage;
    function GAverage(Num1, Num2: Extended; Step,
      Steps: integer): Extended;
    procedure ColorCycling;
    function MultiCpu: Boolean;
    procedure MultiCpuAlert;
    procedure SaveMndFile(const FileName: string);
	public
		 { Public declarations }
		MandelBase: array [0 .. LAST_MANDELBASE] of TMandelPtr;
    Colors: TColorize;
    Mandelb: TMandelbrot;
		NImages : integer;
		MandelSet : TMandelSet;
		IniFile : TIniFile;
    procedure LoadcbColors;
		procedure NewMandelSet;
		procedure FormStart;
    procedure StartMandel( FromButton: boolean; DefaultName: boolean = true );
		procedure BitmapResize( Wi, He: integer; ABitmap: TBitmap );
	end;

function MandStateToStr( MandState: TmandelState ): string;
function MsecToStr( Milli: cardinal ): string;

var
  MainForm: TMainForm;
  KindCol : string;
  NColors : Cardinal;
  CrnStart : Cardinal;
  ColorsPath: string = '';
  ImagesPath: string = '';

implementation

uses
  Orbits, Rectangles, TiledImage, PngImage, RegisterExt, Julia, Jpeg,
  Animator, AviWriter, 	Clipbrd, About, DeltaCoo, ShellApi, ShellExt,
	Complex, Graphic, ColorEdit, Files, Math;

{$R *.DFM}
{$R lens.res}
{$R DRAG.RES}

function GetProdName: string;
  begin
  result := CProductName + ' ' + CVersion;
  end;

procedure TMainForm.PrepareCaption( percent: integer = -1; Info: string = '' );
  begin
 	Caption := GetProdName;
  if edName.Text <> '' then
    Caption := Caption + ' - ' + edName.Text;
  if percent > -1 then
    Caption := Caption + '   (' + Info + ' ' + inttostr( percent ) + '% )';

  Application.Title := Caption;
  end;

procedure TMainForm.FormCreate(Sender: TObject);
  var
    k: integer;
    iniCompleteName: string;
	begin
  ScrollBox1.ControlStyle := ScrollBox1.ControlStyle + [csOpaque]; //for flickering

  Application.UpdateFormatSettings := False;
	DecimalSeparator :='.';
  ThousandSeparator := ',';

	Screen.Cursors[crLenPlus] := LoadCursor( HInstance, 'LEN_PLUS' );
	Screen.Cursors[crLenMinus] := LoadCursor( HInstance, 'LEN_MINUS' );
	Screen.Cursors[crLen] := LoadCursor( HInstance, 'LEN' );
	Screen.Cursors[crDragBegin] := LoadCursor( HInstance, 'BEGINDRAG' );
	Screen.Cursors[crDragEnd] := LoadCursor( HInstance, 'ENDDRAG' );

  Application.HelpFile := HELPNAME;

	NImages := 0;
  NAvi := 0;
  AviPath := ImagesPath;
	ScrollBox1.Top := 0;
	ScrollBox1.Left := 0;
	Image1.Top := 0;
	Image1.Left := 0;
  PrepareCaption;
	Percent.Position := 0;
	Crono.Caption := msectoStr( 0 );
	XV:=-1;
	YV:=-1;

  for k := 3 to PopupImage.Items.Count - 1 do // skip First 3
    begin
    mmimage2.Add( TMenuItem.Create( mmimage2.owner ) );
    mmimage2.Items[ k - 3 ].Caption := PopupImage.Items[ k ].Caption;
    mmimage2.Items[ k - 3 ].OnClick := PopupImage.Items[ k ].OnClick;
    end;
	Shape1.Visible := False;
	SquareNO.Visible := False;
	SquareNE.Visible := False;
	SquareSO.Visible := False;
	SquareSE.Visible := False;
  None1.Checked := true;
  pcParameters.ActivePage := tsData;


  iniCompleteName := ExtractFilePath( Application.exename ) + ININAME;
  IniFile := TIniFile.Create( iniCompleteName );

	with sgHistory do
		begin
    RowCount := 22;
		ColWidths[0]:=60;
		ColWidths[1]:= ClientWidth - ColWidths[0] - 2;
		cells[0, 0]:='Version';
		cells[0, 1]:='Name';
		cells[0, 2]:='Center R.';
		cells[0, 3]:='Center I.';
		cells[0, 4]:='Magnific.';
		cells[0, 5]:='Drawing';
		cells[0, 6]:='Iterations';
		cells[0, 7]:='Width';
		cells[0, 8]:='Height';
		cells[0, 9]:='Aspect';
		cells[0,10]:='Priority';
		cells[0,11]:='Julia';
		cells[0,12]:='Colors';
		cells[0,13]:='Bailout';
		cells[0,14]:='Pert R.';
		cells[0,15]:='Pert I.';
		cells[0,16]:='Coloring';
		cells[0,17]:='Formula';
		cells[0,18]:='Comments';
		cells[0,19]:='Time';
		cells[0,20]:='Crono';
		cells[0,21]:='State';
		end;

	UserChangedH:=true;
	UserChangedW:=true;
	UserChangedA:=true;
	lbFormats.ItemIndex:= 0;

  with cbHistory do
    begin
	  Items.Add('Default');
	  ItemIndex:=0;
    end;

  with cbFormula do
    begin
    Items.Add('Z<-Z^2+C(Normal)');
    Items.Add('Z<-Z^3+C');
    Items.Add('Z<-Z^4+C');
    Items.Add('Z<-Z^8+C');
    Items.Add('Z<-Z^2+C^2');
    Items.Add('Z<-Z^3+C^2');
    Items.Add('Z<-Z^Z+C');
    Items.Add('Z<-Z^2+Z+C');
    Items.Add('Z<-Z^C');
    Items.Add('Z<-Z*C*(1-Z)');
    Items.Add('Z<-sin(Z)+C');
    Items.Add('Z<-C*(s(Z+t(Z)))');
    Items.Add('Spider');
    Items.Add('Magnetism');
    Items.Add('DoubleTail');
    ItemIndex:=0;
    end;

  with cbApply do
    begin
    Items.Add('Iterations');
    Items.Add('Potential');
    Items.Add('Biomorph');
    Items.Add('Radiant');
    Items.Add('Radiant+Iter');
    Items.Add('Real^2');
    Items.Add('Imaginary^2');
    Items.Add('R.^2+I.^2 (mod)');
    Items.Add('Iterations*mod');
    Items.Add('Iterations+mod');
    Items.Add('Internal mod');
    Items.Add('Internal radiant');
    ItemIndex:=0;
    end;

  with cbAlgo do
    begin
    Items.Add( 'Bounds' );
    Items.Add( ALGO_MP );
    Items.Add( 'Plain' );
    Items.Add( 'Interpolate256' );
    Items.Add( 'Interpolate8' );
    Items.Add( 'Interpolate2' );
    Items.Add( 'Draft' );
    Items.Add( 'Orbits' );
    ItemIndex:=0;
    end;

  Ncolors := 100;
  Colors := TColorize.Create( NColors );
  Colors.DefaultPath := ColorsPath;
  Mandelb := TMandelbrot.Create( Image1.Picture.Bitmap, GetProdName );
  Mandelb.OnProgress := DoEvents;
  Mandelb.ProgressTimer := 500;
  LoadcbColors;
	stReal.Caption := '';
	stImag.Caption := '';
	stIter.Caption := '';
	stR.Caption := '';
	stG.Caption := '';
	stB.Caption := '';

  DragAcceptFiles( Handle, True);
  CreateShellExt;

  Mandelb.MandelSetDefault( MandelSet );
	new( MandelBase[0] );
	MandelBase[0]^ := MandelSet;
  MandelSetToRUParameters;

  if not DetectShellExt then
    CreateShellExt;
	end;

procedure TMainForm.MultiCpuAlert;
var
  s: string;
  Alerted: Boolean;
begin
  Alerted := Inifile.ReadBool( 'Alerts', 'MultiCPU', False );
  if MultiCpu and not Alerted then
    begin
    pcParameters.ActivePage := tsColors;
    cbAlgo.ItemIndex := cbAlgo.Items.IndexOf(ALGO_MP);
    cbAlgo.SetFocus;

    s := 'This is a multiprocessor system.';
    s := s + #13#10'To take advantage of other CPU you have to choose';
    s := s + #13#10 + ALGO_MP + ' in "Drawing algorithm" combo on Colors tab.';
    s := s + #13#10 + 'Do you want to see this alert again?';
    if MessageDlg(s, mtWarning, [mbYes, mbNo], 0) = mrNo then
      Inifile.WriteBool( 'Alerts', 'MultiCPU', True );
    end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
  var
    k :integer;
  begin
    try
    if BorderStyle = bsNone then
      SetBounds( 0,0,0,0 ); // to not leave taskbar "dirty"

    for k := 0 to LAST_MANDELBASE do
      Dispose( MandelBase[ k ] );
    Inifile.Free;
    Mandelb.Free;
    Colors.Free;
    except // terminate in every case
      on E: Exception do ShowMessage(E.Message);
    end;
  end;

procedure TMainForm.BitmapResize (Wi,He : integer; ABitmap : TBitmap);
	var
	k: integer;
	NewRect:TRect;

	begin
	k:=Wi;
	if k<10 then k:=10;
	if k>20000 then k:=20000;
	Abitmap.width:=k;
	K:=He;
	if k<10 then k:=10;
	if k>20000 then k:=20000;
	Abitmap.height:=k;
	NewRect := Rect(0,0,Abitmap.width ,Abitmap.height);
	Abitmap.Canvas.Brush.Color := clSilver; //clWhite;
	Abitmap.Canvas.FillRect(NewRect);
	ScrollBox1Resize(self);
	end;

procedure SetColor(KindCol : string; MaxIter: integer );
  begin
  with MainForm do
    begin
    Colors.MaxIter := MaxIter;
    if not Colors.LoadFromFile( KindCol, false ) then
      cbColors.ItemIndex := 0;
    if FrJulia.Visible then
      FrJulia.ResetColors( Colors.FileName );
    end;
  end;

procedure TMainForm.StartMandel( FromButton: boolean; DefaultName: boolean = true );

  procedure BeforeCalc;
    begin
    if defaultName then
      begin
      UpDateMandelSet; // save old mandelset
      NewMandelSet;
    	edComment.text:='';
      if MandelSet.FJulia then name:='Julia' else
        name:='Mand';
      edName.Text := Format( '%s%.4d', [name, NImages] );
      end;
    end;

  procedure BeginCalc;
    begin
    Mandelb.StoreFilter;
    Mandelb.Prepare( MandelSet, Colors );

  // update Orbits max value
    FrOrbits.MaxIterMain := Mandelb.Par.FIter;

  // a simple ScrollBox1.Refresh doesn't work
    ScrollBox1.Visible := False;
    ScrollBox1.Visible := True;

    BitmapResize( Mandelb.Par.FWidth, Mandelb.Par.FHeight, Image1.picture.bitmap );

    if not InitGraphic(Image1.Picture.Bitmap) then
      begin
      showMessage( 'It''s not possible initializiang image');
      exit;
      end;
    shape1.visible:=false;
    SquareNO.visible:=false;
    SquareNE.visible:=false;
    SquareSO.visible:=false;
    SquareSE.visible:=false;

    pcParameters.Enabled := false;
    sbStart.caption:='Stop';
    sbPause.enabled:=true;
    Start1.caption:='&Stop';
    percent.position:=0;
    UpdateMandelState(msRun); // show new mandelset
    end;

	procedure EndCalc;
		begin
		CloseGraphic;
    pcParameters.Enabled := true;
    MandelSet.FCrono := trim( Crono.Caption );
    MandelSet.FTime := DateTimeToStr(Now);
    sbStart.Caption:='Start';
    sbPause.Enabled:=false;
    Start1.Caption:='&Start';
    if Pause1.Caption<>'&Pause' then
      begin
      Pause1.Caption:='&Pause';
      sbPause.Caption:='Pause';
      end;
    if Mandelset.FState = msStopping then
      UpdateMandelState( msStopped )
    else
      UpdateMandelState( msDone );
  	Percent.Position:=0;
    PrepareCaption;
    Mandelb.RestoreFilter;
		end;

  begin
  if (MandelSet.FState = msRun) or (MandelSet.FState = msPause) then
    begin
    if not FromButton then
      begin
      MessageDlg('You must stop current fractal before!', mtWarning, [mbOk], 0);
      exit;
      end;
    UpdateMandelState( msStopping );
    exit;
    end;

  BeforeCalc;
	MandelSet.FAlgo := cbAlgo.Text;
	MandelSet.FIter := edIter.Text;
  ttOffset.Max := StrToIntDef( MandelSet.FIter, 99 ); // offset max is equal to iter max
  ttOffset.Frequency := ttOffset.Max div 10;

	edRPoC.Text:=trim(edRPoC.Text);
	edIPoC.Text:=trim(edIPoC.Text);
	MandelSet.FCentReal:=edRPoC.Text;
	MandelSet.FCentImag:=edIPoC.Text;

	edMagnit.Text:=trim(edMagnit.Text);
	MandelSet.FMagnitud:=edMagnit.Text;

	edWidth.Text:=trim(edWidth.Text);
	edHeight.Text:=trim(edHeight.Text);
	MandelSet.FWidth:=edWidth.Text;
	MandelSet.FHeight:=edHeight.Text;

	edBailout.Text:=trim(edBailout.Text);
	MandelSet.FBailout:=edBailout.Text;

	edRealPerturbation.Text:=trim(edRealPerturbation.Text);
	MandelSet.FRealPert:=edRealPerturbation.Text;

	edImagPerturbation.Text:=trim(edImagPerturbation.Text);
	MandelSet.FImagPert:=edImagPerturbation.Text;

	MandelSet.FPriority:='Medium';// obsolete

  edAspectR.Text:=trim(edAspectR.Text);
  MandelSet.FAspectR:=edAspectR.Text;
	MandelSet.FImageFile:='None';

  MandelSet.FApplyC := cbApply.Text;
  MandelSet.FAlgo   := cbAlgo.Text;
  MandelSet.FColors := cbColors.Text;
  MandelSet.FOffset := IntToStr( ttOffset.Position );

	MandelSet.FFormula:= cbFormula.Text;
	MandelSet.FJulia := cbJulia.Checked;
	MandelSet.FComments := edComment.Text;
	MandelSet.FVersion := CProductName + ' ' + CVersion;

  SetColor( MandelSet.FColors, 1 );

  BeginCalc;
    try
    Mandelb.Render;
    finally
    EndCalc;
    end;
  end;

procedure TMainForm.Start1Click(Sender: TObject);
  begin
  if (MandelSet.FState <> msRun) and (pcParameters.ActivePage = tsHistory) then
    Restoreoldvalues1Click( Sender )
  else
    StartMandel( True );
  end;

procedure TMainForm.Pause1Click(Sender: TObject);
  begin
  if sbPause.Enabled then
    begin
    if MandelSet.FState <> msPause then
      begin
      Pause1.Caption:='&Continue';
      sbPause.caption:='Continue';
      UpdateMandelState(msPause);
      end
    else
      begin
      Pause1.Caption:='&Pause';
      sbPause.caption:='Pause';
      UpdateMandelState(msRun);
      end;
    end;
  end;

procedure TMainForm.TestSpeed1Click(Sender: TObject);

  var
    tms, dkk: extended;
    abc :string;
    mand: TMandelbrot;
    MPar: TMandelSet;
    tick : Cardinal;

  begin
  if MessageDlg('Test will take 5 seconds',mtWarning,[mbOK,mbCancel],0)= mrCancel
    then exit;

  with mpar do
    begin
    FCentReal := '0';
    FCentImag := '0';
    FMagnitud := '1';
    FWidth := '100';
    FHeight := '100';
    FAspectR := '1';
    FJulia := false;
    FBailout := '4';
    FIter := '50000';
    FRealPert := '0';
    FImagPert := '0';
    end;

  Screen.Cursor := crHourglass;
  mand := TMandelbrot.Create( nil, GetProdName );
    try
    mand.Prepare( mpar, nil );
    finally
    mand.Free;
    end;
  tms:=0;
  tick := gettickcount;
  while tick + 5000 >= GetTickCount do
    tms := tms + mand.AlgMndFlt( 0.42566414285721, -0.34081257142841 );
  tick := GetTickCount - tick;
  Screen.Cursor := crDefault;
  dkk := 1000.0 * tms / tick ;
  abc := FloatToStrF( dkk, ffFixed, 2, 22 );
  abc := Format( 'Iterations for second: %n', [ dkk ] );
  MessageDlg( abc, mtInformation, [ mbOK ], 0 );
  end;

procedure TMainForm.Exit1Click(Sender: TObject);
  begin
  Close;
  end;

procedure TMainForm.Open1Click(Sender: TObject);
  begin
  if (MandelSet.FState = msRun) or (MandelSet.FState = msPause) then
    begin
    MessageDlg('You must stop current fractal before!', mtWarning, [mbOk], 0);
    exit;
    end;
  opendialog1.title:='Open a FractalForge File';
  opendialog1.InitialDir := ImagesPath;
  opendialog1.defaultext:='mnd';
  opendialog1.filter:='FractalForge files (*.mnd, *.mnl)|*.mnd;*.mnl|All files|*.*';
  if opendialog1.execute and LoadFile( opendialog1.filename ) then
    DrawLoadedFile;
  end;

procedure TMainForm.DrawLoadedFile;
  begin
  UpdateMandelState( MandelSet.FState );
  startMandel( false, false );
  image1.Invalidate;
  end;

procedure TMainForm.NewMandelSet;
	begin
	inc(NImages);
  if Nimages > LAST_MANDELBASE then
    NImages := 1;
	if not assigned( MandelBase[Nimages] ) then
  	New( MandelBase[NImages] );
	MandelBase[NImages]^ := MandelSet; //stores current values
	UpdateMandelSet;
	end;

procedure TMainForm.Save1Click(Sender: TObject);
  var
    k: integer;
    abc: string;
  begin
  If MandelSet.FState = msNone then
    begin
    MessageDlg('You can''t save if you have no image!',mtError,[mbOK],0);
    exit
    end;

  UpdateMandelSet; // get last changes
  if Savefilein83format1.checked then
    begin
    abc:='';
    abc := copy( trim( MandelSet.FName ), 1, 8 ) + '.mnd';
    end
  else
    begin
    abc:=MandelSet.FName+'.mnd';
    if (copy(abc,1,4)='Mand') or (copy(abc,1,5)='Julia') then
      begin
      k:=1000;
      repeat
        inc(k);
        abc:=inttostr(k);
        abc:=CProductName+copy(abc,2,3)+'.mnd';
      until not((FileExists(abc)) and (k<2000));
      end;
    end;
  savedialog1.title:='Save a FractalForge File';
  savedialog1.options:=[ofOverwritePrompt, ofhidereadonly ];
  savedialog1.filename:=abc;
  savedialog1.defaultext:='mnd';
  savedialog1.filter:='FractalForge Files (*.mnd)|*.mnd|All files|*.*';
  savedialog1.InitialDir := ImagesPath;
  if savedialog1.execute then
    begin
    SaveMndFile(SaveDialog1.FileName);
    end;
  end;

procedure TMainForm.SaveMndFile(const FileName: string);
//this should be a MandelSet method, possibly using Xml
  var
    RecFile: file of TMandelSet;
  begin
    AssignFile( RecFile, FileName) ;
    ReWrite( RecFile ) ;
    Write( RecFile, MandelSet ) ;
    CloseFile( RecFile ) ;
    UpdateMandelState(msSaved);
  end;

procedure TMainForm.SaveJpg( AFileName:string );
  var
    jpg: tjpegimage;
  begin
  jpg := tjpegimage.create;
    try
    jpg.Assign( image1.Picture.Bitmap );
    jpg.CompressionQuality := 70;
    jpg.savetofile( AFileName );
    finally
    jpg.free;
    end;
  end;

procedure TMainForm.SavePng( AFileName: string );
  var
    png: TPngImage;
    UserName: array[ 0 .. 31 ] of char;
    siz: cardinal;
  begin
  png := TPngImage.Create;
    try
    png.CopyFromBmp( image1.Picture.Bitmap );
    siz := sizeof( UserName );
    GetUserName( @UserName, siz );
    png.Author := UserName;
    png.Title := Mandelset.FName;
    png.Description := GetDataAsText( False );
    png.SaveToFile( aFileName );
    finally
    png.Free;
    end;
  end;
  
procedure TMainForm.SaveImage1Click(Sender: TObject);
  var
    answ:word;
    k:integer;
    a,abc:string;

  begin
  UpdateMandelSet; // get last changes
  if MandelSet.FState = msStopped then
    begin
    answ:=MessageDlg('Are you sure to save this incomplete image?',mtConfirmation,[mbYes,mbNo],0);
    case answ of
      mrNo: exit;
      end;
    end;
  if not Savefilein83format1.checked then
    begin
    abc:='';
    k:=0;
    while (length(abc)<8) and (k<length(MandelSet.FName)) do
      begin
      inc(k);
      a:=MandelSet.FName[k];
      if a<>' ' then abc:=abc+a;
      end;
    end
  else
    abc:=MandelSet.FName;
  savedialog1.filename:=abc;
  savedialog1.InitialDir := ImagesPath;
  savedialog1.title := 'Save Image File';
  savedialog1.filter := 'Png (*.png)|*.png|Jpeg (*.jpg)|*.jpg|Bitmap (*.bmp)|*.bmp|All files|*.*';
  savedialog1.FilterIndex := 1;
  savedialog1.options:=[ofOverwritePrompt, ofhidereadonly ];

  if savedialog1.execute then
    begin
    if ( ExtractFileExt( savedialog1.filename ) = '' ) then
      begin
      if savedialog1.FilterIndex = 1 then
        savedialog1.filename := ChangeFileExt( savedialog1.filename, '.png' )
      else if savedialog1.FilterIndex = 2 then
        savedialog1.filename := ChangeFileExt( savedialog1.filename, '.jpg' )
      else
        savedialog1.filename := ChangeFileExt( savedialog1.filename, '.bmp' )
      end;
    MandelSet.FImageFile:=ExtractFileName(savedialog1.filename); // to transport dirs
      try
      if comparetext( ExtractFileExt( MandelSet.FImageFile ), '.png' ) = 0 then
        SavePng( MandelSet.FImageFile )
      else if comparetext( ExtractFileExt( MandelSet.FImageFile ), '.jpg' ) = 0 then
        SaveJpg( MandelSet.FImageFile )
      else
        image1.Picture.SaveToFile( MandelSet.FImageFile );
      finally
      screen.cursor := crdefault;
      end;
    MandelBase[NImages]^:=MandelSet; // save FImageFile;
    end;
  end;

procedure TMainForm.About1Click(Sender: TObject);
  begin
  Application.CreateForm( TAboutBox, AboutBox );
  AboutBox.showmodal;
  end;

function MandStateToStr( MandState: TmandelState ): string;
  begin
  case MandState of
		msStopping:
      result := 'Stopping...';
		msStopped:
      result := 'Stopped';
		msPause:
      result := 'Paused';
		msRun:
      result := 'Calculating...';
		msSaved:
      result := 'Saved';
    msDone:
      result := 'Done';
    else//		msNone:
     result := 'None';
    end;
  end;
  
procedure TMainForm.UpdateMandelState (MandState: TMandelState);
  begin
  with MainForm do
    begin
    State.Caption := MandStateToStr( MandState );
    MandelSet.FState := MandState;
    UpdateMandelSet;
    end; {with}
  end;

procedure TMainForm.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var
    dkm, DK:extended;
    range:integer;
    sc: tpoint; //shape center
  begin
  case image1.cursor of
    crLenPlus:
      begin
      if YV>-1 then
        begin
        range:=abs(YV-Y);
        if range > 3 then
          DK:=1 / ( range * mandelb.Par.FIncI * 2 )
        else
          DK := mandelb.Par.FMagnitud * 4;
        edMagnit.Text := FloatToStrF( DK, ffgeneral, 18, 22);
        XV:=-1;
        YV:=-1;
        shape1.visible:=false;
        SquareNO.visible:=false;
        SquareNE.visible:=false;
        SquareSO.visible:=false;
        SquareSE.visible:=false;
        StartMandel(true);
        end;
      end;
    crLenMinus:
      begin
      if YV>-1 then
        begin
        range:=abs(YV-Y);
        if range > 3 then
          begin
          DK:=( range / mandelb.Par.FHeight ) * 2;
          sc.x := shape1.Left - image1.left + Shape1.Width div 2;
          sc.y := shape1.Top - image1.top + Shape1.Height div 2;
          dkm := mandelb.par.FCentReal - ( sc.X * mandelb.par.FIncR + mandelb.par.FMinCR);
          DKm :=  mandelb.par.FCentReal + dkm / dk;
          edRPoC.Text := FloatToStrF( DKm, ffgeneral, 18, 22 );
          dkm := mandelb.par.FCentImag - ( ( image1.Height - sc.Y ) * mandelb.par.FIncI + mandelb.par.FMinCI);
          DKm :=  mandelb.par.FCentImag + dkm / dk;
          edIPoC.Text := FloatToStrF( DKm, ffgeneral, 18, 22 );
          DK:=mandelb.Par.FMagnitud * dk;
          end
        else
          DK:= mandelb.Par.FMagnitud / 4;
        edMagnit.text:=FloatToStrF(DK,ffgeneral,18,22);
        XV:=-1;
        YV:=-1;
        shape1.visible:=false;
        SquareNO.visible:=false;
        SquareNE.visible:=false;
        SquareSO.visible:=false;
        SquareSE.visible:=false;
        StartMandel(true);
        end;
      end;
    crLen:
      begin
      if YV>-1 then
        begin
        XV:=-1;
        YV:=-1;
        Shape1.Cursor := crUpArrow;
        end;
      end;
    end;{case}
  end;

procedure TMainForm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
	Shift: TShiftState; X, Y: Integer);
	var
		DK : extended;
	begin
  if Button = mbLeft then
    begin
    if (image1.cursor = crLenPlus) then
      begin
      DK := X * mandelb.par.FIncR + mandelb.par.FMinCR;
      edRPoC.Text := FloatToStrF( DK, ffgeneral, 18, 22 );
      DK := ( image1.Height - Y ) * mandelb.par.FIncI + mandelb.par.FMinCI;
      edIPoC.Text := FloatToStrF( DK, ffgeneral, 18, 22 );
      end;
    XV:=X;
    YV:=Y;
    end;
	end;

procedure TMainForm.ShapeInImage;
  var
    ShapeR, ImageR: TRect;
  begin
  ShapeR := Shape1.BoundsRect;
  ImageR := Image1.BoundsRect;
  // constraining Shape1 into Image1
  if ShapeR.Left < ImageR.Left then
    ShapeR.Left := ImageR.Left;
  if ShapeR.Right > ImageR.Right then
    ShapeR.Right := ImageR.Right;
  if ShapeR.Top < ImageR.Top then
    ShapeR.Top := ImageR.Top;
  if ShapeR.Bottom > ImageR.Bottom then
    ShapeR.Bottom := ImageR.Bottom;
  Shape1.SetBounds( ShapeR.Left, ShapeR.Top, ShapeR.Right - ShapeR.Left, ShapeR.Bottom - ShapeR.Top );
  end;

procedure TMainForm.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  var
    sq,XLeft,YTop: integer;
    MI,MR: extended;
    tmpCol: TRGBTriple;

  begin
  ShowHideMenu;
  MI := ( image1.Height - Y ) * mandelb.par.FIncI + mandelb.par.FMinCI;
  MR := X * mandelb.par.FIncR + mandelb.par.FMinCR;
  stReal.Caption:=FloatToStrF(MR,ffgeneral,18,22);
  stImag.Caption:=FloatToStrF(MI,ffgeneral,18,22);
  stIter.Caption:=floattostr( mandelb.AlgMndFlt( MR, MI ) );
  tmpCol := ColToBGR(Image1.Canvas.Pixels[X,Y]);
  stR.Caption:=inttostr(tmpCol.rgbtBlue); // not R
  stG.Caption:=inttostr(tmpCol.rgbtGreen);
  stB.Caption:=inttostr(tmpCol.rgbtRed); // not B

  if MandelSet.FState = msRun then
    exit; //non fa altri controlli

  if FrJulia.Visible then
    FrJulia.ResetValues( Mr, Mi, mandelb.par.FFormula, not mandelb.par.FJulia );

  if FrOrbits.Visible then
    FrOrbits.TraceOrbits(Mr, Mi, FrOrbits.cblines.Checked );

  if frRectangles.Visible then
    begin
    frRectangles.FReal := Mr;
    frRectangles.FImmag := Mi;
    frRectangles.FIngr := 10 / ( mandelb.par.FIncI * Image1.Height ) ; //10 volte gli ingrandimenti dell'immagine
    frRectangles.TraceRects;
    end;

  if (XV > -1) and ( (image1.cursor=crLenPlus) or (image1.cursor=crLenminus ) ) then
    begin
    shape1.visible:=false;
    shape1.top:=image1.top+YV-abs(YV-Y);
    shape1.height:=abs(Y-YV)*2;
    shape1.width:=round(shape1.height*(image1.width/image1.height));
    shape1.left:=image1.left+XV-shape1.width div 2;
    shape1.visible:=true;

    ShapeInImage;
    end;

  if (XV > -1) and (image1.cursor=crLen) then
    begin
    shape1.visible:=false;
    if Y>YV then
      YTop:=YV
    else
      YTop:=Y;
    shape1.top:=image1.top+YTop;
    shape1.height:=abs(Y-YV);
    shape1.width:=round(shape1.height*(image1.width/image1.height));
    if X>XV then
      XLeft:=XV
    else
      XLeft:=XV-shape1.width;
    shape1.left:=image1.left+XLeft;

    ShapeInImage;
    sq:=squareNO.width div 2;
    SquareNO.top:=shape1.top-sq;
    SquareNO.left:=shape1.left-sq;
    SquareSE.top:=shape1.top+shape1.height-sq;
    SquareSE.left:=shape1.left+shape1.width-sq;
    squareNE.left:=SquareSE.left;
    squareSO.left:=SquareNO.left;
    squareNE.top:=SquareNO.top;
    squareSO.top:=SquareSE.top;

    shape1.visible:=true;
    SquareNO.visible:=true;
    SquareNE.visible:=true;
    SquareSO.visible:=true;
    SquareSE.visible:=true;
    end;
  end;

procedure TMainForm.ZoomWindow1Click(Sender: TObject);
  begin
  if MandelSet.FState = msNone then
    messageDlg('You must draw a fractal before',mtWarning,[mbOK],0)
  else
    begin
    image1.cursor:=crLen;
    shape1.cursor:=crLen;
    shape1.visible:=false;
    SquareNO.visible:=false;
    SquareNE.visible:=false;
    SquareSO.visible:=false;
    SquareSE.visible:=false;
    XV:=-1;
    YV:=-1;
    end;
  end;

procedure TMainForm.ZoomInCursor;
  begin
  image1.cursor:=crLenPlus;
  shape1.cursor:=crLenPlus;
  shape1.visible:=false;
  SquareNO.visible:=false;
  SquareNE.visible:=false;
  SquareSO.visible:=false;
  SquareSE.visible:=false;
  XV:=-1;
  YV:=-1;
  end;

procedure TMainForm.ZoomIn1Click(Sender: TObject);
  begin
  if MandelSet.FState = msNone then
    messageDlg('You must draw a fractal before',mtWarning,[mbOK],0)
  else
    ZoomInCursor;
  end;

procedure TMainForm.ZoomOut1Click(Sender: TObject);
  begin
  if MandelSet.FState = msNone then
    messageDlg('You must draw a fractal before',mtWarning,[mbOK],0)
  else
    begin
    image1.cursor:=crLenMinus;
    shape1.cursor:=crLenMinus;
    shape1.visible:=false;
    SquareNO.visible:=false;
    SquareNE.visible:=false;
    SquareSO.visible:=false;
    SquareSE.visible:=false;
    XV:=-1;
    YV:=-1;
    end;
  end;

procedure TMainForm.DefaultValues1Click(Sender: TObject);
  begin
  MandelSet:=MandelBase[0]^;
  MandelSet.FName:=edName.text;
  MandelSetToRUParameters;
  StartMandel( false );
  end;

procedure TMainForm.FormStart;
	var
		l,t,w,h,status:integer;
		SelFile:string;

	begin
	status:=Inifile.ReadInteger ('MainForm','Status',1);
	if status=3 then WindowState:=wsMaximized
	else if status=1 then WindowState:=wsNormal;
	if status <3 then
		begin
		l:=Inifile.ReadInteger ('MainForm','Left',70);
		t:=Inifile.ReadInteger ('MainForm','Top',40);
		w:=Inifile.ReadInteger ('MainForm','Width',500);
		h:=Inifile.ReadInteger ('MainForm','Height',400);
    SetBounds(l,t,w,h);
		end;
	ShowcontrolPanel1.Checked:=Inifile.ReadBool ('Options','ControlPanel',true);
  pnParam.Visible := showcontrolPanel1.Checked;

  if Inifile.ReadBool ('Options','FullScreenMode', false) then
    FullScreen1Click( FullScreenMode1 );

	if ParamStr( 1 ) = '' then
  	SelFile:=MainForm.Inifile.ReadString( 'Options', 'Starting Values', 'None' )
  else
    SelFile := ParamStr( 1 );

	if ( SelFile <> 'None' ) then
    LoadFile( SelFile );

  Show;
  Update;
  PostMessage( handle, WM_STARTMANDEL, 0, 0 );
	end;

procedure TMainForm.WMStartMandel(var Msg: TWMDROPFILES);
  begin
  sbZoomIn.Down := True;
  ZoomInCursor;
  Screen.Cursor := crHourglass;
    try
  	StartMandel( False, False );
    finally
    Screen.Cursor := crDefault;
    end;
  MultiCpuAlert;
  end;


function TMainForm.LoadFile( FileName: string ): boolean;
  var
    HFile: Integer;
    FileLen: int64;
  begin
  if ExtractFilePath( FileName ) = '' then
    FileName := ImagesPath + FileName;
    try
    result := false;
    if FileExists( FileName ) then
      begin
      FileLen := GetFileSize( FileName );
      if FileLen = 4353 then
        begin
        MessageDlg( 'The file ' + FileName + ' is an old version file. You need TrueMandel 1.6 to convert it.', mtWarning,[mbOK],0);
        end
      else if FileLen mod 1023 = 0 then // mnl or mnd
        begin
        UpdateMandelSet; // save old mandelset
        NewMandelSet; // prepare a brand new mandelset
        hfile := FileOpen(FileName, fmOpenRead);
          try
          result := FileRead( hFile, MandelSet, Sizeof(Mandelset) ) = Sizeof(Mandelset);
          finally
          FileClose(HFile);
          end;
        end
      else
        begin
        MessageDlg( 'The file ' + FileName + ' is not a valid file', mtWarning,[mbOK],0);
        end;
      end;
    except
    result := false;
    end;
 MandelSetToRUParameters;
 end;

procedure TMainForm.Shape1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
	sq,t,l:integer;
begin
if ( ssLeft in Shift ) and ( shape1.cursor = crSize ) then
  begin
  t:=shape1.top;
  l:=shape1.left;
  shape1.Top := t + Y - YV;
  shape1.Left := l + X - XV;

  ShapeInImage;

  sq:=squareNO.width div 2;
  SquareNO.top:=shape1.top-sq;
  SquareNO.left:=shape1.left-sq;
  SquareSE.top:=shape1.top+shape1.height-sq;
  SquareSE.left:=shape1.left+shape1.width-sq;
  squareNE.left:=SquareSE.left;
  squareSO.left:=SquareNO.left;
  squareNE.top:=SquareNO.top;
  squareSO.top:=SquareSE.top;
  end
else if Shift = [] then
  begin
  with shape1 do
    begin
    if ( Width > 16 ) and ( Height > 16 ) and ( ( X < 8 ) or ( X > Width - 8 ) or ( Y < 8 ) or ( Y > Height - 8 ) ) then
      Cursor := crSize
    else
      Cursor := crUpArrow;
    end;
  end;
end;

procedure TmainForm.UpdateMandelSet;
	begin
// load changed values
	MandelSet.FName:=edName.text;
	MandelSet.FComments:=edComment.text;
	MandelSet.FColors:= cbColors.text;
  MandelSet.FOffset := IntToStr( ttOffset.Position );
	MandelBase[ NImages ]^:=MandelSet; //save changed values
  cbHistory.ItemIndex := NImages; // go lastitem
  UpdateHistory; // load cbHistory.items
  cbHistoryChange( nil ); // show item
	end;

procedure TMainForm.UpdateHistory;
	var 
    k, j : integer;
  begin
 	j := cbHistory.itemindex;
  cbHistory.Clear;
	for k:=0 to Nimages do
		cbHistory.items.add( MandelBase[k]^.FName );
	cbHistory.ItemIndex := j;
  end;

procedure TMainForm.MandelSetToRUParameters;
	begin
  cbJulia.Checked:=MandelSet.FJulia; // must be first
	edName.text:=MandelSet.FName;
	edRPoC.text:=MandelSet.FCentReal;
	edIPoC.text:=MandelSet.FCentImag;
	edMagnit.text:=MandelSet.FMagnitud;
	edIter.text:=MandelSet.FIter;
	edWidth.text:=Mandelset.FWidth;
	edHeight.text:=Mandelset.FHeight;
	edAspectR.text:=MandelSet.FAspectR;
  cbAlgo.ItemIndex := cbAlgo.Items.IndexOf( trim( MandelSet.FAlgo ) );
  cbColors.Enabled := False;
  if MandelSet.FColors = '' then
    cbColors.ItemIndex := 0
  else
    cbColors.ItemIndex := cbColors.Items.IndexOf( trim( MandelSet.FColors ) );
  cbColors.Enabled := True;
	edBailout.text := MandelSet.FBailout;
	edRealPerturbation.Text:=MandelSet.FRealPert;
	edImagPerturbation.Text:=MandelSet.FImagPert;
	cbApply.ItemIndex := cbApply.Items.IndexOf( trim( MandelSet.FApplyC ) ); ;
	cbFormula.ItemIndex := cbFormula.Items.IndexOf( trim( MandelSet.FFormula ) );
	edComment.text := MandelSet.FComments;
  ttOffset.Max := StrToIntDef( MandelSet.FIter, 99 ); // offset max is equal to iter max
  ttOffset.Frequency := ttOffset.Max div 10;
  ttOffset.Position := Trunc( StrToFloatDef( MandelSet.FOffset, 0 ) );
	end;

procedure TMainForm.Restoreoldvalues1Click(Sender: TObject);
  begin
  if cbHistory.itemindex = -1 then
    MandelSet := MandelBase[NImages-1]^
  else
    MandelSet := MandelBase[cbHistory.itemindex]^;
  MandelSet.FName := edName.text;
  MandelSetToRUParameters;
  StartMandel( False );
  end;


procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  begin
  if Key=VK_ESCAPE then
    begin
    if MandelSet.FState = msRun then
      if MessageDlg( 'Do you want to stop current drawing?', mtConfirmation, mbOKCancel, 0) = mrOk then
        StartMandel( True );
    end
  else if Key=VK_RETURN then
    begin
    if not(ActiveControl is TMemo) and sbstart.Enabled then
      StartMandel( False );
    end
  else if ( Key = ord( 'F' ) ) and (shift = [ ssCtrl ] ) then
    begin
    FullScreen1Click( Sender );
    end;
  end;

procedure TMainForm.SaveList1Click(Sender: TObject);
  var
    k: integer;
    NameRecFile: string;
    RecFile: file of TMandelSet;

  begin
  UpDateMandelSet;
  If NImages<=0 then
    begin
    MessageDlg('You can''t save if you have no image!',mtError,[mbOK],0);
    exit
    end;

  savedialog1.title:='Save a FractalForge File List';
  savedialog1.filename:='List.mnl';
  savedialog1.defaultext:='mnl';
  savedialog1.filter:='FractalForge File List(*.mnl)|*.mnl|FractalForge File (*.mnd)|*.mnd|All files|*.*';
  savedialog1.InitialDir := ImagesPath;
  if savedialog1.execute then
    begin
    NameRecFile:=savedialog1.filename;
    AssignFile( RecFile, NameRecFile) ;
    ReWrite( RecFile ) ;
    for k := 0 to Nimages do
      begin
      Write( RecFile, MandelBase[ k ]^ ) ;
      end;
    CloseFile( RecFile ) ;
    end;
  end;


procedure TMainForm.AddList1Click(Sender: TObject);
  var
    k,test:integer;
    NameOpenFile: string;
    OpenFile: file of TMandelSet;
  begin
  opendialog1.title:='Add a FractalForge File List';
  opendialog1.defaultext:='mnl';
  opendialog1.InitialDir := ImagesPath;
  opendialog1.filter:='FractalForge File List(*.mnl)|*.mnl|FractalForge File (*.mnd)|*.mnd|All files|*.*';
  if opendialog1.execute then
    begin
    NameOpenFile:=opendialog1.filename;
    AssignFile( OpenFile, NameOpenFile);
    Reset(OpenFile);
    test:=FileSize(OpenFile);
    UpDateMandelSet; // save old mandelset
    for k:=1 to test do
      begin
      NewMandelSet; //prepare new
      Read(OpenFile, MandelSet);
    	MandelBase[ NImages ]^:=MandelSet; //save changed values
      end;
    CloseFile(OpenFile);
    cbHistory.ItemIndex := NImages; // go lastitem
    UpdateHistory; // load cbHistory.items
    cbHistoryChange( nil ); // show item
    end
  else
    begin
    MessageDlg('File '+MandelSet.FImageFile+' is not a valid file', mtWarning,[mbOK],0);
    exit;
    end;
  end;

procedure TMainForm.SelectStartingFractal1Click(Sender: TObject);
  begin
  with opendialog1 do
    begin
    title := 'Select a fractal to start with:';
    InitialDir := ImagesPath;
    defaultext:='mnd';
    Filter:='FractalForge files (*.mnd, *.mnl)|*.mnd;*.mnl|All files|*.*';
    FileName := ExtractFileName( Inifile.ReadString ( 'Options', 'Starting Values', '' ) );
    if opendialog1.execute then
      begin
      if LoadFile( FileName ) then
        begin
        Inifile.WriteString ( 'Options', 'Starting Values', ExtractFileName( FileName ) );
        startMandel(false, false);
        end
      else
        ShowMessage( 'Failed to open ' + filename );
      end
    else if MessageDlg( 'Do you want to reset Starting Values ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
      Inifile.WriteString ( 'Options', 'Starting Values', '' );
      end;
    end;
  end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
	var
		status : integer;
	begin
  if MandelSet.FState in [ msRun, msPause ] then
		begin
    if MessageDlg('Do you really want to leave current fractal ?', mtConfirmation, [ mbYes, mbNo], 0) = mrNo then
      begin
      CanClose := false;
		  exit;
      end
    else
      begin
      StartMandel( true );     
      PostMessage( handle, WM_QUIT,0 ,0 );
      CanClose := false;
		  exit;
      end
		end;
	status:=2;
	if WindowState=wsMaximized then
		status:=3
	else if WindowState=wsNormal then
		status:=1;

    try
    Inifile.WriteInteger ('MainForm','Status',Status);
    if FullScreenMode1.Checked then
      begin
      Inifile.WriteInteger ('MainForm','Top',FFSMRect.top);
      Inifile.WriteInteger ('MainForm','Left',FFSMRect.left);
      Inifile.WriteInteger ('MainForm','Width',FFSMRect.Right - FFSMRect.Left);
      Inifile.WriteInteger ('MainForm','Height',FFSMRect.Bottom - FFSMRect.Top);
      end
    else if status=1 then
      begin
      Inifile.WriteInteger ('MainForm','Top',top);
      Inifile.WriteInteger ('MainForm','Left',left);
      Inifile.WriteInteger ('MainForm','Width',width);
      Inifile.WriteInteger ('MainForm','Height',height);
      end;
    Inifile.WriteBool ('Options','ControlPanel',ShowcontrolPanel1.Checked);
    Inifile.WriteBool ('Options','FullScreenMode',FullScreenMode1.Checked);
    except
    ShowMessage('Problems with inifile('+Inifile.FileName+'). Preferences not saved!');
    end;
	end;

procedure TMainForm.Savefilein83format1Click(Sender: TObject);
begin
Savefilein83format1.checked:=not Savefilein83format1.checked;
end;

procedure TMainForm.Shape1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var
    range,CenterY,CenterX: integer;
    DK: Double;
  begin
  if shape1.cursor = crUpArrow then
    begin
    with shape1 do
      begin
      range := height;
      CenterY := image1.Height - ( Top - image1.Top + height div 2 );
      CenterX := Left - image1.Left + width div 2;
      end;
    if range > 3 then
      begin
      DK:=1 / ( range * mandelb.Par.FIncI );
      edMagnit.Text := FloatToStrF( DK, ffgeneral, 18, 22 );
      DK := CenterX * mandelb.Par.FIncR + mandelb.Par.FMinCR;
      edRPoC.Text := FloatToStrF( DK, ffgeneral, 18, 22 );
      DK := {-}CenterY * mandelb.Par.FIncI + mandelb.Par.FMinCI;
      edIPoC.Text := FloatToStrF( DK, ffgeneral, 18, 22 );
      end;
    image1.cursor:=crLen;
    shape1.cursor:=crLen;
    shape1.visible:=false;
    SquareNO.visible:=false;
    SquareNE.visible:=false;
    SquareSO.visible:=false;
    SquareSE.visible:=false;
    StartMandel(false);
    end;
  XV:=-1;
  YV:=-1;
  end;

procedure TMainForm.ShowHideMenu;
  var
    p: TPoint;
  begin
  if FullScreenMode1.Checked then
    begin
    GetCursorPos( p );
    if ( p.y < 16 ) and not assigned( Menu ) then
      begin
      Menu := MainMenu1;
      end
    else if assigned( Menu ) then
      Menu := nil
    else if ( width - p.x < 16 ) and not pnParam.visible then
      begin
      pnParam.visible := true;
      end
    else if pnParam.visible then
      pnParam.visible := false;
    end;
  end;
    
procedure TMainForm.ScrollBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
ShowHideMenu;
if not(stReal.caption='') then
	begin
	stReal.caption:='';
	stImag.caption:='';
	stIter.caption:='';
	stR.caption:='';
	stG.caption:='';
	stB.caption:='';
	end;
end;

procedure TMainForm.UndoFractal1Click(Sender: TObject);
  var
    nh: integer;
  begin
  if MandelSet.FState = msRun then
    begin
    ShowMessage( 'You have to stop current drawing before !' );
    exit;
    end;
  nh := cbHistory.ItemIndex;
  if nh = -1 then
    nh := cbHistory.Items.Count - 1;
  if nh > 0 then
    begin
    Dec( nh );
    cbHistory.ItemIndex := nh;
    Restoreoldvalues1Click( self );
    cbHistory.ItemIndex := nh; //restore it for a next Ctrl+K
    end;
  end;

procedure TMainForm.Print1Click(Sender: TObject);
  var
    s1, s2, s3: string;
  begin
  with MandelSet do
    begin
    if FState = msNone then
      begin
      ShowMessage( 'You have no image to print !' );
      exit;
      end;
    if FState = msRun then
      begin
      ShowMessage( 'You have to stop current drawing to print !' );
      exit;
      end;
    s1 := FName;
    if FImageFile <> 'None' then
      s1 := s1 + '     file: ' + FImageFile;
    s1 := s1 + '     R: ' + MandelSet.FCentReal + '     I: ' + MandelSet.FCentImag + '     M: ' + MandelSet.FMagnitud;
    s2 := 'Iterations: ' + MandelSet.FIter + '     Bailout: ' + MandelSet.FBailout + '     Color by: ' + MandelSet.FApplyC + '     Formula: ' + MandelSet.FFormula;
    if FJulia then
      s3 := 'Julia Mode'
    else
      s3 := 'Mandel Mode';
    s3 := s3 + '     Real Pert.: ' + MandelSet.FRealPert + '     Imag pert.: ' + MandelSet.FImagPert + '     Color sequence: ' + MandelSet.FColors;
    end;
  PrintBitmap( image1.Picture.Bitmap, s1, s2, s3 );
  end;

procedure TMainForm.CopyImage1Click(Sender: TObject);
  begin
  Clipboard.Assign(Image1.Picture);
  end;

function TMainForm.GetDataAsText(MouseCoords: Boolean): string;
  var
    k: integer;
  begin
  result := '';
  with sgHistory do
    begin
    for k := 0 to RowCount - 1 do
      begin
      Result := Result + #13 + #10 + Trim(Cells[ 0, k ]) + '=';
      if MouseCoords and (k = 2) then
        Result := Result + stReal.Caption
      else if MouseCoords and (k = 3) then
        Result := Result + stImag.Caption
      else
        Result := Result + cells[ 1, k ];
      end;
    end;
  end;

procedure TMainForm.CopyValues1Click(Sender: TObject);
  begin
  Clipboard.AsText := GetDataAsText( False );
  end;

procedure TMainForm.PrinterSetup1Click(Sender: TObject);
  begin
  PrinterSetupDialog1.Execute;
  end;

procedure TMainForm.SquareSOMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  var
    sq: integer;
  begin
  if XV > -1 then
    begin
    SquareSO.top:=SquareSO.top+Y-YV;
    sq:=squareNO.width div 2;
    if SquareSO.top<shape1.top-sq then SquareSO.top:=shape1.top-sq;
    shape1.height:=SquareSO.top- shape1.top+sq;

    shape1.width:=round(shape1.height*(image1.width/image1.height));
    SquareSO.left:=SquareNE.left-shape1.width;
    shape1.left:=SquareSO.left+sq;
    ShapeInImage;

    SquareNO.top:=shape1.top-sq;
    SquareNO.left:=shape1.left-sq;
    SquareSE.top:=shape1.top+shape1.height-sq;
    SquareSE.left:=shape1.left+shape1.width-sq;
    squareNE.left:=SquareSE.left;
    squareSO.left:=SquareNO.left;
    squareNE.top:=SquareNO.top;
    squareSO.top:=SquareSE.top;
    end;
  end;

procedure TMainForm.SquareSOMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
XV:=X;
YV:=Y;
end;

procedure TMainForm.SquareSOMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
XV:= -1;
YV:= -1;
end;

procedure TMainForm.SquareNEMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sq: integer;

begin
if XV > -1 then
  begin
  SquareNE.top:=SquareNE.top+Y-YV;
  sq:=squareSO.width div 2;
  if SquareNE.top>SquareSO.top then SquareNE.top:=SquareSO.top;
  shape1.top:=SquareNE.top+sq;
  shape1.height:=SquareSO.top-SquareNE.top;
  shape1.width:=round(shape1.height*(image1.width/image1.height));
  ShapeInImage;

  SquareNE.left:=SquareSO.left+shape1.width;
  SquareNO.top:=shape1.top-sq;
  SquareNO.left:=shape1.left-sq;
  SquareSE.top:=shape1.top+shape1.height-sq;
  SquareSE.left:=shape1.left+shape1.width-sq;
  squareNE.top:=SquareNO.top;
  squareNE.left:=SquareSE.left;
  squareSO.top:=SquareSE.top;
  squareSO.left:=SquareNO.left;
  end;

end;

procedure TMainForm.SquareNOMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sq: integer;

begin
if XV > -1 then
  begin
  SquareNO.top:=SquareNO.top+Y-YV;
  sq:=squareSO.width div 2;
  if SquareNO.top>SquareSE.top then SquareNO.top:=SquareSE.top;
  shape1.top:=SquareNO.top+sq;
  shape1.height:=SquareSE.top-SquareNO.top;
  shape1.width:=round(shape1.height*(image1.width/image1.height));
  SquareNO.left:=SquareSE.left-shape1.width;
  shape1.left:=SquareNO.left+sq;
  ShapeInImage;

  SquareNO.top:=shape1.top-sq;
  SquareNO.left:=shape1.left-sq;
  SquareSE.top:=shape1.top+shape1.height-sq;
  SquareSE.left:=shape1.left+shape1.width-sq;
  squareNE.top:=SquareNO.top;
  squareNE.left:=SquareSE.left;
  squareSO.top:=SquareSE.top;
	squareSO.left:=SquareNO.left;
  end;

end;



procedure TMainForm.SquareSEMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sq: integer;

begin
if XV > -1 then
  begin
  SquareSE.top:=SquareSE.top+Y-YV;
  sq:=squareNO.width div 2;
  if SquareSE.top<SquareNO.top then SquareSE.top:=SquareNO.top;
  shape1.height:=SquareSE.top- SquareNO.top;
  shape1.width:=round(shape1.height*(image1.width/image1.height));
  ShapeInImage;

  SquareSE.left:=SquareNO.left+shape1.width;
  SquareNO.top:=shape1.top-sq;
  SquareNO.left:=shape1.left-sq;
  SquareSE.top:=shape1.top+shape1.height-sq;
  SquareSE.left:=shape1.left+shape1.width-sq;
  squareNE.left:=SquareSE.left;
	squareSO.left:=SquareNO.left;
  squareNE.top:=SquareNO.top;
  squareSO.top:=SquareSE.top;
  end;
end;


procedure TMainForm.SquareSEMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
XV:= -1;
YV:= -1;

end;

procedure TMainForm.SquareNOMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
XV:= -1;
YV:= -1;

end;

procedure TMainForm.SquareNEMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
XV:= -1;
YV:= -1;

end;

procedure TMainForm.SquareNEMouseDown(Sender: TObject;
	Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
XV:=X;
YV:=Y;

end;

procedure TMainForm.SquareNOMouseDown(Sender: TObject;
	Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
XV:=X;
YV:=Y;

end;

procedure TMainForm.SquareSEMouseDown(Sender: TObject;
	Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
XV:=X;
YV:=Y;

end;

procedure TMainForm.EditColors1Click(Sender: TObject);
  begin
  Application.CreateForm( TFrEditColors, FrEditColors );
  FrEditColors.LoadColorsFromFile( ColorsPath + cbColors.Text + '.mnc' );
  FrEditColors.ShowModal;
  LoadcbColors;
  end;

procedure TMainForm.LoadcbColors;
  var
    i: integer;
  begin
  with cbColors do
    begin
    i := ItemIndex;
    DirToStrings( ColorsPath + '*.mnc', Items, False, False );
    if Items.Count = 0 then
      Items.Add( 'Standard' ); // worst case
    if i < 0 then
      i := 0;
  	Sorted := True;
    ItemIndex := i;
    end;
	oldcol:='';
  end;


procedure TMainForm.sbStartClick(Sender: TObject);
  begin
  Start1Click(Sender);
  end;

procedure TMainForm.sbPauseClick(Sender: TObject);
  begin
  Pause1Click(Sender);
  end;

procedure TMainForm.sbZoomInClick(Sender: TObject);
  begin
  ZoomIn1Click(Sender);
  end;

procedure TMainForm.sbZoomOutClick(Sender: TObject);
  begin
  ZoomOut1Click(Sender);
  end;

procedure TMainForm.sbZoomClick(Sender: TObject);
  begin
  ZoomWindow1Click(Sender);
  end;

procedure TMainForm.ControlPanel1Click(Sender: TObject);
  begin
  ShowcontrolPanel1.Checked := not ShowcontrolPanel1.Checked;
  pnParam.Visible := showcontrolPanel1.Checked;
  end;

procedure TMainForm.ScrollBox1Resize(Sender: TObject);
  begin
	ScrollBox1.HorzScrollBar.Visible := false;
	ScrollBox1.VertScrollBar.Visible := false;
	ScrollBox1.HorzScrollBar.Position := 0;
	ScrollBox1.VertScrollBar.Position := 0;

  if Image1.Width < ScrollBox1.ClientWidth then
    Image1.Left:=( ScrollBox1.ClientWidth - image1.Width ) div 2
  else
    begin
    ScrollBox1.HorzScrollBar.Range := Image1.Width;
    Image1.Left:=0;
    end;

  if Image1.Height < ScrollBox1.height then
    Image1.Top := ( ScrollBox1.ClientHeight - Image1.ClientHeight ) div 2
  else
    begin
    ScrollBox1.VertScrollBar.Range := Image1.Height;
    Image1.Top:=0;
    end;
  // second time for scroolbars

  if Image1.Width > ScrollBox1.ClientWidth then
    ScrollBox1.HorzScrollBar.Visible := True;

  if Image1.Height > ScrollBox1.ClientHeight then
    ScrollBox1.VertScrollBar.Visible := True;

  // to remove dirty images  
  ScrollBox1.Visible := False;
  ScrollBox1.Visible := True;
  end;

procedure TMainForm.btRestoreClick(Sender: TObject);
  begin
  Restoreoldvalues1Click(sender);
  end;

procedure TMainForm.edWidthChange(Sender: TObject);
  begin
  if UserChangedW then
    lbFormats.ItemIndex := 0
  else
    UserChangedW := True;
  end;

procedure TMainForm.lbFormatsClick(Sender: TObject);
	var
		W,H,A:string;
	begin
	case lbFormats.ItemIndex of
	1:   begin
			 W:='320';
			 H:='200';
			 A:='0.8333333333333';
			 end;
	2:   begin
			 W:='320';
			 H:='240';
			 A:='1';
			 end;
	3:   begin
			 W:='320';
			 H:='400';
			 A:='1.666666666667';
			 end;
	4:   begin
			 W:='500';
			 H:='500';
			 A:='1';
			 end;
	5:   begin
			 W:='550';
			 H:='530';
			 A:='1';
			 end;
	6:   begin
			 W:='640';
			 H:='400';
			 A:='0.8333333333333';
			 end;
	7:   begin
			 W:='640';
			 H:='480';
			 A:='1';
			 end;
	8:   begin
			 W:='770';
			 H:='700';
			 A:='1';
			 end;
	9:  begin
			 W:='800';
			 H:='600';
			 A:='1';
			 end;
	10:  begin
			 W:='1024';
			 H:='768';
			 A:='1';
			 end;
	11:  begin
			 W:='1152';
			 H:='864';
			 A:='1';
			 end;
	12:  begin
			 W:='1280';
			 H:='1024';
			 A:='1';
			 end;
	13:  begin
			 W:='1600';
			 H:='1200';
			 A:='1';
			 end;
	end; {case}
	if W <> edWidth.text then
		begin
		UserChangedW:=false;
		edWidth.text:=W;
		end;
	if H <> edHeight.text then
		begin
		UserChangedH:=false;
		edHeight.text:=H;
		end;
	if A <> edAspectR.text then
		begin
		UserChangedA:=false;
		edAspectR.text:=A;
		end;

  StartMandel( True );
	end;

procedure TMainForm.btDefaultClick(Sender: TObject);
  begin
  DefaultValues1Click(sender);
  end;

procedure TMainForm.edHeightChange(Sender: TObject);
  begin
  if UserChangedH then
    lbFormats.ItemIndex := 0
  else
    UserChangedH := true;
  end;

procedure TMainForm.edAspectRChange(Sender: TObject);
  begin
  if UserChangedA then
    lbFormats.ItemIndex:=0
  else
    UserChangedA:=true;
  end;

procedure TMainForm.edIterChange(Sender: TObject);
  var
    iter, r: integer;
  begin
  val( edIter.Text, iter, r );
  if r<>0 then
    iter := 0;
  if iter<0 then
    edIter.Text := '0';
  end;

procedure TMainForm.cbJuliaClick(Sender: TObject);
  var
    a,b:string;
  begin
  if ActiveControl = cbJulia then
    begin //only if clicked by user
    a := edRPoC.Text;
    b := edIPoC.Text;
    edRPoC.Text := edRealPerturbation.Text;
    edIPoC.Text := edImagPerturbation.Text;
    edRealPerturbation.Text := a;
    edImagPerturbation.Text := b;
    StartMandel( True );
    end;
  end;

procedure TMainForm.cbHistoryChange(Sender: TObject);
begin
	if ( cbHistory.ItemIndex < 0 ) or ( cbHistory.ItemIndex > NImages ) then
		begin
		cbHistory.ItemIndex := NImages;
		end;
	MandelSet := MandelBase[cbHistory.itemindex]^;
	cbHistory.Text := cbHistory.items[cbHistory.itemindex];
	with sgHistory do
		begin
		cells[1, 0]:=MandelSet.FVersion;
		cells[1, 1]:=MandelSet.FName;
		cells[1, 2]:=MandelSet.FCentReal;
		cells[1, 3]:=MandelSet.FCentImag;
		cells[1, 4]:=MandelSet.FMagnitud;
		cells[1, 5]:=MandelSet.FAlgo;
		cells[1, 6]:=MandelSet.FIter;
		cells[1, 7]:=Mandelset.FWidth;
		cells[1, 8]:=Mandelset.FHeight;
		cells[1, 9]:=MandelSet.FAspectR;
		cells[1,10]:=MandelSet.FPriority;
    cells[1,11]:=BoolToStr( MandelSet.FJulia, True );
		cells[1,12]:=MandelSet.FColors;
		cells[1,13]:=MandelSet.FBailout;
		cells[1,14]:=MandelSet.FRealPert;
		cells[1,15]:=MandelSet.FImagPert;
		cells[1,16]:=MandelSet.FApplyC;
		cells[1,17]:=MandelSet.FFormula;
		cells[1,18]:=MandelSet.FComments;
		cells[1,19]:=MandelSet.FTime;
		cells[1,20]:=MandelSet.FCrono;
		cells[1,21]:=MandStateToStr( MandelSet.FState );
		end;
  end;

procedure TMainForm.btDelClick(Sender: TObject);
  var
    k: integer;
  begin
  if NImages < 1 then
    exit;
  if MessageDlg('Do you really delete current entry in list ?', mtConfirmation,
        [mbYes, mbNo], 0) = mrYes then
    begin
    for k := cbHistory.ItemIndex to LAST_MANDELBASE - 1 do
      MandelBase[ k ] := Mandelbase[ k + 1 ];
    MandelBase[ LAST_MANDELBASE ] := nil;
    cbHistory.ItemIndex := cbHistory.ItemIndex - 1;  
    NImages := cbHistory.Items.Count - 2;
    UpdateHistory;
    cbHistoryChange( cbHistory );
    end;
  end;

procedure TMainForm.btDeltaClick(Sender: TObject);
  begin
  Application.CreateForm(TDeltaDlg,DeltaDlg);
  if DeltaDlg.showmodal = mrOk then
    begin
    if sbStart.Enabled then
      sbStart.click;
    end;
  end;

procedure TMainForm.cbColorsChange(Sender: TObject);
	begin
	if ( ( cbColors.Text = oldcol ) or ( not cbColors.Enabled ) ) then
    exit;
	oldcol := cbColors.Text;
  SetColor( cbColors.Text, StrToIntDef( MandelSet.FIter, 100 ) );

  if cbPreview.Checked then
    ColorPreview;
  end;

procedure TMainForm.ColorPreview;
  begin
  ttOffset.Position := 0;
  Colors.Offset := 0;
  Mandelb.Redraw;
  end;


procedure TMainForm.Showorbits1Click(Sender: TObject);
  begin
  frOrbits.show;
  end;

procedure TMainForm.ShowRectangles1Click(Sender: TObject);
  begin
  FrRectangles.show;
  end;

procedure TMainForm.btEditColorsClick(Sender: TObject);
  begin
  EditColors1Click( Sender );
  end;

procedure TMainForm.Center(Sender: TObject);
  begin
  edRPoC.Text := stReal.Caption;
  edIPoC.Text := stImag.Caption;
  sbStart.Click;
  end;

procedure TMainForm.ZoomIn2Click(Sender: TObject);
  begin
  sbZoomIn.Down := true;
  sbZoomIn.Click;
  end;

procedure TMainForm.Zoom21Click(Sender: TObject);
  begin
  edRPoC.Text := stReal.Caption;
  edIPoC.Text := stImag.Caption;
	edMagnit.Text := FloatToStrF( Mandelb.Par.FMagnitud * 4, ffgeneral, 18, 22 );
  sbStart.Click;
  end;

procedure TMainForm.ZoomOut2Click(Sender: TObject);
  begin
  sbZoomOut.Down := true;
  sbZoomOut.Click;
  end;

procedure TMainForm.ZoomRect1Click(Sender: TObject);
  begin
  sbZoom.Down := true;
  sbZoom.Click;
  end;

procedure TMainForm.ZoomOutNow1Click(Sender: TObject);
  begin
  edRPoC.Text := stReal.Caption;
  edIPoC.Text := stImag.Caption;
	edMagnit.Text := FloatToStrF( Mandelb.Par.FMagnitud / 4, ffgeneral, 18, 22 );
  sbStart.Click;
  end;

procedure TMainForm.DoEvents( Sender: TObject; var Continue: boolean; Progress: Extended = -1 );
  var
    t: integer;
    elapsed: Cardinal;
  begin
	if ScrollBox1.visible then
		begin
    if progress = 0 then
      CrnStart := GetTickCount;

    elapsed := GetTickCount - CrnStart;
 		Crono.Caption:= MSecToStr( elapsed );
		if progress < 1 then
			begin
      if ( WindowState = wsMinimized ) or ( pnParam.Visible ) then
        begin
        if progress = -1 then // it needs recalculate it
          progress := Mandelb.GetPercentDrawn;
	  		t := round( 100 * Progress );
        if t <> percent.position then
          begin
          percent.position := t;
          PrepareCaption( t );
          end;
        end;
			end
		else
			begin
			percent.position:=0;
      PrepareCaption;
			end;
		percent.Invalidate;
		end;

  image1.Repaint;//	Invalidate repaints background too
  Crono.Invalidate;
    repeat
		Application.ProcessMessages;
  	until MandelSet.FState <> msPause;
  Continue := ( MandelSet.FState <> msStopping );
	end;

procedure TMainForm.cbPreviewClick(Sender: TObject);
  begin
  if cbPreview.Checked then
    ColorPreview;
  end;

function MsecToStr(Milli: Cardinal): string;
  var
    h, m, s: Cardinal;
  begin
  h := Milli div 3600000;
  milli := milli mod 3600000;
  m := Milli div 60000;
  milli := milli mod 60000;
  s := Milli div 1000;
  milli := milli mod 1000;
  Result := Format( '%2d:%.2d:%.2d.%.3d', [ h, m, s, milli ] );
  end;
  
procedure TMainForm.btRewClick(Sender: TObject);
  begin
  ColorCycling;
  end;

procedure TMainForm.btFForClick(Sender: TObject);
  begin
  ColorCycling;
  end;

procedure TMainForm.ColorCycling;
  var
    Step, Max, p: integer;
  begin
  Max := ttOffset.Max;
  Step := Trunc(Max div 250) + 1;
  p := ttOffset.Position;
  while not(btStop.Down) and not Application.Terminated do
    begin
    if btRew.Down then
      begin
      p := p - Step;
      if p < 0 then
        p := p + Max;
      end
    else //FFor
      begin
      p := p + Step;
      if p > Max then
        p := p - Max;
      end;
    ttOffset.Position := p;
{    if ( ttOffset.Position <> p ) or not btFFor.Down then
      begin
      btStop.Down := true;
      Exit;
      end;}
    end;
  end;

procedure TMainForm.SavetoDesktop1Click(Sender: TObject);
  var
    fn: string;
    wd: array[ 0 .. 31 ] of char; // buffer for windir
  begin
  GetWindowsDirectory( @wd, sizeof( wd ) );
  fn := wd + '\' +  MandelSet.FName + '.bmp';
  ShowMessage( 'Saved as ' + fn );
  Image1.Picture.SaveToFile( fn );
  SetWallPaper( fn, false );
  end;

procedure TMainForm.Colors1Click(Sender: TObject);
  var
    tms, dkk: extended;
    abc :string;
    k, tick : Cardinal;

  begin
  Screen.Cursor := crHourglass;
  tms:=0;
  tick := gettickcount;
  while tick + 5000 >= GetTickCount do
    begin
    for k := 1 to 50000 do
      begin
      Colors.FromIterToColor( 1.42566414285721 );
      Colors.FromIterToColor( 50.92566414285721 );
      end;
    tms := tms + 100000;
    end;
  tick := GetTickCount - tick;
  Screen.Cursor := crDefault;
  dkk := 1000.0 * tms / tick ;
  abc := FloatToStrF( dkk, ffFixed, 2, 22 );
  abc := Format( 'Iterations for second: %n', [ dkk ] );
  MessageDlg( abc, mtInformation, [ mbOK ], 0 );
  end;

procedure TMainForm.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  begin
  if shape1.cursor = crSize then
    begin
    YV := Y;
    XV := X;
    end;
  end;

procedure TMainForm.btPrevClick(Sender: TObject);
  begin
  UndoFractal1Click( self );
  end;

procedure TMainForm.Area1Click(Sender: TObject);
  var
    r1, r2, r3, r4: string;
    tp, mp: integer;
  begin
  mp := Mandelb.Info.FInsideCount;
  tp := Mandelb.Par.FWidth * Mandelb.Par.FHeight;
  r1 := Format( 'Mandelbrot points: %d on a total of %d', [ mp, tp ] );
  r2 := Format( 'Mandelbrot area: %g', [ mp * Mandelb.Par.FIncI * Mandelb.Par.FIncR ] );
  r3 := Format( 'Minimum value: %g', [ Mandelb.Info.FMin ] );
  r4 := Format( 'Maximum value (apart the set): %g', [ Mandelb.Info.FMax ] );
  ShowMessage( r1 + #13+ #13 + r2 + #13 + r3+ #13 + r4 );
  end;

procedure TMainForm.Edge1Click(Sender: TObject);
  begin
  Edge1.Checked := true;
  Mandelb.DoFilter( fkEdge );
  end;

procedure TMainForm.Bumper1Click(Sender: TObject);
  begin
  Bumper1.Checked := true;
  Mandelb.DoFilter( fkBumper );
  end;

procedure TMainForm.Heights1Click(Sender: TObject);
  begin
  Heights1.Checked := true;
  Mandelb.DoFilter( fkHeight );
  end;

procedure TMainForm.Noise1Click(Sender: TObject);
  begin
  Noise1.Checked := true;
  Mandelb.DoFilter( fkNoise );
  end;

procedure TMainForm.None1Click(Sender: TObject);
  begin
  None1.Checked := true;
  Mandelb.DoFilter( fkNone );
  end;

procedure TMainForm.Lines1Click(Sender: TObject);
  begin
  Lines1.Checked := true;
  Mandelb.DoFilter( fkLines );
  end;

procedure TMainForm.Crystals1Click(Sender: TObject);
  begin
  Crystals1.Checked := true;
  Mandelb.DoFilter( fkCristals );
  end;

procedure TMainForm.Equalizecolors1Click(Sender: TObject);
  begin
  Equalizecolors1.Checked := true;
  Mandelb.DoFilter( fkEqColors );
  end;

procedure TMainForm.ttOffsetChange(Sender: TObject);
  begin
  Colors.Offset := ( ttoffset.Position / ttoffset.max );
  Mandelb.Redraw;
  MouseCapture := False;
  end;

procedure TMainForm.Summary1Click(Sender: TObject);
  var
    HelpPath: string;
	begin
  HelpPath := ExtractFilePath( Application.ExeName ) + Application.HelpFile;
  if FileExists( HelpPath ) then
    ShellExecute(	Handle, 'open',	pchar( HelpPath ), pchar( HelpPath ), '', SW_SHOW )
  else
    ShowMessage( 'Help not found: ' + HelpPath );
	end;


procedure TMainForm.WMDropFiles(var Msg: TWMDROPFILES);
  var
    NumFiles : longint;
    buffer : array[0..255] of char;
    fn: string;
  begin
  NumFiles := DragQueryFile( Msg.Drop, $FFFFFFFF, nil, 0);
  if NumFiles > 0 then
    begin
    DragQueryFile( Msg.Drop, 0, @buffer, sizeof(buffer));
      try
      fn := buffer;
      if LoadFile( fn ) then
        begin
        DrawLoadedFile;
        end;
      finally
      DragFinish( Msg.Drop );
      end;
    end;
  end;

procedure TMainForm.FullScreen1Click(Sender: TObject);
  begin
  FullScreenMode1.Checked := not FullScreenMode1.Checked;
  if FullScreenMode1.Checked then
    begin
    BorderStyle := bsNone;
    pnParam.visible := false;
    Menu := nil;
    FFSMRect := BoundsRect;
    SetBounds( 0, 0, screen.Width, screen.height );
    ShowcontrolPanel1.Enabled := False;
    end
  else
    begin
    BorderStyle := bsSizeable;
    pnParam.visible := ShowcontrolPanel1.Checked;
    if not assigned( Menu ) then
      Menu := MainMenu1;
    BoundsRect := FFSMRect;
    ShowcontrolPanel1.Enabled := true;
    end;
  end;

procedure TMainForm.edNameChange(Sender: TObject);
  begin
  PrepareCaption;
  end;

procedure TMainForm.ShowJulia1Click(Sender: TObject);
  begin
  FrJulia.ResetColors( Colors.FileName );
  FrJulia.show;
  end;

procedure TMainForm.SuperPoster2Click(Sender: TObject);
  var
    nx, ny, kx, ky: integer;
    julia: boolean;
    kmx, kcr, kci, km, m, cr, ci: Extended;
  begin
  with TFrTiledImage.Create( Application ) do
    try
    edVtiles.Text := '4';
    edHtiles.Text := '4';
    edWidth.Text := MandelSet.FWidth;
    edHeight.Text := MandelSet.FHeight;
    if ShowModal <> mrOk then
      Exit;
    // start calculating
    UpDateMandelSet;
    nx := StrToIntDef( edHTiles.Text, -1 );
    ny := StrToIntDef( edVTiles.Text, -1 );
    MandelSet.FWidth := edWidth.Text;
    MandelSet.FHeight := edHeight.Text;
    julia := MandelSet.FJulia;
    if julia then
      begin
      cr := StrToFloat( MandelSet.FRealPert );
      ci := StrToFloat( MandelSet.FImagPert );
      end
    else
      begin
      cr := StrToFloat( MandelSet.FCentReal );
      ci := StrToFloat( MandelSet.FCentImag );
      end;
    m := StrToFloat( MandelSet.FMagnitud );
    km := m * max(ny, nx);
    kmx := StrToFloat( MandelSet.FHeight ) / StrToFloat( MandelSet.FWidth );
    kmx := kmx * km; // Magnitudo is calculated by Y axis so I have to adjust it for X axis
    MandelSet.FMagnitud := FloatToStr( km );
    for kx := 1 to nx do
      for ky := 1 to ny do
        begin
        kcr := cr + ( kx - 0.5 - nx / 2 ) / kmx;
        kci := ci + ( - ky + 0.5 + ny / 2 ) / km;
        if julia then
          begin
          MandelSet.FRealPert := FloatToStr( kcr );
          MandelSet.FImagPert := FloatToStr( kci );
          end
        else
          begin
          MandelSet.FCentReal := FloatToStr( kcr );
          MandelSet.FCentImag := FloatToStr( kci );
          end;
        MandelSet.FName := edName.Text + Format( '%.2d%.2d', [ kx, ky ] );
        MandelSetToRUParameters;
          try
          NewMandelSet;
          startMandel( false, false );
          except
          if MessageDlg( 'Do you want to continue with next image ?', mtConfirmation, [ mbYes, mbNo ], 0 ) = mrNo then
            exit;
          end;
        case rgExt.ItemIndex of
          0: SavePng( edDir.Text + PathDelim + MainForm.MandelSet.FName + '.png' );
          1: SaveJpg( edDir.Text + PathDelim + MainForm.MandelSet.FName + '.jpg' );
          else
            Image1.Picture.SaveToFile( edDir.Text + PathDelim + MainForm.MandelSet.FName + '.bmp' )
          end;
        end;
    finally
    Free;
    end;
  end;

function TMainForm.GAverage(Num1, Num2: Extended; Step, Steps: integer): Extended;
begin
  result := Ln(Num1);
  result := Exp( result + ( ( Ln( Num2 ) - result ) * ( Step / Steps ) ) );
end;

procedure TMainForm.Animator1Click(Sender: TObject);
  var
    sn, n, i, fps: integer;
    julia: boolean;
    kit, kcr, kci, km, cr, ci: Extended;
    i1, i2, cr1, ci1, m1, cr2, ci2, m2: Extended;
    kmt, kmc: Extended;
  begin
  with TFrAnimator.Create( Application ) do
    try
    julia := MandelSet.FJulia;
    if julia then
      begin
      cr := StrToFloat( MandelSet.FRealPert );
      ci := StrToFloat( MandelSet.FImagPert );
      end
    else
      begin
      cr := StrToFloat( MandelSet.FCentReal );
      ci := StrToFloat( MandelSet.FCentImag );
      end;

    edRPoC1.Text := FloatToStr(cr);
    edRPoC2.Text := FloatToStr(cr);
    edIPoC1.Text := FloatToStr(ci);
    edIPoC2.Text := FloatToStr(ci);
    edMagnit1.Text := MandelSet.FMagnitud;
    edMagnit2.Text := MandelSet.FMagnitud;
    edMaxIter1.Text := MandelSet.FIter;
    edMaxIter2.Text := MandelSet.FIter;
    edDir.Text := AviPath;
    inc( NAvi );
    edName.Text := Format( 'FF%.2d', [NAvi] );
    if ShowModal = mrCancel then
      Exit;
    AviPath := edDir.Text;
    // start calculating
    UpDateMandelSet;
    n := StrToIntDef( edNum.Text, -1 );
    fps := StrToIntDef( edFPS.Text, -1 );
    sn := StrToIntDef( edStarting.Text, -1 );
    cr1 := StrToFloat( edRPoC1.Text );
    cr2 := StrToFloat( edRPoC2.Text );
    ci1 := StrToFloat( edIPoC1.Text );
    ci2 := StrToFloat( edIPoC2.Text );
    m1  := StrToFloat( edMagnit1.Text );
    m2  := StrToFloat( edMagnit2.Text );
    i1  := StrToFloat( edMaxIter1.Text );
    i2  := StrToFloat( edMaxIter2.Text );

    kmt := 0;
    for i := 0 to n - 1 do
      begin
      km := GAverage( m1, m2, i, n - 1 );
      kmt := kmt + 1 / km;
      end;

    kmc := 0;
    for i := 0 to n - 1 do
      begin
    //geometric average
      km := GAverage( m1, m2, i, n - 1 );
      kmc := kmc + 1 / km;
      kit := Round(GAverage( i1, i2, i, n - 1 ));
    //arithmetic average
      kcr := cr1 + ( ( cr2 - cr1 ) * ( kmc / kmt ) );
      kci := ci1 + ( ( ci2 - ci1 ) * ( kmc / kmt ) );

      MandelSet.FMagnitud := FloatToStr( km );
      MandelSet.FIter := FloatToStr( kit );
      if julia then
        begin
        MandelSet.FRealPert := FloatToStr( kcr );
        MandelSet.FImagPert := FloatToStr( kci );
        end
      else
        begin
        MandelSet.FCentReal := FloatToStr( kcr );
        MandelSet.FCentImag := FloatToStr( kci );
        end;
      MandelSet.FName := edName.Text + Format( '%.4d', [ i+sn ] );
      MandelSetToRUParameters;
        try
        NewMandelSet;
        StartMandel( False, False );
        except
        if MessageDlg( 'Do you want to continue with next image ?', mtConfirmation, [ mbYes, mbNo ], 0 ) = mrNo then
          exit;
        end;
        Image1.Picture.SaveToFile( IncludeTrailingPathDelimiter( edDir.Text ) + MainForm.MandelSet.FName + '.bmp' );
      end;

    if cbAvi.Checked then // launch AviCreator
      CreateAviFromDir(edDir.Text, AviName, fps, cbDeleteBmp.Checked, CbAvi.Checked);
    finally
    Free;
    end;
  end;

procedure TMainForm.AviCreating(Sender: TObject; Percent: integer; var Continue: Boolean);
  begin
  PrepareCaption(Percent, 'Creating Avi');
  Refresh;
  end;

procedure TMainForm.AviSaving(Sender: TObject; Percent: integer; var Continue: Boolean);
  begin
  PrepareCaption(Percent, 'Saving Avi');
  Refresh;
  end;

procedure TMainForm.CreateAviFromDir(DirName, AviName: string; Fps: integer; DelFiles, PlayAvi: Boolean);
  var
    sr: TSearchRec;
    path: string;
    AviW: TAviWriter;
  begin
  AviW := TAviWriter.Create(nil);
    try
    AviW.OnCreating := AviCreating;
    AviW.OnSaving := AviSaving;
    AviW.DeleteFiles := DelFiles;
    AviW.PlayAvi := PlayAvi;
    AviW.FrameTime := 1000 div Fps;
    path := IncludeTrailingPathDelimiter(DirName);
    if FindFirst(path + '*.bmp', faAnyFile, sr) = 0 then
      try
        repeat
        AviW.BitmapNames.Add(path + sr.Name);
        until FindNext(sr) <> 0;
      finally
      FindClose(sr);
      end;
    AviW.FileName := AviName;
    AviW.Write;
    finally
    AviW.Free;
    PrepareCaption;
    end;
  end;

procedure TMainForm.CopyCoordinates1Click(Sender: TObject);
  begin
  Clipboard.AsText := GetDataAsText( True );
  end;

procedure TMainForm.Colorbumper1Click(Sender: TObject);
  begin
  Colorbumper1.Checked := true;
  Mandelb.DoFilter( fkColorBumper );
  end;

procedure TMainForm.Sharpenedges1Click(Sender: TObject);
  begin
  Sharpenedges1.Checked := true;
  Mandelb.DoFilter( fkUnsharpMask );
  end;


procedure TMainForm.New1Click(Sender: TObject);
  begin
  StartMandel( True );
  end;

procedure TMainForm.cbFormulaClick(Sender: TObject);
  begin
  if ActiveControl = cbFormula then
    StartMandel( True );
  end;

procedure TMainForm.cbApplyClick(Sender: TObject);
  begin
  if ActiveControl = cbApply then
    StartMandel( True );
  end;

procedure TMainForm.cbAlgoClick(Sender: TObject);
  begin
  if ActiveControl = cbAlgo then
    StartMandel( True );
  end;

procedure TMainForm.JuliaHere1Click(Sender: TObject);
  begin
  edRealPerturbation.Text := stReal.Caption;
  edImagPerturbation.Text := stImag.Caption;
  edMagnit.Text := '0.3';
  edIter.Text := '100';
  edRPoC.Text := '0';
  edIPoC.Text := '0';
  cbJulia.Checked := True;
  sbStart.Click;
  end;

procedure TMainForm.PopupImagePopup(Sender: TObject);
  begin
  JuliaHere1.Enabled := not cbJulia.Checked;
  end;

procedure TMainForm.Average1Click(Sender: TObject);
begin
  Average1.Checked := True;
  Mandelb.DoFilter( fkAverage );
end;

function TMainForm.MultiCpu: Boolean;
var
  v: string;
begin
  v := GetEnvironmentVariable('NUMBER_OF_PROCESSORS');
  Result := StrToIntDef(v, 1) > 1;
//for debug Result := True;
end;

initialization
  begin
  ColorsPath := IncludeTrailingPathDelimiter( ExtractFilePath( Application.ExeName ) ) + 'colors' + PathDelim;
  ImagesPath := IncludeTrailingPathDelimiter( ExtractFilePath( Application.ExeName ) ) + 'images' + PathDelim;
  end;
end.


