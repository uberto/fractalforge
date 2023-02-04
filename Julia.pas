unit Julia;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Mandelbrot, Colors;

type
  TFrJulia = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    Mand: TMandelbrot;
    FMandelset: TMandelSet;
    FColors: TColorize;
    procedure RenderJulia;
  public
    procedure ResetColors(const ColorFile: string);
    procedure ResetValues(real, imag: Extended; F: TFormulaF; J: Boolean);
  end;

var
  FrJulia: TFrJulia;

implementation

{$R *.DFM}

procedure TFrJulia.ResetColors(const ColorFile: string);
  begin
  FColors.LoadFromFile( ColorFile, False );
  RenderJulia;
  end;

procedure TFrJulia.ResetValues(real, imag: Extended; F: TFormulaF; J: Boolean);
  begin
  with mand.Par do
    begin
    FJulia := J;
    if J then
      begin
      FRealPert := real;
      FImagPert := imag;
      FCentReal := 0;
      FCentImag := 0;
      end
    else
      begin
      FCentReal := real;
      FCentImag := imag;
      FRealPert := 0;
      FImagPert := 0;
      end;
    FFormula := F;
    end;
  RenderJulia;
  end;

procedure TFrJulia.FormCreate(Sender: TObject);
  begin
  Caption := 'Floating Julia';
  ControlStyle := ControlStyle + [ csOpaque ]; // to avoid flickering
  Mand := TMandelbrot.Create( Image1.Picture.Bitmap, '' );
  with mand.Par do
    begin
    FCentReal := 0;
    FCentImag := 0;
    FMagnitud := 0.3;
    FIter := 50;
    FWidth := Image1.Picture.Bitmap.Width;
    FHeight := Image1.Picture.Bitmap.Height;
    FAspectR := 1;
    FJulia := true;
    FBailout := 4;
    FRealPert := 0;
    FImagPert := 0;
    FApplyC := Iter;
    FFormula := ffQuad;
    FAlgo := maInterp8;
    FCQuad := false;
    end;
  Fmandelset.FVersion := ''; // initialize to zeros
  FColors := TColorize.Create( Round( mand.Par.FIter )) ;
  end;

procedure TFrJulia.FormDestroy(Sender: TObject);
  begin
  Mand.Free;
  FColors.Free;
  end;

procedure TFrJulia.RenderJulia;
  begin
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
  Image1.Picture.Bitmap.PixelFormat := pf24bit;
  with mand.Par do
    begin
    FWidth := Image1.Picture.Bitmap.Width;
    FHeight := Image1.Picture.Bitmap.Height;
    end;
  mand.Prepare( FMandelset, FColors );
  mand.Render( false );
  image1.Repaint;//	Invalidate repaints background too
  end;

procedure TFrJulia.FormResize(Sender: TObject);
  begin
  RenderJulia;
  end;

end.
