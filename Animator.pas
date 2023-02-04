unit Animator;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Complex;

type
  TFrAnimator = class(TForm)
    btCancel: TBitBtn;
    BtOK: TBitBtn;
    PnDestinationPoint: TPanel;
    PnStartingPoint: TPanel;
    Label3: TLabel;
    Label9: TLabel;
    SpeedButton1: TSpeedButton;
    edName: TEdit;
    edDir: TEdit;
    Label1: TLabel;
    edNum: TEdit;
    Label7: TLabel;
    edRPoC1: TEdit;
    Label8: TLabel;
    edIPoC1: TEdit;
    Label2: TLabel;
    edMagnit1: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label12: TLabel;
    edRPoC2: TEdit;
    Label13: TLabel;
    edIPoC2: TEdit;
    Label14: TLabel;
    edMagnit2: TEdit;
    Label15: TLabel;
    edStarting: TEdit;
    CbAvi: TCheckBox;
    Label16: TLabel;
    edFPS: TEdit;
    btPasteStart: TSpeedButton;
    Label11: TLabel;
    Label10: TLabel;
    Label17: TLabel;
    btPasteDest: TSpeedButton;
    cbDeleteBmp: TCheckBox;
    cbPlayAvi: TCheckBox;
    edMaxIter2: TEdit;
    Label18: TLabel;
    edMaxIter1: TEdit;
    Label19: TLabel;
    procedure BtOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btPasteStartClick(Sender: TObject);
    procedure btPasteDestClick(Sender: TObject);
    procedure CbAviClick(Sender: TObject);
  private
    procedure PasteFromClipboard(StartV, DestV: boolean);
  public
    function AviName: string;
  end;

implementation

{$R *.DFM}

uses
  FileCtrl, Clipbrd;

procedure TFrAnimator.BtOKClick(Sender: TObject);

  function CheckNum(Edit: TEdit; min, max: Double): Boolean;
    var
      nx: double;
    begin
    nx := StrToFloatDef( Edit.Text, min - 1 );
    if ( nx < min ) or ( nx > max ) then
      begin
      Edit.setfocus;
      beep;
      Result := False;
      end
    else
      Result := True;
    end;

  begin
  if not CheckNum( edStarting, 1, 9999 ) then
    exit;
  if not CheckNum( edNum, 1, 10000 - StrToInt( edStarting.Text ) ) then
    exit;
  if not CheckNum( edFPS, 1, 25 ) then
    exit;
  if not CheckNum( edRPoC1, -9999, 9999 ) then
    exit;
  if not CheckNum( edIPoC1, -9999, 9999 ) then
    exit;
  if not CheckNum( edMaxIter1, 1, 1E+10 ) then
    exit;
  if not CheckNum( edMagnit1, 0.00001, 1E+18 ) then
    exit;

  if not CheckNum( edRPoC2, -9999, 9999 ) then
    exit;
  if not CheckNum( edIPoC2, -9999, 9999 ) then
    exit;
  if not CheckNum( edMaxIter2, 1, 1E+10 ) then
    exit;
  if not CheckNum( edMagnit2, 0.00001, 1E+18 ) then
    exit;

  if (edRPoC1.Text = edRPoC2.Text) and (edIPoC1.Text = edIPoC2.Text)
      and (edMaxIter1.Text = edMaxIter2.Text) and (edMagnit1.Text = edMagnit2.Text) then
    begin
    ShowMessage('Starting and destination points must be different!');
    Exit;
    end;

  if Trim(edName.Text) = '' then
    begin
    edName.SetFocus;
    beep;
    exit;
    end;

  if Trim(edDir.Text) = '' then
    begin
    edName.SetFocus;
    beep;
    exit;
    end;

  if FileExists( AviName ) and not ( MessageDlg('File exists! Do you really want to overwrite it?',
           mtWarning, [mbYes,mbNo], 0) = mrYes ) then
    Exit;

  if not DirectoryExists( edDir.Text ) then
    ForceDirectories( edDir.Text );

  ModalResult := mrOk;
  end;

function TFrAnimator.AviName: string;
  begin
  result := edDir.Text + PathDelim + edName.Text + '.avi';
  end;

procedure TFrAnimator.FormShow(Sender: TObject);
  begin
  edNum.Text := '50';
  edFPS.Text := '10';
  edStarting.Text := '1';
  end;

procedure TFrAnimator.SpeedButton1Click(Sender: TObject);
  var
    dir: string;
  begin
  dir := edDir.Text;
  if SelectDirectory('Select a directory where store Bmp and Avi files','',dir) then
    edDir.Text := dir;
  end;

procedure TFrAnimator.PasteFromClipboard(StartV, DestV: boolean);
  var
    sl: TStringList;
    cx, cy, it, ma: string;
  begin
  sl := TStringList.Create;
    try
    sl.Text := Clipboard.AsText;
    if StrToBoolDef( Trim(sl.Values['Julia']), False ) then
      begin
      cx := Trim(sl.Values['Center R.']);
      cy := Trim(sl.Values['Center I.']);
      end
    else
      begin
      cx := Trim(sl.Values['Center R.']);
      cy := Trim(sl.Values['Center I.']);
      end;
    ma := Trim(sl.Values['Magnific.']);
    it := Trim(sl.Values['Iterations']);
    if StartV then
      begin
      edRPoC1.Text := cx;
      edIPoC1.Text := cy;
      edMagnit1.Text := ma;
      edMaxIter1.Text := it;
      end;
    if DestV then
      begin
      edRPoC2.Text := cx;
      edIPoC2.Text := cy;
      edMagnit2.Text := ma;
      edMaxIter2.Text := it;
      end
    finally
    sl.Free;
    end;
  end;

procedure TFrAnimator.btPasteStartClick(Sender: TObject);
  begin
  PasteFromClipboard(True, False);
  end;

procedure TFrAnimator.btPasteDestClick(Sender: TObject);
  begin
  PasteFromClipboard(False, True);
  end;

procedure TFrAnimator.CbAviClick(Sender: TObject);
begin
  cbPlayAvi.Enabled := CbAvi.Checked;
  cbDeleteBmp.Enabled := CbAvi.Checked;
end;

end.

