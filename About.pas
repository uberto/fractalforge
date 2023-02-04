unit About;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Copyright: TLabel;
    OKButton: TBitBtn;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MailClick(Sender: TObject);
    procedure HttpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

uses
  Main, ShellApi;

{$R *.DFM}

procedure TAboutBox.FormCreate(Sender: TObject);
begin
ProductName.caption:=CProductName;
Version.caption:=CVersion;
Copyright.caption:='by Uberto Barbini';
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
close;
end;

procedure TAboutBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TAboutBox.MailClick(Sender: TObject);
begin
  ShellExecute( Handle, 'open', 'mailto:uberto@ubiland.net', '','', SW_SHOW	);
end;

procedure TAboutBox.HttpClick(Sender: TObject);
begin
  ShellExecute( Handle, 'open', 'http://sourceforge.net/projects/fractalforge', '','', SW_SHOW	);
end;

end.

