unit GZIP;

{$INCLUDE ../incs/CompilerVersion.inc}

interface

uses
{$IFDEF HAS_UNIT_SCOPE}
  System.SysUtils,
{$ELSE !HAS_UNIT_SCOPE}
  SysUtils,
{$ENDIF HAS_UNIT_SCOPE}
  ZLibExApi;

function DecompressGZIP(const szCompress: PAnsiChar; const nCompressLength: Cardinal;
  var szUncompress: PAnsiChar; var pnUncompressLength: Cardinal): Integer;

implementation

function ZInternalCompressStream(var pStream: TZStreamRec;
  const pInputBuffer: Pointer; const nInputLength: Cardinal;
  var pOutputBuffer: Pointer; var pnOutputLength:  Cardinal): Integer;
var
  pInput, pOutput: PBYTE;
  nBufferSize, nOutputSize: Cardinal;
  pTempOutputBuffer: PBYTE;
  nTempOutputLength, nTempOutputPosition, nTempInputPosition: Cardinal;
begin
  Result := Z_STREAM_END;

  //pInput := nil;
  //pOutput := nil;
  nBufferSize := $10000;
  //nOutputSize := 0;

	pTempOutputBuffer := nil;
  nTempOutputLength := 0;
  nTempOutputPosition := 0;
  //nTempInputPosition := 0;

  GetMem(pInput, nBufferSize);
  GetMem(pOutput, nBufferSize);
  try
    if ((nil = pInput) or (nil = pOutput)) then
      Exit;

    FillChar(pInput^, nBufferSize, 0);
    FillChar(pOutput^, nBufferSize, 0);

    if (nBufferSize > nInputLength) then
      nTempInputPosition := nInputLength
    else
      nTempInputPosition := nBufferSize;

    Move(pInputBuffer^, pInput^, nTempInputPosition);
    pStream.avail_in := nTempInputPosition;

    while (pStream.avail_in > 0) do
    begin
      pStream.next_in := pInput;

      repeat
        pStream.next_out := pOutput;
        pStream.avail_out := nBufferSize;

        Result := deflate(pStream, Z_NO_FLUSH);
        if (Result < Z_OK) then
          Exit;

        nOutputSize := nBufferSize - pStream.avail_out;
        if (nTempOutputPosition + nOutputSize >= nTempOutputLength) then
        begin
          while (nTempOutputPosition + nOutputSize >= nTempOutputLength) do
          begin
            Inc(nTempOutputLength, nBufferSize);
          end;

          if (nil = pTempOutputBuffer) then
          begin
            GetMem(pTempOutputBuffer, nTempOutputLength);
            if (nil = pTempOutputBuffer) then
              Exit;
          end
          else
          begin
            ReallocMem(pTempOutputBuffer, nTempOutputLength);
            if (nil = pTempOutputBuffer) then
              Exit;
          end;
        end;

        Move(pOutput^, pTempOutputBuffer[nTempOutputPosition], nOutputSize);
        Inc(nTempOutputPosition, nOutputSize);
      until ((Result = Z_STREAM_END) or (pStream.avail_in <= 0));

      if (nTempInputPosition + nBufferSize > nInputLength) then
      begin
        Move(Pointer(UINT64(pInputBuffer) + nTempInputPosition)^, pInput^, nInputLength - nTempInputPosition);
        nTempInputPosition := nInputLength;
      end
      else
      begin
        Move(Pointer(UINT64(pInputBuffer) + nTempInputPosition)^, pInput^, nBufferSize);
        Inc(nTempInputPosition, nBufferSize);
      end;
    end;

    while (Result <> Z_STREAM_END) do
    begin
      pStream.next_out := pOutput;
      pStream.avail_out := nBufferSize;

      Result := deflate(pStream, Z_FINISH);
      nOutputSize := nBufferSize - pStream.avail_out;

      if (nTempOutputPosition + nOutputSize >= nTempOutputLength) then
      begin
        while (nTempOutputPosition + nOutputSize >= nTempOutputLength) do
        begin
          Inc(nTempOutputLength, nBufferSize);
        end;

        if (nil = pTempOutputBuffer) then
        begin
          GetMem(pTempOutputBuffer, nTempOutputLength);
          if (nil = pTempOutputBuffer) then
            Exit;
        end
        else
        begin
          ReallocMem(pTempOutputBuffer, nTempOutputLength);
          if (nil = pTempOutputBuffer) then
            Exit;
        end;
      end;

      Move(pOutput^, pTempOutputBuffer[nTempOutputPosition], nOutputSize);
      Inc(nTempOutputPosition, nOutputSize);
    end;

    if (nil <> pTempOutputBuffer) then
    begin
      pTempOutputBuffer[nTempOutputPosition] := 0;
    end;

    if (nil <> @pOutputBuffer) then
    begin
      pOutputBuffer := pTempOutputBuffer;
      pTempOutputBuffer := nil;
    end;

    if (nil <> @pnOutputLength) then
    begin
      pnOutputLength := nTempOutputPosition;
    end;
  finally
    if (nil <> pTempOutputBuffer) then
      FreeMem(pTempOutputBuffer, nTempOutputLength);
    if (nil <> pOutput) then
      FreeMem(pOutput, nBufferSize);
    if (nil <> pInput) then
      FreeMem(pInput, nBufferSize);

    deflateEnd(pStream);
  end;
end;

function ZInternalDecompressStream(var pStream: TZStreamRec;
  const pInputBuffer: Pointer; const nInputLength: Cardinal;
  var pOutputBuffer: Pointer; var pnOutputLength: Cardinal
): Integer;
var
  pInput, pOutput: PBYTE;
  nBufferSize, nOutputSize: Cardinal;
  pTempOutputBuffer: PBYTE;
  nTempOutputLength, nTempOutputPosition, nTempInputPosition: Cardinal;
begin
  Result := Z_OK;
  //pInput := nil;
  //pOutput := nil;
  nBufferSize := $10000;
  //nOutputSize := 0;

	pTempOutputBuffer := nil;
  nTempOutputLength := 0;
  nTempOutputPosition := 0;
  //nTempInputPosition := 0;

  GetMem(pInput, nBufferSize);
  GetMem(pOutput, nBufferSize);
  try
    if ((nil = pInput) or (nil = pOutput)) then
      Exit;

    FillChar(pInput^, nBufferSize, 0);
    FillChar(pOutput^, nBufferSize, 0);

    if (nBufferSize > nInputLength) then
      nTempInputPosition := nInputLength
    else
      nTempInputPosition := nBufferSize;

    Move(pInputBuffer^, pInput^, nTempInputPosition);
    pStream.avail_in := nTempInputPosition;
    while ((Result <> Z_STREAM_END) and (pStream.avail_in > 0)) do
    begin
      pStream.next_in := pInput;

      repeat
        pStream.next_out := pOutput;
        pStream.avail_out := nBufferSize;

        Result := inflate(pStream, Z_NO_FLUSH);
        if (Result < Z_OK) then
          Exit;

        nOutputSize := nBufferSize - pStream.avail_out;

        if (nTempOutputPosition + nOutputSize >= nTempOutputLength) then
        begin
          while (nTempOutputPosition + nOutputSize >= nTempOutputLength) do
          begin
            Inc(nTempOutputLength, nBufferSize);
          end;

          if (nil = pTempOutputBuffer) then
            GetMem(pTempOutputBuffer, nTempOutputLength)
          else
            ReallocMem(pTempOutputBuffer, nTempOutputLength);

          if (nil = pTempOutputBuffer) then
            Exit;
        end;

        Move(pOutput^, pTempOutputBuffer[nTempOutputPosition], nOutputSize);
        Inc(nTempOutputPosition, nOutputSize);
      until ((Z_STREAM_END = Result) or (pStream.avail_out > 0));

      if (pStream.avail_in > 0) then
      begin
        Dec(nTempInputPosition, pStream.avail_in);
      end;

      if (Result <> Z_STREAM_END) then
      begin
        if (nTempInputPosition + nBufferSize > nInputLength) then
        begin
          Move(Pointer(UINT64(pInputBuffer) + nTempInputPosition)^, pInput^, nInputLength - nTempInputPosition);
          nTempInputPosition := nInputLength;
        end
        else
        begin
          Move(Pointer(UINT64(pInputBuffer) + nTempInputPosition)^, pInput^, nBufferSize);
          Inc(nTempInputPosition, nBufferSize);
        end;
      end;
    end;

    if (nil <> pTempOutputBuffer) then
    begin
      pTempOutputBuffer[nTempOutputPosition] := 0;
    end;

    if (nil <> @pOutputBuffer) then
    begin
      pOutputBuffer := pTempOutputBuffer;
      pTempOutputBuffer := nil;
    end;

    if (nil <> @pnOutputLength) then
    begin
      pnOutputLength := nTempOutputPosition;
    end;
  finally
    if (nil <> pTempOutputBuffer) then
      FreeMem(pTempOutputBuffer, nTempOutputLength);
    if (nil <> pOutput) then
      FreeMem(pOutput, nBufferSize);
    if (nil <> pInput) then
      FreeMem(pInput, nBufferSize);

    inflateEnd(pStream);
  end;
end;

function ZCompressStream(const pInputBuffer: Pointer; const nInputLength: Cardinal;
  var pOutputBuffer: Pointer; var pnOutputLength: Cardinal;
  const nLevel: Integer): Integer;
var
  pStream: TZStreamRec;
begin
  FillChar(pStream, SizeOf(pStream), 0);
  Result := deflateInit(pStream, nLevel);
  if (Z_OK = Result) then
    Result := ZInternalCompressStream(pStream, pInputBuffer, nInputLength, pOutputBuffer, pnOutputLength);
end;

function ZCompressStream2(const pInputBuffer: Pointer; const nInputLength: Cardinal;
  var pOutputBuffer: Pointer; var pnOutputLength: Cardinal;
  const nLevel: Integer; const nWindowBits, nMemoryLevel, nStrategy: Integer): Integer;
var
  pStream: TZStreamRec;
begin
  FillChar(pStream, SizeOf(pStream), 0);
	Result := deflateInit2(pStream, nLevel, Z_DEFLATED, nWindowBits, nMemoryLevel, nStrategy);
  if (Z_OK = Result) then
    Result := ZInternalCompressStream(pStream, pInputBuffer, nInputLength, pOutputBuffer, pnOutputLength);
end;

function ZCompressStreamWeb(const pInputBuffer: Pointer; const nInputLength: Cardinal;
  var pOutputBuffer: Pointer; var pnOutputLength: Cardinal): Integer;
begin
	Result := ZCompressStream2(pInputBuffer, nInputLength, pOutputBuffer, pnOutputLength,
		Z_BEST_SPEED, -15, 9, Z_DEFAULT_STRATEGY);
end;

function ZDecompressStream(const pInputBuffer: Pointer; const nInputLength: Cardinal;
  var pOutputBuffer: Pointer; var pnOutputLength: Cardinal): Integer;
var
  pStream: TZStreamRec;
begin
  FillChar(pStream, SizeOf(pStream), 0);
	Result := inflateInit(pStream);
	if (Z_OK = Result) then
    Result := ZInternalDecompressStream(pStream, pInputBuffer, nInputLength, pOutputBuffer, pnOutputLength);
end;

function ZDecompressStream2(const pInputBuffer: Pointer; const nInputLength: Cardinal;
  var pOutputBuffer: Pointer; var pnOutputLength: Cardinal;
  const nWindowBits: Integer): Integer;
var
  pStream: TZStreamRec;
begin
  FillChar(pStream, SizeOf(pStream), 0);
	Result := inflateInit2(pStream, nWindowBits);
	if (Z_OK = Result) then
    Result := ZInternalDecompressStream(pStream, pInputBuffer, nInputLength, pOutputBuffer, pnOutputLength);
end;

function DecompressGZIP(const szCompress: PAnsiChar; const nCompressLength: Cardinal;
  var szUncompress: PAnsiChar; var pnUncompressLength: Cardinal): Integer;
begin
	if (nil <> @szUncompress) and (nil <> szUncompress) then
		szUncompress^ := #0;
	if (nil <> @pnUncompressLength) then
		pnUncompressLength := 0;

	if (nCompressLength < 2) then
  begin
    Result := -1;
    Exit;
  end;

	if ((#$1f = szCompress[0]) and (#$8b = szCompress[1])) then
		Result := ZDecompressStream2(szCompress, nCompressLength, Pointer(szUncompress), pnUncompressLength, 47)
	else
		Result := -1;
end;

end.
