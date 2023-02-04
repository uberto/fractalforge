unit Rectangles;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, ComCtrls, ExtCtrls, Grids;

type
	TVertex = record
		R : extended;
		I : extended;
		end;

	TfrRectangles = class(TForm)
		Image1: TImage;
		edIterac: TEdit;
		UpDown1: TUpDown;
		Label1: TLabel;
    lbIngr: TLabel;
    lbReal: TLabel;
    lbImmag: TLabel;
    lbMaxI: TLabel;
    lbMinR: TLabel;
    lbMinI: TLabel;
    lbMaxR: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
		procedure edIteracChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
	private
		{ Private declarations }
	public
		{ Public declarations }
		FReal : extended;
		FImmag : extended;
		FIngr : extended;
		procedure TraceRects;
	end;

var
	frRectangles: TfrRectangles;

implementation

{$R *.DFM}

procedure TfrRectangles.TraceRects;
	const
		NV = 25;
	var
		k,it,mit: integer;
		cr, ci, offset,r,i,zqr,zqi,pz: extended;
		Points: array[0 .. NV] of TPoint;
		Verteces: array[0 .. NV-1] of TVertex;
		maxI,	maxR,	minI, minR, delta : extended;

	begin
	lbIngr.Caption := floattostr(Fingr);
	lbImmag.Caption := floattostr(FImmag);
	lbReal.Caption := floattostr(FReal);
  Image1.Canvas.FillRect( image1.ClientRect );
	if (Freal <> 0) and (Fimmag <> 0) then
		begin
		mit := Strtointdef(edIterac.text ,10);
		offset := 1/(Fingr * 2);

		for k:=0 to NV-1 do
			begin
			pz := 0;
			zqi := 0;
			zqr := 0;
			it := 0;
			cr := Freal + (offset / 5) * (k mod 5 - 2);
			ci := Fimmag + (offset / 5) * (k div 5 - 2);
  		r := 0;
			i := 0;
			while ((it < mit) and (ZqR + ZqI < 4)) do //alto sx
				begin
				r := ZqR - ZqI + cr;
				i := PZ + PZ + ci;
				ZqI := i * i;
				PZ := r * i;
				ZqR := r * r;
				inc(it);
				end;
			if it = mit then
				begin
				Verteces[k].R := r;
				Verteces[k].I := i;
				end
			else
				begin
				Verteces[k].R := 0;
				Verteces[k].I := 0;
				end
			end;


		maxI := -3;
		maxR := -3;
		minI := 3;
		minR := 3;

		for k :=0 to NV-1 do
			begin
			if Verteces[k].R < minR then
				minR := Verteces[k].R;
			if Verteces[k].I < minI then
				minI := Verteces[k].I;
			if Verteces[k].R > maxR then
				maxR := Verteces[k].R;
			if Verteces[k].I > maxI then
				maxI := Verteces[k].I;
			end;

		delta := maxR - minR;
		if maxI - minI > delta then
			delta := maxI-minI;

		lbMinR.Caption := FloatToStr(minR);
		lbMinI.Caption := FloatToStr(minI);
		lbMaxR.Caption := FloatToStr(minR + delta);
		lbMaxI.Caption := FloatToStr(minI + delta);

		if delta > 0 then
			begin
			for k :=0 to NV-1 do
				begin
				Points[k].x := 10 + round((Verteces[k].R - minR) / delta * (Image1.Width - 20)); //i 10 e i 20 sono per lasciare un bordo
				Points[k].y := 10 + round((Verteces[k].I - minI) / -delta * (20 - Image1.Height)); //invertito alto basso
				end;

			Points[NV] := Points[0];
			for k := 0 to 4 do
				image1.Canvas.Polyline([Points[k*5],Points[k*5+1],Points[k*5+2],Points[k*5+3],Points[k*5+4]]);
			for k := 0 to 4 do
				image1.Canvas.Polyline([Points[k],Points[k+5],Points[k+10],Points[k+15],Points[k+20]]);
      end;
		end;
	end;

procedure TfrRectangles.edIteracChange(Sender: TObject);
  begin
  TraceRects;
  end;

procedure TfrRectangles.FormCreate(Sender: TObject);
  begin
	Image1.Picture.Bitmap.PixelFormat := pf8bit;
	Image1.Picture.Bitmap.Width := Image1.Width;
	Image1.Picture.Bitmap.Height := Image1.Height;
	FReal := 0;
	FImmag := 0;
	edIterac.Text := '100';
  TraceRects;
  end;

end.
