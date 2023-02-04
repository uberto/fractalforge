unit Mandelbrot;

interface

uses
	Windows, SysUtils, Messages, Classes, Graphics, Controls,
	Forms, Dialogs, Graphic, Colors, Math, Complex;//ComplexMathLibrary; //Complex;

type

	TMandelState = (msRun, msPause, msStopped, msDone, msNone, msSaved, msStopping);

  TThreadBounded = class;

	TMandelPtr= ^TMandelSet;
	TMandelSet = record
		FVersion	  : string[32];
		FImageFile	: string[255];
		FName	      : string[32];
		FCentReal 	: string[32];
		FCentImag 	: string[32];
		FMagnitud  	: string[32];
		FAlgo     	: string[16];
    FIter 	    : string[16];
		FOffset 	  : string[16]; // was FIfGreater
    FWidth 	    : string[16];
    FHeight 	: string[16];
		FAspectR	: string[16];
    FPriority	: string[16];
    FJulia	: boolean;
    FColors    	: string[24];
    FBailout	: string[32];
    FRealPert	: string[32];
    FImagPert	: string[32];
		FApplyC	: string[16];
		FFormula    : string[16];
    FComments	: string[255];
    FState	: TMandelState;
    FTime 	: string[32];// was FCrono
    FCrono 	: string[16]; // was FSteps
		FReserved	: string[16];
  end;

	TFormulaF = (ffQuad, ffCube, ffForth, ffEight, ffZed, ffSqSingle, ffLambda, ffZedC, ffSin, ffSinTan, ffSpider, ffMagnetism, ffDoubleTail);

	TApplyC = ( Iter, Vepstas, Real, Imag, Sum, IntMod, IntRadiant, Prod, SumI, BioM, Radiant, IterRad );

  TMandAlgo = ( maInterp256, maInterp8, maInterpEven, maPlain, maBounded, maBoundedMP, maDraft, maOrbits );

  TFilterKind = ( fkNone, fkEdge, fkBumper, fkHeight, fkNoise, fkLines, fkCristals, fkEqColors, fkColorBumper, fkUnsharpMask, fkAverage );

  TMandParameters = record
    // init given parameters
    FCentReal: Extended;
    FCentImag: Extended;
    FMagnitud: Extended;
    FIter: Extended;
    FWidth: Integer;
    FHeight: Integer;
    FAspectR: Extended;
    FJulia: Boolean;
    FBailout: Integer;
    FRealPert: Extended;
    FImagPert: Extended;
    FApplyC: TApplyC;
    FFormula: TFormulaf;
    FAlgo: TMandAlgo;
    // init calculated parameters
    FMaxIterVal	: Extended; // max value. Usually equal to FIter but it can be different in some formulas
    FCQuad: Boolean;
    FIncI: Extended;
    FIncR: Extended;
    FMinCR: Extended;
    FMinCI: Extended;
    FExtraPar1: Extended; //was ValItr
    FExtraPar2: Extended;
  end;

  TProgrEvent = procedure ( Sender: TObject; var Continue: boolean; Progress: Extended = -1 ) of object;

  TMandelInfo = record
    FInsideCount: Cardinal;
    FMin: Extended;
    FMax: Extended; // excluded points inside the Set
  end;

  TMandelbrot = class
    private
      Bmp: TBitmap;
      MandelSet: TMandelSet;
      FProdVers: string;
      values: array of Extended;
      FOnProgress: TProgrEvent;
      FTimer: Cardinal;
      FInfo: TMandelInfo;
      FFilter: TFilterKind;
      FPrevFilter: TFilterKind;
      FMndcount: Cardinal;
      FLastTime: Cardinal;
      function Getvalue( x, y : integer ): Extended;
      procedure Orbit;
      function  BorderEqual( ARect: TRect ): extended;
      procedure CalculateBorders( ARect: TRect );
      procedure Enclose( Rect: TRect; BordersDone: boolean);
      function  BordersEqual( x, y, step: integer; Adiacents, Diagonals: boolean; var val: extended ): boolean;
      procedure Draft( Step: integer );
      procedure Interpolate( Step: integer );
      procedure Pass( IsOdd: boolean; Step: integer; Interpolate: boolean );
      procedure FillVal( ARect: TRect; AValue: Extended; ValOnly: boolean );
      procedure Fill(ARect: TRect; AValue: Extended );
      procedure TraceBar( Horizontal: boolean; ARect: Trect; var r1, r2: TRect );
      procedure DrawAll( step: integer );
      procedure SetOnProgress(const Value: TProgrEvent);
      procedure SetTimer(const Value: Cardinal);
      procedure CutBorders(var Rect: TRect);
      function  FilteredValuesToCol( Filter: TFilterKind; Val, ValUp, ValDown, ValLeft, ValRight: extended ): TRGBTriple;
      procedure ResetInfo;
    protected
      FCritical: _RTL_CRITICAL_SECTION;
      function UpdatePar( AMandelSet: TMandelSet ): boolean;
      function FixParameters: boolean;
    public
      Par: TMandParameters;
      Colors : TColorize;
      constructor Create(ABitmap: TBitmap; const ProdVers: string);
      destructor Destroy; override;
      procedure Prepare( AMandelSet: TMandelSet; AColors: TColorize );
      procedure Render( UpdatingInfo: boolean = true );
      function  AlgMndFlt( CR, CI :Extended ): extended;
      function GetPercentDrawn: Extended;
      procedure UpdateInfo;
      procedure Redraw;
      procedure DoProgress( Progress: Extended = -1 );
      procedure DoFilter( AFilter: TFilterKind; KeepProgr: Boolean = True);
      procedure RestoreFilter;
      procedure StoreFilter;
      procedure MandelSetDefault( var AMandelset: TMandelSet );
      property  Info: TMandelInfo read FInfo;
    published
      property  ProgressTimer: Cardinal read FTimer write SetTimer;
      property  OnProgress: TProgrEvent read FOnProgress write SetOnProgress;
    end;

  TThreadBounded = class( TThread )
    private
      FMandelbrot: TMandelbrot;
      FRect: TRect;
      FLastTime: Cardinal;
      FTimer: Cardinal;
    public
      constructor Create( AMandelbrot: TMandelbrot; ARect: TRect );
      procedure Execute; override;
    end;

implementation

{ TThreadBounded }

constructor TThreadBounded.Create( AMandelbrot: TMandelbrot; ARect: TRect );
  begin
  inherited Create( True );
  FreeOnTerminate := True; //False;
  FMandelbrot := AMandelbrot;
  FLastTime := 0;
  FTimer := 500;
  FRect := ARect;
  Resume;
  end;

procedure TThreadBounded.Execute;
  begin
    try
    FMandelbrot.Enclose( FRect, False );
    finally
    Terminate;
    end;
  end;

{ TMandelbrot }

function TMandelbrot.Getvalue( x, y : integer ): Extended;
  begin
  with Par do
    if ( x >= 0 ) and ( x < FWidth ) and ( y >= 0 ) and ( y < FHeight ) then
      Result := values[ x + y * FWidth ]
    else
      Result := 0;
  end;

procedure TMandelbrot.DrawAll( step: integer );
  var
    nv, ky, kx: integer;
    CurrLine :  PRGBArray;
    v: Extended;
    tCol : TRGBTriple;
    kys: boolean;
  begin
  nv := -1;
  with Par do
    for ky := 0 to FHeight - 1 do
      begin
      CurrLine :=  PRGBArray( Bmp.ScanLine[ ky ] );
      kys := ( ( ky mod step ) = 0 );
      for kx := 0 to FWidth - 1 do
        begin
        if step = 1 then
          inc( nv )
        else if ( kx mod step ) = 0 then
          begin
          if kys then
            nv := ky * fwidth + kx
          else
            nv := ( ky div step ) * step * fwidth + kx;
          end;

        v := values[ nv ];
        tCol := Colors.FromIterToColor( v );
        SwitchRB( tcol );
        CurrLine[ kx ] := tCol;
        end;
      end;
  end;

procedure TMandelbrot.Orbit;
  var
    pcy, step, pcx, maxv: Extended;
    i, kx, ky, nv : integer;
		oldzpr, zpr, zpi: extended;
    v, tmpv: Extended;
  begin
  with Par do
    begin
    maxv := 0;
    step := 1 / ( FMagnitud * FHeight );
    nv := 0;
    for ky := 0 to FHeight - 1 do
      begin
      pcy := ( FHeight shr 1 - ky ) * step + FCentImag;
      for kx := 0 to FWidth - 1 do
        begin
        pcx := ( kx - ( FWidth shr 1 ) ) * step + FCentReal;
        zpr := 0;
        zpi := 0;
        i := 0;
        v := 0;
        while i < FIter do
          begin
          inc(i);
          oldzpr := zpr;
          zpr := zpr*zpr - zpi*zpi + pcx;
          zpi := 2*zpi*oldzpr + pcy;
          tmpv := arctan2( abs( zpi - pcy ), abs( zpr - pcx )  ); // distance
           v := v + tmpv;
          if zpr*zpr + zpi*zpi > FBailout then //4 = 2^2
            break;
          end;
        values[ nv ] := v;
        inc( nv );
        if v > maxv then
          maxv := v;
        end;
      end;
    FMaxIterVal := maxv;
    Colors.MaxIter := round( FMaxIterVal );
    end;
  DrawAll( 1 );
  end;

function TMandelbrot.BordersEqual( x, y, step: integer; Adiacents, Diagonals: boolean; var val: extended ): boolean;
  var
    i: Extended;
  begin
  i := 0;
  if Adiacents then
    begin
    i := getvalue( x - step, y );
    Result := ( i > 0 ) and ( i = getvalue( x + step, y ) ) and ( i = getvalue( x, y - step ) ) and ( i = getvalue( x, y + step ) );
    end
  else
    Result := true;
  if Diagonals then
    begin
    i := getvalue( x - step, y - step );
    Result := Result and ( i > 0 ) and ( i = getvalue( x + step, y - step ) ) and ( i = getvalue( x - step, y + step ) ) and ( i = getvalue( x + step, y + step ) );
    end;
  if Result then
    val := i;
  end;


procedure TMandelbrot.Pass( IsOdd: boolean; Step: integer; Interpolate: boolean );
  var
    my, kx, ky, x, y, nv: integer;
    CurrLine :  PRGBArray;
    v, pcx, pcy: Extended;
    tCol : TRGBTriple;
  begin
  with Par do
    begin
    my := ( FHeight - 1 ) div Step;
    if IsOdd and Interpolate then
      my := my shr 1;
    for ky := 0 to my do
      begin
      y := ky * Step;
      if IsOdd and Interpolate then
        y := y shl 1 + Step;
      if y >= FHeight then
        break;

      pcy := ( FHeight shr 1 - y ) * FincI + FCentImag;
      CurrLine :=  PRGBArray( Bmp.ScanLine[ y ] );
      if IsOdd and Interpolate then
        x := Step
      else if not IsOdd xor odd( ky ) then
        x := Step
      else
        x := 0;
      for kx := 0 to ( FWidth - 1 ) div ( Step shl 1 ) do
        begin
        if x >= FWidth then
          break;
        nv := x + y * FWidth;
        if values[ nv ] = 0 then
          begin // da calcolare
          if Interpolate and BordersEqual( x, y, Step, not IsOdd, IsOdd, v ) then
            begin
            if IsOdd then
              tCol := PRGBArray( Bmp.ScanLine[ y - Step ] ) [ x - Step ]
            else
              tCol := CurrLine[ x - Step ];
            end
          else
            begin
            pcx := ( x - ( FWidth shr 1 ) ) * FincR + FCentReal;
            v := AlgMndFlt( pcx, pcy ); //   Mandel(pcx, pcy, max);
            tCol := Colors.FromIterToColor( v );
            SwitchRB( tcol );
            end;
          values[ nv ] := v;
          CurrLine[ x ] := tCol;
          end;
        inc( x, Step shl 1 );
        end;
      end;
    DoProgress;
    end;
  end;

procedure TMandelbrot.Draft( Step: integer );
  begin
  Pass( true, Step, false );
  Pass( false, Step, true );
    repeat
    Step := Step shr 1;
    Pass( true, Step, true );
    DoProgress;
    Pass( false, Step, true );
    DoProgress;
    until ( Step <= 8 ) or Application.Terminated;
  DrawAll( 8 );
  end;

procedure TMandelbrot.Interpolate( Step: integer );
  begin
  Pass( true, Step, false );
  Pass( false, Step, true );
    repeat
    Step := Step shr 1;
    Pass( true, Step, true );
    Pass( false, Step, true );
    until ( Step = 1 ) or Application.Terminated;
  end;

procedure TMandelbrot.Fill( ARect: TRect; AValue: Extended );
  begin
  FillVal( ARect, AValue, false );
  end;

procedure TMandelbrot.FillVal( ARect: TRect; AValue: Extended; ValOnly: boolean );
  var
    CurrLineDiff, kx, ky, nv: integer;
    CurrLine :  PRGBArray;
    pcx, pcy, v: Extended;
    tcol: TRGBTriple;
    totalarea, longline: boolean;
  begin
  with ARect do
    begin
    totalarea := ( Left = 0 ) and ( Top = 0 ) and ( Right = Bmp.Width - 1 ) and ( Bottom = Bmp.Height - 1 );
    longline := ( Right - Left > 256 ) or ( Bottom - Top > 256 );
    end;
  with Par do
    begin
    v := AValue;
    CurrLine := PRGBArray( Bmp.ScanLine[ ARect.Top ] );
    if ARect.Top <> ARect.Bottom then
      begin
      CurrLineDiff := integer( Bmp.ScanLine[ ARect.Top + 1 ] ) - integer( CurrLine );
      CurrLine := PRGBArray( integer( CurrLine ) - CurrLineDiff );
      end
    else
      CurrLineDiff := 0;
    if not ValOnly then
      begin
      tcol := Colors.FromIterToColor( Avalue );
      SwitchRB( tcol );
      end;
    for ky := ARect.Top to ARect.Bottom do
      begin
      pcy := ( FHeight shr 1 - ky ) * FincI + FCentImag;
      if not ValOnly then
        CurrLine := PRGBArray( integer( CurrLine ) + CurrLineDiff );
      for kx := ARect.Left to ARect.Right do
        begin
        nv := kx + ky * FWidth;
        if AValue = 0 then
          begin
          pcx := ( kx - ( FWidth shr 1 ) ) * FincR + FCentReal;
          v := AlgMndFlt( pcx, pcy );
          if not ValOnly then
            begin
            tcol := Colors.FromIterToColor( v );
            SwitchRB( tcol );
            end;
          end;
        values[ nv ] := v;
        if not ValOnly then
          CurrLine[ kx ] := tCol;
        end;
      if totalarea then
        DoProgress( ky / ARect.Bottom );
      end;
    if longline then
      DoProgress;
    end;
  end;

procedure TMandelbrot.CalculateBorders( ARect: TRect );
  var
    bar: TRect;
  begin
  bar := rect( ARect.Left, ARect.Top, ARect.Right, ARect.Top ); // Top
  Fill( bar, 0 );
  bar := rect( ARect.Left, ARect.Bottom, ARect.Right, ARect.Bottom ); //Bottom
  Fill( bar, 0 );
  bar := rect( ARect.Left, ARect.Top + 1, ARect.Left, ARect.Bottom - 1 ); // left
  Fill( bar, 0 );
  bar := rect( ARect.Right, ARect.Top + 1, ARect.Right, ARect.Bottom - 1 ); // right
  Fill( bar, 0 );
  end;

function TMandelbrot.BorderEqual( ARect: TRect ): extended;
  var
    k, nv: integer;
    v: Extended;
  begin
  with Par do
    begin
    Result := 0; // worst condition
    // first check the 4 corners
    nv := ARect.Left + ARect.Top * FWidth;
    v := values[ nv ];
    nv := ARect.Right + ARect.Top * FWidth;
    if v <> values[ nv ] then
      exit;
    nv := ARect.Right + ARect.Bottom * FWidth;
    if v <> values[ nv ] then
      exit;
    nv := ARect.Left + ARect.Bottom * FWidth;
    if v <> values[ nv ] then
      exit;

    for k := ARect.Left + 1 to ARect.Right - 1 do
      begin
      nv := k + ARect.Top * FWidth;
      if v <> values[ nv ] then
        exit;
      nv := k + ARect.Bottom * FWidth;
      if v <> values[ nv ] then
        exit;
      end;

    for k := ARect.Top + 1 to ARect.Bottom - 1 do
      begin
      nv := ARect.Left + k * FWidth;
      if v <> values[ nv ] then
        exit;
      nv := ARect.Right + k * FWidth;
      if v <> values[ nv ] then
        exit;
      end;
    end;
  Result := v;
  end;

procedure TMandelbrot.TraceBar( Horizontal: boolean; ARect: Trect; var r1, r2: TRect );
  var
    Bar: TRect;
  begin
  if Horizontal then
    begin
    Bar.Left := ARect.Left + 1 ;
    Bar.Right := ARect.Right - 1;
    Bar.Top := ( ARect.Bottom + ARect.Top ) shr 1;
    Bar.Bottom := Bar.Top;

    r1 := rect( ARect.Left, ARect.Top, ARect.Right, Bar.Bottom );
    r2 := rect( ARect.Left, Bar.Top, ARect.Right, ARect.Bottom );
    end
  else
    begin
    Bar.Left := ( ARect.Right + ARect.Left ) shr 1;
    Bar.Right := Bar.Left;
    Bar.Top := ARect.Top + 1;
    Bar.Bottom := ARect.Bottom - 1;

    r1 := rect( ARect.Left, ARect.Top, Bar.Right, ARect.Bottom );
    r2 := rect( Bar.Left, ARect.Top, ARect.Right, ARect.Bottom );
    end;
  FillVal( Bar, 0, False );
  end;


procedure TMandelbrot.Enclose( Rect: TRect; BordersDone: boolean );
  var
    hr, wr : integer;
    r1, r2: TRect;
    bu: Extended;
  begin
  wr := Rect.Right - rect.Left;
  hr := Rect.Bottom - rect.Top;

  if ( wr <= 12 ) and ( hr <= 12 ) then
    begin // too small
    CutBorders( Rect );
    Fill( Rect, 0 );
    exit;
    end;

  if not BordersDone then
    CalculateBorders( Rect );

  bu := BorderEqual( Rect );
  if ( bu > 0 ) and ( wr < Par.FWidth ) then // skip the first time
    begin // Fill solid
    CutBorders( Rect );
    Fill( Rect, bu );
    exit;
    end;

  if ( wr >= 32 ) and ( hr >= 32 ) then
    DoProgress;

  TraceBar( ( wr < hr ), Rect, r1, r2 );
  Enclose( r1, true );
  Enclose( r2, true );
  end;

procedure TMandelbrot.CutBorders( var Rect: TRect );
  begin
  with Rect do
    begin
    inc( Left );
    inc( Top );
    dec( right );
    dec( bottom );
    end;
  end;

procedure TMandelbrot.Prepare( AMandelSet: TMandelSet; AColors: TColorize );
  var
    i: integer;
  begin
  if AMandelSet.FVersion = '' then
    FixParameters
  else
    UpdatePar( AMandelSet );
  if assigned( Bmp ) then
    begin
    SetLength( values, par.FWidth * par.FHeight );
    for i := 0 to high(values) do
      values[i] := 0; // set all to zeros
    Bmp.Width := par.FWidth;
    Bmp.Height := par.FHeight;
    Bmp.PixelFormat := pf24bit;
    end;
  if assigned( AColors ) then
    begin
    Colors := AColors;
    Colors.MaxIter := round( par.fiter );
    end;
  end;

procedure TMandelbrot.Render(UpdatingInfo: boolean = true);
  var
    tb1, tb2, tb3, tb4 : TThreadBounded;
    hh, hw: integer;
  begin
  FFilter := fkNone;
  if UpdatingInfo then
    begin
    ResetInfo;
    DoProgress( 0 );
    end;

    try
    case par.FAlgo of
      maInterp256:
        begin
        Interpolate( 256 );
        end;
      maInterp8:
        begin
        Interpolate( 8 );
        end;
      maPlain:
        begin
        Fill( rect( 0, 0, par.FWidth - 1, par.FHeight - 1 ), 0 );
        end;
      maInterpEven:
        begin
        Pass( true, 1, false );
        DoProgress;
        Pass( false, 1, true );
        end;
      maOrbits:
        begin
        Orbit;
        end;
      maDraft:
        begin
        Draft( 256 );
        end;
      maBoundedMP:
        begin
        hw := par.FWidth div 2;
        hh := par.FHeight div 2;
        tb1 := TThreadBounded.Create( self, Rect( 0, 0, hw - 1, hh - 1 ) );
        tb2 := TThreadBounded.Create( self, Rect( hw, 0, par.FWidth - 1, hh - 1 ) );
        tb3 := TThreadBounded.Create( self, Rect( 0, hh, hw - 1, par.FHeight - 1 ) );
        tb4 := TThreadBounded.Create( self, Rect( hw, hh, par.FWidth - 1, par.FHeight - 1 ) );
        while not ( tb4.Terminated and tb3.Terminated and tb2.Terminated and tb1.Terminated ) do
          begin
          Application.ProcessMessages;
          end;
        end
      else  //  maBounded:
        begin
        Enclose( rect( 0, 0, par.FWidth - 1, par.FHeight - 1 ), false );
        end;
      end;
    finally
    FFilter := fkNone;
    if UpdatingInfo then
      begin
      DoProgress( 1 );
      UpdateInfo;
      end;
    end;
  end;

constructor TMandelbrot.Create(ABitmap: TBitmap; const ProdVers: string);
  begin
  FProdVers := ProdVers;
  Bmp := ABitmap;
  SetLength( values, 0 ); // mette anche a zero
  MandelSetDefault( Mandelset );
  FTimer := 100;
  FLastTime := 0;
  InitializeCriticalSection(FCritical);
  end;

function TMandelbrot.AlgMndFlt(CR,CI :extended): Extended;
  var
    mi, Realqv,Sumqv,Imagqv,Realnv,Dprodv,Imagnv,PR,PI: extended;
    MaxItr, Iterv : integer;
    zeta, c, t1, t2: Tcomplex;
  begin
  with Par do
    begin
    mi := FBailout; // MaxVal;
    MaxItr := round( FIter );
    Iterv := MaxItr;
    if FCQuad then
      begin
      PR:=2*CR*CI;
      CR:=CR*CR-CI*CI;
      CI:=PR;
      end;
    PR := par.FRealPert;
    PI := par.FImagPert;

    if FJulia then
      begin
      PR := CR;
      PI := CI;
      CR := par.FRealPert;
      CI := par.FImagPert;
      end;

    case FFormula of
    ffQuad:
    asm
      mov ECX, Iterv
      mov DX, 4100h	   {Flags}
      fld mi           {MaxVal                       R7}
      fld CR               {CR                           R6}
      fld CI               {CI                           R5}
      fld PI               {ZqI                          R4}
      fld st(0)            {DPZ:=ZqI                     R3}
      fmul st(1),st        {ZqI:=ZqI*DPZ                 R3}
      fadd st,st           {DPZ:=DPZ+DPZ                 R3}
      fld PR               {ZqR                          R2}
      fmul st(1),st        {DPZ:=DPZ*ZqR                 R2}
      fmul st,st           {ZqR:=ZqR*ZqR                 R2}
      fadd st,st(4)        {ZqR:=ZqR+CR                  R2}
      fsub st,st(2)        {ZqR:=ZqR-ZqI                 R2}

      @@start:
      fld  st(0)           {temp:=ZqR                    R1}
      fmul st(1),st        {ZqR:=ZqR*temp                R1}
      fadd st, st(0)       {temp:=temp+temp              R1}
      fxch st(2)           {temp:=DPZ  DPZ:=temp         R1}
      fadd st, st(4)       {temp:=temp+CI                R1}
      fmul st(2),st        {DPZ:=DPZ*temp                R1}
      fmul st, st          {temp:=temp*temp              R1}
      fst  st(3)           {ZqI:=temp                    R1}
      fadd st, st(1)       {temp:=ZqR+ZqI                R1}
      fcomp st(6)          {temp:=temp-MaxVal            R2}
      fstsw AX             {salva 80x87 cond.code        R2}
      fadd st,st(4)        {ZqR:=ZqR+CR                  R2}
      test AX,DX           {test flag carry e zero       R2}
      fsub st,st(2)        {ZqR:=ZqR-ZqI                 R2}
      loopnz @@start

      mov EAX,iterv
      sub EAX,ECX
      mov Iterv,EAX
      fadd st,st(2)
      fsub st,st(4)
      fstp Realqv            {R3}
      fstp DProdv            {R4}
      fstp Imagqv            {R5}
      finit
      @@Fine:
      end;
    {  This is corresponding pascal code
    while ((Itr < MaxItr) and (ZqR+ZqI < MaxVal)) do
      begin
      inc(Itr);
      ZR:=ZqR-ZqI+CR;
      ZI:=DPZ+DPZ+CI;
      ZqI:=ZI*ZI;
      DPZ:=ZR*ZI;
      ZqR:=ZR*ZR;
      end;
    }

    ffEight:
    asm
      mov ECX, Iterv
      mov DX, 4100h	   {Flags}
      fld mi           {MaxVal                       R7}
      fld CR               {CR                           R6}
      fld CI               {CI                           R5}
      fld PI               {ZI                           R4}
      fld PR               {ZR                           R3}
      fld st(1)            {ZqI:=ZI                      R2}
      fmul st,st           {ZqI:=ZqI*ZqI                 R2}
      fld st(1)            {ZqR:=ZR                      R1}
      fmul st,st           {ZqR:=ZqR*ZqR                 R1}

      @@start:
      fld  st(0)           {temp:=ZqR                    R0}
      fsub st,st(2)        {temp:=temp-ZqI               R0}
      fxch st(3)           {temp:=ZR ZR:=temp            R0}
      fmul st,st(4)        {temp:=temp*ZI                R0}
      fadd st, st          {temp:=temp+temp              R0}
      fst  st(4)           {ZI:=temp                     R0}
      fmul st, st          {temp:=temp*temp              R0}
      fstp st(2)           {ZqI:=temp                    R1}
      fld st(2)            {temp:=ZR                     R0}
      fmul st, st          {temp:=temp*temp              R0}
      fst st(1)            {ZqR:=temp                    R0}
      fsub st,st(2)        {temp:=temp-ZqI               R0}
      fxch st(3)           {temp:=ZR ZR:=temp            R0}
      fmul st,st(4)        {temp:=temp*ZI                R0}
      fadd st, st          {temp:=temp+temp              R0}
      fst  st(4)           {ZI:=temp                     R0}
      fmul st, st          {temp:=temp*temp              R0}
      fstp st(2)           {ZqI:=temp                    R1}
      fld st(2)            {temp:=ZR                     R0}
      fmul st, st          {temp:=temp*temp              R0}
      fst st(1)            {ZqR:=temp                    R0}
      fsub st,st(2)        {temp:=temp-ZqI               R0}
      fadd st, st(6)       {temp:=temp+CR                R0}
      fxch st(3)           {temp:=ZR ZR:=temp            R0}
      fmul st,st(4)        {temp:=temp*ZI                R0}
      fadd st, st          {temp:=temp+temp              R0}
      fadd st, st(5)       {temp:=temp+CI                R0}
      fst  st(4)           {ZI:=temp                     R0}
      fmul st, st          {temp:=temp*temp              R0}
      fstp st(2)           {ZqI:=temp                    R1}
      fld st(2)            {temp:=ZR                     R0}
      fmul st, st          {temp:=temp*temp              R0}
      fst st(1)            {ZqR:=temp                    R0}

      fadd st, st(2)       {temp:=temp+ZqI               R0}
      fcomp st(7)          {temp:=temp-MaxVal            R1}
      fstsw AX             {salva 80x87 cond.code        R1}
      test AX,DX           {test flag carry e zero       R1}

      loopnz @@start2
      jp @@cont
  @@start2:      jp @@start
  @@cont:        mov EAX,iterv
      sub EAX,ECX
      mov Iterv,EAX
      fstp Realqv            {R3}
      fstp DProdv             {R4}
      fstp Imagqv            {R5}
      finit
      @@Fine:
      end;

    ffForth:
      asm
        mov ECX, Iterv
        mov DX, 4100h	   {Flags}
        fld mi               {MaxVal                       R7}
        fld CR               {CR                           R6}
        fld CI               {CI                           R5}
        fld PR               {PZ:=ZR                       R4}
        fld PI               {ZqI:=ZI                      R3}
        fld st(1)            {ZqR:=PZ                      R2}
        fmul st,st           {ZqR:=ZqR*ZqR                 R2}
        fxch st(1)           {ZqR:=ZqI  ZqI:=ZqR           R2}
        fmul st(2),st        {PZ:=ZqR*PZ                   R2}
        fmul st,st           {ZqR:=ZqR*ZqR                 R2}
        fxch st(1)           {ZqR:=ZqI  ZqI:=ZqR           R2}

      @@start:
        fld st(0)            {temp:=ZqR                    R1}
        fsub st,st(2)        {temp:=ZqR-ZqI                R1}
        fld st(3)            {tem2:=PZ                     R0}
        fadd st,st           {tem2:=tem2+tem2              R0}
        fadd st,st           {tem2:=tem2+tem2              R0}
        fmul st(4),st        {PZ:=PZ*tem2                  R0}
        fmul st,st(1)        {tem2:=tem2*temp              R0}
        fadd st,st(5)        {tem2:=tem2+CI                R0}
        fstp st(2)           {ZqR:=tem2                    R1}
        fmul st,st           {temp:=temp*temp              R1}
        fsub st,st(3)        {temp:=temp-PZ                R1}
        fadd st,st(5)        {temp:=temp+CR                R1}
        fst st(3)            {PZ:=temp                     R1}
        fmul st,st(1)        {temp:=temp*ZqR               R1}
        fxch st(3)           {temp:=PZ PZ:=temp            R1}
        fmul st,st           {temp:=temp*temp              R1}
        fxch st(1)           {temp:=ZqR ZqR:=temp          R1}
        fmul st,st           {temp:=temp*temp              R1}
        fst st(2)            {ZqI:=temp                    R1}
        fadd st,st(1)        {temp:=ZqR+ZqI                R1}
        fcomp st(6)          {temp:=temp-MaxVal            R2}
        fstsw AX             {salva 80x87 cond.code        R2}
        test AX,DX           {test flag carry e zero       R2}
        loopnz @@start

      mov EAX,iterv
      sub EAX,ECX
      mov Iterv,EAX
      fstp Realqv            {R3}
      fstp DProdv             {R4}
      fstp Imagqv            {R5}
      finit
      @@Fine:
     end;

    ffCube:
      asm
        mov ECX, Iterv
        mov DX, 4100h	   {Flags}
        fld mi           {MaxVal                       R7}
        fld CR               {CR                           R6}
        fld CI               {CI                           R5}
        fld PI               {ZI                           R4}
        fld PR               {ZR                           R3}
        fld st(0)            {ZqR:=ZR                      R2}
        fmul st,st           {ZqR:=ZqR*ZqR                 R2}
        fld st(2)            {ZqI:=ZI                      R1}
        fmul st,st           {ZqI:=ZqI*ZqI                 R1}
      @@start:
        fld st(0)            {temp:=ZqI                    R0}
        fadd st,st(0)        {temp:=temp+temp              R0}
        fadd st,st(1)        {temp:=temp+ZqI               R0}
        fchs                 {temp:=-temp                  R0}
        fadd st,st(2)        {temp:=temp+ZqR               R0}
        fmul st,st(3)        {temp:=temp*ZR                R0}
        fadd st,st(6)        {temp:=temp+CR                R0}
        fstp st(3)           {ZR:=temp                     R1}
        fld st(1)            {temp:=ZqR                    R0}
        fadd st,st(0)        {temp:=temp+temp              R0}
        fadd st,st(2)        {temp:=temp+ZqR               R0}
        fsub st,st(1)        {temp:=temp-ZqI               R0}
        fmul st,st(4)        {temp:=temp*ZI                R0}
        fadd st,st(5)        {temp:=temp+CI                R0}
        fst st(4)            {ZI:=temp                     R0}
        fmul st,st           {temp:=ZI*ZI                  R0}
        fstp st(1)           {ZqI=temp                     R1}
        fld st(2)            {temp:=ZR                     R0}
        fmul st,st           {temp:=ZR*ZR                  R0}
        fst st(2)            {ZqR:=temp                    R0}
        fadd st,st(1)        {temp:=ZqR+ZqI                R0}
        fcomp st(7)          {temp:=temp-MaxVal            R1}
        fstsw AX             {salva 80x87 cond.code        R1}
        test AX,DX           {test flag carry e zero       R1}
        loopnz @@start

      mov EAX,iterv
      sub EAX,ECX
      mov Iterv,EAX
      fstp Imagqv         {R2}
      fstp DProdv         {R3}
      fstp Realqv         {R4}
      finit
     @@Fine:
     end;

    ffZed:
      begin
      zeta.X := PR;
      zeta.Y := PI;
      Iterv := 0;
      sumqv :=0;
      realqv := 0;
      imagqv :=0;
      Dprodv :=0;
      while ( ( Iterv < FIter ) and ( sumqv < mi ) ) do
        begin
        inc(Iterv);
        zeta := ZPower( zeta, zeta );
        zeta.x := zeta.x+CR;
        zeta.y := zeta.y+CI;
        imagqv := zeta.y*zeta.y;
        realqv := zeta.x*zeta.x;
        sumqv := imagqv + realqv;
        end;
      end;

    ffSqSingle:
      begin
      zeta.X := PR;
      zeta.Y := PI;
      c.X := CR;
      c.Y := CI;
      Iterv := 0;
      sumqv :=1;
      realqv := 0;
      imagqv :=0;
      Dprodv :=0;
      while ( ( Iterv < FIter ) and ( sumqv < mi ) ) do
        begin
        inc(Iterv);
        zeta := ZAdd( ZSqr( zeta ), zeta, c );
        imagqv := zeta.y*zeta.y;
        realqv := zeta.x*zeta.x;
        sumqv := imagqv + realqv;
        end;
      end;

    ffLambda:
      begin
      zeta.X := 0.5+PR;
      zeta.Y := 0+PI;
      c.X := CR;
      c.Y := CI;
      Iterv := 0;
      sumqv :=0;
      realqv := 0;
      imagqv :=0;
      while ( ( Iterv < FIter ) and ( sumqv < mi ) ) do
        begin
        inc(Iterv);
        zeta := ZMul( ZMul(c, zeta), ZSub( 1, ZSqr( zeta ) ) );
        imagqv := zeta.y*zeta.y;
        realqv := zeta.x*zeta.x;
        sumqv := imagqv + realqv;
        end;
      end;

    ffDoubleTail:
      begin
      zeta.X := PR;
      zeta.Y := PI;
      c.X := CR;
      c.Y := CI;
      t1 := ZPower(c, 0.15); //0.15 is a fine double tail
      Iterv := 0;
      sumqv :=0;
      realqv := 0;
      imagqv :=0;
      while ( ( Iterv < FIter ) and ( sumqv < mi ) ) do
        begin
        inc(Iterv);
        zeta := ZAdd( ZMul( ZSqr(zeta), t1 ), c );
        imagqv := zeta.y*zeta.y;
        realqv := zeta.x*zeta.x;
        sumqv := imagqv + realqv;
        end;
      end;

    ffZedC:
      begin
      zeta.X := PR;
      zeta.Y := PI;
      c.X := CR;
      c.Y := CI;
      Iterv := 0;
      sumqv :=0;
      realqv := 0;
      imagqv :=0;
      while ( ( Iterv < FIter ) and ( sumqv < mi ) ) do
        begin
        inc(Iterv);
        zeta := ZPower(c, zeta);
        imagqv := zeta.y*zeta.y;
        realqv := zeta.x*zeta.x;
        sumqv := imagqv + realqv;
        end;
      end;

    ffSin:
      begin
      zeta.X := CR+PR;
      zeta.Y := CI+PI;
      c.X := CR;
      c.Y := CI;
      Iterv := 0;
      sumqv :=0;
      realqv := 0;
      imagqv :=0;
      while ( ( Iterv < FIter ) and ( sumqv < mi ) ) do
        begin
        inc(Iterv);
        zeta := ZMul( ZSin(zeta), c);
        imagqv := zeta.y*zeta.y;
        realqv := zeta.x*zeta.x;
        sumqv := imagqv + realqv;
        end;
      end;

    ffSinTan:
      begin
      zeta.X := CR+PR;
      zeta.Y := CI+PI;
      c.X := CR;
      c.Y := CI;
      Iterv := 0;
      sumqv :=0;
      realqv := 0;
      imagqv :=0;
      while ( ( Iterv < FIter ) and ( sumqv < mi ) ) do
        begin
//        Z<-C*(sin(Z+tan(Z)))
        inc(Iterv);
        zeta := ZMul( C, ZSin( ZAdd( Zeta, ZTan( Zeta ) ) ) );
        imagqv := zeta.y*zeta.y;
        realqv := zeta.x*zeta.x;
        sumqv := imagqv + realqv;
        end;
      end;

    ffSpider:
      begin
      zeta.X := PR;
      zeta.Y := PI;
      c.X := CR;
      c.Y := CI;
      Iterv := 0;
      imagqv := 0;
      realqv := 0;
      sumqv := 0;
      while ( ( Iterv < FIter ) and ( sumqv < mi ) ) do
        begin
        inc(Iterv);
        zeta := ZAdd( c, ZSqr( zeta ) );
        c := ZAdd(zeta, ZDiv( c, 2 ));
        imagqv := zeta.y*zeta.y;
        realqv := zeta.x*zeta.x;
        sumqv := imagqv + realqv;
        end;
      end;

    ffMagnetism:
      begin
      zeta.X := PR;
      zeta.Y := PI;
      c.X := CR;
      c.Y := CI;
      Iterv := 0;
      imagqv := 0;
      realqv := 0;
      sumqv := 0;
      while ( ( Iterv < FIter ) and ( sumqv < mi ) ) do
        begin
        inc(Iterv);
        t1 := ZSqr( ZAdd( ZAdd( c, ZSqr( zeta ) ), -1) );
        t2 := ZSqr( ZAdd( ZAdd( c, zeta, zeta ), -2) );
        zeta := ZDiv( t1, t2 );
        imagqv := zeta.y*zeta.y;
        realqv := zeta.x*zeta.x;
        sumqv := imagqv + realqv;
        end;
      end;
   end; {case}

   sumqv := realqv + imagqv;
   Realnv := realqv - imagqv + CR;
   imagnv := dprodv + CI;


    if iterv < FIter then
      begin
        case FApplyC of
          Iter:
            begin
            Result := Iterv;
            end;
          Vepstas:
            begin
            Result := iterv + ( FExtraPar1 - Ln( Ln( sumqv ) * 0.5 ) ) * FExtraPar2; // FExtraPar1 := Ln( Ln( par.FBailout ) )    FExtraPar2 = 1 / Ln( 2 );
            end;
          Sum:  
            begin
            Result:= sqrt( sumqv ) * FExtraPar1;  {FExtraPar1= MaxItr / bailout}
            end;
          Imag:
            begin
            Result:= imagqv * FExtraPar1; {FExtraPar1= MaxItr / bailout ^ 2}
            end;
          Real: 
            begin
            Result:= realqv * FExtraPar1;  {FExtraPar1= MaxItr / bailout ^ 2}
            end;
          Prod: 
            begin
            Result:= sqrt( sumqv ) * FExtraPar1 * Iterv;    {FExtraPar1= 1 / bailout}
            end;
          SumI: 
            begin
            Result:=Iterv - ( sqrt( sumqv ) * FExtraPar1 );   {FExtraPar1= 1 / bailout}
            end;
          BioM:
            begin
            if (realqv < mi) xor (imagqv < mi) then
              Result := Iterv
            else
              Result := 1;
            end;
          Radiant:
            begin
            Result := ( arctan2( imagnv, realnv ) / FExtraPar1  + 0.5 ) * MaxItr; // FExtraPar1 = pi * 2
            end;
          IterRad:
            begin
            Result := Iterv + ( arctan2( imagnv, realnv ) / FExtraPar1  + 0.5 ) ; // FExtraPar1 = pi * 2            
            end
        else
          Result := MaxItr;
        end;
      end
    else
      begin
        case FApplyC of
          IntMod:
            begin
            result := sqrt( sumqv ) * FExtraPar1; {FExtraPar1= MaxItr / bailout}
            end;
          IntRadiant:
            begin
            Result := ( arctan2( imagnv, realnv ) / FExtraPar1  + 0.5 ) * MaxItr; // FExtraPar1 = pi * 2
            end
        else
          Result := MaxItr;
        end;
      end;
    end;
  if Result <= 0 then
    Result := 1e-10;
    
  asm
    finit // seems there some errors in Math
  end;

  end;


function TMandelbrot.UpdatePar(AMandelSet: TMandelSet): boolean;
  begin
  with AMandelset do
    try
    par.FCentReal := StrToFloatDef( FCentReal, 0 );
    par.FCentImag := StrToFloatDef( FCentImag, 0 );
    par.FMagnitud := StrToFloatdef( FMagnitud, 1 );
    par.FIter := StrToFloatDef( FIter, 10 );
    par.FWidth := StrToIntDef( FWidth, 0 );
    if par.FWidth < 32 then
      par.FWidth := 32;
    par.FHeight := StrToIntDef( FHeight, 0 );
    if par.FHeight < 32 then
      par.FHeight := 32;
    par.FAspectR := StrToFloatDef( FAspectR, 1 );
    par.FJulia := FJulia;
    par.FBailout := StrToIntDef( FBailout, 4 );
    par.FRealPert := StrToFloatDef( FRealPert, 0 );
    par.FImagPert := StrToFloatDef( FImagPert, 0 );

    if Falgo = 'Interpolate256' then
      begin
      par.FAlgo := maInterp256;
      end
    else if Falgo = 'Interpolate8' then
      begin
      par.FAlgo := maInterp8;
      end
    else if Falgo = 'Interpolate2' then
      begin
      par.FAlgo := maInterpEven;
      end
    else if Falgo = 'Plain' then
      begin
      par.FAlgo := maPlain;
      end
    else if Falgo = 'Orbits' then
      begin
      par.FAlgo := maOrbits;
      end
    else if Falgo = 'Draft' then
      begin
      par.FAlgo := maDraft;
      end
    else if Falgo = 'BoundsMP' then
      begin
      par.FAlgo := maBoundedMP;
      end
    else // default
      begin
      par.FAlgo := maBounded;
      end;

  	if FApplyC='R.^2+I.^2 (mod)' then
      par.FApplyC := Sum
    else if FApplyC='Potential' then
      par.FApplyC := Vepstas
    else if FApplyC='Iteractions*mod' then //for legacy
      par.FApplyC := Prod
    else if FApplyC='Iterations*mod' then
      par.FApplyC := Prod
    else if FApplyC='Iteractions+mod' then //for legacy
      par.FApplyC := SumI
    else if FApplyC='Iterations+mod' then
      par.FApplyC := SumI
    else if FApplyC='Real^2' then
      par.FApplyC := Real
    else if FApplyC='Imaginary^2' then
      par.FApplyC := Imag
    else if FApplyC='Internal mod' then
      par.FApplyC := IntMod
    else if FApplyC='Internal radiant' then
      par.FApplyC := IntRadiant
    else if FApplyC='Biomorph' then
      par.FApplyC := BioM
    else if FApplyC='Radiant' then
      par.FApplyC := Radiant
    else if FApplyC='Radiant+Iter' then
      par.FApplyC := IterRad
    else
      par.FApplyC := Iter;

    if FFormula='Z<-Z^4+C' then
      begin
      par.FCQuad:=false;
      par.FFormula:=ffForth;
      end
    else if FFormula='Z<-Z^3+C' then
      begin
      par.FCQuad:=false;
      par.FFormula:=ffCube;
      end
    else if FFormula='Z<-Z^2+C^2' then
      begin
      par.FCQuad:=true;
      par.FFormula:=ffQuad;
      end
    else if FFormula='Z<-Z^3+C^2' then
      begin
      par.FCQuad:=true;
      par.FFormula:=ffCube;
      end
    else if FFormula='Z<-Z^8+C' then
      begin
      par.FCQuad:=false;
      par.FFormula:=ffEight;
      end
    else if FFormula='Z<-Z^Z+C' then
      begin
      par.FCQuad:=false;
      par.FFormula:=ffZed;
      end
    else if FFormula='Z<-Z^2+Z+C' then
      begin
      par.FCQuad:=false;
      par.FFormula:=ffSqSingle;
      end
    else if FFormula='Z<-Z^C' then
      begin
      par.FCQuad:=false;
      par.FFormula:=ffZedC;
      end
    else if FFormula='Z<-Z*C*(1-Z)' then
      begin
      par.FCQuad:=false;
      par.FFormula:=ffLambda;
      end
    else if FFormula='Z<-sin(Z)+C' then
      begin
      par.FCQuad:=false;
      par.FFormula:=ffSin;
      end
    else if FFormula='Z<-C*(s(Z+t(Z)))' then //Z<-C*(sin(Z+tan(Z)))
      begin
      par.FCQuad:=false;
      par.FFormula:=ffSinTan;
      end
    else if FFormula='Spider' then
      begin
      par.FCQuad:=false;
      par.FFormula:=ffSpider;
      end
    else if FFormula='Magnetism' then
      begin
      par.FCQuad:=false;
      par.FFormula:=ffMagnetism;
      end
    else if FFormula='DoubleTail' then
      begin
      par.FCQuad:=false;
      par.FFormula:=ffDoubleTail;
      end
    else
      begin
      par.FFormula:=ffQuad;
      par.FCQuad:=false;
      end;
    MandelSet := AMandelSet;
    Result := FixParameters;
    except
    UpdatePar( Mandelset );
    Result := false;
    end;
  end;

function TMandelbrot.FixParameters: boolean;
  begin
  with par do
    try
  	case FApplyC of
    Sum:
      begin
      FExtraPar1 := FIter / FBailout;
      end;
    Vepstas:
      begin
      FExtraPar1 := Ln( Ln( FBailout ) );
      FExtraPar2 := 1 / Ln( 2 );
      end;
    Prod:  
      begin
      FExtraPar1 := 1 / FBailout;
      end;
    SumI:
      begin
      FExtraPar1 := 1 / FBailout;
      end;
    Real:
      begin
      FExtraPar1 := FIter / ( FBailout * FBailout );
      end;
    Imag:
      begin
      FExtraPar1 := FIter / ( FBailout * FBailout );
      end;
    IntMod:
      begin
      FExtraPar1 := FIter / FBailout;
      end;
    IntRadiant:
      begin
      FExtraPar1 := pi * 2;
      end;
    BioM:
      begin
      FExtraPar1 := FIter / FBailout;
      end;
    Radiant:
      begin
      FExtraPar1 := pi * 2;
      end;
    IterRad:  
      begin
      FExtraPar1 := pi * 2;
      end;
    else
      FExtraPar1 := 0;
    end;  
      // init calculated parameters
    FMaxIterVal	:= FIter; // max value. Usually equal to FIter but it can be different in some formulas
    FIncI := 1 / ( FMagnitud * FHeight );
    FIncR := FIncI * FAspectR;

    FMinCR := FCentReal - FIncR * ( FWidth div 2 );
    FMinCI := FCentImag - FIncI * ( FHeight div 2 );
    Result := true;
    except
    Result := false;
    end;
  end;

procedure TMandelbrot.MandelSetDefault( var AMandelset: TMandelSet );
  begin
  with AMandelSet do
		begin
		FVersion := FProdVers;
		FImageFile:='None';
		FName:='Mand000';
		FCentReal:='-0.75';
		FCentImag:='0';
		FMagnitud:='0.4';
		FAlgo := 'Bounds';
		FIter:='100';
		FOffset:='0';
		FWidth:='550';
		FHeight:='530';
		FAspectR:='1';
		FPriority:='High';
		FJulia:=false;
		FColors:='';
		FBailout:='128';
		FRealPert:='0';
		FImagPert:='0';
		FApplyC:='Potential';
		FFormula:='Z<-Z^2+C(Normal)';
		FComments:='Starting fractal';
		FTime:=DateTimeToStr(Now);
		FCrono:='0:00:00:000';
		FReserved := ''; // non usato
		FState := msNone;
		end;
  end;
  
procedure TMandelbrot.Redraw;
  begin
  DoFilter( FFilter );
  end;

procedure TMandelbrot.SetOnProgress(const Value: TProgrEvent);
  begin
  FOnProgress := Value;
  end;

procedure TMandelbrot.SetTimer(const Value: Cardinal);
  begin
  FTimer := Value;
  end;

procedure TMandelbrot.DoProgress( Progress: Extended = -1 );
  var
    Continue: boolean;
  begin
  if assigned( FOnProgress ) then
    begin
    if ( Progress = 0 ) or ( Progress = 1 ) or ( GetTickCount - FLastTime > FTimer ) then
      begin
      EnterCriticalSection(FCritical); //prevent conflict in multithread
        try
        Continue := true;
        FOnProgress( Self, Continue, Progress );
        if not Continue then
          SysUtils.Abort;
        FLastTime := GetTickCount;

        finally
        LeaveCriticalSection(FCritical);
        end;
      end;
    end;
  end;

var
  timesHere: cardinal = 0;

procedure TMandelbrot.DoFilter( AFilter: TFilterKind; KeepProgr: Boolean = True );
  var
    nv, ky, kx: integer;
    CurrLine :  PRGBArray;
    v, vup, vdw, vlf, vrg: Extended;
    tCol : TRGBTriple;
    ThisTime: cardinal;
  begin
  inc( timesHere ); // works only 2^32 times ;-)
  ThisTime := timesHere;
  FFilter := AFilter;
  if KeepProgr then
    DoProgress( 0 );  //initialize
  with Par do
    for ky := 0 to FHeight - 1 do
      begin
      if ThisTime <> timesHere then
        exit; // there's a newer call to this same routine
      CurrLine := PRGBArray( Bmp.ScanLine[ ky ] );
      nv := ( ky * fwidth ) - 1 ;
      for kx := 0 to FWidth - 1 do
        begin
        inc( nv );
        v := values[ nv ];
        if FFilter = fkNone then
          begin
          tcol := Colors.FromIterToColor( v );
          SwitchRB( tcol );
          end
        else
          begin
          if ky > 0 then
            vup := values[ nv - fwidth  ]
          else
            vup := v;
          if ky < FHeight - 1 then
            vdw := values[ nv + fwidth ]
          else
            vdw := v;
          if kx > 0 then
            vlf := values[ nv - 1 ]
          else
            vlf := v;
          if kx < FWidth - 1 then
            vrg := values[ nv + 1 ]
          else
            vrg := v;
          tcol := FilteredValuesToCol( FFilter, v, vup, vdw, vlf, vrg );
          end;
        CurrLine[ kx ] := tCol;
        end;
      if KeepProgr then
        DoProgress( ky / ( FHeight - 1 ) );
      end;
  end;

function TMandelbrot.FilteredValuesToCol(Filter: TFilterKind; Val, ValUp, ValDown, ValLeft, ValRight: Extended ): TRGBTriple;
  var
    sat, lv, hue: Extended;
    lum: Byte;
  begin
  case Filter of
    fkEdge:
      begin
      lv := abs( val - ( valup + valdown + valleft + valright ) / 4 );
      lv := 1 - lv / Par.FIter;
      lv :=  1 - lv * lv * lv; //gamma = 3
      lum := 255 - trunc( lv * 255 );
      result.rgbtBlue := lum;
      result.rgbtGreen := lum;
      result.rgbtRed := lum;
      end;
    fkBumper:
      begin
      lv := ( ( valup - valdown ) + ( valleft - valright ) ) / 2;
      lv := 1 - lv / Par.FIter;
      lv :=  1 - lv * lv * lv; //gamma = 3
      lum := trunc( lv * 127 + 128 );
      result.rgbtBlue := lum;
      result.rgbtGreen := lum;
      result.rgbtRed := lum;
      end;
    fkColorBumper:
      begin
      sat := 1;
      lv := ( ( valup - valdown ) + ( valleft - valright ) ) / 2;
      hue := ( val / Par.FIter );
      HSLtoRGB(hue, sat, lv, result);
      end;
    fkHeight:
      begin
      lv := valdown - valup;
      lum := trunc( ( lv / Par.FIter ) * 127 + 128 );
      result.rgbtRed := lum;
      lv := valRight - valLeft;
      lum := trunc( ( lv / Par.FIter ) * 127 + 128 );
      result.rgbtGreen := lum;
      lum := trunc( ( val / Par.FIter ) * 255 );
      result.rgbtBlue := lum;
      end;
    fkUnsharpMask:
      begin
      lv := ( ValDown + ValUp + ValRight + ValLeft ) / 4;
      lv := Val + ( Val - lv );
      if lv < 1 then
        lv := 1
      else if lv > Par.FIter then
        lv := Par.FIter;
      result := Colors.FromIterToColor( lv );
      end;
    fkAverage:
      begin
      lv := ( ValDown + ValUp + ValRight + ValLeft ) / 4;
      lv := ( Val + lv ) / 2;
      if lv < 1 then
        lv := 1
      else if lv > Par.FIter then
        lv := Par.FIter;
      result := Colors.FromIterToColor( lv );
      end;
    fkNoise:
      begin
      result := Colors.FromIterToColor( val );
      if Random( 2 ) = 0 then
        begin
        RGBtoHSL( result, hue, sat, lv );
        lv := frac(lv + Random * 0.5 - 0.25);
        HSLtoRGB(hue, sat, lv, result);
        end;
      end;
    fkLines:
      begin
      if ( Val <> ValUp ) or (Val <> ValDown ) or ( Val <> ValLeft ) or ( Val <> ValRight ) then
        Result := Colors.FromIterToColor( val )
      else 
        begin
        Result.rgbtBlue := 0;
        Result.rgbtGreen := 0;
        Result.rgbtRed := 0;
        end;
      end;
    fkCristals:
      begin  
      if ( Val <> ValUp ) and (Val <> ValDown ) and ( Val <> ValLeft ) and ( Val <> ValRight ) then
        Result := Colors.FromIterToColor( val )
      else 
        begin
        Result.rgbtBlue := 0;
        Result.rgbtGreen := 0;
        Result.rgbtRed := 0;
        end;
      end;
    fkEqColors:
      begin  
      if Info.Fmax = Info.FMin then
        lv := val
      else
        lv := ( ( Val - Info.Fmin ) / ( Info.Fmax - Info.FMin ) ) * Par.Fiter;

      Result := Colors.FromIterToColor( lv );
      end;
    end;
  SwitchRB( Result );
  end;

function TMandelbrot.GetPercentDrawn: Extended;
  var
    v, vmax: integer;
    d, nd: integer;

  begin
  with FInfo do
    begin
    vmax := Par.FWidth * ( Par.FHeight - 1 );
    v := 0;
    d := 0;
    nd := 0;
    while v < vmax do
      begin
      if values[ v ] = 0 then
        inc( nd )
      else
        inc( d );
      inc( v, 100 ); // get one point every 100
      end;
    end;
  result := d / ( nd + d );
  if result >= 1 then
    result := 0.9999999999;
  end;

procedure TMandelbrot.UpdateInfo;
  var
    v, vmax: integer;
    p: ^extended;
  begin
  ResetInfo;
  with FInfo do
    begin
    vmax := Par.FWidth * Par.FHeight - 1;
    p := @values[ 0 ];
    for v := 0 to vmax do
      begin
      if p^ = Par.FIter then
        Inc(FInsideCount);
      if ( FMin = -1 ) or ( p^ < Fmin ) then
        Fmin := p^;
      if (( FMax = -1 ) or ( p^ > Fmax )) and ( p^ < Par.FIter ) then
        Fmax := p^;
      inc( p );
      end;
    end;
  end;

procedure TMandelbrot.ResetInfo;
  begin
  with FInfo do
    begin
    FInsideCount := 0;
    FMin := -1;
    FMax := -1;
    end;
  FMndcount := 0;
  end;

procedure TMandelbrot.StoreFilter;
  begin
  FPrevFilter := FFilter;
  end;

procedure TMandelbrot.RestoreFilter;
  begin
  // if there was a filter reapply it
  if FPrevFilter <> fkNone then
    DoFilter( FPrevFilter );
  end;

{
procedure TMandelbrot.SetParentThread(AThread: TThreadBounded);
  begin
  FParentThread := AThread;
  end;
}
destructor TMandelbrot.Destroy;
begin
  DeleteCriticalSection(FCritical);
  inherited;
end;

end.


