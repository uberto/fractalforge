unit TiledImage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Main, Mandelbrot, ExtCtrls;

type
  TFrTiledImage = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edVtiles: TEdit;
    edHTiles: TEdit;
    edWidth: TEdit;
    edHeight: TEdit;
    edGlobalWidth: TEdit;
    edGlobalHeight: TEdit;
    edName: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label9: TLabel;
    edDir: TEdit;
    SpeedButton1: TSpeedButton;
    rgExt: TRadioGroup;
    Label10: TLabel;
    lbTot: TLabel;
    procedure edHeightChange(Sender: TObject);
    procedure edHTilesChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}
uses
  FileCtrl; //Only for non CLX

procedure TFrTiledImage.edHeightChange(Sender: TObject);
  begin
  edGlobalHeight.Text := IntToStr( strtointdef( edVtiles.Text, 0 ) * strtointdef( edHeight.Text, 0 ) );
  lbTot.Caption := IntToStr( StrToIntDef( edHTiles.Text, 0 ) * StrToIntDef( edVtiles.Text, 0 ) );
  end;

procedure TFrTiledImage.edHTilesChange(Sender: TObject);
  begin
  edGlobalWidth.Text := IntToStr( strtointdef( edHtiles.Text, 0 ) * strtointdef( edWidth.Text, 0 ) );
  lbTot.Caption := IntToStr( StrToIntDef( edHTiles.Text, 0 ) * StrToIntDef( edVtiles.Text, 0 ) );
  end;

procedure TFrTiledImage.BitBtn2Click(Sender: TObject);
  begin
  Close;
  end;

procedure TFrTiledImage.BitBtn1Click(Sender: TObject);
  var 
    w, h, nx, ny : integer;
  begin
  nx := StrToIntDef( edHTiles.Text, -1 );
  if ( nx < 1 ) or ( nx > 99 ) then
    begin
    edHTiles.setfocus;
    beep;
    exit;
    end;
  ny := StrToIntDef( edVTiles.Text, -1 );
  if ( ny < 1 ) or ( ny > 99 ) then
    begin
    edVTiles.setfocus;
    beep;
    exit;
    end;
  w := StrToIntDef( edWidth.Text, -1 );
  if ( w < 1 ) or ( w > 30000 ) then
    begin
    edwidth.setfocus;
    beep;
    exit;
    end;
  h := StrToIntDef( edHeight.Text, -1 );
  if ( h < 1 ) or ( h > 30000 ) then
    begin
    edheight.setfocus;
    beep;
    exit;
    end;

  if edName.Text = '' then
    begin
    edName.SetFocus;
    beep;
    exit;
    end;

  if not DirectoryExists( edDir.Text ) then
    ForceDirectories( edDir.Text );

  ModalResult := mrOk;
  end;

procedure TFrTiledImage.SpeedButton1Click(Sender: TObject);
  var
    Dir: string;
  begin
  Dir := edDir.Text;
  if Dir = '' then
    Dir := GetCurrentDir;
  if SelectDirectory( Dir, [ sdAllowCreate, sdPerformCreate,sdPrompt	], 0 ) then
    edDir.Text := Dir;
  end;

procedure TFrTiledImage.FormShow(Sender: TObject);
  begin
  edDir.Text := GetCurrentDir;
  edName.Text := '';
  end;

end.
