unit Files;

interface

uses
  Windows, Classes, SysUtils;

procedure DirToStrings(APath : string; AStrings : TStrings; WithExt, WithPath: boolean ); //APath = c:\windows\*.exe
procedure SetWallPaper( ImageFileName: string; IsTiled: boolean );
function GetFileSize( FileName: string ): int64;

implementation

function GetFileSize( FileName:string ): int64;
  var
    fh: integer;
    fi: TByHandleFileInformation;
  begin
  result := 0;
  fh := fileopen( FileName, fmOpenRead );
    try
    if GetFileInformationByHandle( fh, fi ) then
      begin
      result := fi.nFileSizeHigh;
      result := result shr 32 + fi.nFileSizeLow;
      end;
    finally
    fileclose( fh );
    end;
  end;

procedure SetWallPaper( ImageFileName: string; IsTiled: boolean );
  begin
  SystemParametersInfo( SPI_SETDESKWALLPAPER, 0, PChar( imagefilename ), SPIF_UPDATEINIFILE );
  end;


procedure DirToStrings(APath : string; AStrings : TStrings; WithExt, WithPath: boolean ); //APath = c:\windows\*.exe
	var
		Found, p : integer;
		SearchRec : TSearchRec;
    fn: string;
	begin
	AStrings.Clear;
	Found := FindFirst(APath, faAnyFile, SearchRec);
	while Found = 0 do
		begin
		p := Pos('.',SearchRec.Name);
		if p > 1 then //esclude . e .. e i file con nomi piu' lunghi di 10
			begin
      fn := SearchRec.Name;
      if not WithExt then
        fn := ChangeFileExt( fn, '' );
      if WithPath then
        fn := ExtractFilePath( APath ) + fn;
			AStrings.Add( fn );
			end;
		Found := FindNext( SearchRec );
		end;
	FindClose( SearchRec );
	end;

end.
