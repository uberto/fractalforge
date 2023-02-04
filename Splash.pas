unit Splash;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Inifiles, Shellapi;

type
  TSplashForm = class(TForm)
    Timer1: TTimer;
    pnClient: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    lbversion: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label4Click(Sender: TObject);
    procedure GeneralClick(Sender: TObject);
  private
    TimeToWait: integer;
  public
  end;

var
  SplashForm: TSplashForm;

implementation

uses Main;
{$R *.DFM}

procedure TSplashForm.FormCreate(Sender: TObject);
	begin
	caption:='';
	end;

procedure TSplashForm.FormShow(Sender: TObject);
  begin
  timetowait := 4;
  lbversion.Caption := CVersion;
  end;

procedure TSplashForm.Button1Click(Sender: TObject);
  begin
  close;
  end;

procedure TSplashForm.Timer1Timer(Sender: TObject);
  begin
  timetowait:=timetowait-1;
	if ( timetowait <= 0 ) and MainForm.Visible then
		begin
		Timer1.Enabled := false;
		Close;
		end;
  end;

procedure TSplashForm.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
  Action := caFree;
  end;

procedure TSplashForm.Label4Click(Sender: TObject);
  begin
  ShellExecute( Handle, 'open', 'mailto:uberto@usa.net', '','', SW_SHOW	);
  end;

procedure TSplashForm.GeneralClick(Sender: TObject);
  begin
  TimeToWait := 0;
  end;

end.
