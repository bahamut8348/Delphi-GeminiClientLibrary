unit Functions.StringsUtils;

{$INCLUDE ../incs/CompilerVersion.inc}

interface

uses
  System.SysUtils;


function StringIsEmpty(const pString: PAnsiChar): Boolean; overload;
function StringIsEmpty(const pString: PWideChar): Boolean; overload;
function StringValue(const szValue: PAnsiChar): PAnsiChar; overload;
function StringValue(const szValue: PWideChar): PWideChar; overload;
function StrNewA(const pString: PAnsiChar): PAnsiChar; overload;
function StrNewA(const nLength: Integer): PAnsiChar; overload;
function StrNewW(const pString: PWideChar): PWideChar; overload;
function StrNewW(const nLength: Integer): PWideChar; overload;
function StrDisposeA(var pString: PAnsiChar): Boolean; overload;
function StrDisposeW(var pString: PWideChar): Boolean; overload;
function SameText(const pszString1, pszString2: PAnsiChar): Boolean; overload;
function SameText(const pszString1, pszString2: PAnsiChar; const pLocaleOptions: TLocaleOptions): Boolean; overload;
function SameText(const pszString1, pszString2: PWideChar): Boolean; overload;
function SameText(const pszString1, pszString2: PWideChar; const pLocaleOptions: TLocaleOptions): Boolean; overload;

function AnsiTrim(const szValue: AnsiString): AnsiString;
function AnsiTrimLeft(const szValue: AnsiString): AnsiString;
function AnsiTrimRight(const szValue: AnsiString): AnsiString;

function AnsiStringValue(const pValue: PAnsiChar): AnsiString; overload;
function AnsiStringValue(const pValue: PWideChar): AnsiString; overload;
function AnsiStringValue(const sValue: AnsiString): AnsiString; overload;
function AnsiStringValue(const sValue: WideString): AnsiString; overload;
function AnsiStringValue(const sValue: String): AnsiString; overload;
function AnsiStringValue(const nValue: Integer): AnsiString; overload;
function AnsiStringValue(const nValue: INT64): AnsiString; overload;
function AnsiStringValue(const nValue: Cardinal): AnsiString; overload;
function AnsiStringValue(const nValue: UINT64): AnsiString; overload;
function AnsiStringValue(const fValue: Real): AnsiString; overload;
function AnsiStringValue(const fValue: Double): AnsiString; overload;

function WideStringValue(const pValue: PAnsiChar): WideString; overload;
function WideStringValue(const pValue: PWideChar): WideString; overload;
function WideStringValue(const sValue: AnsiString): WideString; overload;
function WideStringValue(const sValue: WideString): WideString; overload;
function WideStringValue(const sValue: String): WideString; overload;
function WideStringValue(const nValue: Integer): WideString; overload;
function WideStringValue(const nValue: INT64): WideString; overload;
function WideStringValue(const nValue: Cardinal): WideString; overload;
function WideStringValue(const nValue: UINT64): WideString; overload;
function WideStringValue(const fValue: Real): WideString; overload;
function WideStringValue(const fValue: Double): WideString; overload;

function StringValueP(const pValue: PAnsiChar): String; overload;
function StringValueP(const pValue: PWideChar): String; overload;
function StringValueS(const sValue: AnsiString): String; overload;
function StringValueS(const sValue: WideString): String; overload;
function StringValueN(const nValue: Integer): String; overload;
function StringValueN(const nValue: INT64): String; overload;
function StringValueN(const nValue: Cardinal): String; overload;
function StringValueN(const nValue: UINT64): String; overload;
function StringValueF(const fValue: Real): String; overload;
function StringValueF(const fValue: Double): String; overload;

implementation

{$IFDEF UNICODE}
uses
  Functions.SystemExtended,
  {$IFDEF HAS_UNIT_SCOPE}
  System.AnsiStrings;
  {$ELSE !HAS_UNIT_SCOPE}
  AnsiStrings;
  {$ENDIF HAS_UNIT_SCOPE}
{$ENDIF UNICODE}


function StringIsEmpty(const pString: PAnsiChar): Boolean; overload;
begin
  Result := (nil = pString) or (#0 = pString^);
end;

function StringIsEmpty(const pString: PWideChar): Boolean; overload;
begin
  Result := (nil = pString) or (#0 = pString^);
end;

function StringValue(const szValue: PAnsiChar): PAnsiChar; overload;
begin
  if StringIsEmpty(szValue) then
    Result := ''
  else
    Result := szValue;
end;

function StringValue(const szValue: PWideChar): PWideChar; overload;
begin
  if StringIsEmpty(szValue) then
    Result := ''
  else
    Result := szValue;
end;

function StrNewA(const pString: PAnsiChar): PAnsiChar; overload;
var
  nLength, nSize: Integer;
begin
  Result := nil;
  if StringIsEmpty(pString) then
    Exit;

{$IFDEF UNICODE}
  nLength := AlignOfInt({$IFDEF HAS_UNIT_SCOPE}System.{$ENDIF HAS_UNIT_SCOPE}AnsiStrings.StrLen(pString) + 1);
{$ELSE !UNICODE}
  nLength := AlignOfInt(SysUtils.StrLen(pString) + 1);
{$ENDIF UNICODE}
  nSize := nLength * SizeOf(Result^);

  GetMem(Result, nSize);
  if (nil <> Result) then
  begin
{$IFDEF UNICODE}
    Move(pString^, Result^, ({$IFDEF HAS_UNIT_SCOPE}System.{$ENDIF HAS_UNIT_SCOPE}AnsiStrings.StrLen(pString) + 1) * SizeOf(Result^));
{$ELSE !UNICODE}
    Move(pString^, Result^, (SysUtils.StrLen(pString) + 1) * SizeOf(Result^));
{$ENDIF UNICODE}
  end;
end;

function StrNewA(const nLength: Integer): PAnsiChar; overload;
var
  nSize: Integer;
begin
  Result := nil;
  if (0 = nLength) then
    Exit;

  nSize := AlignOfInt(nLength + 1) * SizeOf(Result^);
  GetMem(Result, nSize);
end;

function StrNewW(const pString: PWideChar): PWideChar; overload;
var
  nLength, nSize: Integer;
begin
  Result := nil;
  if StringIsEmpty(pString) then
    Exit;

  nLength := AlignOfInt(System.SysUtils.StrLen(pString) + 1);
  nSize := nLength * SizeOf(Result^);

  GetMem(Result, nSize);
  if (nil <> Result) then
    Move(pString^, Result^, (StrLen(pString) + 1) * SizeOf(Result^));
end;

function StrNewW(const nLength: Integer): PWideChar; overload;
var
  nSize: Integer;
begin
  Result := nil;
  if (0 = nLength) then
    Exit;

  nSize := AlignOfInt(nLength + 1) * SizeOf(Result^);
  GetMem(Result, nSize);
end;

function StrDisposeA(var pString: PAnsiChar): Boolean; overload;
begin
  Result := FALSE;
  if (nil = pString) then
    Exit;

  FreeMem(pString);
  pString := nil;
  Result := TRUE;
end;

function StrDisposeW(var pString: PWideChar): Boolean; overload;
begin
  Result := FALSE;
  if (nil = pString) then
    Exit;

  FreeMem(pString);
  pString := nil;
  Result := TRUE;
end;

function SameText(const pszString1, pszString2: PAnsiChar): Boolean; overload;
begin
{$IFDEF UNICODE}
  Result := {$IFDEF HAS_UNIT_SCOPE}System.{$ENDIF HAS_UNIT_SCOPE}AnsiStrings.SameText(pszString1, pszString2);
{$ELSE !UNICODE}
  Result := SameText(pszString1, pszString2);
{$ENDIF UNICODE}
end;

function SameText(const pszString1, pszString2: PAnsiChar; const pLocaleOptions: TLocaleOptions): Boolean; overload;
begin
{$IFDEF UNICODE}
  Result := {$IFDEF HAS_UNIT_SCOPE}System.{$ENDIF HAS_UNIT_SCOPE}AnsiStrings.SameText(pszString1, pszString2, pLocaleOptions);
{$ELSE !UNICODE}
  Result := SameText(pszString1, pszString2, pLocaleOptions);
{$ENDIF UNICODE}
end;

function SameText(const pszString1, pszString2: PWideChar): Boolean; overload;
begin
{$IFDEF UNICODE}
  Result := {$IFDEF HAS_UNIT_SCOPE}System.{$ENDIF HAS_UNIT_SCOPE}SysUtils.SameText(pszString1, pszString2);
{$ELSE !UNICODE}
  Result := SameText(pszString1, pszString2);
{$ENDIF UNICODE}
end;

function SameText(const pszString1, pszString2: PWideChar; const pLocaleOptions: TLocaleOptions): Boolean; overload;
begin
{$IFDEF UNICODE}
  Result := {$IFDEF HAS_UNIT_SCOPE}System.{$ENDIF HAS_UNIT_SCOPE}SysUtils.SameText(pszString1, pszString2, pLocaleOptions);
{$ELSE !UNICODE}
  Result := SameText(pszString1, pszString2, pLocaleOptions);
{$ENDIF UNICODE}
end;

{$IFDEF UNICODE}
function AnsiTrim(const szValue: AnsiString): AnsiString;
var
  nLeft, nRight: Integer;
  pValue: PAnsiChar;
begin
  nLeft := 0;
  nRight := Length(szValue) - 1;
  pValue := PAnsiChar(szValue);
  if (nRight > -1) and (pValue[nLeft] > ' ') and (pValue[nRight] > ' ') then
  begin
    Result := szValue;
    Exit;
  end;

  // trim left
  while (nLeft <= nRight) and (pValue[nLeft] <= ' ') do
  begin
    Inc(nLeft);
  end;

  if (nLeft > nRight) then
  begin
    Result := '';
    Exit;
  end;

  // trim right
  while (pValue[nRight] <= ' ') do
  begin
    Dec(nRight);
  end;

  if (nLeft > nRight) then
  begin
    Result := '';
    Exit;
  end;

  SetLength(Result, nRight - nLeft + 1);
  Move(pValue[nLeft], Pointer(Result)^, (nRight - nLeft + 1) * SizeOf(pValue^));
end;

function AnsiTrimLeft(const szValue: AnsiString): AnsiString;
var
  nLeft, nRight: Integer;
  pValue: PAnsiChar;
begin
  nLeft := 0;
  nRight := Length(szValue) - 1;
  pValue := PAnsiChar(szValue);

  // trim left
  while (nLeft <= nRight) and (pValue[nLeft] <= ' ') do
  begin
    Inc(nLeft);
  end;

  if (nLeft > nRight) then
  begin
    Result := '';
    Exit;
  end;

  SetLength(Result, nRight - nLeft + 1);
  Move(pValue[nLeft], Pointer(Result)^, (nRight - nLeft + 1) * SizeOf(pValue^));
end;

function AnsiTrimRight(const szValue: AnsiString): AnsiString;
var
  nLeft, nRight: Integer;
  pValue: PAnsiChar;
begin
  nLeft := 0;
  nRight := Length(szValue) - 1;
  pValue := PAnsiChar(szValue);

  // trim right
  while (nLeft <= nRight) and (pValue[nRight] <= ' ') do
  begin
    Dec(nRight);
  end;

  if (nLeft > nRight) then
  begin
    Result := '';
    Exit;
  end;

  SetLength(Result, nRight - nLeft + 1);
  Move(pValue[nLeft], Pointer(Result)^, (nRight - nLeft + 1) * SizeOf(pValue^));
end;
{$ELSE !UNICODE}
function AnsiTrim(const szValue: AnsiString): AnsiString;
begin
  Result := Trim(szValue);
end;

function AnsiTrimLeft(const szValue: AnsiString): AnsiString;
begin
  Result := TrimLeft(szValue);
end;

function AnsiTrimRight(const szValue: AnsiString): AnsiString;
begin
  Result := TrimRight(szValue);
end;
{$ENDIF UNICODE}



function AnsiStringValue(const pValue: PAnsiChar): AnsiString;
begin
  Result := AnsiString(pValue);
end;

function AnsiStringValue(const pValue: PWideChar): AnsiString;
begin
  Result := AnsiStringValue(WideString(pValue));
end;

function AnsiStringValue(const sValue: AnsiString): AnsiString;
begin
  Result := sValue;
end;

function AnsiStringValue(const sValue: WideString): AnsiString;
begin
  Result := AnsiString(sValue);
end;

function AnsiStringValue(const sValue: String): AnsiString;
begin
  Result := AnsiString(sValue);
end;

function AnsiStringValue(const nValue: Integer): AnsiString;
begin
  Result := AnsiStringValue(IntToStr(nValue));
end;

function AnsiStringValue(const nValue: INT64): AnsiString;
begin
  Result := AnsiStringValue(IntToStr(nValue));
end;

function AnsiStringValue(const nValue: Cardinal): AnsiString;
begin
  Result := AnsiStringValue(UIntToStr(nValue));
end;

function AnsiStringValue(const nValue: UINT64): AnsiString;
begin
  Result := AnsiStringValue(UIntToStr(nValue));
end;

function AnsiStringValue(const fValue: Real): AnsiString;
begin
  Result := AnsiStringValue(FloatToStr(fValue));
end;

function AnsiStringValue(const fValue: Double): AnsiString;
begin
  Result := AnsiStringValue(FloatToStr(fValue));
end;


function WideStringValue(const pValue: PAnsiChar): WideString;
begin
  Result := WideStringValue(AnsiString(pValue));
end;

function WideStringValue(const pValue: PWideChar): WideString;
begin
  Result := WideStringValue(WideString(pValue));
end;

function WideStringValue(const sValue: AnsiString): WideString;
begin
  Result := WideString(sValue);
end;

function WideStringValue(const sValue: WideString): WideString;
begin
  Result := sValue;
end;

function WideStringValue(const sValue: String): WideString;
begin
  Result := sValue;
end;

function WideStringValue(const nValue: Integer): WideString;
begin
  Result := WideStringValue(IntToStr(nValue));
end;

function WideStringValue(const nValue: INT64): WideString;
begin
  Result := WideStringValue(IntToStr(nValue));
end;

function WideStringValue(const nValue: Cardinal): WideString;
begin
  Result := WideStringValue(UIntToStr(nValue));
end;

function WideStringValue(const nValue: UINT64): WideString;
begin
  Result := WideStringValue(UIntToStr(nValue));
end;

function WideStringValue(const fValue: Real): WideString;
begin
  Result := WideStringValue(FloatToStr(fValue));
end;

function WideStringValue(const fValue: Double): WideString;
begin
  Result := WideStringValue(FloatToStr(fValue));
end;


function StringValueP(const pValue: PAnsiChar): String;
begin
  Result := StringValueS(AnsiString(pValue));
end;

function StringValueP(const pValue: PWideChar): String;
begin
  Result := StringValueS(WideString(pValue));
end;

function StringValueS(const sValue: AnsiString): String;
begin
  Result := String(sValue);
end;

function StringValueS(const sValue: WideString): String;
begin
  Result := String(sValue);
end;

function StringValueN(const nValue: Integer): String;
begin
  Result := StringValueS(IntToStr(nValue));
end;

function StringValueN(const nValue: INT64): String;
begin
  Result := StringValueS(IntToStr(nValue));
end;

function StringValueN(const nValue: Cardinal): String;
begin
  Result := StringValueS(UIntToStr(nValue));
end;

function StringValueN(const nValue: UINT64): String;
begin
  Result := StringValueS(UIntToStr(nValue));
end;

function StringValueF(const fValue: Real): String;
begin
  Result := StringValueS(FloatToStr(fValue));
end;

function StringValueF(const fValue: Double): String;
begin
  Result := StringValueS(FloatToStr(fValue));
end;

end.
