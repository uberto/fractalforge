unit Orbits;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mandelbrot;

const
  Zoom = 3;
  OffY = -1.5;
  OffX = -2.25;

type
	TFrOrbits = class(TForm)
		Image1: TImage;
    Panel1: TPanel;
    cbLines: TCheckBox;
    procedure FormResize(Sender: TObject);
    procedure cbLinesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
	private
    FMandelBmp: TBitmap;
    FMaxIterMain: integer;
    procedure DrawMandel;
    procedure SetMaxIterMain(const Value: Extended);
    function GetMaxIterMain: extended;
    procedure DrawPoint(Real, Imag: extended; iter: integer);
	public
    procedure TraceOrbits( real, immag: extended; tracing: boolean );
    property MaxIterMain: Extended read GetMaxIterMain write SetMaxIterMain;

	end;

var
	FrOrbits: TFrOrbits;

implementation

{$R *.DFM}

procedure TFrOrbits.TraceOrbits( real, immag: Extended; tracing: boolean );
	var
		it: integer;
		i, r, zqr, zqi, pz: extended;
	begin
  Image1.Picture.Bitmap.Assign( FMandelBmp );

	if (real <> 0) and (immag <> 0) then
		begin
    DrawPoint( real, immag, 0 ); // move PenPos
		pz := 0;
		zqi := 0;
		zqr := 0;
		it := 0;
		while (( it < FMaxIterMain ) and ( ZqR + ZqI < 16 )) do
			begin
			r := ZqR - ZqI + real;
			i := PZ + PZ + immag;
			ZqI := i * i;
			PZ := r * i;
			ZqR := r * r;
			inc(it);
      DrawPoint( r, i, it );
			end;
		end;
	Image1.Invalidate;
	end;

procedure TFrOrbits.DrawPoint( Real, Imag: extended; iter: integer );
  var
    col: TColor;
    gray: byte;
    ImageX, ImageY: integer;
  begin
	ImageX := round((( Real - OffX ) / Zoom) * image1.Width);
  ImageY := round((( -Imag - OffY ) / Zoom) * image1.Height);
  if iter = FMaxIterMain then
    col := clWhite
  else
    begin // use only 200 shades to better visibility
    gray := 25 + ( 200 * iter ) div FMaxIterMain;
    col := RGB( gray, gray, gray );
    end;
  if cbLines.Checked then
    begin
    Image1.Canvas.Pen.Color := col;
    if iter = 0 then
      Image1.Canvas.PenPos := Point( ImageX, ImageY )
    else
      Image1.Canvas.LineTo( ImageX, ImageY );
    end
  else
    Image1.Canvas.Pixels[ ImageX, ImageY ] := col;
  end;

procedure TFrOrbits.FormResize(Sender: TObject);
	begin
	ClientHeight := Clientwidth;
	Image1.Picture.Bitmap.PixelFormat := pf8bit;
	Image1.Picture.Bitmap.Width := Image1.Width;
	Image1.Picture.Bitmap.Height := Image1.Height;
  DrawMandel;
	TraceOrbits( 0, 0, cblines.checked );
	end;

procedure TFrOrbits.DrawMandel;
  const
    max = 50;
  var
    CurrLine: PByteArray;
    Mand: TMandelbrot;
		col: byte;
    x,y: integer;
    r, i: Extended;
  begin
// draw a mandelbrot set and store in FMandelBmp
  Mand := TMandelbrot.Create(nil, '');
    try
      Mand.Par.FIter := max;
      Mand.Par.FBailout := 4;
      Mand.Par.FRealPert := 0;
      Mand.Par.FImagPert := 0;
      Mand.Par.FApplyC := Iter;
      Mand.Par.FFormula := ffQuad;

      for y := 0 to Image1.Height-1 do
        begin
        CurrLine := Image1.Picture.Bitmap.ScanLine[y];
        i := (y / Image1.Height) * Zoom + OffY;
        for x := 0 to Image1.Width-1 do
          begin
          r := (x / Image1.Width) * Zoom + OffX;
          if Mand.AlgMndFlt( r, i ) >= max then
            col := 5
          else
            col := 6;
          CurrLine[x] := col;
          end;
        end;
    finally
      Mand.Free;
    end;
  FMandelBmp.Assign( Image1.Picture.Bitmap );
  end;

procedure TFrOrbits.cbLinesClick(Sender: TObject);
  begin
	TraceOrbits( 0, 0, cblines.checked );
  end;

procedure TFrOrbits.FormCreate(Sender: TObject);
begin
  Caption := 'Floating Orbits';
  FMandelBmp := TBitmap.Create;
  ControlStyle := ControlStyle + [csOpaque]; // to avoid flickering
  FMaxIterMain := 50; //default
end;

procedure TFrOrbits.FormDestroy(Sender: TObject);
begin
  FMandelBmp.Free;
end;

procedure TFrOrbits.SetMaxIterMain(const Value: Extended);
begin
  if value > 100000 then
    FMaxIterMain := 100000
  else
    FMaxIterMain := Trunc(Value);
end;

function TFrOrbits.GetMaxIterMain: extended;
begin
  result := FMaxIterMain;
end;

end.
