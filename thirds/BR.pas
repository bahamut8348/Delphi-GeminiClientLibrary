unit BR;

{$INCLUDE ../incs/CompilerVersion.inc}
{$HINTS OFF}

interface

uses
{$IFDEF HAS_UNIT_SCOPE}
  System.SysUtils;
{$ELSE !HAS_UNIT_SCOPE}
  SysUtils;
{$ENDIF HAS_UNIT_SCOPE}

type
  TBrotliDecoderStateStruct    = record
    /// ...
  end;
  TBrotliDecoderStateInternal  = TBrotliDecoderStateStruct;
  TBrotliDecoderState          = TBrotliDecoderStateInternal;

const
  /// BrotliDecoderParameter
  (**
   * Disable "canny" ring buffer allocation strategy.
   *
   * Ring buffer is allocated according to window size, despite the real size of
   * the content.
   *)
  BROTLI_DECODER_PARAM_DISABLE_RING_BUFFER_REALLOCATION      = 0;
  (**
   * Flag that determines if "Large Window Brotli" is used.
   *)
  BROTLI_DECODER_PARAM_LARGE_WINDOW                          = 1;


  /// BrotliDecoderResult
  (** Decoding error, e.g. corrupted input or memory allocation problem. *)
  BROTLI_DECODER_RESULT_ERROR                                = 0;
  (** Decoding successfully completed. *)
  BROTLI_DECODER_RESULT_SUCCESS                              = 1;
  (** Partially done; should be called again with more input. *)
  BROTLI_DECODER_RESULT_NEEDS_MORE_INPUT                     = 2;
  (** Partially done; should be called again with more output. *)
  BROTLI_DECODER_RESULT_NEEDS_MORE_OUTPUT                    = 3;

function DecompressBR(
  const pInputBuffer: Pointer; const nInputLength: Cardinal;
  pOutputBuffer: Pointer; var pnOutputLength: Cardinal;
  pContent: PPointer; out nTotal: Cardinal): Integer;

implementation

{$IFDEF MSWINDOWS}
  {$IFDEF CPU386}
    {$DEFINE WITH_UNDERSCORE}
    {$L mORMotBP/Tools/Brotli/static/bcc32/backward_references.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/backward_references_hq.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/bit_cost.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/bit_reader.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/block_splitter.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/brotli_bit_stream.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/cluster.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/command.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/compress_fragment.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/compress_fragment_two_pass.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/constants.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/context.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/decode.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/dictionary.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/dictionary_hash.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/encode.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/encoder_dict.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/entropy_encode.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/fast_log.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/histogram.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/huffman.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/literal_cost.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/memory.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/metablock.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/platform.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/state.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/static_dict.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/transform.obj}
    {$L mORMotBP/Tools/Brotli/static/bcc32/utf8_util.obj}
  {$ELSE CPU386}
    {$L mORMotBP/Tools/Brotli/static/bcc64/backward_references.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/backward_references_hq.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/bit_cost.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/bit_reader.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/block_splitter.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/brotli_bit_stream.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/cluster.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/command.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/compress_fragment.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/compress_fragment_two_pass.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/constants.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/context.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/decode.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/dictionary.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/dictionary_hash.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/encode.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/encoder_dict.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/entropy_encode.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/fast_log.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/histogram.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/huffman.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/literal_cost.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/memory.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/metablock.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/platform.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/state.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/static_dict.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/transform.o}
    {$L mORMotBP/Tools/Brotli/static/bcc64/utf8_util.o}
  {$ENDIF CPU386}
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
  {$IFDEF CPU386}
    {$L mORMotBP/Tools/Brotli/static/gcc32/backward_references.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/backward_references_hq.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/bit_cost.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/bit_reader.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/block_splitter.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/brotli_bit_stream.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/cluster.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/command.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/compress_fragment.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/compress_fragment_two_pass.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/constants.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/context.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/decode.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/dictionary.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/dictionary_hash.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/encode.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/encoder_dict.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/entropy_encode.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/fast_log.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/histogram.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/huffman.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/literal_cost.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/memory.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/metablock.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/platform.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/state.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/static_dict.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/transform.o}
    {$L mORMotBP/Tools/Brotli/static/gcc32/utf8_util.o}
  {$ELSE CPU386}
    {$L mORMotBP/Tools/Brotli/static/gcc64/backward_references.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/backward_references_hq.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/bit_cost.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/bit_reader.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/block_splitter.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/brotli_bit_stream.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/cluster.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/command.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/compress_fragment.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/compress_fragment_two_pass.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/constants.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/context.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/decode.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/dictionary.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/dictionary_hash.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/encode.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/encoder_dict.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/entropy_encode.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/fast_log.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/histogram.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/huffman.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/literal_cost.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/memory.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/metablock.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/platform.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/state.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/static_dict.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/transform.o}
    {$L mORMotBP/Tools/Brotli/static/gcc64/utf8_util.o}
  {$ENDIF CPU386}
{$ENDIF LINUX}

type
  TBrotliSize = {$IFDEF CPU386} Integer {$ELSE} Int64 {$ENDIF};

  EBrotliExitException = class(Exception)
    Status: Integer;
  end;

{$IFDEF WITH_UNDERSCORE}
function _BrotliEncoderMaxCompressedSize(const InputSize: Integer): Integer;
  cdecl; external;
function _BrotliEncoderCompress(
    const quality: Integer; const lgwin: Integer; const mode: Integer;
    const input_size: TBrotliSize; const input_buffer: Pointer;
    out encoded_size: TBrotliSize; const encoded_buffer: Pointer): Integer;
      cdecl; external;
function _BrotliEncoderVersion: Cardinal; cdecl; external;
function _BrotliDecoderCreateInstance(
  const alloc_func, free_func, opaque: Pointer): Pointer; cdecl; external;
procedure _BrotliDecoderDestroyInstance(const state: Pointer); cdecl; external;
function _BrotliDecoderSetParameter(const state: Pointer;
  const BrotliDecoderParameter: Integer; const Value: Cardinal): Integer;
    cdecl; external;
function _BrotliDecoderDecompressStream(const state: Pointer;
  var available_in: TBrotliSize; var next_in: Pointer;
  var available_out: TBrotliSize; var next_out: Pointer;
  total_out: Pointer): Integer; cdecl; external;
function _BrotliDecoderVersion: Cardinal; cdecl; external;
function _BrotliDecoderIsUsed(const state: Pointer): Integer; cdecl; external;
function _BrotliDecoderIsFinished(const state: Pointer): Integer; cdecl; external;
procedure _BrotliBuildAndStoreHuffmanTreeFast; cdecl; external;
procedure _BrotliBuildHistogramsWithContext; cdecl; external;
procedure _BrotliClusterHistogramsDistance; cdecl; external;
procedure _BrotliClusterHistogramsLiteral; cdecl; external;
procedure _BrotliCompressFragmentFast; cdecl; external;
procedure _BrotliCompressFragmentTwoPass; cdecl; external;
procedure _BrotliCreateBackwardReferences; cdecl; external;
procedure _BrotliCreateHqZopfliBackwardReferences; cdecl; external;
procedure _BrotliCreateZopfliBackwardReferences; cdecl; external;
procedure _BrotliDestroyBlockSplit; cdecl; external;
procedure _BrotliGetDictionary; cdecl; external;
procedure _BrotliInitBitReader; cdecl; external;
procedure _BrotliInitBlockSplit; cdecl; external;
procedure _BrotliInitZopfliNodes; cdecl; external;
procedure _BrotliOptimizeHuffmanCountsForRle; cdecl; external;
procedure _BrotliPopulationCostCommand; cdecl; external;
procedure _BrotliPopulationCostDistance; cdecl; external;
procedure _BrotliPopulationCostLiteral; cdecl; external;
procedure _BrotliSafeReadBits32Slow; cdecl; external;
procedure _BrotliSplitBlock; cdecl; external;
procedure _BrotliStoreHuffmanTree; cdecl; external;
procedure _BrotliStoreMetaBlock; cdecl; external;
procedure _BrotliStoreMetaBlockFast; cdecl; external;
procedure _BrotliStoreMetaBlockTrivial; cdecl; external;
procedure _BrotliStoreUncompressedMetaBlock; cdecl; external;
procedure _BrotliWarmupBitReader; cdecl; external;
procedure _BrotliZopfliComputeShortestPath; cdecl; external;
procedure _BrotliZopfliCreateCommands; cdecl; external;
procedure _kBrotliBitMask; cdecl; external;
procedure _kStaticDictionaryHashWords; cdecl; external;
procedure _kStaticDictionaryHashLengths; cdecl; external;
{$ELSE}
function BrotliEncoderMaxCompressedSize(const InputSize: Integer): Integer;
  cdecl; external;
function BrotliEncoderCompress(
    const quality: Integer; const lgwin: Integer; const mode: Integer;
    const input_size: TBrotliSize; const input_buffer: Pointer;
    out encoded_size: TBrotliSize; const encoded_buffer: Pointer): Integer;
      cdecl; external;
function BrotliEncoderVersion: Cardinal; cdecl; external;
function BrotliDecoderCreateInstance(
  const alloc_func, free_func, opaque: Pointer): Pointer; cdecl; external;
procedure BrotliDecoderDestroyInstance(const state: Pointer); cdecl; external;
function BrotliDecoderSetParameter(const state: Pointer;
  const BrotliDecoderParameter: Integer; const Value: Cardinal): Integer;
    cdecl; external;
function BrotliDecoderDecompressStream(const state: Pointer;
  var available_in: TBrotliSize; var next_in: Pointer;
  var available_out: TBrotliSize; var next_out: Pointer;
  total_out: Pointer): Integer; cdecl; external;
function BrotliDecoderVersion: Cardinal; cdecl; external;
function BrotliDecoderIsUsed(const state: Pointer): Integer; cdecl; external;
function BrotliDecoderIsFinished(const state: Pointer): Integer; cdecl; external;
procedure BrotliBuildAndStoreHuffmanTreeFast; cdecl; external;
procedure BrotliBuildHistogramsWithContext; cdecl; external;
procedure BrotliClusterHistogramsDistance; cdecl; external;
procedure BrotliClusterHistogramsLiteral; cdecl; external;
procedure BrotliCompressFragmentFast; cdecl; external;
procedure BrotliCompressFragmentTwoPass; cdecl; external;
procedure BrotliCreateBackwardReferences; cdecl; external;
procedure BrotliCreateHqZopfliBackwardReferences; cdecl; external;
procedure BrotliCreateZopfliBackwardReferences; cdecl; external;
procedure BrotliDestroyBlockSplit; cdecl; external;
procedure BrotliGetDictionary; cdecl; external;
procedure BrotliInitBitReader; cdecl; external;
procedure BrotliInitBlockSplit; cdecl; external;
procedure BrotliInitZopfliNodes; cdecl; external;
procedure BrotliOptimizeHuffmanCountsForRle; cdecl; external;
procedure BrotliPopulationCostCommand; cdecl; external;
procedure BrotliPopulationCostDistance; cdecl; external;
procedure BrotliPopulationCostLiteral; cdecl; external;
procedure BrotliSafeReadBits32Slow; cdecl; external;
procedure BrotliSplitBlock; cdecl; external;
procedure BrotliStoreHuffmanTree; cdecl; external;
procedure BrotliStoreMetaBlock; cdecl; external;
procedure BrotliStoreMetaBlockFast; cdecl; external;
procedure BrotliStoreMetaBlockTrivial; cdecl; external;
procedure BrotliStoreUncompressedMetaBlock; cdecl; external;
procedure BrotliWarmupBitReader; cdecl; external;
procedure BrotliZopfliComputeShortestPath; cdecl; external;
procedure BrotliZopfliCreateCommands; cdecl; external;
procedure kBrotliBitMask; cdecl; external;
procedure kStaticDictionaryHashWords; cdecl; external;
procedure kStaticDictionaryHashLengths; cdecl; external;
{$ENDIF}

const
  EncoderMaxCompressedSize: function(
    const InputSize: Integer): Integer cdecl =
      {$IFDEF WITH_UNDERSCORE}
        _BrotliEncoderMaxCompressedSize
      {$ELSE}
        BrotliEncoderMaxCompressedSize
      {$ENDIF};

  EncoderCompress: function(const quality: Integer; const lgwin: Integer;
    const mode: Integer; const input_size: TBrotliSize;
    const input_buffer: Pointer; out encoded_size: TBrotliSize;
    const encoded_buffer: Pointer): Integer cdecl =
      {$IFDEF WITH_UNDERSCORE}
        _BrotliEncoderCompress
      {$ELSE}
        BrotliEncoderCompress
      {$ENDIF};

  EncoderVersion: function: Cardinal cdecl  =
    {$IFDEF WITH_UNDERSCORE}
      _BrotliEncoderVersion
    {$ELSE}
      BrotliEncoderVersion
    {$ENDIF};

  DecoderCreateInstance: function(const alloc_func, free_func,
    opaque: Pointer): Pointer cdecl =
      {$IFDEF WITH_UNDERSCORE}
        _BrotliDecoderCreateInstance
      {$ELSE}
        BrotliDecoderCreateInstance
      {$ENDIF};

  DecoderDestroyInstance: procedure(const state: Pointer) cdecl =
    {$IFDEF WITH_UNDERSCORE}
      _BrotliDecoderDestroyInstance
    {$ELSE}
      BrotliDecoderDestroyInstance
    {$ENDIF};

  DecoderSetParameter: function (const state: Pointer;
    const BrotliDecoderParameter: Integer;
    const Value: Cardinal): Integer cdecl =
      {$IFDEF WITH_UNDERSCORE}
        _BrotliDecoderSetParameter
      {$ELSE}
        BrotliDecoderSetParameter
      {$ENDIF};

  DecoderDecompressStream: function(const state: Pointer;
    var available_in: TBrotliSize; var next_in: Pointer;
    var available_out: TBrotliSize; var next_out: Pointer;
    total_out: Pointer = nil): Integer cdecl =
      {$IFDEF WITH_UNDERSCORE}
        _BrotliDecoderDecompressStream
      {$ELSE}
        BrotliDecoderDecompressStream
      {$ENDIF};

  DecoderVersion: function: Cardinal cdecl  =
    {$IFDEF WITH_UNDERSCORE}
      _BrotliDecoderVersion
    {$ELSE}
      BrotliDecoderVersion
    {$ENDIF};

  DecoderIsUsed: function(const state: Pointer): Integer cdecl =
    {$IFDEF WITH_UNDERSCORE}
      _BrotliDecoderIsUsed
    {$ELSE}
      BrotliDecoderIsUsed
    {$ENDIF};

  DecoderIsFinished: function(const state: Pointer): Integer cdecl =
    {$IFDEF WITH_UNDERSCORE}
      _BrotliDecoderIsFinished
    {$ELSE}
      BrotliDecoderIsFinished
    {$ENDIF};

function DecompressBR(
  const pInputBuffer: Pointer; const nInputLength: Cardinal;
  pOutputBuffer: Pointer; var pnOutputLength: Cardinal;
  pContent: PPointer; out nTotal: Cardinal): Integer;
var
  pState: ^TBrotliDecoderState;
  available_in, available_out: TBrotliSize;
  next_in, next_out: Pointer;
begin
  if (nil = pContent) or (nil = pContent^) then
    pState := DecoderCreateInstance(nil, nil, nil)
  else
    pState := nil;

  available_in := nInputLength;
  next_in := pInputBuffer;
  available_out := pnOutputLength;
  next_out := pOutputBuffer;

  if (nil = pContent) or (nil = pContent^) then
  begin
    //if (not BrotliDecoderStateInit(pState, 0, 0, 0)) then
    //begin
    //  Result := BROTLI_DECODER_RESULT_ERROR;
    //  Exit;
    //end;
    pContent^ := pState;
  end
  else
    pState := pContent^;

	//DecoderSetParameter(pState, BROTLI_DECODER_PARAM_LARGE_WINDOW, 1);
	Result := DecoderDecompressStream(pState,
    available_in, next_in, available_out, next_out, @nTotal);
	//available_out := nTotal;
  if (nil <> @pnOutputLength) then
    pnOutputLength := Cardinal(available_out);

	// 判断是否解完
	if ((DecoderIsUsed(pState) <> 0) and (DecoderIsFinished(pState) <> 0)) then
	begin
		//DecoderStateCleanup(pState);
		// 销毁
		DecoderDestroyInstance(pState);
    pState := nil;
    pContent^ := nil;
	end;

	if ((Result <> BROTLI_DECODER_RESULT_SUCCESS) and (Result <> BROTLI_DECODER_RESULT_NEEDS_MORE_INPUT)) then
	begin
		Result := BROTLI_DECODER_RESULT_ERROR;
		//DecoderStateCleanup(pState);
		// 销毁
		DecoderDestroyInstance(pState);
    pState := nil;
    pContent^ := nil;
	end;
end;



{$IFNDEF FPC}
{$IFDEF WITH_UNDERSCORE}
procedure __exit(Status: Integer); cdecl; export;
{$ELSE}
procedure _exit(Status: Integer); cdecl; export;
{$ENDIF}
var
  E: EBrotliExitException;
begin
  E := EBrotliExitException.CreateFmt('Brotli exit: Status=%d', [Status]);
  E.Status := Status;
  raise E;
end;
{$ENDIF}

// See https://github.com/caodj/dSqlite3/blob/master/src/sqlite3/MSVCRT.pas

{$IFDEF WITH_UNDERSCORE}
function _malloc(Size: Cardinal): Pointer; cdecl;
{$ELSE}
function malloc(Size: Cardinal): Pointer; cdecl;
{$ENDIF}
begin
  GetMem(Result, Size);
end;

{$IFDEF WITH_UNDERSCORE}
procedure _free(P: Pointer); cdecl;
{$ELSE}
procedure free(P: Pointer); cdecl;
{$ENDIF}
begin
  FreeMem(P);
end;

{$IFDEF WITH_UNDERSCORE}
function _memset(P: Pointer; B: Integer; Count: Integer): Pointer; cdecl;
{$ELSE}
function memset(P: Pointer; B: Integer; Count: Integer): Pointer; cdecl;
{$ENDIF}
begin
  FillChar(P^, Count, B);
  Result := P;
end;

{$IFDEF WITH_UNDERSCORE}
function _memcpy(Dest, Source: Pointer; Count: TBrotliSize): Pointer; cdecl;
{$ELSE}
function memcpy(Dest, Source: Pointer; Count: TBrotliSize): Pointer; cdecl;
{$ENDIF}
begin
  Move(Source^, Dest^, Count);
  Result := Dest;
end;

{$IFDEF WITH_UNDERSCORE}
function _memmove(Dest, Source: Pointer; const Count: Integer): Pointer; cdecl;
{$ELSE}
function memmove(Dest, Source: Pointer; const Count: Integer): Pointer; cdecl;
{$ENDIF}
begin
  Move(source^, dest^, count);
  result := dest;
end;

{$IFDEF WIN32}
function _brotliLog(X: Double): Double; cdecl; export;
{$ENDIF WIN32}
{$IFDEF WIN64}
function _brotliLog(X: Double): Double; cdecl; export;
{$ENDIF WIN64}
{$IFDEF FPC}{$IFDEF LINUX}
function brotliLog(X: Double): Double; cdecl; export;
{$ENDIF}
{$ENDIF FPC}
begin
  Result := Ln(X);
end;
{$IFDEF WIN64}
function brotliLog(X: Double): Double; cdecl; export;
begin
  Result := Ln(X);
end;
{$ENDIF WIN64}

{$IFNDEF FPC}

{$IFDEF WIN32}
procedure __llushr;
asm
  jmp System.@_llushr
end;

procedure __llmul;
asm
  jmp System.@_llmul
end;

// Borland C++ float to integer (Int64) conversion
function __ftol: Int64;
asm
  jmp System.@Trunc  // FST(0) -> EDX:EAX, as expected by BCC32 compiler
end;

procedure __llshl;
asm
  jmp System.@_llshl
end;

const
  __huge_dble: Double = 1e300;
var
  __turboFloat: Word; { not used, but must be present for linking }

{$ENDIF WIN32}

{$IFDEF WIN64}
/// Allocate temporary stack memory
//
// __chkstk is a helper function for the compiler. It is called in the prologue
// to a function that has more than 4K bytes of local variables. It performs a
// stack probe by poking all pages in the new stack area. The number of bytes
// that will be allocated is passed in RAX.
//
// See $(BDS)\source\cpprtl\Source\memory\chkstk.nasm
procedure __chkstk;
asm
        lea     r10, [rsp]
        mov     r11, r10
        sub     r11, rax
        and     r11w, 0f000h
        and     r10w, 0f000h
@loop:  sub     r10, 01000h
        cmp     r10, r11       // more to go?
        jl      @exit
        mov     qword [r10], 0 // probe this page
        jmp     @loop
@exit:
end;

const
  _Inf: Double = 1e300;
{$ENDIF WIN64}

{$ENDIF FPC}

end.
