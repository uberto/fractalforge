unit DeltaCoo;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, SysUtils, Dialogs;

type
  TDeltaDlg = class(TForm)
    Bevel1: TBevel;
    Label2: TLabel;
    edBLR: TEdit;
    edBLI: TEdit;
    Label3: TLabel;
    edTRR: TEdit;
    Label4: TLabel;
    edTRI: TEdit;
    Label5: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    Label6: TLabel;
    BtnCancel: TBitBtn;
    btnOk: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Rapp: extended;
  public
    { Public declarations }
  end;

var
  DeltaDlg: TDeltaDlg;

implementation

uses Main;

{$R *.DFM}

procedure TDeltaDlg.FormShow(Sender: TObject);
var
R,I,M,A,W,H : extended;
st: integer;

begin
with MainForm do
	begin
	val(edRPoC.text,R,st);
	val(edIPoC.text,I,st);
	val(edMagnit.text,M,st);
	val(edAspectR.text,A,st);
	val(edWidth.text,W,st);
	val(edHeight.text,H,st);
  Rapp := A * W / H;

	edBLR.text:=FloatToStr(R-Rapp/(M*2));
	edBLI.text:=FloatToStr(I-1/(M*2));
	edTRR.text:=FloatToStr(R+Rapp/(M*2));
	edTRI.text:=FloatToStr(I+1/(M*2));
	end;

end;

procedure TDeltaDlg.CancelBtnClick(Sender: TObject);
begin
close;
end;

procedure TDeltaDlg.OKBtnClick(Sender: TObject);
	var
		LR,LI,RR,RI:extended;
		st : integer;
    
  function Different( n1, n2: extended ): boolean;
    begin
    result := ( n1 > n2 * 1.001 ) or ( n1 * 1.001 < n2 )
    end;
    
	begin
  val(edBLR.text,LR,st);
  val(edBLI.text,LI,st);
  val(edTRR.text,RR,st);
  val(edTRI.text,RI,st);
  if Different( Rapp * (RI-LI), (RR-LR) ) then
    begin
    showmessage( 'Incompatible values !' );
  	edTRR.text := FloatToStr((RR+LR)/2+Rapp*(RI-LI)/2);
    edBLR.text := FloatToStr((RR+LR)/2-Rapp*(RI-LI)/2);
    exit;
    end;
	with MainForm do
		begin
		edRPoC.text:=FloatToStr((RR+LR)/2);
		edIPoC.text:=FloatToStr((RI+LI)/2);
		edMagnit.text:=FloatToStr(1/(RI-LI));
		end;
	ModalResult := mrOK;
	end;

procedure TDeltaDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
end;

end.
