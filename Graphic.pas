unit Graphic;

interface

uses
  windows, sysutils, graphics, dialogs, Printers, Forms, Colors;

type
	PDIBPixelArray = ^TDIBPixelArray;
	TDIBPixelArray = array [0 .. MaxInt div 4] of TRGBTriple;

function InitGraphic(ABitmap: TBitmap) : boolean;
procedure GetBGRPixel(X,Y : integer; var BGR: TRGBTriple);
procedure SetBGRPixel(X,Y : integer; BGR: TRGBTriple);
function GetDIBPixel(X,Y : integer):TColor;
procedure SetDIBPixel(X,Y : integer; Color: TColor);
function BGRtoCol(ABGR : TRGBTriple): TColor;
function ColToBGR(ACol : TColor): TRGBTriple;
procedure SetDIBRect(ARect : TRect; AColor: TColor);
procedure SetRGBDIBPixel(X,Y : integer; AColor: TRGBTriple );
function  GetRGBDIBPixel(X,Y : integer) : TRGBTriple;
procedure SetRGBDIBRect( ARect : TRect; AColor: TRGBTriple );
procedure SetBGRRect(ARect : TRect; ABGR: TRGBTriple);
procedure CloseGraphic;
procedure PrintBitmap(ABitmap: TBitmap; riga1, riga2, riga3: string);

implementation

var
	Init : boolean;
	DIB : TBitmap;
	CurrLine : PDIBPixelArray;
	CurrLineNo : Integer;
	MaxX,MaxY : integer;

function InitGraphic(ABitmap: TBitmap) : boolean;
	begin
	if Init then
   	raise Exception.Create('Wrong graphic initialization!');
	result := Assigned(ABitmap) and (ABitmap.PixelFormat = pf24bit);
	if Result then
		begin
		Init := true;
		DIB := ABitmap;
		CurrLine := nil;
		CurrLineNo := MaxInt;
		MaxX := DIB.Width-1;
		MaxY := DIB.Height-1;
		end;
	end;

procedure GetBGRPixel(X,Y : integer; var BGR: TRGBTriple);
	begin
	if Y <> CurrLineNo then
		begin
		CurrLineNo := y;
		CurrLine := DIB.ScanLine[y];
		end;
	BGR := CurrLine[x];
	end;

procedure SetBGRPixel(X,Y : integer; BGR: TRGBTriple);
	begin
	if Y <> CurrLineNo then
		begin
		CurrLineNo := y;
		CurrLine := DIB.ScanLine[y];
		end;
	CurrLine[x] := BGR;
	end;

function GetDIBPixel(X,Y : integer):TColor;
	var
		tmpBGR : TRGBTriple;
	begin
	if not Init then
		raise Exception.Create('Not initialized graphic');
	if (Y<0) or (X<0) or (Y>MaxY) or (X>MaxX) then
		begin
		result :=0;
		exit;
		end;
	GetBGRPixel(X,Y, tmpBGR);
	result := BGRtoCol(tmpBGR);
	end;

procedure SetDIBPixel(X,Y : integer; Color: TColor);
	begin
	if not Init then
		raise Exception.Create('Not initialized graphic');
	if (Y<0) or (X<0) or (Y>MaxY) or (X>MaxX) then
		exit;
	SetBGRPixel(X,Y, ColToBGR(Color));
	end;

function BGRtoCol(ABGR : TRGBTriple): TColor;
	begin
	result := ABGR.rgbtRed ; //R
	result := (result shl 8) + ABGR.rgbtGreen; //G
	result := (result shl 8) +  ABGR.rgbtBlue; //B
	end;

function ColToBGR(ACol : TColor): TRGBTriple;
	begin
	if (ACol and $FF000000) <> 0 then //colore Windows
		ACol := ColorToRGB(ACol);
	Result.rgbtRed := (ACol and $00FF0000) shr 16;
	Result.rgbtGreen := (ACol and $0000FF00) shr 8;
	Result.rgbtBlue := ACol and $000000FF;
	end;

procedure SetDIBRect(ARect : TRect; AColor: TColor);
	begin
	if not Init then
		raise Exception.Create('Not initialized graphic');
	if ARect.Left < 0 then
		ARect.Left := 0;
	if ARect.Top < 0 then
		ARect.Top := 0;
	if ARect.Right > MaxX+1 then
		ARect.Right := MaxX+1;
	if ARect.Bottom > MaxY+1 then
		ARect.Bottom := MaxY+1;

	if (ARect.Right <= ARect.Left) or (ARect.Bottom <= ARect.Top) then
		exit;
	SetBGRRect(ARect, ColToBGR(AColor));
	end;

procedure SetRGBDIBRect( ARect : TRect; AColor: TRGBTriple );
	begin
	if not Init then
		raise Exception.Create('Not initialized graphic');
	if ARect.Left < 0 then
		ARect.Left := 0;
	if ARect.Top < 0 then
		ARect.Top := 0;
	if ARect.Right > MaxX+1 then
		ARect.Right := MaxX+1;
	if ARect.Bottom > MaxY+1 then
		ARect.Bottom := MaxY+1;

	if (ARect.Right <= ARect.Left) or (ARect.Bottom <= ARect.Top) then
		exit;
  SwitchRB( AColor );
	SetBGRRect(ARect, TRGBTriple( AColor ) );
	end;

procedure SetRGBDIBPixel(X,Y : integer; AColor: TRGBTriple );
	begin
	if not Init then
		raise Exception.Create('Not initialized graphic');
	if (Y<0) or (X<0) or (Y>MaxY) or (X>MaxX) then
		exit;
  SwitchRB( AColor );
	SetBGRPixel(X,Y, TRGBTriple( AColor ) );
	end;

function GetRGBDIBPixel(X,Y : integer) : TRGBTriple;
	begin
	if not Init then
		raise Exception.Create('Not initialized graphic');
	if (Y<0) or (X<0) or (Y>MaxY) or (X>MaxX) then
		begin
		Result.rgbtBlue := 0;
		Result.rgbtGreen := 0;
		Result.rgbtRed := 0;
		exit;
		end;
	GetBGRPixel(X,Y, Result );
  SwitchRB( Result );
	end;


procedure SetBGRRect(ARect : TRect; ABGR: TRGBTriple);
	var
		kx,ky: integer;
		RectLine: PDIBPixelArray;
	begin
	for ky := ARect.Top to ARect.Bottom-1 do
		begin
		if ky=CurrLineNo then
			RectLine := CurrLine
		else
			RectLine := DIB.ScanLine[ky];
		for kx := ARect.Left to ARect.Right-1 do
			RectLine[kx] := ABGR;
		end;
	end;

procedure CloseGraphic;
	begin
	Init := false;
	end;

procedure PrintBitmap(ABitmap: TBitmap; riga1, riga2, riga3: string);
	var
		PrintWidth, PrintHeight, DIBWidth, DIBHeight: integer;
		Info: PBitmapInfo;
		InfoSize: Cardinal;
		Image: Pointer;
		ImageSize: DWORD;
		Bits: HBITMAP;
    AltezzaDisp, LarghezzaDisp, MargineInf, MargineSin : integer;
    x, y, nangle, size, th: integer;
    hfont: THandle;
    s: string;
	begin
	Printer.BeginDoc;
    try
    with Printer, Canvas do
      begin
      Canvas.Font.Name := 'Arial';
      Canvas.Font.Size := 9;
      MargineInf := Round( Canvas.TextHeight( 'pt' ) * 3.6 ); // possono esserci 3 righe
      Canvas.Font.Size := 7;
      MargineSin := Round( Canvas.TextHeight( 'pt' ) * 1.2 );

      AltezzaDisp := PageHeight - MargineInf;
      LarghezzaDisp := PageWidth - MargineSin;

      DIBWidth := ABitmap.Width;
      DIBHeight := ABitmap.Height;
      PrintWidth := MulDiv(DIBWidth, AltezzaDisp, DIBHeight);
      if PrintWidth < LarghezzaDisp then
        PrintHeight := AltezzaDisp
      else
				begin
        PrintWidth := LarghezzaDisp;
        PrintHeight := MulDiv(DIBHeight, LarghezzaDisp, DIBWidth);
        end;
//      StretchDraw(Rect( 0, 0, PrintWidth, PrintHeight),ABitmap);

			Bits := ABitmap.Handle;
      GetDIBSizes(Bits, InfoSize, ImageSize);
      Info := AllocMem(InfoSize);
				try
        Image := AllocMem(ImageSize);
          try
          GetDIB(Bits, 0, Info^, Image^);
          with Info^.bmiHeader do
            begin
            DIBWidth := biWidth;
						DIBHeight := biHeight;
            end;
          StretchDIBits( Canvas.Handle, MargineSin, 0, PrintWidth, PrintHeight, 0, 0, DIBWidth, DIBHeight, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
          finally
          FreeMem(Image, ImageSize);
          end;
        finally
        FreeMem(Info, InfoSize);
        end;
      Canvas.Font.Name := 'Arial';
      Canvas.Font.Size := 9;
      x := MargineSin;
//      y := PrintHeight + margineInf - Canvas.TextHeight( s );
      th := Canvas.TextHeight( 'pt' );
      y := PrintHeight + round( th * 0.2 );
      Canvas.TextOut( x, y, riga1 );
      y := y + round( th * 1.2 );
      Canvas.TextOut( x, y, riga2 );
      y := y + round( th * 1.2 );
      Canvas.TextOut( x, y, riga3 );

      nangle := 270;
      size := -MulDiv( 7, GetDeviceCaps(printer.Canvas.Handle, LOGPIXELSY), 72); // trasform il font size per usarlo con la stampante
      hfont := CreateFont(-size, 0, nangle*10, nangle*10, fw_normal,0,0,0,1,4,$10,2,4, 'Arial' );
      SelectObject( printer.Canvas.Handle, hfont );
      s := Application.Title + ' by Uberto Barbini ( uberto@usa.net )';
      x := Canvas.TextHeight( s ); // altezza massima
      y := 0 ;//PrintHeight + margineInf - Canvas.TextWidth( s );
      Canvas.TextOut( x, y, s );
      end;
 		finally
		Printer.EndDoc;
		end;
  end;
  
end.
