unit Functions.SystemExtended;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Defaults, System.Generics.Collections,
  System.Rtti, System.TypInfo, System.ObjAuto,
  System.JSON,
  System.DateUtils, System.TimeSpan;

function AlignOfInt(const n: Integer): Integer; overload; inline;
function AlignOfInt(const n: LongWord): LongWord; overload; inline;
function AlignOfInt(const n: Int64): Int64; overload; inline;
function AlignOfInt(const n: UINT64): UINT64; overload; inline;

procedure SafeFreeAndNil(var instance); inline;
//procedure SafeRelease(var instance); inline;

function LocaleDateTimeToUniversalDateTime(const dtLocale: TDateTime): TDateTime; inline;
function UniversalDateTimeToLocaleDateTime(const dtUniversal: TDateTime): TDateTime; inline;
function DateTimeToUniversalString(const dtDateTime: TDateTime = 0;
  const bDateTimeIsUniversal: Boolean = FALSE): String; inline;
function UniversalStringToDateTime(const szUniversalString: String): TDateTime; inline;

function GetJsonStringValue(const pValue: TJSONValue): String; inline;
function GetJsonAnsiStringValue(const pValue: TJSONValue): AnsiString; inline;
function GetJsonWideStringValue(const pValue: TJSONValue): WideString; inline;
function GetJsonIntValue(const pValue: TJSONValue): Integer; inline;
function GetJsonUIntValue(const pValue: TJSONValue): Cardinal; inline;
function GetJsonInt64Value(const pValue: TJSONValue): INT64; inline;
function GetJsonUInt64Value(const pValue: TJSONValue): UINT64; inline;
function GetJsonFloatValue(const pValue: TJSONValue): Real; inline;
function GetJsonDoubleValue(const pValue: TJSONValue): Double; inline;
function GetJsonBooleanValue(const pValue: TJSONValue): Boolean; inline;

function CreateAnsiStringArrayWithJson(const pJsonValue: TJSONValue): TArray<AnsiString>; inline;
function CreateWideStringArrayWithJson(const pJsonValue: TJSONValue): TArray<WideString>; inline;
function CreateStringArrayWithJson(const pJsonValue: TJSONValue): TArray<String>; inline;
function CreateIntArrayWithJson(const pJsonValue: TJSONValue): TArray<Integer>; inline;
function CreateUIntArrayWithJson(const pJsonValue: TJSONValue): TArray<Cardinal>; inline;
function CreateInt64ArrayWithJson(const pJsonValue: TJSONValue): TArray<INT64>; inline;
function CreateUInt64ArrayWithJson(const pJsonValue: TJSONValue): TArray<UINT64>; inline;
function CreateFloatArrayWithJson(const pJsonValue: TJSONValue): TArray<Real>; inline;
function CreateDoubleArrayWithJson(const pJsonValue: TJSONValue): TArray<Double>; inline;
function CreateBooleanArrayWithJson(const pJsonValue: TJSONValue): TArray<Boolean>; inline;

function CopyAnsiStringArrayWithJson(var pTargets: TArray<AnsiString>;
  const pJsonValue: TJSONValue): TArray<AnsiString>; inline;
function CopyWideStringArrayWithJson(var pTargets: TArray<WideString>;
  const pJsonValue: TJSONValue): TArray<WideString>; overload; inline;
function CopyStringArrayWithJson(var pTargets: TArray<String>;
  const pJsonValue: TJSONValue): TArray<String>; overload; inline;
function CopyIntArrayWithJson(var pTargets: TArray<Integer>;
  const pJsonValue: TJSONValue): TArray<Integer>; inline;
function CopyUIntArrayWithJson(var pTargets: TArray<Cardinal>;
  const pJsonValue: TJSONValue): TArray<Cardinal>; inline;
function CopyInt64ArrayWithJson(var pTargets: TArray<INT64>;
  const pJsonValue: TJSONValue): TArray<INT64>; inline;
function CopyUInt64ArrayWithJson(var pTargets: TArray<UINT64>;
  const pJsonValue: TJSONValue): TArray<UINT64>; inline;
function CopyFloatArrayWithJson(var pTargets: TArray<Real>;
  const pJsonValue: TJSONValue): TArray<Real>; inline;
function CopyDoubleArrayWithJson(var pTargets: TArray<Double>;
  const pJsonValue: TJSONValue): TArray<Double>; inline;
function CopyBooleanArrayWithJson(var pTargets: TArray<Boolean>;
  const pJsonValue: TJSONValue): TArray<Boolean>; inline;

function CopyStringArrayWithArray(var pTargets: TArray<AnsiString>;
  const pSources: TArray<AnsiString>): TArray<AnsiString>; overload; inline;
function CopyStringArrayWithArray(var pTargets: TArray<WideString>;
  const pSources: TArray<WideString>): TArray<WideString>; overload; inline;
function CopyStringArrayWithArray(var pTargets: TArray<String>;
  const pSources: TArray<String>): TArray<String>; overload; inline;

function JsonValueToDictionary(var pDictionary: TDictionary<String, String>;
  const pJsonValue: TJSONValue): Boolean; inline;
function DictionaryToJsonObject(var pJsonObject: TJSONObject;
  const pDictionary: TDictionary<String, String>): Boolean; inline;

function CopyDictionaryWithDictionary(var pTarget: TDictionary<String, String>;
  const pSource: TDictionary<String, String>): Boolean; inline;

function ReleaseStringArray(var pArray: TArray<String>): TArray<String>; overload; inline;
function ReleaseStringArray(var pArray: TArray<AnsiString>): TArray<AnsiString>; overload; inline;
function ReleaseStringArray(var pArray: TArray<WideString>): TArray<WideString>; overload; inline;

implementation

function AlignOfInt(const n: Integer): Integer;
begin
  Result := (n + SizeOf(Integer) - 1) and not(SizeOf(Integer) - 1);
end;

function AlignOfInt(const n: LongWord): LongWord;
begin
  Result := (n + SizeOf(Integer) - 1) and not(SizeOf(Integer) - 1);
end;

function AlignOfInt(const n: Int64): Int64;
begin
  Result := (n + SizeOf(Integer) - 1) and not(SizeOf(Integer) - 1);
end;

function AlignOfInt(const n: UINT64): UINT64;
begin
  Result := (n + SizeOf(Integer) - 1) and not(SizeOf(Integer) - 1);
end;

procedure SafeFreeAndNil(var instance);
begin
  if (nil <> Pointer(instance)) then
  begin
    FreeAndNil(instance);
  end;
end;

procedure SafeRelease(var instance);
begin
  if (nil <> Pointer(instance)) then
  begin
    IUnknown(instance)._Release();
    IUnknown(instance) := nil;
  end;
end;

function LocaleDateTimeToUniversalDateTime(const dtLocale: TDateTime): TDateTime;
begin
  Result := TTimeZone.Local.ToUniversalTime(dtLocale);
end;

function UniversalDateTimeToLocaleDateTime(const dtUniversal: TDateTime): TDateTime;
begin
  Result := TTimeZone.Local.ToLocalTime(dtUniversal);
end;

function DateTimeToUniversalString(const dtDateTime: TDateTime;
  const bDateTimeIsUniversal: Boolean): String;
var
  dtUniversalTimeCoordinated: TDateTime;
  wYear, wMonth, wDay, wHour, wMinute, wSecond, wMilliSecond: WORD;
begin
  if (bDateTimeIsUniversal) then
  begin
    if (0 = dtDateTime) then
      dtUniversalTimeCoordinated := Now()
    else
      dtUniversalTimeCoordinated := dtDateTime;
  end
  else
  begin
    if (0 = dtDateTime) then
      dtUniversalTimeCoordinated := LocaleDateTimeToUniversalDateTime(Now())
    else
      dtUniversalTimeCoordinated := LocaleDateTimeToUniversalDateTime(dtDateTime);
  end;
  DecodeDateTime(dtUniversalTimeCoordinated, wYear, wMonth, wDay, wHour, wMinute, wSecond, wMilliSecond);
{
  Result := Format('%.4d-%.2d-%.2dT%.2d:%.2d:%.2d.%.9dZ', [
    wYear, wMonth, wDay, wHour, wMinute, wSecond, wMilliSecond]);
}
{
  Result := Format('%.4d-%.2d-%.2dT%.2d:%.2d:%.2d.%.9d+%s', [
    wYear, wMonth, wDay, wHour, wMinute, wSecond, wMilliSecond,
    TTimeZone.Local.UtcOffset.ToString()]);
}
{
  Result := Format('%.4d-%.2d-%.2dT%.2d:%.2d:%.2dZ', [
    wYear, wMonth, wDay, wHour, wMinute, wSecond]);
}
  Result := Format('%.4d-%.2d-%.2dT%.2d:%.2d:%.2d+%s', [
    wYear, wMonth, wDay, wHour, wMinute, wSecond,
    TTimeZone.Local.UtcOffset.ToString()]);
end;

function UniversalStringToDateTime(const szUniversalString: String): TDateTime;
var
  szLocale: String;
  pIndex, pStop: PChar;

  szYear: array[0..3] of Char;
  szMonth, szDay, szHour, szMinute, szSecond: array[0..1] of Char;
  szMilliSecond, szUTCOffset: String;

  szDelimiterYearAndMonth, szDelimiterMonthAndDay, szDelimiterDayAndHour,
  szDelimiterHourAndMinute, szDelimiterMinuteAndSecond, szDelimiterSecondAndLast,
  szDelimiterOther: Char;

  nYear, nMonth, nDay, nHour, nMinute, nSecond, nMilliSecond: Integer;
begin
  // 0000-00-00T00:00:00.000000000Z
  // 0000-00-00T00:00:00.000000000+00:00
  Result := 0;
  szLocale := Trim(szUniversalString);
  if (Length(szLocale) < 20) then
    Exit;

  pIndex := PChar(szLocale);

  Move(pIndex^, szYear[0], SizeOf(szYear)); // 复制【年】
  Inc(pIndex, Length(szYear));
  Move(pIndex^, szDelimiterYearAndMonth, SizeOf(szDelimiterYearAndMonth)); // 【年】与【月】之间的分隔符
  Inc(pIndex, 1);
  Move(pIndex^, szMonth[0], SizeOf(szMonth)); // 复制【月】
  Inc(pIndex, Length(szMonth));
  Move(pIndex^, szDelimiterMonthAndDay, SizeOf(szDelimiterMonthAndDay)); // 【月】与【日】之间的分隔符
  Inc(pIndex, 1);
  Move(pIndex^, szDay[0], SizeOf(szDay)); // 复制【月】
  Inc(pIndex, Length(szDay));
  Move(pIndex^, szDelimiterDayAndHour, SizeOf(szDelimiterDayAndHour)); // 【日】与【时】之间的分隔符
  Inc(pIndex, 1);
  Move(pIndex^, szHour[0], SizeOf(szHour)); // 复制【时】
  Inc(pIndex, Length(szHour));
  Move(pIndex^, szDelimiterHourAndMinute, SizeOf(szDelimiterHourAndMinute)); // 【时】与【分】之间的分隔符
  Inc(pIndex, 1);
  Move(pIndex^, szMinute[0], SizeOf(szMinute)); // 复制【分】
  Inc(pIndex, Length(szMinute));
  Move(pIndex^, szDelimiterMinuteAndSecond, SizeOf(szDelimiterMinuteAndSecond)); // 【分】与【秒】之间的分隔符
  Inc(pIndex, 1);
  Move(pIndex^, szSecond[0], SizeOf(szSecond)); // 复制【秒】
  Inc(pIndex, Length(szSecond));
  Move(pIndex^, szDelimiterSecondAndLast, SizeOf(szDelimiterSecondAndLast)); // 【秒】与【后续其他内容】之间的分隔符
  Inc(pIndex, 1);

  if ('-' <> szDelimiterYearAndMonth) then // 【年】与【月】之间的分隔符
    Exit;
  if ('-' <> szDelimiterMonthAndDay) then // 【月】与【日】之间的分隔符
    Exit;
  if ('T' <> szDelimiterDayAndHour) and ('t' <> szDelimiterDayAndHour) then // 【日】与【时】之间的分隔符
    Exit;
  if (':' <> szDelimiterHourAndMinute) then // 【时】与【分】之间的分隔符
    Exit;
  if (':' <> szDelimiterMinuteAndSecond) then // 【分】与【秒】之间的分隔符
    Exit;

  if ('.' = szDelimiterSecondAndLast) then // 【秒】之后的分隔符如果是小数点【.】则表示有毫秒
  begin
    // 由于毫秒位数不固定【可能有3、6、9位】，所以需要循环判断。
    pStop := pIndex;
    while ((pStop^ >= '0') and (pStop^ <= '9')) do
    begin
      Inc(pStop);
    end;
    if (pStop > pIndex) then
      SetString(szMilliSecond, pIndex, pStop - pIndex);
    pIndex := pStop;

    Move(pIndex^, szDelimiterOther, SizeOf(szDelimiterOther)); // 最后一个分隔符
    Inc(pIndex, 1);
  end
  else
  begin
    szMilliSecond := '0';
    szDelimiterOther := szDelimiterSecondAndLast;
  end;

  if ('+' = szDelimiterOther) then // 【+】为时间与时区偏移的间隔
  begin
    szUTCOffset := pIndex; // 时差偏移
  end
  else if ('Z' = szDelimiterOther) or ('z' = szDelimiterOther) then // 【Z】为结束符
  begin
    szUTCOffset := TTimeZone.Local.UtcOffset.ToString; // 时差偏移
  end
  else
    Exit;

  // 尝试转换时间的各个成员
  nYear := StrToIntDef(szYear, -1);
  if (-1 = nYear) then
    Exit;
  nMonth := StrToIntDef(szMonth, -1);
  if (-1 = nMonth) then
    Exit;
  nDay := StrToIntDef(szDay, -1);
  if (-1 = nDay) then
    Exit;
  nHour := StrToIntDef(szHour, -1);
  if (-1 = nHour) then
    Exit;
  nMinute := StrToIntDef(szMinute, -1);
  if (-1 = nMinute) then
    Exit;
  nSecond := StrToIntDef(szSecond, -1);
  if (-1 = nSecond) then
    Exit;
  nMilliSecond := StrToIntDef(szMilliSecond, -1);
  if (-1 = nMilliSecond) then
    Exit;

  // 尝试组合utc时间
  if not TryEncodeDateTime(nYear, nMonth, nDay, nHour, nMinute, nSecond, nMilliSecond, Result) then
  begin
    Result := 0;
    Exit;
  end;

  // 最后加上时差偏移
  Result := Result + StrToTimeDef(szUTCOffset, 0);
end;

function GetJsonStringValue(const pValue: TJSONValue): String;
begin
  if (nil = pValue) then
    Result := ''
  else if (pValue is TJSONString) then
    Result := (pValue as TJSONString).Value
  else
    Result := pValue.Value;
end;

function GetJsonAnsiStringValue(const pValue: TJSONValue): AnsiString;
begin
  if (nil = pValue) then
    Result := ''
  else if (pValue is TJSONString) then
    Result := AnsiString((pValue as TJSONString).Value)
  else
    Result := AnsiString(pValue.Value);
end;

function GetJsonWideStringValue(const pValue: TJSONValue): WideString;
begin
  if (nil = pValue) then
    Result := ''
  else if (pValue is TJSONString) then
    Result := (pValue as TJSONString).Value
  else
    Result := pValue.Value;
end;

function GetJsonIntValue(const pValue: TJSONValue): Integer;
begin
  if (nil = pValue) then
    Result := 0
  else if (pValue is TJSONNumber) then
    Result := (pValue as TJSONNumber).AsInt
  else
    Result := StrToInt(pValue.Value);
end;

function GetJsonUIntValue(const pValue: TJSONValue): Cardinal;
begin
  if (nil = pValue) then
    Result := 0
  else if (pValue is TJSONNumber) then
    Result := Cardinal((pValue as TJSONNumber).AsInt)
  else
    Result := StrToUInt(pValue.Value);
end;

function GetJsonInt64Value(const pValue: TJSONValue): INT64;
begin
  if (nil = pValue) then
    Result := 0
  else if (pValue is TJSONNumber) then
    Result := (pValue as TJSONNumber).AsInt64
  else
    Result := StrToInt64(pValue.Value);
end;

function GetJsonUInt64Value(const pValue: TJSONValue): UINT64;
begin
  if (nil = pValue) then
    Result := 0
  else if (pValue is TJSONNumber) then
    Result := UINT64((pValue as TJSONNumber).AsInt64)
  else
    Result := StrToUInt64(pValue.Value);
end;

function GetJsonFloatValue(const pValue: TJSONValue): Real;
begin
  if (nil = pValue) then
    Result := 0
  else if (pValue is TJSONNumber) then
    Result := (pValue as TJSONNumber).AsDouble
  else
    Result := StrToFloat(pValue.Value);
end;

function GetJsonDoubleValue(const pValue: TJSONValue): Double;
begin
  if (nil = pValue) then
    Result := 0
  else if (pValue is TJSONNumber) then
    Result := (pValue as TJSONNumber).AsDouble
  else
    Result := StrToFloat(pValue.Value);
end;

function GetJsonBooleanValue(const pValue: TJSONValue): Boolean;
begin
  if (nil = pValue) then
    Result := FALSE
  else if (pValue is TJSONBool) then
    Result := (pValue as TJSONBool).AsBoolean
  else
    Result := StrToBool(pValue.Value);
end;

function CreateAnsiStringArrayWithJson(const pJsonValue: TJSONValue): TArray<AnsiString>;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(Result, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(Result, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(Result) to High(Result) do
      Result[nIndex] := GetJsonAnsiStringValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := GetJsonAnsiStringValue(pJsonValue);
  end;
end;

function CreateWideStringArrayWithJson(const pJsonValue: TJSONValue): TArray<WideString>;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(Result, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(Result, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(Result) to High(Result) do
      Result[nIndex] := GetJsonWideStringValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := GetJsonWideStringValue(pJsonValue);
  end;
end;

function CreateStringArrayWithJson(const pJsonValue: TJSONValue): TArray<String>;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(Result, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(Result, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(Result) to High(Result) do
      Result[nIndex] := GetJsonStringValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := GetJsonWideStringValue(pJsonValue);
  end;
end;

function CreateIntArrayWithJson(const pJsonValue: TJSONValue): TArray<Integer>;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(Result, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(Result, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(Result) to High(Result) do
      Result[nIndex] := GetJsonIntValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := GetJsonIntValue(pJsonValue);
  end;
end;

function CreateUIntArrayWithJson(const pJsonValue: TJSONValue): TArray<Cardinal>;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(Result, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(Result, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(Result) to High(Result) do
      Result[nIndex] := GetJsonUIntValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := GetJsonUIntValue(pJsonValue);
  end;
end;

function CreateInt64ArrayWithJson(const pJsonValue: TJSONValue): TArray<INT64>;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(Result, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(Result, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(Result) to High(Result) do
      Result[nIndex] := GetJsonInt64Value((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := GetJsonInt64Value(pJsonValue);
  end;
end;

function CreateUInt64ArrayWithJson(const pJsonValue: TJSONValue): TArray<UINT64>;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(Result, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(Result, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(Result) to High(Result) do
      Result[nIndex] := GetJsonUInt64Value((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := GetJsonUInt64Value(pJsonValue);
  end;
end;

function CreateFloatArrayWithJson(const pJsonValue: TJSONValue): TArray<Real>;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(Result, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(Result, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(Result) to High(Result) do
      Result[nIndex] := GetJsonFloatValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := GetJsonFloatValue(pJsonValue);
  end;
end;

function CreateDoubleArrayWithJson(const pJsonValue: TJSONValue): TArray<Double>;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(Result, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(Result, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(Result) to High(Result) do
      Result[nIndex] := GetJsonDoubleValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := GetJsonDoubleValue(pJsonValue);
  end;
end;

function CreateBooleanArrayWithJson(const pJsonValue: TJSONValue): TArray<Boolean>;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(Result, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(Result, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(Result) to High(Result) do
    begin
      Result[nIndex] := GetJsonBooleanValue((pJsonValue as TJSONArray).Items[nIndex]);
    end;
  end
  else
  begin
    SetLength(Result, 1);
    Result[0] := GetJsonBooleanValue(pJsonValue);
  end;
end;

function CopyAnsiStringArrayWithJson(var pTargets: TArray<AnsiString>;
  const pJsonValue: TJSONValue): TArray<AnsiString>; inline;
var
  nIndex: Integer;
begin
  for nIndex := High(pTargets) downto Low(pTargets) do
    pTargets[nIndex] := '';

  if (nil = pJsonValue) then
    SetLength(pTargets, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(pTargets) to High(pTargets) do
      pTargets[nIndex] := GetJsonAnsiStringValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(pTargets, 1);
    pTargets[0] := GetJsonAnsiStringValue(pJsonValue);
  end;

  Result := pTargets;
end;

function CopyWideStringArrayWithJson(var pTargets: TArray<WideString>;
  const pJsonValue: TJSONValue): TArray<WideString>; overload; inline;
var
  nIndex: Integer;
begin
  for nIndex := High(pTargets) downto Low(pTargets) do
    pTargets[nIndex] := '';

  if (nil = pJsonValue) then
    SetLength(pTargets, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(pTargets) to High(pTargets) do
      pTargets[nIndex] := GetJsonWideStringValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(pTargets, 1);
    pTargets[0] := GetJsonWideStringValue(pJsonValue);
  end;

  Result := pTargets;
end;

function CopyStringArrayWithJson(var pTargets: TArray<String>;
  const pJsonValue: TJSONValue): TArray<String>; overload; inline;
var
  nIndex: Integer;
begin
  for nIndex := High(pTargets) downto Low(pTargets) do
    pTargets[nIndex] := '';

  if (nil = pJsonValue) then
    SetLength(pTargets, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(pTargets) to High(pTargets) do
      pTargets[nIndex] := GetJsonStringValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(pTargets, 1);
    pTargets[0] := GetJsonStringValue(pJsonValue);
  end;

  Result := pTargets;
end;

function CopyIntArrayWithJson(var pTargets: TArray<Integer>;
  const pJsonValue: TJSONValue): TArray<Integer>; inline;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(pTargets, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(pTargets) to High(pTargets) do
      pTargets[nIndex] := GetJsonIntValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(pTargets, 1);
    pTargets[0] := GetJsonIntValue(pJsonValue);
  end;

  Result := pTargets;
end;

function CopyUIntArrayWithJson(var pTargets: TArray<Cardinal>;
  const pJsonValue: TJSONValue): TArray<Cardinal>; inline;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(pTargets, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(pTargets) to High(pTargets) do
      pTargets[nIndex] := GetJsonUIntValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(pTargets, 1);
    pTargets[0] := GetJsonUIntValue(pJsonValue);
  end;

  Result := pTargets;
end;

function CopyInt64ArrayWithJson(var pTargets: TArray<INT64>;
  const pJsonValue: TJSONValue): TArray<INT64>; inline;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(pTargets, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(pTargets) to High(pTargets) do
      pTargets[nIndex] := GetJsonInt64Value((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(pTargets, 1);
    pTargets[0] := GetJsonInt64Value(pJsonValue);
  end;

  Result := pTargets;
end;

function CopyUInt64ArrayWithJson(var pTargets: TArray<UINT64>;
  const pJsonValue: TJSONValue): TArray<UINT64>; inline;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(pTargets, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(pTargets) to High(pTargets) do
      pTargets[nIndex] := GetJsonUInt64Value((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(pTargets, 1);
    pTargets[0] := GetJsonUInt64Value(pJsonValue);
  end;

  Result := pTargets;
end;

function CopyFloatArrayWithJson(var pTargets: TArray<Real>;
  const pJsonValue: TJSONValue): TArray<Real>; inline;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(pTargets, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(pTargets) to High(pTargets) do
      pTargets[nIndex] := GetJsonFloatValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(pTargets, 1);
    pTargets[0] := GetJsonFloatValue(pJsonValue);
  end;

  Result := pTargets;
end;

function CopyDoubleArrayWithJson(var pTargets: TArray<Double>;
  const pJsonValue: TJSONValue): TArray<Double>; inline;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(pTargets, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(pTargets) to High(pTargets) do
      pTargets[nIndex] := GetJsonDoubleValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(pTargets, 1);
    pTargets[0] := GetJsonDoubleValue(pJsonValue);
  end;

  Result := pTargets;
end;

function CopyBooleanArrayWithJson(var pTargets: TArray<Boolean>;
  const pJsonValue: TJSONValue): TArray<Boolean>; inline;
var
  nIndex: Integer;
begin
  if (nil = pJsonValue) then
    SetLength(pTargets, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(pTargets) to High(pTargets) do
      pTargets[nIndex] := GetJsonBooleanValue((pJsonValue as TJSONArray).Items[nIndex]);
  end
  else
  begin
    SetLength(pTargets, 1);
    pTargets[0] := GetJsonBooleanValue(pJsonValue);
  end;

  Result := pTargets;
end;

function CopyStringArrayWithArray(var pTargets: TArray<AnsiString>;
  const pSources: TArray<AnsiString>): TArray<AnsiString>;
var
  nIndex: Integer;
begin
  for nIndex := High(pTargets) downto Low(pTargets) do
    pTargets[nIndex] := '';

  SetLength(pTargets, Length(pSources));
  for nIndex := Low(pTargets) to High(pTargets) do
    pTargets[nIndex] := pSources[nIndex];
  Result := pTargets;
end;

function CopyStringArrayWithArray(var pTargets: TArray<WideString>;
  const pSources: TArray<WideString>): TArray<WideString>;
var
  nIndex: Integer;
begin
  for nIndex := High(pTargets) downto Low(pTargets) do
    pTargets[nIndex] := '';

  SetLength(pTargets, Length(pSources));
  for nIndex := Low(pTargets) to High(pTargets) do
    pTargets[nIndex] := pSources[nIndex];
  Result := pTargets;
end;

function CopyStringArrayWithArray(var pTargets: TArray<String>;
  const pSources: TArray<String>): TArray<String>;
var
  nIndex: Integer;
begin
  for nIndex := High(pTargets) downto Low(pTargets) do
    pTargets[nIndex] := '';

  SetLength(pTargets, Length(pSources));
  for nIndex := Low(pTargets) to High(pTargets) do
    pTargets[nIndex] := pSources[nIndex];
  Result := pTargets;
end;

function JsonValueToDictionary(var pDictionary: TDictionary<String, String>;
  const pJsonValue: TJSONValue): Boolean;
var
  nIndex: Integer;
  pItem: TJSONPair;
begin
  Result := FALSE;
  if (nil = pJsonValue) then
    Exit;

  if (nil = pDictionary) then
    pDictionary := TDictionary<String, String>.Create()
  else
    pDictionary.Clear();

  if (pJsonValue is TJSONObject) then
  begin
    for nIndex := 0 to (pJsonValue as TJSONObject).Count - 1 do
    begin
      pItem := (pJsonValue as TJSONObject).Pairs[nIndex];
      if (nil <> pItem) then
        pDictionary.Add(pItem.JsonString.Value, pItem.JsonValue.Value);
    end;
  end
  else if (pJsonValue is TJSONArray) then
  begin
    for nIndex := 0 to (pJsonValue as TJSONArray).Count - 1 do
      pDictionary.Add(IntToStr(nIndex), GetJsonStringValue((pJsonValue as TJSONArray).Items[nIndex]));
  end
  else
  begin
    pDictionary.Add('0', GetJsonStringValue(pJsonValue));
  end;

  Result := TRUE;
end;

function DictionaryToJsonObject(var pJsonObject: TJSONObject;
  const pDictionary: TDictionary<String, String>): Boolean;
var
  nIndex: Integer;
  pItem: TPair<String, String>;
begin
  Result := FALSE;
  if (nil = pDictionary) then
    Exit;

  if (nil = pJsonObject) then
    pJsonObject := TJSONObject.Create()
  else
  begin
    for nIndex := pJsonObject.Count - 1 downto 0 do
    begin
      pJsonObject.RemovePair(pJsonObject.Pairs[nIndex].JsonString.Value).Free();
    end;
  end;

  for pItem in pDictionary.ToArray() do
  begin
    pJsonObject.AddPair(pItem.Key, pItem.Value);
  end;

  Result := TRUE;
end;

function CopyDictionaryWithDictionary(var pTarget: TDictionary<String, String>;
  const pSource: TDictionary<String, String>): Boolean;
var
  pArray: TArray<TPair<String, String>>;
  nIndex: Integer;
begin
  Result := FALSE;
  if (nil = pSource) then
  begin
    if (nil <> pTarget) then
      pTarget.Clear();
    Exit;
  end;

  if (nil = pTarget) then
    pTarget := TDictionary<String, String>.Create()
  else
    pTarget.Clear();

  pArray := pSource.ToArray();
  for nIndex := Low(pArray) to High(pArray) do
  begin
    pTarget.Add(pArray[nIndex].Key, pArray[nIndex].Value);
  end;

  Result := TRUE;
end;

function ReleaseStringArray(var pArray: TArray<String>): TArray<String>;
var
  nIndex: Integer;
begin
  for nIndex := High(pArray) downto Low(pArray) do
    pArray[nIndex] := '';
  SetLength(pArray, 0);
end;

function ReleaseStringArray(var pArray: TArray<AnsiString>): TArray<AnsiString>;
var
  nIndex: Integer;
begin
  for nIndex := High(pArray) downto Low(pArray) do
    pArray[nIndex] := '';
  SetLength(pArray, 0);
end;

function ReleaseStringArray(var pArray: TArray<WideString>): TArray<WideString>;
var
  nIndex: Integer;
begin
  for nIndex := High(pArray) downto Low(pArray) do
    pArray[nIndex] := '';
  SetLength(pArray, 0);
end;

end.
