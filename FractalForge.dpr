program FractalForge;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  About in 'About.pas' {AboutBox},
  DeltaCoo in 'DeltaCoo.pas' {DeltaDlg},
  Splash in 'Splash.pas' {SplashForm},
  ColorEdit in 'ColorEdit.pas' {FrEditColors},
  Graphic in 'Graphic.pas',
  Orbits in 'Orbits.pas' {FrOrbits},
  Rectangles in 'Rectangles.pas' {frRectangles},
  Files in 'Files.pas',
  Mandelbrot in 'Mandelbrot.pas',
  TiledImage in 'TiledImage.pas' {FrTiledImage},
  PngImage in 'PngImage.pas',
  pngdef in 'pngdef.pas',
  Julia in 'Julia.pas' {FrJulia},
  Animator in 'Animator.pas' {FrAnimator},
  AviWriter in 'AviWriter.pas';

{$R *.RES}

begin
  Application.ShowMainForm := false;
	Application.Title := ''; // it'll be assigned later
	Application.HelpFile := '';// it'll be assigned later
  SplashForm := TSplashForm.Create( nil );
  SplashForm.Show;
	Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFrOrbits, FrOrbits);
  Application.CreateForm(TfrRectangles, frRectangles);
  Application.CreateForm(TFrJulia, FrJulia);
  MainForm.FormStart;
	Application.Run;
end.
