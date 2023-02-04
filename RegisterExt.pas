unit RegisterExt;

interface

procedure CreateShellExt;
procedure DestroyShellExt;
function DetectShellExt: boolean;

implementation

uses
  Registry, Messages, Windows, SysUtils, Forms;

const
  MAIN_REGISTRY_KEY = '\Software\FractalForge';
  CLASS_REGISTRY_KEY = 'FractalForge.Files';
  DESCRIPTION_KEY = 'FractalForge files';

procedure AssociaShellExt(aReg: TRegistry; aExt, aKeyClass: string );
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
    if Reg.OpenKey( '\' + CLASS_REGISTRY_KEY, True ) then
      begin
      Reg.WriteString( '', DESCRIPTION_KEY );
      if Reg.OpenKey( '\' + CLASS_REGISTRY_KEY + '\shell\open\command', True ) then
        Reg.WriteString( '', '"' + Application.ExeName + '"  "%1"' );
      end;
    AssociaShellExt( reg, '.mnd', CLASS_REGISTRY_KEY );
    AssociaShellExt( reg, '.mnl', CLASS_REGISTRY_KEY );
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
    Reg.DeleteKey( CLASS_REGISTRY_KEY );
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
    Result := Reg.OpenKey( CLASS_REGISTRY_KEY, False );
  finally
    Reg.Free;
    end;
  end;

end.
