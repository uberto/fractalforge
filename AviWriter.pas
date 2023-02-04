unit AviWriter;

// Changes by Uberto Barbini (uberto@usa.net):
// Replaced Tbitmap list with a TStringList to fill with filenames of bmps.
// Pruned property Stretch
// Recfactored AddBitmap
// Added two events (OnCreating, OnSaving) for progress feedback.
// Added dialog for choose codec
// Added property to delete files after creation
// Added SaveAvi procedure to choose another codec if one fails
// Added PlayAvi property to play the avi after creation

/////////////////////////////////////////////////////////////////////////////
//                                                                         //
//       AviWriter -- a component to create rudimentary AVI files          //
//                  by Elliott Shevin, with large pieces of code           //
//                  stolen from Anders Melander                            //
//       version 1.0. Please send comments, suggestions, and advice        //
//       to shevine@aol.com.                                               //
/////////////////////////////////////////////////////////////////////////////
//                                                                         //
//  AviWriter will build an AVI file containing one stream of any          //
//  number of TBitmaps, plus a single WAV file.                            //
//                                                                         //
//  Properties:                                                            //
//     Bitmaps : A TList of pointers to TBitmap objects which become       //
//               frames of the AVI video stream. The component             //
//               allocates and frees the TList, but the caller             //
//               is responsible for managing the TBitmaps themselves.      //
//               Manipulate the list as you would any other TList.         //
//               At least one bitmap is required.                          //
//     Height, Width:                                                      //
//               The dimensions of the AVI video, in pixels.               //
//     FrameTime:                                                          //
//               The duration of each video frame, in milliseconds.        //
//     Stretch:  If TRUE, each TBitmap on the Bitmaps list is              //
//               stretches to the dimensions specified in Height           //
//               and Width. If FALSE, each TBitmap is copied from          //
//               its upper left corner without stretching.                 //
//     FileName: The name of the AVI file to be written.                   //
//     WAVFileName:                                                        //
//               The name of a WAV file which will become the audio        //
//               stream for the AVI. Optional.                             //
//                                                                         //
//  Method:                                                                //
//      Write:  Creates the AVI file named by FileName.                    //
/////////////////////////////////////////////////////////////////////////////
//  Wish List:                                                             //
//    I'd like to be able to enhance this component in two ways, but       //
//    don't know how. Please send ideas to shevine@aol.com.                //
//       1. So far, it's necessary to transform the video stream into      //
//          and AVI file on disk. I'd prefer to do this in memory.         //
//       2. MIDI files for audio.                                          //
/////////////////////////////////////////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ActiveX, ShellApi;

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                      Video for Windows                                     //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Adapted from Thomas Schimming's VFW.PAS                                    //
// (c) 1996 Thomas Schimming, schimmin@iee1.et.tu-dresden.de                  //
// (c) 1998,99 Anders Melander                                                //
// (c) 2002 Uberto Barbini                                                    //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Ripped all COM/ActiveX stuff and added some AVI stream functions.          //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

type
 { TAVIFileInfoW record }

  LONG = Longint;
  PVOID = Pointer;

// TAVIFileInfo dwFlag values
const
  AVIF_HASINDEX		= $00000010;
  AVIF_MUSTUSEINDEX	= $00000020;
  AVIF_ISINTERLEAVED	= $00000100;
  AVIF_WASCAPTUREFILE	= $00010000;
  AVIF_COPYRIGHTED	= $00020000;
  AVIF_KNOWN_FLAGS	= $00030130;

  AVIERR_UNSUPPORTED              = $80044065; // MAKE_AVIERR(101)
  AVIERR_BADFORMAT                = $80044066; // MAKE_AVIERR(102)
  AVIERR_MEMORY                   = $80044067; // MAKE_AVIERR(103)
  AVIERR_INTERNAL                 = $80044068; // MAKE_AVIERR(104)
  AVIERR_BADFLAGS                 = $80044069; // MAKE_AVIERR(105)
  AVIERR_BADPARAM                 = $8004406A; // MAKE_AVIERR(106)
  AVIERR_BADSIZE                  = $8004406B; // MAKE_AVIERR(107)
  AVIERR_BADHANDLE                = $8004406C; // MAKE_AVIERR(108)
  AVIERR_FILEREAD                 = $8004406D; // MAKE_AVIERR(109)
  AVIERR_FILEWRITE                = $8004406E; // MAKE_AVIERR(110)
  AVIERR_FILEOPEN                 = $8004406F; // MAKE_AVIERR(111)
  AVIERR_COMPRESSOR               = $80044070; // MAKE_AVIERR(112)
  AVIERR_NOCOMPRESSOR             = $80044071; // MAKE_AVIERR(113)
  AVIERR_READONLY                 = $80044072; // MAKE_AVIERR(114)
  AVIERR_NODATA                   = $80044073; // MAKE_AVIERR(115)
  AVIERR_BUFFERTOOSMALL           = $80044074; // MAKE_AVIERR(116)
  AVIERR_CANTCOMPRESS             = $80044075; // MAKE_AVIERR(117)
  AVIERR_USERABORT                = $800440C6; // MAKE_AVIERR(198)
  AVIERR_ERROR                    = $800440C7; // MAKE_AVIERR(199)

type
  TAVIFileInfoW = record
    dwMaxBytesPerSec,	// max. transfer rate
    dwFlags,		// the ever-present flags
    dwCaps,
    dwStreams,
    dwSuggestedBufferSize,
    dwWidth,
    dwHeight,
    dwScale,
    dwRate,	// dwRate / dwScale == samples/second
    dwLength,
    dwEditCount: DWORD;

    szFileType: array[0..63] of WideChar;		// descriptive string for file type?
  end;
  PAVIFileInfoW = ^TAVIFileInfoW;
// TAVIStreamInfo dwFlag values
const
  AVISF_DISABLED	= $00000001;
  AVISF_VIDEO_PALCHANGES= $00010000;
  AVISF_KNOWN_FLAGS	= $00010001;

type
  TAVIStreamInfoA = record
    fccType,
    fccHandler,
    dwFlags,        // Contains AVITF_* flags
    dwCaps: DWORD;
    wPriority,
    wLanguage: WORD;
    dwScale,
    dwRate, // dwRate / dwScale == samples/second
    dwStart,
    dwLength, // In units above...
    dwInitialFrames,
    dwSuggestedBufferSize,
    dwQuality,
    dwSampleSize: DWORD;
    rcFrame: TRect;
    dwEditCount,
    dwFormatChangeCount: DWORD;
    szName:  array[0..63] of AnsiChar;
  end;
  TAVIStreamInfo = TAVIStreamInfoA;
  PAVIStreamInfo = ^TAVIStreamInfo;

  { TAVIStreamInfoW record }

  TAVIStreamInfoW = record
    fccType,
    fccHandler,
    dwFlags,        // Contains AVITF_* flags
    dwCaps: DWORD;
    wPriority,
    wLanguage: WORD;
    dwScale,
    dwRate, // dwRate / dwScale == samples/second
    dwStart,
    dwLength, // In units above...
    dwInitialFrames,
    dwSuggestedBufferSize,
    dwQuality,
    dwSampleSize: DWORD;
    rcFrame: TRect;
    dwEditCount,
    dwFormatChangeCount: DWORD;
    szName:  array[0..63] of WideChar;
  end;

  PAVIStream = pointer;
  PAVIFile = pointer;
  TAVIStreamList = array[0..0] of PAVIStream;
  PAVIStreamList = ^TAVIStreamList;
  TAVISaveCallback = function (nPercent: integer): LONG; stdcall;

  TAVICompressOptions = packed record
    fccType		: DWORD;
    fccHandler		: DWORD;
    dwKeyFrameEvery	: DWORD;
    dwQuality		: DWORD;
    dwBytesPerSecond	: DWORD;
    dwFlags		: DWORD;
    lpFormat		: pointer;
    cbFormat		: DWORD;
    lpParms		: pointer;
    cbParms		: DWORD;
    dwInterleaveEvery	: DWORD;
  end;
  PAVICompressOptions = ^TAVICompressOptions;

const
  ICMF_CHOOSE_KEYFRAME = $00000001;
  ICMF_CHOOSE_DATARATE = $00000002;
  ICMF_CHOOSE_PREVIEW = $00000004;
  ICMF_CHOOSE_ALLCOMPRESSORS = $00000008;

// Palette change data record
  RIFF_PaletteChange: DWORD = 1668293411;

type
  TAVIPalChange = packed record
    bFirstEntry		: byte;
    bNumEntries		: byte;
    wFlags		: WORD;
    peNew		: array[byte] of TPaletteEntry;
  end;
  PAVIPalChange = ^TAVIPalChange;

  APAVISTREAM          = array[0..1] of PAVISTREAM;
  APAVICompressOptions = array[0..1] of PAVICompressOptions;

procedure AVIFileInit; stdcall;
procedure AVIFileExit; stdcall;
function AVIFileOpen(var ppfile: PAVIFile; szFile: PChar; uMode: UINT; lpHandler: pointer): HResult; stdcall;
function AVIFileCreateStream(pfile: PAVIFile; var ppavi: PAVISTREAM; var psi: TAVIStreamInfo): HResult; stdcall;
function AVIStreamSetFormat(pavi: PAVIStream; lPos: LONG; lpFormat: pointer; cbFormat: LONG): HResult; stdcall;
function AVIStreamReadFormat(pavi: PAVIStream; lPos: LONG; lpFormat: pointer; var cbFormat: LONG): HResult; stdcall;
function AVIStreamWrite(pavi: PAVIStream; lStart, lSamples: LONG; lpBuffer: pointer; cbBuffer: LONG; dwFlags: DWORD; var plSampWritten: LONG; var plBytesWritten: LONG): HResult; stdcall;
function AVIStreamRelease(pavi: PAVISTREAM): ULONG; stdcall;
function AVIFileRelease(pfile: PAVIFile): ULONG; stdcall;
function AVIFileGetStream(pfile: PAVIFile; var ppavi: PAVISTREAM; fccType: DWORD; lParam: LONG): HResult; stdcall;
function CreateEditableStream(var ppsEditable: PAVISTREAM; psSource: PAVISTREAM): HResult; stdcall;
function AVISaveV(szFile: PChar; pclsidHandler: PCLSID; lpfnCallback: TAVISaveCallback;
  nStreams: integer; pavi: APAVISTREAM; lpOptions: APAVICompressOptions): HResult; stdcall;
function AVISaveOptions(Handle: HWND; uiFlags: UINT; nStreams: integer; pavi: APAVISTREAM; lpOptions: APAVICompressOptions): BOOL; stdcall;

const
  AVIERR_OK       = 0;

  AVIIF_LIST      = $01;
  AVIIF_TWOCC	  = $02;
  AVIIF_KEYFRAME  = $10;

  streamtypeVIDEO = $73646976; // DWORD( 'v', 'i', 'd', 's' )
  streamtypeAUDIO = $73647561; // DWORD( 'a', 'u', 'd', 's' )


type
  TPixelFormat = (pfDevice, pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit, pfCustom);

  TCreatingEvent = procedure(Sender: TObject; Percent: integer; var Continue: Boolean) of object;

  TAviWriter = class(TComponent)
  private
    TempFileName   : string;
    pFile          : PAVIFile;
    fHeight        : integer;
    fWidth         : integer;
    fFrameTime     : integer;
    fFileName      : string;
    fWavFileName   : string;
    VideoStream    : PAVISTREAM;
    AudioStream    : PAVISTREAM;
    FOnCreating: TCreatingEvent;
    FOnSaving: TCreatingEvent;
    FDeleteFiles: Boolean;
    FPlayAvi: Boolean;

    procedure AddVideo;
    procedure AddAudio;
    procedure InternalGetDIBSizes(Bitmap: HBITMAP; var InfoHeaderSize: Integer;
        var ImageSize: longInt; PixelFormat: TPixelFormat);
    function InternalGetDIB(Bitmap: HBITMAP; Palette: HPALETTE;
        var BitmapInfo; var Bits; PixelFormat: TPixelFormat): Boolean;
    procedure InitializeBitmapInfoHeader(Bitmap: HBITMAP; var Info: TBitmapInfoHeader;
           PixelFormat: TPixelFormat);
    procedure SetWavFileName(value : string);
    procedure AddBitmapsFromFiles(pStream: PAVISTREAM);
    procedure AddBitmap(TmpBmp: TBitmap; Pos: integer;
      pStream: PAVISTREAM);
    procedure SetOnCreating(const Value: TCreatingEvent);
    procedure SetOnSaving(const Value: TCreatingEvent);
    procedure SetDeleteFiles(const Value: Boolean);
    procedure SetPlayAvi(const Value: Boolean);
  protected
    procedure SaveAvi(const FileName: string; nStreams: integer;
      Streams: APAVISTREAM);
  public
    BitmapNames : TStringList;
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure Write;
  published
    property Height: integer read fHeight  write fHeight;
    property Width: integer read fWidth   write fWidth;
    property FrameTime: integer read fFrameTime write fFrameTime;
    property FileName: string read fFileName write fFileName;
    property WavFileName: string read fWavFileName write SetWavFileName;
    property DeleteFiles: Boolean read FDeleteFiles write SetDeleteFiles;
    property PlayAvi: Boolean read FPlayAvi write SetPlayAvi;
    property OnCreating: TCreatingEvent read FOnCreating write SetOnCreating;
    property OnSaving: TCreatingEvent read FOnSaving write SetOnSaving;
  end;

function mmioFOURCC(c1, c2, c3, c4: char): Cardinal;

procedure Register;

implementation

function mmioFOURCC(c1, c2, c3, c4: char): Cardinal;
begin
  Result := Ord(c4);
  Result := Result shr 8 + Ord(c3);
  Result := Result shr 8 + Ord(c2);
  Result := Result shr 8 + Ord(c1);
end;

constructor TAviWriter.Create(AOwner : TComponent);
var
  tempdir               : string;
  l                     : integer;
begin
    inherited Create(AOwner);
    fHeight    := screen.height div 10;
    fWidth     := screen.width  div 10;
    fFrameTime := 1000;
    fFileName  := '';
    BitmapNames := TStringList.create;
    AVIFileInit;

    setlength(tempdir,MAX_PATH + 1);
    l := GetTempPath(MAX_PATH,pchar(tempdir));
    setlength(tempdir,l);
    if copy(tempdir,length(tempdir),1) <> '\'
       then tempdir := tempdir + '\';
    TempFileName := tempdir + '~AWTemp.avi';
end;

destructor TAviWriter.Destroy;
begin
    BitmapNames.free;
    AviFileExit;
    inherited;
end;

var
  tmpAW: TAviWriter;

function SaveCallBack(nPercent: integer): LONG; stdcall;
var
  c: Boolean;
begin
  Result := 0;
  if Assigned(tmpAW.OnSaving) then begin
    c := True;
    tmpAW.OnSaving(tmpAW, nPercent, c);
    if not c then
      Result := -1;
  end;
end;

procedure TAviWriter.SaveAvi(const FileName: string; nStreams: integer;
      Streams: APAVISTREAM);
  var
    AVIERR, hnd: cardinal;
    ErrMess: string;
    CompOptions: APAVICompressOptions;
    VideoCompOptions: TAVICompressOptions;
  begin
    // Create the output file.
    CompOptions[0] := @VideoCompOptions;
    CompOptions[1] := nil;

    tmpAW := Self; //for callback
    hnd := Application.MainForm.Handle;

    repeat
      ErrMess := '';

      if not AviSaveOptions(hnd, ICMF_CHOOSE_ALLCOMPRESSORS, 1, Streams, CompOptions) then
        Abort;

      AVIERR := AVISaveV(PChar(FileName),
          nil, // File handler
          SaveCallBack, // Callback
          nStreams,     // Number of streams
          Streams,
          CompOptions); // Compress options for VideoStream
      case AVIERR of
        AVIERR_OK:
          begin
          if PlayAvi then
            ShellExecute(hnd, 'open', PChar(FileName), '', '', SW_SHOW);
          if MessageDlg('Avi sucessfully created!'+#13+#10+'Do you want to try another codec?', mtWarning, [mbYes,mbNo], 0) = mrYes then
            AVIERR := AVIERR_ERROR; //to retry
          end;
        AVIERR_UNSUPPORTED:
          ErrMess := 'Error, unsupported format!';
        AVIERR_BADFORMAT:
          ErrMess := 'Error, bad format!';
        AVIERR_FILEREAD:
          ErrMess := 'Error reading files!';
        AVIERR_FILEWRITE:
          ErrMess := 'Error writing files!';
        AVIERR_MEMORY:
          ErrMess := 'Error in memory!';
        AVIERR_INTERNAL:
          ErrMess := 'Error internal!';
        AVIERR_BADFLAGS:
          ErrMess := 'Error bad flags!';
        AVIERR_BADPARAM:
          ErrMess := 'Error bad params!';
        AVIERR_BADSIZE:
          ErrMess := 'Error bad size!';
        AVIERR_BADHANDLE:
          ErrMess := 'Error bad handle!';
        AVIERR_FILEOPEN:
          ErrMess := 'Error opening files!';
        AVIERR_COMPRESSOR:
          ErrMess := 'Error in compressor!';
        AVIERR_NOCOMPRESSOR:
          ErrMess := 'Error no compressor!';
        AVIERR_READONLY:
          ErrMess := 'Error read-only files!';
        AVIERR_NODATA:
          ErrMess := 'Error no data!';
        AVIERR_BUFFERTOOSMALL:
          ErrMess := 'Error buffer too small!';
        AVIERR_CANTCOMPRESS:
          ErrMess := 'Error cannot compress!';
        AVIERR_USERABORT:
          ErrMess := 'Error user abort!';
        AVIERR_ERROR:
          ErrMess := 'Error generic!';
        else
          ErrMess := 'Avi error number: ' + IntToStr(AVIERR);
        end;
      if ErrMess <> '' then
        if MessageDlg( ErrMess + #13#10'Do you want to try another codec?', mtError, [mbYes,mbNo], 0) = mrNo then
          raise Exception.Create( ErrMess );
    until (AVIERR = AVIERR_OK);
  end;


procedure TAviWriter.Write;
var
  nstreams: integer;
  i: integer;
  Streams: APAVISTREAM;
  refcount: integer;

begin
  AudioStream := nil;
  VideoStream := nil;
  // If no bitmaps are on the list, raise an error.
  if BitmapNames.count < 1 then
      raise Exception.Create('No bitmaps on the Bitmaps list');

  // If anything on the Bitmaps TList is not a bitmap, raise
  // an error.
  for i := 0 to BitmapNames.count - 1 do begin
    if not FileExists(BitmapNames[i]) then
      raise Exception.Create('Bitmap [' + BitmapNames[i] + '] not found!');
  end;

  if FileExists( FileName ) then
    DeleteFile( FileName );

  try
    AddVideo;
    Streams[0] := VideoStream;

    if WavFileName <> '' then begin
      AddAudio;
      Streams[1] := AudioStream;
      nstreams := 2;
    end else begin
      nstreams := 1;
      Streams[1] := nil;
    end;

  SaveAvi(FileName, nStreams, Streams);

  finally
    if assigned(VideoStream) then      AviStreamRelease(VideoStream);    if assigned(AudioStream) then
      AviStreamRelease(AudioStream);
    repeat      refcount := AviFileRelease(pFile);
    until refcount <= 0;

    DeleteFile(TempFileName);
    if DeleteFiles then
      for i := 0 to BitmapNames.Count - 1 do
        DeleteFile(PChar(BitmapNames[i]));
  end;
end;

procedure TAviWriter.AddVideo;
var
  Pstream       : PAVISTREAM;
  StreamInfo		: TAVIStreamInfo;
begin
  // Open AVI file for write
  if (AVIFileOpen(pFile, pchar(TempFileName), OF_WRITE or OF_CREATE OR OF_SHARE_EXCLUSIVE, nil) <> AVIERR_OK) then
    raise Exception.Create('Failed to create AVI video work file');

  // Write the stream header.
  FillChar(StreamInfo, sizeof(StreamInfo), 0);

  // Set frame rate and scale
  StreamInfo.dwRate := 1000;
  StreamInfo.dwScale := fFrameTime;
  StreamInfo.fccType := streamtypeVIDEO;
  StreamInfo.fccHandler := 0;
  StreamInfo.dwFlags := 0;
  StreamInfo.dwSuggestedBufferSize := 0;
  StreamInfo.rcFrame.Right := self.width;
  StreamInfo.rcFrame.Bottom := self.height;

  // Open AVI data stream
  if (AVIFileCreateStream(pFile, pStream, StreamInfo) <> AVIERR_OK) then
     raise Exception.Create('Failed to create AVI video stream');

  try
    // Write the bitmaps to the stream.
    AddBitmapsFromFiles(pStream);

    // Create the editable VideoStream from pStream.
    if CreateEditableStream(VideoStream,pStream) <> AVIERR_OK then
        raise Exception.Create('Could not create Video Stream');
  finally
    AviStreamRelease(pStream);
  end;
end;

procedure TAviWriter.AddBitmapsFromFiles(pStream: PAVISTREAM);
var
  i: integer;
  TmpBmp: TBitmap;
  cont: Boolean;
begin
  cont := True;
  TmpBmp := TBitmap.Create;
  try
    for i := 0 to BitmapNames.count - 1 do begin
      TmpBmp.LoadFromFile(BitmapNames[i]);
      AddBitmap(TmpBmp, i, pStream);
      if Assigned(OnCreating) then
        OnCreating(Self, (i*100) div (BitmapNames.Count-1), cont);
      if not cont then
        Abort;
    end;
  finally
    TmpBmp.Free;
  end;
end;

procedure TAviWriter.AddBitmap(TmpBmp: TBitmap; Pos: integer; pStream: PAVISTREAM);
var
  BitmapInfo		: PBitmapInfoHeader;
  BitmapInfoSize	: Integer;
  BitmapSize		: longInt;
  BitmapBits		: pointer;
  AVIERR                : integer;
  Samples_Written       : LONG;
  Bytes_Written         : LONG;
begin
  BitmapInfo := nil;
  BitmapBits := nil;
  try
    // Copy the bitmap from the list to the AVI bitmap,
    // stretching if desired. If the caller elects not to
    // stretch, use the first pixel in the bitmap as a
    // background color in case either the height or
    // width of the source is smaller than the output.
    // If Draw fails, do a StretchDraw.
    // Determine size of DIB
    InternalGetDIBSizes(TmpBmp.Handle, BitmapInfoSize, BitmapSize, pf8bit);
    if (BitmapInfoSize = 0) then
      raise Exception.Create('Failed to retrieve bitmap info');

    // Get DIB header and pixel buffers
    GetMem(BitmapInfo, BitmapInfoSize);
    GetMem(BitmapBits, BitmapSize);
    InternalGetDIB(TmpBmp.Handle, 0, BitmapInfo^, BitmapBits^, pf8bit);

    // On the first time through, set the stream format.
    if pos = 0 then
      if (AVIStreamSetFormat(pStream, pos, BitmapInfo, BitmapInfoSize) <> AVIERR_OK) then
          raise Exception.Create('Failed to set AVI stream format');

    // Write frame to the video stream
    AVIERR := AVIStreamWrite(pStream, pos, 1, BitmapBits, BitmapSize, AVIIF_KEYFRAME, Samples_Written, Bytes_Written);
    if AVIERR <> AVIERR_OK then
      raise Exception.Create('Failed to add frame to AVI. Err=' + inttohex(AVIERR,8));
  finally
    if (BitmapInfo <> nil) then
     FreeMem(BitmapInfo);
    if (BitmapBits <> nil) then
     FreeMem(BitmapBits);
  end;
end;

procedure TAviWriter.AddAudio;
var
   InputFile    : PAVIFILE;
   hr           : HRESULT;
   InputStream  : PAVIStream;
begin
   // Open the audio file.
   hr := AVIFileOpen(InputFile, pchar(WavFileName),OF_READ, nil);
   case hr of
        0:     ;
        HRESULT( AVIERR_BADFORMAT)  : raise Exception.Create('The file could not be read, indicating a corrupt file or an unrecognized format.');
        HRESULT( AVIERR_MEMORY   )  : raise Exception.Create('The file could not be opened because of insufficient memory.');
        HRESULT( AVIERR_FILEREAD )  : raise Exception.Create('A disk error occurred while reading the audio file.');
        HRESULT( AVIERR_FILEOPEN )  : raise Exception.Create('A disk error occurred while opening the audio file.');
        REGDB_E_CLASSNOTREG : raise Exception.Create('According to the registry, the type of audio file specified in AVIFileOpen does not have a handler to process it.');
        else raise Exception.Create('Unknown error opening audio file');
   end;

   // Open the audio stream.
   try
     if (AVIFileGetStream(InputFile, InputStream, 0, 0) <> AVIERR_OK) then
         raise Exception.Create('Unable to get audio stream');

     try
       // Create AudioStream as a copy of InputStream
       if (CreateEditableStream(AudioStream,InputStream) <> AVIERR_OK) then
            raise Exception.Create('Failed to create editable AVI audio stream');
     finally
       AviStreamRelease(InputStream);
     end;

   finally
     AviFileRelease(InputFile);
   end;
end;

// --------------
// InternalGetDIB
// --------------
// Converts a bitmap to a DIB of a specified PixelFormat.
//
// Parameters:
// Bitmap	The handle of the source bitmap.
// Pal		The handle of the source palette.
// BitmapInfo	The buffer that will receive the DIB's TBitmapInfo structure.
//		A buffer of sufficient size must have been allocated prior to
//		calling this function.
// Bits		The buffer that will receive the DIB's pixel data.
//		A buffer of sufficient size must have been allocated prior to
//		calling this function.
// PixelFormat	The pixel format of the destination DIB.
//
// Returns:
// True on success, False on failure.
//
// Note: The InternalGetDIBSizes function can be used to calculate the
// nescessary sizes of the BitmapInfo and Bits buffers.
//
function TAviWriter.InternalGetDIB(Bitmap: HBITMAP; Palette: HPALETTE;
  var BitmapInfo; var Bits; PixelFormat: TPixelFormat): Boolean;
// From graphics.pas, "optimized" for our use
var
  OldPal	: HPALETTE;
  DC		: HDC;
begin
  InitializeBitmapInfoHeader(Bitmap, TBitmapInfoHeader(BitmapInfo), PixelFormat);
  OldPal := 0;
  DC := CreateCompatibleDC(0);
  try
    if (Palette <> 0) then
    begin
      OldPal := SelectPalette(DC, Palette, False);
      RealizePalette(DC);
    end;
    Result := (GetDIBits(DC, Bitmap, 0, abs(TBitmapInfoHeader(BitmapInfo).biHeight),
      @Bits, TBitmapInfo(BitmapInfo), DIB_RGB_COLORS) <> 0);
  finally
    if (OldPal <> 0) then
      SelectPalette(DC, OldPal, False);
    DeleteDC(DC);
  end;
end;


// -------------------
// InternalGetDIBSizes
// -------------------
// Calculates the buffer sizes nescessary for convertion of a bitmap to a DIB
// of a specified PixelFormat.
// See the GetDIBSizes API function for more info.
//
// Parameters:
// Bitmap	The handle of the source bitmap.
// InfoHeaderSize
//		The returned size of a buffer that will receive the DIB's
//		TBitmapInfo structure.
// ImageSize	The returned size of a buffer that will receive the DIB's
//		pixel data.
// PixelFormat	The pixel format of the destination DIB.
//
procedure TAviWriter.InternalGetDIBSizes(Bitmap: HBITMAP; var InfoHeaderSize: Integer;
  var ImageSize: longInt; PixelFormat: TPixelFormat);
// From graphics.pas, "optimized" for our use
var
  Info		: TBitmapInfoHeader;
begin
  InitializeBitmapInfoHeader(Bitmap, Info, PixelFormat);
  // Check for palette device format
  if (Info.biBitCount > 8) then
  begin
    // Header but no palette
    InfoHeaderSize := SizeOf(TBitmapInfoHeader);
    if ((Info.biCompression and BI_BITFIELDS) <> 0) then
      Inc(InfoHeaderSize, 12);
  end else
    // Header and palette
    InfoHeaderSize := SizeOf(TBitmapInfoHeader) + SizeOf(TRGBQuad) * (1 shl Info.biBitCount);
  ImageSize := Info.biSizeImage;
end;

// --------------------------
// InitializeBitmapInfoHeader
// --------------------------
// Fills a TBitmapInfoHeader with the values of a bitmap when converted to a
// DIB of a specified PixelFormat.
//
// Parameters:
// Bitmap	The handle of the source bitmap.
// Info		The TBitmapInfoHeader buffer that will receive the values.
// PixelFormat	The pixel format of the destination DIB.
//
{$IFDEF BAD_STACK_ALIGNMENT}
  // Disable optimization to circumvent optimizer bug...
  {$IFOPT O+}
    {$DEFINE O_PLUS}
    {$O-}
  {$ENDIF}
{$ENDIF}


procedure TAviWriter.InitializeBitmapInfoHeader(Bitmap: HBITMAP; var Info: TBitmapInfoHeader;
  PixelFormat: TPixelFormat);
// From graphics.pas, "optimized" for our use
var
  DIB		: TDIBSection;
  Bytes		: Integer;
  function AlignBit(Bits, BitsPerPixel, Alignment: Cardinal): Cardinal;
  begin
    Dec(Alignment);
    Result := ((Bits * BitsPerPixel) + Alignment) and not Alignment;
    Result := Result SHR 3;
  end;
begin
  DIB.dsbmih.biSize := 0;
  Bytes := GetObject(Bitmap, SizeOf(DIB), @DIB);
  if (Bytes = 0) then
    raise Exception.Create('Invalid bitmap');
//    Error(sInvalidBitmap);

  if (Bytes >= (sizeof(DIB.dsbm) + sizeof(DIB.dsbmih))) and
    (DIB.dsbmih.biSize >= sizeof(DIB.dsbmih)) then
    Info := DIB.dsbmih
  else
  begin
    FillChar(Info, sizeof(Info), 0);
    with Info, DIB.dsbm do
    begin
      biSize := SizeOf(Info);
      biWidth := bmWidth;
      biHeight := bmHeight;
    end;
  end;
  case PixelFormat of
    pf1bit: Info.biBitCount := 1;
    pf4bit: Info.biBitCount := 4;
    pf8bit: Info.biBitCount := 8;
    pf24bit: Info.biBitCount := 24;
  else
//    Error(sInvalidPixelFormat);
    raise Exception.Create('Invalid pixel foramt');
    // Info.biBitCount := DIB.dsbm.bmBitsPixel * DIB.dsbm.bmPlanes;
  end;
  Info.biPlanes := 1;
  Info.biCompression := BI_RGB; // Always return data in RGB format
  Info.biSizeImage := AlignBit(Info.biWidth, Info.biBitCount, 32) * Cardinal(abs(Info.biHeight));
end;
{$IFDEF O_PLUS}
  {$O+}
  {$UNDEF O_PLUS}
{$ENDIF}

procedure TAviWriter.SetWavFileName(value : string);
begin
   if lowercase(fWavFileName) <> lowercase(value)
      then if lowercase(ExtractFileExt(value)) <> '.wav'
             then raise Exception.Create('WavFileName must name a file '
                             + 'with the .wav extension')
             else fWavFileName := value;
end;             


procedure Register;
begin
  RegisterComponents('Custom', [TAviWriter]);
end;

  procedure AVIFileInit; stdcall; external 'avifil32.dll' name 'AVIFileInit';
  procedure AVIFileExit; stdcall; external 'avifil32.dll' name 'AVIFileExit';
  function AVIFileOpen; external 'avifil32.dll' name 'AVIFileOpenA';
  function AVIFileCreateStream; external 'avifil32.dll' name 'AVIFileCreateStreamA';
  function AVIStreamSetFormat; external 'avifil32.dll' name 'AVIStreamSetFormat';
  function AVIStreamReadFormat; external 'avifil32.dll' name 'AVIStreamReadFormat';
  function AVIStreamWrite; external 'avifil32.dll' name 'AVIStreamWrite';
  function AVIStreamRelease; external 'avifil32.dll' name 'AVIStreamRelease';
  function AVIFileRelease; external 'avifil32.dll' name 'AVIFileRelease';
  function AVIFileGetStream; external 'avifil32.dll' name 'AVIFileGetStream';
  function CreateEditableStream; external 'avifil32.dll' name 'CreateEditableStream';
  function AVISaveV; external 'avifil32.dll' name 'AVISaveV';
  function AVISaveOptions; external 'avifil32.dll' name 'AVISaveOptions';


procedure TAviWriter.SetOnCreating(const Value: TCreatingEvent);
begin
  FOnCreating := Value;
end;

procedure TAviWriter.SetOnSaving(const Value: TCreatingEvent);
begin
  FOnSaving := Value;
end;

procedure TAviWriter.SetDeleteFiles(const Value: Boolean);
begin
  FDeleteFiles := Value;
end;

procedure TAviWriter.SetPlayAvi(const Value: Boolean);
begin
  FPlayAvi := Value;
end;

end.
