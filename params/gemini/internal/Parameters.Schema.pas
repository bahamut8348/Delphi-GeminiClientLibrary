unit Parameters.Schema;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#Schema
  Schema 对象允许定义输入和输出数据类型。这些类型可以是对象，也可以是原始类型和数组。表示 OpenAPI 3.0 架构对象的选定子集。
}
  TSchema = class(TParameterReality)
  private
    { private declarations }
    FExampleNeedFree,
    FDefaultNeedFree: Boolean;

    FType: String;
    FFormat: String;
    FTitle: String;
    FDescription: String;
    FNullable: Boolean;
    FEnum: TArray<String>;
    FMaxItems: String;
    FMinItems: String;
    FProperties: TDictionary<String, String>; // map (key: string, value: object (Schema))
    FRequired: TArray<String>;
    FMinProperties: String;
    FMaxProperties: String;
    FMinLength: String;
    FMaxLength: String;
    FPattern: String;
    FExample: TObject; // value (Value format)
    FAnyOf: TArray<TSchema>;
    FPropertyOrdering: TArray<String>;
    FDefault: TObject; // value (Value format)
    FItems: TSchema;
    FMinimum: Double;
    FMaximum: Double;

    procedure SetDefault(const Value: TObject);
    procedure SetExample(const Value: TObject);
    procedure SetItems(const Value: TSchema);

    procedure SetAnyOf(const Value: TArray<TSchema>);
    procedure SetEnum(const Value: TArray<String>);
    procedure SetProperties(const Value: TDictionary<String, String>);
    procedure SetPropertyOrdering(const Value: TArray<String>);
    procedure SetRequired(const Value: TArray<String>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。数据类型。
    //
    // 值                               | 说明
    // TYPE_UNSPECIFIED                 | 未指定，不应使用。
    // STRING                           | 字符串类型。
    // NUMBER                           | 号码类型。
    // INTEGER                          | 整数类型。
    // BOOLEAN                          | 布尔值类型。
    // ARRAY                            | 数组类型。
    // OBJECT                           | 对象类型。
    // NULL                             | Null 类型。
    property &type: String read FType write FType;
    // 可选。数据的格式。允许使用任何值，但大多数值不会触发任何特殊功能。
    property format: String read FFormat write FFormat;
    // 可选。架构的标题。
    property title: String read FTitle write FTitle;
    // 可选。参数的简要说明。这可能包含使用示例。参数说明可以采用 Markdown 格式。
    property description: String read FDescription write FDescription;
    // 可选。指示值是否为 null。
    property nullable: Boolean read FNullable write FNullable;
    // 可选。Type.STRING 类型的元素可能的具有枚举格式的值。例如，我们可以将 Enum 方向定义为：{type:STRING, format:enum, enum:["EAST", NORTH", "SOUTH", "WEST"]}
    property enum: TArray<String> read FEnum write SetEnum;
    // 可选。Type.ARRAY 的元素数量上限。
    property maxItems: String read FMaxItems write FMaxItems;
    // 可选。Type.ARRAY 的元素数量下限。
    property minItems: String read FMinItems write FMinItems;
    // 可选。Type.OBJECT 的属性。
    // 包含一系列 "key": value 对的对象。示例：{ "name": "wrench", "mass": "1.3kg", "count": "3" }。
    property properties: TDictionary<String, String> read FProperties write SetProperties; // map (key: string, value: object (Schema))
    // 可选。Type.OBJECT 的必需属性。
    property required: TArray<String> read FRequired write SetRequired;
    // 可选。Type.OBJECT 的属性数量下限。
    property minProperties: String read FMinProperties write FMinProperties;
    // 可选。Type.OBJECT 的属性数量上限。
    property maxProperties: String read FMaxProperties write FMaxProperties;
    // 可选。类型为 STRING 的架构字段的最小长度。STRING
    property minLength: String read FMinLength write FMinLength;
    // 可选。Type.STRING 的最大长度
    property maxLength: String read FMaxLength write FMaxLength;
    // 可选。Type.STRING 的模式，用于将字符串限制为正则表达式。
    property pattern: String read FPattern write FPattern;
    // 可选。对象的示例。仅当对象为根对象时才会填充。
    property example: TObject read FExample write SetExample; // value (Value format)
    // 可选。该值应根据列表中的任何（一个或多个）子架构进行验证。
    property anyOf: TArray<TSchema> read FAnyOf write SetAnyOf;
    // 可选。属性的顺序。不是 OpenAPI 规范中的标准字段。用于确定响应中属性的顺序。
    property propertyOrdering: TArray<String> read FPropertyOrdering write SetPropertyOrdering;
    // 可选。字段的默认值。根据 JSON 架构，此字段适用于文档生成器，不会影响验证。因此，此处包含该字段并将其忽略，以便发送包含 default 字段的架构的开发者不会收到未知字段错误。
    property default: TObject read FDefault write SetDefault; // value (Value format)
    // 可选。Type.ARRAY 的元素的架构。
    property items: TSchema read FItems write SetItems;
    // 可选。类型为 INTEGER 和 NUMBER 的架构字段的最小值。
    property minimum: Double read FMinimum write FMinimum;
    // 可选。Type.INTEGER 和 Type.NUMBER 的最大值
    property maximum: Double read FMaximum write FMaximum;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType,
  Functions.SystemExtended;

{ TSchema }

constructor TSchema.Create();
begin
  inherited Create();
  Self.FExampleNeedFree := FALSE;
  Self.FDefaultNeedFree := FALSE;

  Self.FType := GEMINI_TYPE_UNSPECIFIED;
  Self.FFormat := '';
  Self.FTitle := '';
  Self.FDescription := '';
  Self.FNullable := FALSE;
  SetLength(Self.FEnum, 0);
  Self.FMaxItems := '';
  Self.FMinItems := '';
  Self.FProperties := nil; // map (key: string, value: object (Schema))
  SetLength(Self.FRequired, 0);
  Self.FMinProperties := '';
  Self.FMaxProperties := '';
  Self.FMinLength := '';
  Self.FMaxLength := '';
  Self.FPattern := '';
  Self.FExample := nil; // value (Value format)
  SetLength(Self.FAnyOf, 0);
  SetLength(Self.FPropertyOrdering, 0);
  Self.FDefault := nil; // value (Value format)
  Self.FItems := nil;
  Self.FMinimum := 0;
  Self.FMaximum := 0;
end;

destructor TSchema.Destroy();
begin
  Self.FMaximum := 0;
  Self.FMinimum := 0;
  SafeFreeAndNil(Self.FItems);
  if (Self.FDefaultNeedFree) then
    SafeFreeAndNil(Self.FDefault);
  ReleaseStringArray(Self.FPropertyOrdering);
  TParameterReality.ReleaseArray<TSchema>(Self.FAnyOf);
  if (Self.FExampleNeedFree) then
    SafeFreeAndNil(Self.FExample);
  Self.FPattern := '';
  Self.FMaxLength := '';
  Self.FMinLength := '';
  Self.FMaxProperties := '';
  Self.FMinProperties := '';
  ReleaseStringArray(Self.FRequired);
  SafeFreeAndNil(Self.FProperties);
  Self.FMinItems := '';
  Self.FMaxItems := '';
  ReleaseStringArray(Self.FEnum);
  Self.FNullable := FALSE;
  Self.FDescription := '';
  Self.FTitle := '';
  Self.FFormat := '';
  Self.FType := '';

  Self.FDefaultNeedFree := FALSE;
  Self.FExampleNeedFree := FALSE;
  inherited Destroy();
end;

function TSchema.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
var
  pProperties: TJSONObject;
begin
  if SameText(sName, 'properties') then
  begin
    pProperties := nil;
    if DictionaryToJsonObject(pProperties, Self.properties) then
    begin
      pValue := TValue.From(pProperties);
      SafeFreeAndNil(pProperties);
    end
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else
    Result := inherited GetMemberValue(sName, pValue);
end;

procedure TSchema.SetAnyOf(const Value: TArray<TSchema>);
begin
  TParameterReality.CopyArrayWithClass<TSchema>(FAnyOf, Value);
end;

procedure TSchema.SetDefault(const Value: TObject);
begin
  if (Value <> FDefault) then
    TParameterReality.CloneWithClass(FDefault, FDefaultNeedFree, Value);
end;

procedure TSchema.SetEnum(const Value: TArray<String>);
begin
  CopyStringArrayWithArray(FEnum, Value);
end;

procedure TSchema.SetExample(const Value: TObject);
begin
  if (Value <> FExample) then
    TParameterReality.CloneWithClass(FExample, FExampleNeedFree, Value);
end;

procedure TSchema.SetItems(const Value: TSchema);
begin
  if (Value <> FItems) then
    TParameterReality.CopyWithClass(FItems, Value);
end;

function TSchema.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'properties') then
  begin
    Result := JsonValueToDictionary(Self.FProperties, pValue);
  end
  else if SameText(sName, 'enum') then
  begin
    CopyStringArrayWithJson(Self.FEnum, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'required') then
  begin
    CopyStringArrayWithJson(Self.FRequired, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'anyOf') then
  begin
    TParameterReality.CopyArrayWithJson<TSchema>(Self.FAnyOf, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'propertyOrdering') then
  begin
    CopyStringArrayWithJson(Self.FPropertyOrdering, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'example') then
  begin
    TParameterReality.CloneWithJson(FExample, FExampleNeedFree, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'default') then
  begin
    TParameterReality.CloneWithJson(FDefault, FDefaultNeedFree, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'items') then
  begin
    TParameterReality.CopyWithJson(FItems, TSchema, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TSchema.SetProperties(const Value: TDictionary<String, String>);
begin
  CopyDictionaryWithDictionary(FProperties, Value);
end;

procedure TSchema.SetPropertyOrdering(const Value: TArray<String>);
begin
  CopyStringArrayWithArray(FPropertyOrdering, Value);
end;

procedure TSchema.SetRequired(const Value: TArray<String>);
begin
  CopyStringArrayWithArray(FRequired, Value);
end;

end.
