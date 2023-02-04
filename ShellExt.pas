unit ShellExt;

interface

procedure CreateShellExt;
procedure DestroyShellExt;
function DetectShellExt: boolean;

implementation

uses
  Registry, Messages, Windows, SysUtils, Forms;

const
  MAINREGISTRYKEY = '\Software\FractalForge';
  CLASSREGISTRYKEY = 'FractalForge.Files';

procedure AddShellExt(aReg: TRegistry; aExt, aKeyClass: string );
  begin
  if aReg.OpenKey( '\' + aExt, True ) then
    aReg.WriteString( '', aKeyClass );
  end;

procedure CreateShellExt;
  var
    Reg: TRegistry;

  begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CLASSES_ROOT;
    try
    if Reg.OpenKey( '\' + CLASSREGISTRYKEY, True ) then
      begin
      Reg.WriteString( '', 'FractalForge parameter file' );
      if Reg.OpenKey( '\' + CLASSREGISTRYKEY + '\shell\open\command', True ) then
        Reg.WriteString( '', '"' + Application.ExeName + '"  "%1"' );
      end;
    AddShellExt( reg, '.mnd', CLASSREGISTRYKEY );
    AddShellExt( reg, '.mnl', CLASSREGISTRYKEY );
    finally
    Reg.Free;
    end;
  end;

procedure DestroyShellExt;
  var
    Reg: TRegistry;

  begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CLASSES_ROOT;
  try
    Reg.DeleteKey( CLASSREGISTRYKEY );
  finally
    Reg.Free;
    end;
  end;

function DetectShellExt: boolean;
  var
    Reg: TRegistry;

  begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CLASSES_ROOT;
  try
    Result := Reg.OpenKey( CLASSREGISTRYKEY, False );
  finally
    Reg.Free;
    end;
  end;

end.
