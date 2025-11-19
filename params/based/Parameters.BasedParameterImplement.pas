unit Parameters.BasedParameterImplement;

interface

uses
  System.SysUtils, System.Classes,
  System.Rtti, System.TypInfo, System.ObjAuto,
  System.JSON,
  System.Generics.Defaults, System.Generics.Collections,

  Functions.StringsUtils, Functions.SystemExtended,

  Parameters.BasedParameterStatement;

type
{$M+}
{$METHODINFO ON}
  TParameterRealityClass = class of TParameterReality;

  TParameterReality = class(TInterfacedObject, IParameterContract)
  private
    { private declarations }

    // json对象，在转换为json对象或json格式字符串时使用。
    FJsonObject: TJSONObject;

    // 清除json对象列表
    function ClearJsonObjectPair(): Boolean;

    (*******************************************************************************
     * 功  能: 根据 json 对象创建实例【类或者结构类型】。                          *
     * 参  数:                                                                     *
     *   pJsonObject: json 对象实例                                                *
     *   pInstanceType: 要创建的实例的 rtti 类型信息                               *
     * 返回值:                                                                     *
     *   成功返回新的实例，否则返回 TValue.Empty 。                                *
     *   注：该方法只处理类或者结构类型，其他简单类型一律返回 TValue.Empty。       *
     *******************************************************************************)
    function CreateInstanceFromJsonObject(const pJsonObject: TJSONObject;
      const pInstanceType: TRttiType): TValue;

    (*******************************************************************************
     * 功  能: 将指定成员【属性或字段】的值转为json值对象                          *
     * 参  数:                                                                     *
     *   pInstance: 成员【属性或字段】所属对象的实例                               *
     *   pValue: 成员【属性或字段】的值                                            *
     * 返回值:                                                                     *
     *   返回转换后的json值的对象。                                                *
     *******************************************************************************)
    function MemberValueToJsonValue(const pValue: TValue): TJSONValue;
    // 该方法只处理 tkClass, tkClassRef, tkInterface, tkRecord, tkMRecord 几种类型，其他类型将调用 ValueToJsonValue 方法处理
    function MemberValueToJsonObject(const pValue: TValue): TJSONValue;

    (*******************************************************************************
     * 功  能: 将 json 对象中的值填充到指定对象的属性中                            *
     * 参  数:                                                                     *
     *   pJsonObject: json 对象实例                                                *
     *   pInstance: 被填充的对象实例                                               *
     *   pInstanceType: 对象实例对应的 rtti 类型信息                               *
     * 返回值:                                                                     *
     *   成功返回 true ，否则返回 false 。                                         *
     *******************************************************************************)
    //function ParseJsonObjectToInstance(const pJsonObject: TJSONObject;
    //  pInstance: TObject): Boolean; overload;
    //function ParseJsonObjectToInstance(const pJsonObject: TJSONObject;
    //  pInstance: Pointer; const pInstanceType: TRttiType): Boolean;

    (*******************************************************************************
     * 功  能: 将json值对象转为符合指定成员【属性或字段】的值                      *
     * 参  数:                                                                     *
     *   pJsonValue: json值对象                                                    *
     *   pInstance: 成员【属性或字段】所属的对象实例                               *
     *   pMember: 指定的实例成员【属性或字段】对象                                 *
     * 返回值:                                                                     *
     *   返回转换后的值（TValue）。                                                *
     *******************************************************************************)
    function JsonValueToMemberValue(const pJsonValue: TJSONValue;
      pInstance: Pointer; const pInstanceType: TRttiType): TValue; overload;
    function JsonValueToMemberValue(const pJsonValue: TJSONValue;
      const pMember: TRttiMember): TValue; overload;
    function JsonValueToMemberValue(const pJsonValue: TJSONValue;
      pInstance: TObject; const pMember: TRttiMember): TValue; overload;
  protected
    { protected declarations }
    function AssignTo(const pTarget: TParameterReality): Boolean; virtual;

    (*******************************************************************************
     * 功  能: 获取指定的成员【属性或字段】值（将实例转为json对象时会被调用）      *
     * 参  数:                                                                     *
     *   sName: 要获取的成员【属性或字段】名                                       *
     *   pValue: 成员【属性或字段】的值                                            *
     * 返回值:                                                                     *
     *   返回true则不会调用默认方式获取成员【属性或字段】的值，否则使用默认方法获取该成员【属性或字段】的值。
     * 备  注:
     *   在调用 ToJson 方法转换为 json 对象时会枚举本类 public 与 published 域所有属性或字段【变量】，并且会逐一调用该方法以便后代类可以单独处理感兴趣的属性或者字段。
     *   后代类可以依据实际需求对特定的属性或字段进行自定义处理。
     *   当属性或字段为集合、函数、方法、枚举等方法时，后代类必需自行处理并返回对应的值，否则该属性或字段的值将被忽略。
     *******************************************************************************)
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; virtual;

    (*******************************************************************************
     * 功  能: 设置指定的成员【属性或字段】值（解析json格式字符串时会被调用）      *
     * 参  数:                                                                     *
     *   sName: 要设置的成员【属性或字段】名                                       *
     *   pValue: 成员【属性或字段】的值                                            *
     * 返回值:                                                                     *
     *   返回true则不会调用默认方式设置成员【属性或字段】的值，否则使用默认方法设置该成员【属性或字段】的值。
     * 备  注:                                                                     *
     *   在调用 Parse 方法解析 json 字符串或对象时会枚举所有json字段，并且会逐一调用该方法以便后代类可以单独处理感兴趣的字段。
     *   当字段为数组、集合、函数、方法、枚举等方法时，后代类必需自行处理，否则该字段将被忽略。
     *   当字段为对象或需要显示初始化的复杂类型时，需要后代类做出必要的初始化操作，否则默认赋值过程将可能因无法初始化对应属性或字段而出错。
     *   如果想要保存原始的 json 数据【即直接保存pValue】需要后代类自行处理，且不能保存 json 对象的引用而需要调用 Clone 方法保存副本以确保数据的准确性。默认的赋值过程只会枚举属性进行填充，这样就无法获取到正确的 json 字段信息。
     *******************************************************************************)
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; virtual;

  public
    { public declarations }

    constructor Create(); reintroduce; virtual;
    destructor Destroy(); override;

  public
    { public declarations }

    (*******************************************************************************
     * 功  能: 实例转为json对象                                                    *
     * 参  数: 无                                                                  *
     * 返回值:                                                                     *
     *   返回转换后的标准json对象                                                  *
     *******************************************************************************)
    function ToJson(): TJSONValue;

    (*******************************************************************************
     * 功  能: 实例转为json格式字符串                                              *
     * 参  数: 无                                                                  *
     * 返回值:                                                                     *
     *   返回转换后的标准json格式字符串                                            *
     *******************************************************************************)
    function ToString(): WideString;{$IF RTLVersion > 20} reintroduce; {$IFEND} stdcall;

    (*******************************************************************************
     * 功  能: 按json方式解析指定的字符串，并将解析后的结果填充到属性中            *
     * 参  数:                                                                     *
     *   szJsonString: 指定要解析的json格式字符串                                  *
     * 返回值:                                                                     *
     *   解析成功返回true，否则返回false。                                         *
     *******************************************************************************)
    function Parse(const szJsonString: String): Boolean; overload;

    (*******************************************************************************
     * 功  能: 将json对象的值填充到属性中                                          *
     * 参  数:                                                                     *
     *   pJsonObject: json对象实例                                                 *
     * 返回值:                                                                     *
     *   成功返回true，否则返回false。                                             *
     *******************************************************************************)
    function Parse(const pJsonValue: TJSONValue): Boolean; overload;

    function Assign(const pSource: TParameterReality): Boolean;
  public
    { public declarations }

    (*******************************************************************************
     * 功  能: 根据传入的参数创建对象实例                                          *
     * 参  数:                                                                     *
     *   szJsonString: 指定要解析的json格式字符串                                  *
     * 返回值:                                                                     *
     *   解析成功返回创建的实例，否则返回空。                                      *
     *******************************************************************************)
    class function From(const szJsonString: String): IParameterContract; overload;

    (*******************************************************************************
     * 功  能: 根据传入的参数创建对象实例                                          *
     * 参  数:                                                                     *
     *   pJsonObject: json对象实例                                                 *
     * 返回值:                                                                     *
     *   解析成功返回创建的实例，否则返回空。                                      *
     *******************************************************************************)
    class function From(const pJsonValue: TJSONValue): IParameterContract; overload;

  public
    { public declarations }
    class function CreateWithTypeInfo(const pTypeInfo: Pointer): TParameterReality; inline; static;
    class function CreateWithConst(const pTypeInfo: Pointer; const pValue): TParameterReality; inline; static;

    class function CreateWithClass(const pExistsValue: TParameterReality): TParameterReality; overload; inline; static;
    class function CreateWithClass(const pClass: TParameterRealityClass;
      const pExistsValue: TParameterReality): TParameterReality; overload; inline; static;

    class function CreateWithJson(const pClass: TParameterRealityClass;
      const pJsonValue: TJSONValue): TParameterReality; overload; inline; static;
    class function CreateWithJson(const pTypeInfo: Pointer;
      const pJsonValue: TJSONValue): TParameterReality; overload; inline; static;

    class function CreateArrayWithJson<T>(const pClass: TParameterRealityClass;
      const pJsonValue: TJSONValue): TArray<T>; overload; inline; static;
    class function CreateArrayWithJson<T>(const pJsonValue: TJSONValue): TArray<T>; overload; inline; static;

    class function CopyWithClass(var pTarget; const pClass: TParameterRealityClass;
      const pSource: TParameterReality): TParameterReality; overload; inline; static;
    class function CopyWithClass(var pTarget;
      const pSource: TParameterReality): TParameterReality; overload; inline; static;

    class function CopyWithJson(var pTarget; const pClass: TParameterRealityClass;
      const pJsonValue: TJSONValue): TParameterReality; overload; inline; static;
    //class function CopyWithJson(var pTarget;
    //  const pJsonValue: TJSONValue): TParameterReality; overload; inline; static;

    class function CopyArrayWithClass<T>(var pTargets: TArray<T>;
      const pSources: TArray<T>): TArray<T>; inline; static;

    class function CopyArrayWithJson<T>(var pTargets: TArray<T>;
      const pClass: TParameterRealityClass;
      const pJsonValue: TJSONValue): TArray<T>; overload; inline; static;
    class function CopyArrayWithJson<T>(var pTargets: TArray<T>;
      const pJsonValue: TJSONValue): TArray<T>; overload; inline; static;

    // 接受通用对象，直接赋值不做其他处理
    // 注意：当 bDestNeedFree 为 TRUE 时会在赋值之前尝试调用 FREEANDNIL 释放原有对象。
    class function CloneWithClass(var pTarget: TObject; var bTargetNeedFree: Boolean;
      const pSource: TObject): TObject; overload; inline; static;
    // 接受原始 json 对象，实际调用 json 对象的 clone 方法保存对象的副本，本质上还是一个 TJSONAncestor 及其后代类对象实例。
    // 注意：当 bDestNeedFree 为 TRUE 时会在赋值之前尝试调用 FREEANDNIL 释放原有对象。
    class function CloneWithJson(var pTarget: TObject; var bTargetNeedFree: Boolean;
      const pJsonValue: TJSONValue): TObject; overload; inline; static;

    class function CloneArrayWithClass(var pTargets: TArray<TObject>;
      var bTargetElementNeedFree: Boolean;
      const pSources: TArray<TObject>): TArray<TObject>; inline; static;
    class function CloneArrayWithJson(var pTargets: TArray<TObject>;
      var bTargetElementNeedFree: Boolean;
      const pJsonValue: TJSONValue): TArray<TObject>; inline; static;

    class function ReleaseArray<T>(var pArray: TArray<T>;
      const bReleaseElement: Boolean = TRUE): TArray<T>; inline; static;
  published
    { published declarations }
  end;
{$METHODINFO OFF}
{$M-}

//{$Z1}
//{$Z2}
//{$Z4}
//{$Z+}

{$IFOPT Z+}
//  ShowMessage('Z+');
{$ELSE}
//  ShowMessage('Z-');
{$ENDIF}

implementation

function TypeToString(lpInfo: PTypeInfo; nIndex: Integer): WideString;
begin
  Result := GetEnumName(lpInfo, nIndex);
end;

function StringToType(lpInfo: PTypeInfo; szName: WideString): Integer;
begin
  Result := GetEnumValue(lpInfo, szName);
end;
{
function JsonValueAsValue(const pInfo: PTypeInfo; const pValue: TJSONValue): TValue;
var
  pRttiContext: TRttiContext;
  pRttiType: TRttiType;
  pRttiMethod: TRttiMethod;
  pParameter: array[0..1] of TValue;
  bResult: Boolean;
begin
  Result := TValue.Empty;
  pRttiContext := TRttiContext.Create();
  pRttiType := pRttiContext.GetType(pValue.ClassInfo);
  pRttiMethod := pRttiType.GetMethod('AsTValue');
  if (nil <> pRttiMethod) then
  begin
    pParameter[0].From(pInfo);
    pParameter[1].From(@Result);
    bResult := pRttiMethod.Invoke(pValue, pParameter).AsBoolean();
    if (not bResult) then
      Result := TValue.Empty;
  end;
end;
}
type
  TJSONValue1 = class(System.JSON.TJSONValue)
  end;

type
  TValueHelper = record helper for TValue
  public
    function CopyRawData(var pBuffer: Pointer): Integer;
    function ReleaseCopyData(var pBuffer: Pointer; const nDataSize: Integer): Boolean;
  end;

{ TValueHelper }

function TValueHelper.CopyRawData(var pBuffer: Pointer): Integer;
begin
  pBuffer := nil;
  Result := Self.DataSize; // 获取源数据的大小
  if (Result > 0) then
  begin
    GetMem(pBuffer, Result); // 创建缓冲区
    if (nil <> pBuffer) then
      Self.ExtractRawData(pBuffer) // 读取源数据到缓冲区
    else
      Result := 0;
  end;
end;

function TValueHelper.ReleaseCopyData(var pBuffer: Pointer;
  const nDataSize: Integer): Boolean;
begin
  if (nil = pBuffer) or (nDataSize <= 0) then
    Exit(FALSE);

  FreeMem(pBuffer, nDataSize);
  pBuffer := nil;
  Result := TRUE;
end;

{ TParameterReality }

function TParameterReality.Assign(const pSource: TParameterReality): Boolean;
begin
  if (nil <> pSource) then
    Result := pSource.AssignTo(Self)
  else
    Result := FALSE;
end;

function TParameterReality.AssignTo(const pTarget: TParameterReality): Boolean;
{
var
  pSelfRttiContext, pTargetRttiContext: TRttiContext;
  pSelfRttiType, pTargetRttiType: TRttiType;
  pSelfRttiProperties: TArray<TRttiProperty>;
  pSelfRttiFields: TArray<TRttiField>;

  pTargetProperty: TRttiProperty;
  pTargetField: TRttiField;
  nIndex: Integer;
begin
  Result := FALSE;
  if (nil = pTarget) then
    Exit;

  // 获取 target 的 rtti 信息
  pTargetRttiContext := TRttiContext.Create();
  pTargetRttiType := pTargetRttiContext.GetType(pTarget.ClassType());
  if (nil = pTargetRttiType) then
    Exit;

  // 获取 self 的 rtti 信息
  pSelfRttiContext := TRttiContext.Create();
  pSelfRttiType := pSelfRttiContext.GetType(Self.ClassType());
  if (nil = pSelfRttiType) then
    Exit;

  // 遍历 self 的所有属性，尝试将属性的值赋值给 pTarget 的同名属性
  pSelfRttiProperties := pSelfRttiType.GetProperties();
  for nIndex := Low(pSelfRttiProperties) to High(pSelfRttiProperties) do
  begin
    pTargetProperty := pTargetRttiType.GetProperty(pSelfRttiProperties[nIndex].Name);
    if (nil <> pTargetProperty) and (pTargetProperty.IsWritable) and (pTargetProperty.Visibility in [mvProtected, mvPublic, mvPublished]) then
    begin
      pTargetProperty.SetValue(pTarget, pSelfRttiProperties[nIndex].GetValue(Self));
    end;
  end;

  // 遍历 self 的所有字段，尝试将字段的值赋值给 pTarget 的同名字段
  pSelfRttiFields := pSelfRttiType.GetFields();
  for nIndex := Low(pSelfRttiFields) to High(pSelfRttiFields) do
  begin
    pTargetField := pTargetRttiType.GetField(pSelfRttiFields[nIndex].Name);
    if (nil <> pTargetField) and (pTargetField.Visibility in [mvProtected, mvPublic, mvPublished]) then
    begin
      pTargetField.SetValue(pTarget, pSelfRttiFields[nIndex].GetValue(Self));
    end;
  end;

  Result := TRUE;
end;
}
begin
  Result := FALSE;
  if (nil = pTarget) then
    Exit;
  Result := pTarget.Parse(Self.ToJson());
end;

function TParameterReality.ClearJsonObjectPair(): Boolean;
var
  nIndex: Integer;
begin
  Result := FALSE;
  if (nil = FJsonObject) then
    Exit;

  for nIndex := FJsonObject.Count - 1 downto 0 do
  begin
    FJsonObject.RemovePair(FJsonObject.Pairs[nIndex].JsonString.Value).Free();
  end;

  Result := TRUE;
end;

class function TParameterReality.CloneArrayWithClass(
  var pTargets: TArray<TObject>; var bTargetElementNeedFree: Boolean;
  const pSources: TArray<TObject>): TArray<TObject>;
var
  nIndex: Integer;
begin
  if (bTargetElementNeedFree) then
  begin
    for nIndex := High(pTargets) downto Low(pTargets) do
      SafeFreeAndNil(pTargets[nIndex]);
    bTargetElementNeedFree := FALSE;
  end;

  if (not Assigned(pSources)) then
    SetLength(pTargets, 0)
  else
  begin
    SetLength(pTargets, Length(pSources));
    for nIndex := Low(pTargets) to High(pTargets) do
    begin
      pTargets[nIndex] := pSources[nIndex];
    end;
  end;

  Result := pTargets;
end;

class function TParameterReality.CloneArrayWithJson(
  var pTargets: TArray<TObject>; var bTargetElementNeedFree: Boolean;
  const pJsonValue: TJSONValue): TArray<TObject>;
var
  nIndex: Integer;
begin
  if (bTargetElementNeedFree) then
  begin
    for nIndex := High(pTargets) downto Low(pTargets) do
      SafeFreeAndNil(pTargets[nIndex]);
    bTargetElementNeedFree := FALSE;
  end;

  if (nil = pJsonValue) then
  begin
    SetLength(pTargets, 0);
    bTargetElementNeedFree := FALSE;
  end
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);
    for nIndex := Low(pTargets) to High(pTargets) do
    begin
      if (nil <> (pJsonValue as TJSONArray).Items[nIndex]) then
        pTargets[nIndex] := (pJsonValue as TJSONArray).Items[nIndex].Clone()
      else
        pTargets[nIndex] := nil;
    end;

    bTargetElementNeedFree := TRUE;
  end
  else
  begin
    SetLength(pTargets, 1);
    if (nil <> pJsonValue) then
      pTargets[0] := pJsonValue.Clone()
    else
      pTargets[0] := nil;

    bTargetElementNeedFree := TRUE;
  end;

  Result := pTargets;
end;

class function TParameterReality.CloneWithClass(var pTarget: TObject;
  var bTargetNeedFree: Boolean; const pSource: TObject): TObject;
begin
  if (bTargetNeedFree) then
  begin
    SafeFreeAndNil(pTarget);
    bTargetNeedFree := FALSE;
  end;

  pTarget := pSource;
  Result := pTarget;
end;

class function TParameterReality.CloneWithJson(var pTarget: TObject;
  var bTargetNeedFree: Boolean; const pJsonValue: TJSONValue): TObject;
begin
  if (bTargetNeedFree) then
  begin
    SafeFreeAndNil(pTarget);
    bTargetNeedFree := FALSE;
  end;

  if (nil <> pJsonValue) then
  begin
    pTarget := pJsonValue.Clone();
    bTargetNeedFree := TRUE;
  end
  else
  begin
    pTarget := nil;
    bTargetNeedFree := FALSE;
  end;

  Result := pTarget;
end;

class function TParameterReality.CopyArrayWithClass<T>(var pTargets: TArray<T>;
  const pSources: TArray<T>): TArray<T>;
var
  nIndex, nLength: Integer;
  pNewItem: TParameterReality;
begin
  for nIndex := High(pTargets) downto Low(pTargets) do
    SafeFreeAndNil(pTargets[nIndex]);

  nLength := Length(pSources);
  SetLength(pTargets, nLength);
  for nIndex := Low(pSources) to High(pSources) do
  begin
    //pNewItem := TParameterReality.CreateWithClass(TValue.From(pSources[nIndex]).AsType<TParameterReality>());
    pNewItem := TParameterReality.CreateWithConst(TypeInfo(T), pSources[nIndex]);
    if (nil = pNewItem) then
      pTargets[nIndex] := TValue.Empty.AsType<T>()
    else
      pTargets[nIndex] := TValue.From(pNewItem).AsType<T>();
  end;

  Result := pTargets;
end;

class function TParameterReality.CopyArrayWithJson<T>(var pTargets: TArray<T>;
  const pJsonValue: TJSONValue): TArray<T>;
var
  nIndex: Integer;
  pTypeInfo: Pointer;
  pNewItem: TParameterReality;
begin
  for nIndex := High(pTargets) downto Low(pTargets) do
  begin
    SafeFreeAndNil(pTargets[nIndex]);
  end;

  pTypeInfo := System.TypeInfo(T);

  if (nil = pJsonValue) or (nil = pTypeInfo) then
  begin
    SetLength(pTargets, 0);
  end
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);

    for nIndex := Low(pTargets) to High(pTargets) do
    begin
      pNewItem := TParameterReality.CreateWithJson(pTypeInfo, (pJsonValue as TJSONArray).Items[nIndex]);
      if (nil = pNewItem) then
        pTargets[nIndex] := TValue.Empty.AsType<T>()
      else
        pTargets[nIndex] := TValue.From(pNewItem).AsType<T>();
    end;
  end
  else
  begin
    SetLength(pTargets, 1);

    pNewItem := TParameterReality.CreateWithJson(pTypeInfo, pJsonValue);
    if (nil = pNewItem) then
      pTargets[0] := TValue.Empty.AsType<T>()
    else
      pTargets[0] := TValue.From(pNewItem).AsType<T>();
  end;

  Result := pTargets;
end;

class function TParameterReality.CopyArrayWithJson<T>(var pTargets: TArray<T>;
  const pClass: TParameterRealityClass; const pJsonValue: TJSONValue): TArray<T>;
var
  nIndex: Integer;
  pNewItem: TParameterReality;
begin
  for nIndex := High(pTargets) downto Low(pTargets) do
  begin
    SafeFreeAndNil(pTargets[nIndex]);
  end;

  if (nil = pJsonValue) or (nil = pClass) then
  begin
    SetLength(pTargets, 0);
  end
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(pTargets, (pJsonValue as TJSONArray).Count);

    for nIndex := Low(pTargets) to High(pTargets) do
    begin
      pNewItem := TParameterReality.CreateWithJson(pClass, (pJsonValue as TJSONArray).Items[nIndex]);
      if (nil = pNewItem) then
        pTargets[nIndex] := TValue.Empty.AsType<T>()
      else
        pTargets[nIndex] := TValue.From(pNewItem).AsType<T>();
    end;
  end
  else
  begin
    SetLength(pTargets, 1);

    pNewItem := TParameterReality.CreateWithJson(pClass, pJsonValue);
    if (nil = pNewItem) then
      pTargets[0] := TValue.Empty.AsType<T>()
    else
      pTargets[0] := TValue.From(pNewItem).AsType<T>();
  end;

  Result := pTargets;
end;

class function TParameterReality.CopyWithClass(var pTarget;
  const pClass: TParameterRealityClass;
  const pSource: TParameterReality): TParameterReality;
begin
  if (nil = pSource) then
    SafeFreeAndNil(pTarget)
  else if (nil = Pointer(pTarget)) then
    TParameterReality(pTarget) := TParameterReality.CreateWithClass(pClass, pSource)
  else
    TParameterReality(pTarget).Assign(pSource);

  Result := TParameterReality(pTarget);
end;

class function TParameterReality.CopyWithClass(var pTarget;
  const pSource: TParameterReality): TParameterReality;
begin
  if (nil = pSource) then
  begin
    SafeFreeAndNil(pTarget);
    Result := nil;
  end
  else
    Result := TParameterReality.CopyWithClass(pTarget,
      TParameterRealityClass(pSource.ClassType()), pSource);
end;

class function TParameterReality.CopyWithJson(var pTarget; const pClass: TParameterRealityClass;
  const pJsonValue: TJSONValue): TParameterReality;
begin
  if (nil = pJsonValue) then
    SafeFreeAndNil(pTarget)
  else if (nil = Pointer(pTarget)) then
    TParameterReality(pTarget) := TParameterReality.CreateWithJson(pClass, pJsonValue)
  else
    TParameterReality(pTarget).Parse(pJsonValue);

  Result := TParameterReality(pTarget);
end;
{
class function TParameterReality.CopyWithJson(var pTarget;
  const pJsonValue: TJSONValue): TParameterReality;
begin
  Result := TParameterReality.CopyWithJson(pTarget,
    TParameterRealityClass(TParameterReality(pTarget).ClassType()), pJsonValue);
end;
}
constructor TParameterReality.Create();
begin
  inherited Create();
  FJsonObject := TJSONObject.Create();
end;

class function TParameterReality.CreateArrayWithJson<T>(
  const pJsonValue: TJSONValue): TArray<T>;
var
  nIndex: Integer;
  pTypeInfo: Pointer;
  pNewItem: TParameterReality;
begin
  pTypeInfo := System.TypeInfo(T);

  if (nil = pJsonValue) or (nil = pTypeInfo) then
    SetLength(Result, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(Result, (pJsonValue as TJSONArray).Count);

    for nIndex := Low(Result) to High(Result) do
    begin
      pNewItem := TParameterReality.CreateWithJson(pTypeInfo, (pJsonValue as TJSONArray).Items[nIndex]);
      if (nil = pNewItem) then
        Result[nIndex] := TValue.Empty.AsType<T>()
      else
        Result[nIndex] := TValue.From(pNewItem).AsType<T>();
    end;
  end
  else
  begin
    SetLength(Result, 1);

    pNewItem := TParameterReality.CreateWithJson(pTypeInfo, pJsonValue);
    if (nil = pNewItem) then
      Result[0] := TValue.Empty.AsType<T>()
    else
      Result[0] := TValue.From(pNewItem).AsType<T>();
  end;
end;

class function TParameterReality.CreateArrayWithJson<T>(
  const pClass: TParameterRealityClass;
  const pJsonValue: TJSONValue): TArray<T>;
var
  nIndex: Integer;
  pNewItem: TParameterReality;
begin
  if (nil = pJsonValue) or (nil = pClass) then
    SetLength(Result, 0)
  else if (pJsonValue is TJSONArray) then
  begin
    SetLength(Result, (pJsonValue as TJSONArray).Count);

    for nIndex := Low(Result) to High(Result) do
    begin
      pNewItem := TParameterReality.CreateWithJson(pClass, (pJsonValue as TJSONArray).Items[nIndex]);
      if (nil = pNewItem) then
        Result[nIndex] := TValue.Empty.AsType<T>()
      else
        Result[nIndex] := TValue.From(pNewItem).AsType<T>();
    end;
  end
  else
  begin
    SetLength(Result, 1);

    pNewItem := TParameterReality.CreateWithJson(pClass, pJsonValue);
    if (nil = pNewItem) then
      Result[0] := TValue.Empty.AsType<T>()
    else
      Result[0] := TValue.From(pNewItem).AsType<T>();
  end;
end;

function TParameterReality.CreateInstanceFromJsonObject(
  const pJsonObject: TJSONObject; const pInstanceType: TRttiType): TValue;
var
  pClass: TClass;
  pInstance: TObject;
  pBuffer: Pointer;
  nBufferSize: Integer;
begin
  Result := TValue.Empty;
  if (nil = pJsonObject) or (nil = pInstanceType) then
    Exit; // json 对象与要创建的实例类型都必需不为空

  case pInstanceType.TypeKind of
    tkClass,
    tkClassRef:
    begin
      {
        如果成员是类类型，那么会先通过类型名获取类信息，然后尝试调用 GetClass 获取类信息创建新的对象实例。
        但要注意的是 GetClass 只能获取到通过 RegisterClass 注册过的类的信息，并且该方法只能注册 TPersistent 及后代类。
      }
      pClass := GetClass(pInstanceType.Name); // 通过类型名获取类信息

      if (nil <> pClass) then // 类名已注册则用获取到的类型创建实例。
        pInstance := pClass.NewInstance()
      else
        pInstance := nil; // 否则为空

      // 实例创建成功则会调用对象的构造方法进行初始化
      if (nil <> pInstance) then
      try
        //pClass.InitInstance(pInstance);
        pInstance.Create(); // 调用构造方法。
      except
        //pClass.FreeInstance();
        FreeAndNil(pInstance);
      end;

      if (nil = pInstance) then
        Result := TValue.Empty // 实例创建不成功则返回空。
      else
      begin
        // 对象创建成功则调用赋值转换过程
        Result := JsonValueToMemberValue(pJsonObject, pInstance, pInstanceType);
        FreeAndNil(pInstance); // 释放临时创建的对象实例
      end;
    end;

    tkRecord,
    tkMRecord:
    begin
      // 由于结构类型实际占用内存空间不同，所以需要根据类型大小创建对应的缓冲区，然后才能使用。
      nBufferSize := pInstanceType.TypeSize; // 获取实际大小
      GetMem(pBuffer, nBufferSize); // 申请缓冲区
      if (nil = pBuffer) then
        Result := TValue.Empty // 缓冲区申请失败则返回空。
      else
      begin
        FillChar(pBuffer^, nBufferSize, 0); // 初始化缓冲区
        Result := JsonValueToMemberValue(pJsonObject, pBuffer, pInstanceType); // 调用赋值转换过程
        FreeMem(pBuffer, nBufferSize); // 清理缓冲区
      end;
    end;

    else
      Result := TValue.From(pJsonObject.Value); // 其他类型直接返回 json 字符串
  end;
end;

class function TParameterReality.CreateWithClass(
  const pExistsValue: TParameterReality): TParameterReality;
begin
  if (nil <> pExistsValue) then
    Result := TParameterReality.CreateWithClass(
      TParameterRealityClass(pExistsValue.ClassType()), pExistsValue)
  else
    Result := nil;
end;

class function TParameterReality.CreateWithClass(
  const pClass: TParameterRealityClass;
  const pExistsValue: TParameterReality): TParameterReality;
begin
  if (nil <> pClass) and (nil <> pExistsValue) then
  begin
    Result := pClass.NewInstance() as TParameterReality;
    Result.Create();
    Result.Assign(pExistsValue);
  end
  else
    Result := nil;
end;

class function TParameterReality.CreateWithConst(const pTypeInfo: Pointer;
  const pValue): TParameterReality;
begin
  Result := TParameterReality.CreateWithTypeInfo(pTypeInfo);
  if (nil <> Result) then
    Result.Assign(TParameterReality(pValue));
end;

class function TParameterReality.CreateWithJson(const pTypeInfo: Pointer;
  const pJsonValue: TJSONValue): TParameterReality;
begin
  if (nil <> pTypeInfo) and (nil <> pJsonValue) then
  begin
    Result := TParameterReality.CreateWithTypeInfo(pTypeInfo);
    if (nil <> Result) then
      Result.Parse(pJsonValue);
  end
  else
    Result := nil;
end;

class function TParameterReality.CreateWithJson(const pClass: TParameterRealityClass;
  const pJsonValue: TJSONValue): TParameterReality;
begin
  if (nil <> pClass) and (nil <> pJsonValue) then
  begin
    Result := pClass.NewInstance() as TParameterReality;
    Result.Create();
    Result.Parse(pJsonValue);
  end
  else
    Result := nil;
end;

class function TParameterReality.CreateWithTypeInfo(
  const pTypeInfo: Pointer): TParameterReality;
var
  pRttiType: TRttiType;
  pMethods: TArray<TRttiMethod>;
  nIndex: Integer;
begin
  Result := nil;
  // 获取指定类型的 rtti 类型信息
  pRttiType := TRttiContext.Create().GetType(pTypeInfo);

  // 遍历所有方法，找到要求的构造函数并检查没有纯虚函数
  //pConstructor := nil;
  pMethods := pRttiType.GetMethods();
  if not Assigned(pMethods) then
    Exit;
  for nIndex := Low(pMethods) to High(pMethods) do
  begin
    if pMethods[nIndex].IsConstructor then // 静态方法
    begin
      //if (pMethods[nIndex].Visibility = mvPublic) and (Length(pMethods[nIndex].GetParameters) = 0) then
      //  pConstructor := pMethods[nIndex];
    end
    else if (nil = pMethods[nIndex].CodeAddress) then // 抽象方法
      Exit;
  end;

  // 创建实例
  Result := pRttiType.Handle.TypeData.ClassType.NewInstance() as TParameterReality;
  try
    // 调用默认构造函数创建实例
    //pConstructor.Invoke(Result, []);
    Result.Create();
  except
    Result.FreeInstance(); // 出错则回收内存，这里不调用 Destory
    Result := nil;
  end;
end;

destructor TParameterReality.Destroy();
begin
  if (nil <> FJsonObject) then
  begin
    ClearJsonObjectPair();
    FreeAndNil(FJsonObject);
  end;

  inherited Destroy();
end;

class function TParameterReality.From(const pJsonValue: TJSONValue): IParameterContract;
var
  pResult: TParameterReality;
begin
  Result := nil;

  pResult := TParameterReality.NewInstance() as TParameterReality;
  if (nil = pResult) then
  begin
    Exit;
  end;

  pResult.Create();
  if not pResult.Parse(pJsonValue) then
  begin
    FreeAndNil(pResult);
    Exit;
  end;

  if (pResult.QueryInterface(IParameterContract, Result) <> S_OK) then
    Result := nil;
end;

class function TParameterReality.From(const szJsonString: String): IParameterContract;
var
  pResult: TParameterReality;
begin
  Result := nil;

  pResult := TParameterReality.NewInstance() as TParameterReality;
  if (nil = pResult) then
  begin
    Exit;
  end;

  pResult.Create();
  if not pResult.Parse(szJsonString) then
  begin
    FreeAndNil(pResult);
    Exit;
  end;

  if (pResult.QueryInterface(IParameterContract, Result) <> S_OK) then
    Result := nil;
end;

function TParameterReality.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := FALSE; // 返回false表示不处理
end;

function TParameterReality.JsonValueToMemberValue(const pJsonValue: TJSONValue;
  pInstance: Pointer; const pInstanceType: TRttiType): TValue;
var
  pProperty: TRttiProperty;
  pField: TRttiField;

  szName: String;
  pValue: TValue;
  nIndex: Integer;
begin
  // 只处理TJSONObject与TObject对应且双方都不为空的情况，否则返回空
  if ((nil = pJsonValue) or (not (pJsonValue is TJSONObject)) or (nil = pInstance) or (nil = pInstanceType)) then
  begin
    Result := TValue.Empty;
    Exit;
  end;

  // 如果传入的实例类型是类类型，并且是 TParameterReality 及其后代类，那么就调用该实例的 Parse 方法解析 json 数据。
  if (pInstanceType.TypeKind in [tkClass, tkClassRef]) then
  try
    // 尝试将指针 pInstance 强转为 TObject 实例并进行类型判断。
    if (TObject(pInstance) is TParameterReality) then
    begin
      TParameterReality(pInstance).Parse(pJsonValue as TJSONObject);
      Result := TValue.From(TParameterReality(pInstance));
      Exit;
    end;
  except
    // 如果强转失败则调用后面的赋值过程。
  end;

  // 其他通用过程.
  for nIndex := 0 to (pJsonValue as TJSONObject).Count - 1 do
  begin
    // 获取 json 字段名
    szName := (pJsonValue as TJSONObject).Pairs[nIndex].JsonString.Value;

    // 根据 json 字段名获取类属性
    pProperty := pInstanceType.GetProperty(szName);
    if (nil <> pProperty) and (pProperty.IsWritable) and (not (pProperty.Visibility in [mvPrivate, mvProtected])) then
    begin // 不获取私有域及保护域成员
      pValue := JsonValueToMemberValue((pJsonValue as TJSONObject).Pairs[nIndex].JsonValue, pInstance, pProperty);
      pProperty.SetValue(pInstance, pValue);
    end;

    // 根据 json 字段名获取类字段
    pField := pInstanceType.GetField(szName);
    if (nil <> pField) and (not (pField.Visibility in [mvPrivate, mvProtected])) then
    begin // 不获取私有域及保护域成员
      pValue := JsonValueToMemberValue((pJsonValue as TJSONObject).Pairs[nIndex].JsonValue, pInstance, pField);
      pField.SetValue(pInstance, pValue);
    end;
  end;

  // 由于结构类型传递的是地址，所以这里要与类类型做个区分
  if (pInstanceType.TypeKind in [tkRecord, tkMRecord]) then
    TValue.Make(pInstance, pInstanceType.Handle, Result)
  else
    TValue.Make(@pInstance, pInstanceType.Handle, Result);
end;

function TParameterReality.JsonValueToMemberValue(const pJsonValue: TJSONValue;
  const pMember: TRttiMember): TValue;
var
  nIndex, nCount: Integer;
  pArray: array of TValue;
  pMemberType: TRttiType;
  tkTypeKind: TTypeKind;
  sValue: String;
  pJsonObject: TJSONValue;
begin
  { 首先获取成员【属性或字段】的RTTI类型 }
  if (nil = pMember) then
  begin
    pMemberType := nil;
    tkTypeKind := tkUnknown;
  end
  else if (pMember is TRttiProperty) then
  begin // 取属性的RTTI类型
    pMemberType := (pMember as TRttiProperty).PropertyType;
    tkTypeKind := pMemberType.TypeKind;
  end
  else if (pMember is TRttiField) then
  begin // 取字段的RTTI类型
    pMemberType := (pMember as TRttiField).FieldType;
    tkTypeKind := pMemberType.TypeKind;
  end
  else
  begin // 空
    pMemberType := nil;
    tkTypeKind := tkUnknown;
  end;

  if (pJsonValue is TJSONNumber) then
  begin
    // number类型包括浮点、整型以及枚举型（boolean属于枚举型），为了区分所以需要判断成员的数据类型。
    case tkTypeKind of
      tkInteger:
        Result := TValue.From((pJsonValue as TJSONNumber).AsInt);
      tkEnumeration:
        if (pMemberType = TRttiContext.Create().GetType(System.TypeInfo(Boolean))) then
          Result := TValue.From(pJsonValue.AsType<Boolean>())
        else
          Result := TValue.From((pJsonValue as TJSONNumber).AsInt);
      tkFloat:
        Result := TValue.From((pJsonValue as TJSONNumber).AsDouble);
      tkInt64:
        Result := TValue.From((pJsonValue as TJSONNumber).AsInt64);
      else
        Result := TValue.From((pJsonValue as TJSONNumber).AsDouble); // 默认返回浮点型
    end;
  end
  else if (pJsonValue is TJSONString) then // 字符串类型
  begin
    {
      string类型属于兼容性比较高的类型，这里会根据指定的成员【属性或字段】的类型进行转换，
      然后再将转换后的 Json 对象的各成员的值填充到成员中。
    }
    sValue := (pJsonValue as TJSONString).Value; // 获取源字符串

    { 根据成员类型进行数据转换 }
    case tkTypeKind of
      tkInteger: // 整型
      begin
        Result := TValue.From(StrToInt(sValue));
      end;

      tkEnumeration: // 枚举型，包括 Boolean
      begin
        if (pMemberType = TRttiContext.Create().GetType(System.TypeInfo(Boolean))) then
          Result := TValue.From(StrToBool(sValue))
        else
          Result := TValue.From(StrToInt(sValue));
      end;

      tkFloat: // 浮点型
      begin
        Result := TValue.From(StrToFloat(sValue));
      end;

      tkInt64: // 长整型
      begin
        Result := TValue.From(StrToInt64(sValue));
      end;

      tkClass,
      tkClassRef, // 类类型
      tkRecord,
      tkMRecord: // 记录/结构类型
      begin
        pJsonObject := TJSONObject.ParseJSONValue(sValue); // 解析字符串
        if (nil <> pJsonObject) then
        try  // 解析成功调用赋值转换过程
          Result := CreateInstanceFromJsonObject(pJsonObject as TJSONObject, pMemberType);
        finally
          FreeAndNil(pJsonObject); // 释放解析后的 json 实例
        end
        else // 解析失败则返回空。
          Result := TValue.Empty;
      end;

      else // 默认返回源字符串
        Result := TValue.From(sValue);
    end;

    //Result := TValue.From((pJsonValue as TJSONString).Value)
  end
  else if (pJsonValue is TJSONBool) then // bool 类型直接填充
  begin
    case tkTypeKind of
      tkInteger,
      tkInt64,
      tkFloat: // 数值型【包括整型、浮点型】
        Result := TValue.From(Ord((pJsonValue as TJSONBool).AsBoolean));

      tkString,
      tkUString,
      tkLString,
      tkWString: // 字符串
        Result := TValue.From(pJsonValue.Value);

      tkEnumeration: // 枚举型，包括 Boolean
      begin
        if (pMemberType = TRttiContext.Create().GetType(System.TypeInfo(Boolean))) then
          Result := TValue.From((pJsonValue as TJSONBool).AsBoolean)
        else
          Result := TValue.From(Ord((pJsonValue as TJSONBool).AsBoolean));
      end;

      else // 默认返回 boolean 型
        Result := TValue.From((pJsonValue as TJSONBool).AsBoolean);
    end;
  end
  else if (pJsonValue is TJSONNull) then // 空类型
    Result := TValue.Empty // 返回空
  else if (pJsonValue is TJSONObject) then // json 对象
  begin
    {
      如果 json 数据为对象类型则需要根据成员【属性或字段】的类型进行赋值。
    }
    case tkTypeKind of
      tkClass,
      tkClassRef,
      tkRecord,
      tkMRecord:
      begin // 类类型或者结构类型尝试创建一个新的实例并读取 json 对象的每个字段的值填充进创建的实例中
        Result := CreateInstanceFromJsonObject(pJsonValue as TJSONObject, pMemberType);
      end;

      else
        Result := TValue.From(pJsonValue.Value); // 其他类型返回源字符串
    end;
  end
  else if (pJsonValue is TJSONArray) then
  begin
    {
      如果 json 数据为数组类型则需要严格与数组匹配
    }
    if (tkTypeKind in [tkArray, tkDynArray]) then
    begin
      nCount := (pJsonValue as TJSONArray).Count;
      SetLength(pArray, nCount);
      for nIndex := 0 to nCount - 1 do
      begin
        pArray[nIndex] := JsonValueToMemberValue((pJsonValue as TJSONArray).Items[nIndex], pMember);
      end;

      Result := TValue.From(pArray);
    end
    else // 其他类型无法处理，返回空
      Result := TValue.Empty;
  end
  else
    Result := TValue.Empty; // 缺省状态返回空
end;

function TParameterReality.JsonValueToMemberValue(const pJsonValue: TJSONValue;
  pInstance: TObject; const pMember: TRttiMember): TValue;
var
  pMemberValue: TValue;
  pMemberType: TRttiType;
  pMemberBuffer: Pointer;
  nBufferSize: Integer;
{
  pItem: TValue;
  nIndex, nCount: Integer;
  pArray: TArray<TValue>;
}
begin
  if (nil = pJsonValue) then
  begin
    Result := TValue.Empty;
    Exit;
  end;

  if (nil = pInstance) or (nil = pMember) then
  begin
    Result := TValue.Empty;
    Exit;
  end;

  if (pJsonValue is TJSONObject) then // 对象类型
  begin
    if (pMember is TRttiProperty) then
    begin
      pMemberValue := (pMember as TRttiProperty).GetValue(pInstance);
      pMemberType := (pMember as TRttiProperty).PropertyType;
    end
    else if (pMember is TRttiField) then
    begin
      pMemberValue := (pMember as TRttiField).GetValue(pInstance);
      pMemberType := (pMember as TRttiField).FieldType;
    end
    else
    begin
      pMemberValue := TValue.Empty;
      pMemberType := nil;
    end;

    if pMemberValue.IsEmpty then
      Result := JsonValueToMemberValue(pJsonValue, pMember)
    else case pMemberValue.Kind of
      tkClass,
      tkClassRef:
      begin
        Result := JsonValueToMemberValue(pJsonValue, pMemberValue.AsObject(), pMemberType);
      end;

      tkRecord,
      tkMRecord:
      begin
        nBufferSize := pMemberValue.CopyRawData(pMemberBuffer);
        if (nBufferSize > 0) then
        begin
          Result := JsonValueToMemberValue(pJsonValue as TJSONObject, pMemberBuffer, pMemberType);
          pMemberValue.ReleaseCopyData(pMemberBuffer, nBufferSize);
        end;
      end;
    end;
  end
  else if (pJsonValue is TJSONArray) then // 数组类型
  begin
    if (pMember is TRttiProperty) then
    begin
      pMemberValue := (pMember as TRttiProperty).GetValue(pInstance);
      //pMemberType := (pMember as TRttiProperty).PropertyType;
    end
    else if (pMember is TRttiField) then
    begin
      pMemberValue := (pMember as TRttiField).GetValue(pInstance);
      //pMemberType := (pMember as TRttiField).FieldType;
    end
    else
    begin
      pMemberValue := TValue.Empty;
      //pMemberType := nil;
    end;

    // 数组使用如下方式无法处理，暂时直接返回传入的值.
    Result := pMemberValue;

{
    if pMemberValue.IsEmpty or (not (pMemberValue.Kind in [tkArray, tkDynArray])) then
      Result := pMemberValue //JsonValueToMemberValue(pJsonValue, pMember)
    else
    begin
      // 获取数量小的
      if (pJsonValue as TJSONArray).Count >= pMemberValue.GetArrayLength() then
        nCount := pMemberValue.GetArrayLength()
      else
        nCount := (pJsonValue as TJSONArray).Count;
      SetLength(pArray, nCount);

      // 遍历数组所有元素。
      for nIndex := 0 to nCount - 1 do
      begin
        // 获取数组属性中的元素
        pItem := pMemberValue.GetArrayElement(nIndex);

        if (pItem.Kind in [tkClass, tkClassRef]) then // 类类型
        begin
          if pItem.IsEmpty then // 由于无法获取数组元素的类型信息，所以如果元素为空则用空值填充。
            pArray[nIndex] := JsonValueToMemberValue((pJsonValue as TJSONArray).Items[nIndex], pMember)
          else // 不为空则填充属性值到对象实例中去。
            pArray[nIndex] := JsonValueToMemberValue((pJsonValue as TJSONArray).Items[nIndex], pItem.AsObject(), pMemberType);
        end
        else
          pArray[nIndex] := JsonValueToMemberValue((pJsonValue as TJSONArray).Items[nIndex], pMember);
      end;
      Result := TValue.From(pArray);
    end;
}
  end
  else
    Result := JsonValueToMemberValue(pJsonValue, pMember);
end;

function TParameterReality.MemberValueToJsonObject(
  const pValue: TValue): TJSONValue;
var
  pRttiContext: TRttiContext;
  pRttiType: TRttiType;
  pProperty: TRttiProperty;
  pField: TRttiField;
  pInstance: Pointer;
  nBufferSize: Integer;
begin
  // 缓冲区大小，在复制 pValue 源数据的时候返回实际大小.
  nBufferSize := 0;
  // 首先获取实例
  if (pValue.Kind in [tkClass, tkClassRef]) then
  begin
    // 类类型可以直接调用 AsObject 方法获取
    pInstance := pValue.AsObject();

    // 当 pValue 是 TJSONValue 及其后代类【即为原始json对象时】，直接返回一个克隆对象。
    // 注意在设置成员属性时不能直接保存对象的引用，而应该调用 Clone 对象保存实例的副本。
    if (TObject(pInstance) is TJSONValue) then
    begin
      Result := TJSONValue(pInstance).Clone() as TJSONValue;
      Exit;
    end;

    // 当 pValue 是 TParameterReality 及其后代类时，调用它本身的 ToJson 方法获取 json 对象
    if (TObject(pInstance) is TParameterReality) then
    begin
      Result := TParameterReality(pInstance).ToJson().Clone() as TJSONValue;
      Exit;
    end;
  end
  else if (pValue.Kind in [tkInterface]) then
  begin
    // 接口类型可以直接调用 AsInterface 方法获取
    pInstance := pValue.AsInterface();
  end
  else if (pValue.Kind in [tkRecord, tkMRecord]) then
  begin
    // 结构类型由于无法直接确定占用内存空间，所以需要使用 TValue 的 ExtractRawData 方法读取实际内容，具体实现方法参见助手类实现的 CopyRawData 方法。
    nBufferSize := pValue.CopyRawData(pInstance);
  end
  else
  begin
    // 其他类型调用 ValueToJsonValue 方法转换
    Result := MemberValueToJsonValue(pValue);
    Exit;
  end;

  if (nil = pInstance) then
  begin
    Result := TJSONNull.Create();
    Exit;
  end;

  // 总是返回 TJSONObject 类型
  Result := TJSONObject.Create();

  // 初始化 rtti 相关结构
  pRttiContext := TRttiContext.Create();
  pRttiType := pRttiContext.GetType(pValue.TypeInfo);

  // 获取属性
  for pProperty in pRttiType.GetProperties() do
  begin
    if (pProperty.Visibility in [mvPrivate, mvProtected]) then
      Continue // 不获取私有域及保护域成员
    else if (SameText('RefCount', pProperty.Name)) then
      Continue; // 跳过 TInterfacedObject 的 RefCount 属性

    // 循环将所有属性的名称与值json对象中
    (Result as TJSONObject).AddPair(pProperty.Name, MemberValueToJsonValue(pProperty.GetValue(pInstance)));
  end;

  // 获取字段
  for pField in pRttiType.GetFields() do
  begin
    if (pField.Visibility in [mvPrivate, mvProtected]) then
      Continue; // 不获取私有域及保护域的成员
    {
    // 跳过 System.Generics.Collections 单元中 TList<T> 的成员 FListHelper , 因为 FListHelper 内部定义的 FListObj 可能引发循环引用导致死循环。
    if (SameText(pField.Name, 'FListHelper') or SameText(pField.Name, 'FListObj')) then
      Continue;
    // 跳过 TInterfacedObject 的 FRefCount 字段
    if (SameText('FRefCount', pField.Name)) then
      Continue;
    // 跳过本类的 FJsonObject 字段
    if (SameText('FJsonObject', pField.Name)) then
      Continue;
    }

    // 循环将所有字段的名称与值json对象中
    (Result as TJSONObject).AddPair(pField.Name, MemberValueToJsonValue(pField.GetValue(pInstance)));
  end;

  // 缓冲区大小大于0表示赋值过 pValue 的原始数据，所以需要用 ReleaseCopyData 回收资源。
  if (nBufferSize > 0) then
    pValue.ReleaseCopyData(pInstance, nBufferSize);
end;

function TParameterReality.MemberValueToJsonValue(
  const pValue: TValue): TJSONValue;
var
  nIndex: Integer;
begin
  if (pValue.IsEmpty) then
  begin
    Result := TJSONNull.Create();
    Exit;
  end;

{
tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray, tkUString,
tkClassRef, tkPointer, tkProcedure, tkMRecord
}
  case pValue.Kind of
    tkInteger:
    begin
      Result := TJSONNumber.Create(pValue.AsInteger());
    end;

    tkInt64:
    begin
      Result := TJSONNumber.Create(pValue.AsInt64());
    end;

    tkEnumeration:
    begin
      if pValue.TypeInfo = System.TypeInfo(Boolean) then
        Result := TJSONBool.Create(pValue.AsBoolean())
      else
        Result := TJSONNumber.Create(pValue.AsInteger());
    end;

    tkFloat:
    begin
      Result := TJSONNumber.Create(pValue.AsExtended());
    end;

    tkChar,
    tkWChar,
    tkString,
    tkLString,
    tkWString,
    tkUString:
    begin
      Result := TJSONString.Create(pValue.AsString());
    end;

    tkSet,
    tkArray,
    tkDynArray:
    begin
      Result := TJSONArray.Create();
      // 循环将所有元素添加进json数组对象
      for nIndex := 0 to pValue.GetArrayLength() - 1 do
      begin
        TJSONArray(Result).AddElement(MemberValueToJsonValue(pValue.GetArrayElement(nIndex)));
      end;
    end;

    tkClass,  // 类类型
    tkClassRef,
    tkInterface, // 接口类型
    tkRecord,
    tkMRecord: // 结构类型
    begin
      Result := MemberValueToJsonObject(pValue); // 这个方法只
    end;

    tkMethod,
    tkProcedure,
    tkPointer:
    begin
      Result := TJSONNumber.Create(Integer(pValue.AsType<Pointer>()));
    end;

    tkVariant:
    begin
      Result := TJSONString.Create(pValue.AsVariant());
    end;

    else
    begin
      Result := TJSONString.Create(pValue.AsString());
    end;
  end;
end;

function TParameterReality.Parse(const szJsonString: String): Boolean;
var
  pJsonValue: TJSONValue;
begin
  Result := FALSE;
  if ('' = szJsonString) then
    Exit;

  // 解析字符串，解析成功调用同名的 Parse 方法解析获取 json 数据。
  pJsonValue := TJSONObject.ParseJSONValue(szJsonString);
  if (nil <> pJsonValue) then
  try
    Result := Parse(pJsonValue);
  finally
    FreeAndNil(pJsonValue);
  end;
end;

function TParameterReality.Parse(const pJsonValue: TJSONValue): Boolean;
var
  pRttiContext: TRttiContext;
  pRttiType: TRttiType;
  pProperty: TRttiProperty;
  pField: TRttiField;

  szName: String;
  nIndex: Integer;
  pValue: TValue;
  pJsonObject: TJSONObject;
begin
  Result := FALSE;

  if (nil = pJsonValue) then
    Exit;
  if not (pJsonValue is TJSONObject) then
    Exit;
  pJsonObject := pJsonValue as TJSONObject;

  pRttiContext := TRttiContext.Create();
  pRttiType := pRttiContext.GetType(Self.ClassType());

  for nIndex := 0 to pJsonObject.Count - 1 do
  begin
    // 获取json字段名
    szName := pJsonObject.Pairs[nIndex].JsonString.Value;

    //TJSONValue1(pJsonObject.Pairs[nIndex].JsonValue).AsTValue(pValue.TypeInfo, pValue);
    // 尝试调用 SetMemberValue 方法来设置成员的值，如果返回true表示后代类中可能按照自己的方式设置过该成员，则直接跳过后续设置过程，进入下一次循环。
    if (SetMemberValue(szName, pJsonObject.Pairs[nIndex].JsonValue)) then
    begin
      Continue;
    end;

    // 根据 json 字段名获取类属性
    pProperty := pRttiType.GetProperty(szName);
    if (nil <> pProperty) and (pProperty.IsWritable) and (not (pProperty.Visibility in [mvPrivate, mvProtected])) then
    begin // 不获取私有域及保护域成员
      pValue := JsonValueToMemberValue(pJsonObject.Pairs[nIndex].JsonValue, Self, pProperty);
      pProperty.SetValue(Self, pValue);
    end;

    // 根据 json 字段名获取类字段
    pField := pRttiType.GetField(szName);
    if (nil <> pField) and (not (pField.Visibility in [mvPrivate, mvProtected])) then
    begin // 不获取私有域及保护域成员
      pValue := JsonValueToMemberValue(pJsonObject.Pairs[nIndex].JsonValue, Self, pField);
      pField.SetValue(Self, pValue);
    end;
  end;
  Result := TRUE;
end;

class function TParameterReality.ReleaseArray<T>(var pArray: TArray<T>;
  const bReleaseElement: Boolean): TArray<T>;
var
  nIndex: Integer;
begin
  if (bReleaseElement) then
  begin
    for nIndex := High(pArray) downto Low(pArray) do
      SafeFreeAndNil(pArray[nIndex]);
  end;
  SetLength(pArray, 0);
  Result := pArray;
end;

{
function TParameterReality.ParseJsonObjectToInstance(const pJsonObject: TJSONObject;
  pInstance: Pointer; const pInstanceType: TRttiType): Boolean;
var
  pProperty: TRttiProperty;
  pField: TRttiField;

  szName: String;
  nIndex: Integer;
  pValue: TValue;
begin
  Result := FALSE;

  if ((nil = pJsonObject) or (nil = pInstanceType) or (nil = pInstance)) then
    Exit;

  for nIndex := 0 to pJsonObject.Count - 1 do
  begin
    // 获取 json 字段名
    szName := pJsonObject.Pairs[nIndex].JsonString.Value;

    // 根据 json 字段名获取类属性
    pProperty := pInstanceType.GetProperty(szName);
    if (nil <> pProperty) and (pProperty.IsWritable) and (not (pProperty.Visibility in [mvPrivate, mvProtected])) then
    begin // 不获取私有域及保护域成员
      pValue := JsonValueToMemberValue(pJsonObject.Pairs[nIndex].JsonValue, pInstance, pProperty);
      pProperty.SetValue(pInstance, pValue);
    end;

    // 根据 json 字段名获取类字段
    pField := pInstanceType.GetField(szName);
    if (nil <> pField) and (not (pField.Visibility in [mvPrivate, mvProtected])) then
    begin // 不获取私有域及保护域成员
      pValue := JsonValueToMemberValue(pJsonObject.Pairs[nIndex].JsonValue, pInstance, pField);
      pField.SetValue(pInstance, pValue);
    end;
  end;
  Result := TRUE;
end;

function TParameterReality.ParseJsonObjectToInstance(
  const pJsonObject: TJSONObject; pInstance: TObject): Boolean;
var
  pRttiContext: TRttiContext;
  pRttiType: TRttiType;
  pProperty: TRttiProperty;
  pField: TRttiField;

  szName: String;
  nIndex: Integer;
  pValue: TValue;
begin
  Result := FALSE;

  if ((nil = pJsonObject) or (nil = pInstance)) then
    Exit;

  pRttiContext := TRttiContext.Create();
  pRttiType := pRttiContext.GetType(pInstance.ClassType());

  for nIndex := 0 to pJsonObject.Count - 1 do
  begin
    // 获取 json 字段名
    szName := pJsonObject.Pairs[nIndex].JsonString.Value;

    // 根据 json 字段名获取类属性
    pProperty := pRttiType.GetProperty(szName);
    if (nil <> pProperty) and (pProperty.IsWritable) and (not (pProperty.Visibility in [mvPrivate, mvProtected])) then
    begin // 不获取私有域及保护域成员
      pValue := JsonValueToMemberValue(pJsonObject.Pairs[nIndex].JsonValue, pInstance, pProperty);
      pProperty.SetValue(pInstance, pValue);
    end;

    // 根据 json 字段名获取类字段
    pField := pRttiType.GetField(szName);
    if (nil <> pField) and (not (pField.Visibility in [mvPrivate, mvProtected])) then
    begin // 不获取私有域及保护域成员
      pValue := JsonValueToMemberValue(pJsonObject.Pairs[nIndex].JsonValue, pInstance, pField);
      pField.SetValue(pInstance, pValue);
    end;
  end;
  Result := TRUE;
end;
}

function TParameterReality.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  Result := FALSE; // 返回false表示不处理
end;

function TParameterReality.ToJson(): TJSONValue;
var
  pRttiContext: TRttiContext;
  pRttiType: TRttiType;
  pProperty: TRttiProperty;
  pField: TRttiField;

  sMemberName: String;
  vMemberValue: TValue;
begin
  Result := nil;
  if not Self.ClearJsonObjectPair() then
    Exit;

  pRttiContext := TRttiContext.Create();
  pRttiType := pRttiContext.GetType(Self.ClassType());

  // 获取全属性
  for pProperty in pRttiType.GetProperties() do
  begin
    if (pProperty.Visibility in [mvPrivate, mvProtected]) then // 不获取私有域及保护域的成员
    begin
      Continue
    end
    else if (SameText('RefCount', pProperty.Name)) then // 跳过 TInterfacedObject 的 RefCount 属性
    begin
      Continue;
    end;

    // 这里尝试调用 GetMemberValue 来获取指定成员【属性或字段】的值，如果返回false表示没有处理，那么就会按照默认方式获取该成员【属性或字段】的值。
    sMemberName := pProperty.Name;
    if (not GetMemberValue(sMemberName, vMemberValue)) then
    begin
      sMemberName := pProperty.Name;
      vMemberValue := pProperty.GetValue(Self);
    end;

    // 忽略空值
    if (vMemberValue.IsEmpty) then
    begin
      Continue;
    end
    else if (vMemberValue.Kind in [tkChar, tkWChar, tkString, tkLString, tkWString, tkUString]) then
    begin
      if ('' = vMemberValue.ToString()) then
        Continue;
    end;

    FJsonObject.AddPair(sMemberName, MemberValueToJsonValue(vMemberValue));
  end;

  // 获取全字段
  for pField in pRttiType.GetFields() do
  begin
    if (pField.Visibility in [mvPrivate, mvProtected]) then // 不获取私有域及保护域的成员
    begin
      Continue;
    end;
    {
    // 跳过 System.Generics.Collections 单元中 TList<T> 的成员 FListHelper , 因为 FListHelper 内部定义的 FListObj 可能引发循环引用导致死循环。
    if (SameText(pField.Name, 'FListHelper') or SameText(pField.Name, 'FListObj')) then
    begin
      Continue;
    end;
    // 跳过 TInterfacedObject 的 FRefCount 字段
    if (SameText('FRefCount', pField.Name)) then
    begin
      Continue;
    end;
    // 跳过本类的 FJsonObject 字段
    if (SameText('FJsonObject', pField.Name)) then
    begin
      Continue;
    end;
    }
    // 这里尝试调用 GetMemberValue 来获取指定成员【属性或字段】的值，如果返回false表示没有处理，那么就会按照默认方式获取该成员【属性或字段】的值。
    sMemberName := pField.Name;
    if (not GetMemberValue(sMemberName, vMemberValue)) then
    begin
      sMemberName := pField.Name;
      vMemberValue := pField.GetValue(Self);
    end;

    if (vMemberValue.IsEmpty) then
    begin
      Continue;
    end
    else if (vMemberValue.Kind in [tkChar, tkWChar, tkString, tkLString, tkWString, tkUString]) then
    begin
      if ('' = vMemberValue.ToString()) then
        Continue;
    end;

    FJsonObject.AddPair(sMemberName, MemberValueToJsonValue(vMemberValue));
  end;

  Result := FJsonObject;
end;

function TParameterReality.ToString(): WideString;
begin
  Self.ToJson();
  Result := FJsonObject.ToString();
end;

end.
