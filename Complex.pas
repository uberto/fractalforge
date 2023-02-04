unit complex;

interface

uses Math, SysUtils;

type
	TComplex = record
		x,y: Extended
	end;

function Teta(const zed: TComplex): Extended;
function Modulus(const zed: TComplex): Extended;
function Modulus2(const zed: TComplex): Extended;
function ZPower(const zedBase, zedExponent: TComplex): TComplex; overload;
function ZPower(const zedBase: TComplex; const Exponent: Extended): TComplex; overload;
function ZSqr(const zed1: TComplex): TComplex;
function ZMul(const zed1, zed2: TComplex): TComplex; overload;
function ZMul(const real1: Extended; const zed2: TComplex): TComplex; overload;
function ZDiv(const zed1, zed2: TComplex): TComplex; overload;
function ZDiv(const real1: Extended; const zed2: TComplex): TComplex; overload;
function ZDiv(const zed1: TComplex; const real2: Extended): TComplex; overload;
function ZAdd(const zed1, zed2: TComplex): TComplex; overload;
function ZAdd(const zed1, zed2, zed3: TComplex): TComplex; overload;
function ZAdd(const zed1: TComplex; const real2: Extended): TComplex; overload;
function ZSub(const real1: Extended; const zed1: TComplex): TComplex; overload;
function ZSub(const zed1, zed2: TComplex): TComplex; overload;
function ZSin(const zed1: TComplex): TComplex;
function ZTan(const zed1: TComplex): TComplex;

implementation

function StrToFloatDef( AValue: String; DefValue: Extended ): Extended;
  begin
    try
    Result := StrToFloat( AValue );
    except
    Result := DefValue;
    end;
  end;

function Modulus(const zed: TComplex): Extended;
begin
	result := sqrt(Modulus2(zed))
end;

function Modulus2(const zed: TComplex): Extended;
	begin
	result := zed.x*zed.x + zed.y*zed.y;
	end;

function Teta(const zed: TComplex): Extended;
begin
	if zed.x <> 0 then
		result := ArcTan2(zed.y, zed.x)
	else if zed.y = 0.0 then
		result := 0.0
	else if zed.y > 0 then
		result := PI/2
	else result := -PI/2;
end;

function ZSqr(const zed1: TComplex): TComplex;
  begin
  result.x := zed1.x * zed1.x - zed1.y * zed1.y;
  result.y := zed1.y * zed1.x;
  result.y := result.y + result.y;
  end;

function ZMul(const zed1, zed2: TComplex): TComplex;
  begin
  result.x := zed1.x * zed2.x - zed1.y * zed2.y;
  result.y := zed1.x * zed2.y + zed1.y * zed2.x;
  end;

function ZMul(const real1: Extended; const zed2: TComplex): TComplex;
  begin
  result.x := zed2.x * real1;
  result.y := zed2.y * real1;
  end;


function ZDiv(const zed1, zed2: TComplex): TComplex;
  var
    t: Extended;
  begin
  t := Modulus2(zed2);

	if t <> 0 then
		begin
    result.x := (zed1.x * zed2.x + zed1.y * zed2.y) / t;
    result.y := (zed1.y * zed2.x - zed1.x * zed2.y) / t;
    end
  else
		begin
		result.x:=0;
		result.y:=0;
		end;
  end;

function ZDiv(const real1: Extended; const zed2: TComplex): TComplex;
  var
    t: Extended;
  begin
  t := Modulus2(zed2);
	if t <> 0 then
		begin
    result.x := (real1 * zed2.x) / t;
    result.y := (-real1 * zed2.y) / t;
    end
  else
		begin
		result.x:=0;
		result.y:=0;
		end;
  end;

function ZDiv(const zed1: TComplex; const real2: Extended): TComplex;
  begin
	if real2 <> 0 then
		begin
    result.x := zed1.x / real2;
    result.y := zed1.y / real2;
    end
  else
		begin
		result.x:=0;
		result.y:=0;
		end;
  end;

function ZPower(const zedBase, zedExponent: TComplex): TComplex;
	var
		lnm,m,t,s,c: Extended;
	begin
	m := Modulus2(zedBase);
	if m > 0 then
		begin
		t := Teta(zedBase);
		lnm := ln(m) / 2;
		SinCos(zedExponent.x*t + zedExponent.y*Lnm, s, c);
		m := exp(zedExponent.x*lnm - zedExponent.y*t);
		result.x := m*c;
		result.y := m*s;
		end
	else
		begin
		result.x:=0;
		result.y:=0;
		end;
	end;

function ZPower(const zedBase: TComplex; const Exponent: Extended): TComplex;
	var
		lnm,m,t,s,c: Extended;
	begin
	m := Modulus2(zedBase);
	if m > 0 then
		begin
		t := Teta(zedBase);
		lnm := ln(m) / 2;
		SinCos(Exponent*t, s, c);
		m := exp(Exponent*lnm );
		result.x := m*c;
		result.y := m*s;
		end
	else
		begin
		result.x:=0;
		result.y:=0;
		end;
	end;

function ZAdd(const zed1: TComplex; const real2: Extended): TComplex;
  begin
  result.x := zed1.x + real2;
  result.y := zed1.y;
  end;

function ZAdd(const zed1, zed2: TComplex): TComplex;
  begin
  result.x := zed1.x + zed2.x;
  result.y := zed1.y + zed2.y;
  end;

function ZAdd(const zed1, zed2, zed3: TComplex): TComplex;
  begin
  result.x := zed1.x + zed2.x + zed3.x;
  result.y := zed1.y + zed2.y + zed3.y;
  end;

function ZSub(const zed1, zed2: TComplex): TComplex;
  begin
  result.x := zed1.x - zed2.x;
  result.y := zed1.y - zed2.y;
  end;

function ZSub(const real1: Extended; const zed1: TComplex): TComplex;
  begin
  result.x := real1 - zed1.x;
  result.y := - zed1.y;
  end;

function ZSin(const zed1: TComplex): TComplex;
  begin
  result.x := sin(zed1.x) * cosh(zed1.y);
  result.y := cos(zed1.x) * sinh(zed1.y);
  end;

function ZTan(const zed1: TComplex): TComplex;
  var
    t: Extended;
  begin
  t := cos(2.0*zed1.x) + cosh(2.0*zed1.y);
  if t = 0 then
    begin
    result.x := 0;
    result.y := 0;
    end
  else
    begin
    result.x := sin(2.0*zed1.x) /t;
    result.y := sinh(2.0*zed1.y)/t;
    end;
  end;

end.

