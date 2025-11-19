unit Parameters.FunctionDeclaration;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Schema;

type
{
  https://ai.google.dev/api/caching#FunctionDeclaration
  OpenAPI 3.03 规范定义的函数声明的结构化表示法。此声明中包含函数名称和参数。此 FunctionDeclaration 是一个代码块的表示形式，可由模型用作 Tool 并由客户端执行。
}
  TFunctionDeclaration = class(TParameterReality)
  private
    { private declarations }
    FParameters: TSchema;
    FParametersJsonSchema: TObject; // TDictionary<String, TValue>;
    FParametersJsonSchemaNeedFree: Boolean;

    FResponse: TSchema;
    FResponseJsonSchema: TObject;
    FResponseJsonSchemaNeedFree: Boolean;

    procedure SetParameters(const Value: TSchema);
    procedure SetParametersJsonSchema(const Value: TObject);
    procedure SetResponse(const Value: TSchema);
    procedure SetResponseJsonSchema(const Value: TObject); // TDictionary<String, TValue>;
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。函数的名称。必须是 a-z、A-Z、0-9 或包含下划线、英文冒号、英文句点和英文短划线，长度上限为 64。
    name: String;
    // 必需。函数的简要说明。
    description: String;
    // 可选。指定函数行为。目前仅受 BidiGenerateContent 方法支持。
    //
    // 值               | 说明
    // UNSPECIFIED      | 此值未使用。
    // BLOCKING         | 如果设置，系统将等待接收函数响应，然后再继续对话。
    // NON_BLOCKING     | 如果设置，系统将不会等待接收函数响应。相反，它会尝试在函数响应可用时处理这些响应，同时保持用户与模型之间的对话。
    behavior: String;
  public
    { public declarations }
    // 可选。描述此函数的参数。反映了 Open API 3.03 参数对象字符串键：参数的名称。参数名称区分大小写。架构值：用于定义参数所用类型的架构。
    property parameters: TSchema read FParameters write SetParameters;
    // 可选。以 JSON 架构格式描述函数的参数。该架构必须描述一个对象，其中属性是函数的参数。例如：
    // {
    //   "type": "object",
    //   "properties": {
    //     "name": { "type": "string" },
    //     "age": { "type": "integer" }
    //   },
    //   "additionalProperties": false,
    //   "required": ["name", "age"],
    //   "propertyOrdering": ["name", "age"]
    // }
    // 此字段与 parameters 互斥。
    // TDictionary<String, TValue>;
    property parametersJsonSchema: TObject read FParametersJsonSchema write SetParametersJsonSchema;
  public
    { public declarations }
    // 可选。以 JSON 架构格式描述此函数的输出。反映了 Open API 3.03 响应对象。架构定义了用于函数响应值的类型。
    property response: TSchema read FResponse write SetResponse;
    // 可选。以 JSON 架构格式描述此函数的输出。架构指定的值是函数的响应值。
    // 此字段与 response 互斥。
    // TDictionary<String, TValue>;
    property responseJsonSchema: TObject read FResponseJsonSchema write SetResponseJsonSchema;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType, Functions.SystemExtended;

{ TFunctionDeclaration }

constructor TFunctionDeclaration.Create();
begin
  inherited Create();
  Self.name := '';
  Self.description := '';
  Self.behavior := GEMINI_BEHAVIOR_UNSPECIFIED;
  Self.FParameters := nil;
  Self.FParametersJsonSchema := nil;
  Self.FParametersJsonSchemaNeedFree := FALSE;
  Self.FResponse := nil;
  Self.FResponseJsonSchema := nil;
  Self.FResponseJsonSchemaNeedFree := FALSE;
end;

destructor TFunctionDeclaration.Destroy();
begin
  if (Self.FResponseJsonSchemaNeedFree) then
    SafeFreeAndNil(Self.FResponseJsonSchema);
  SafeFreeAndNil(Self.FResponse);
  Self.FResponseJsonSchemaNeedFree := FALSE;
  if (Self.FParametersJsonSchemaNeedFree) then
    SafeFreeAndNil(Self.FParametersJsonSchema);
  SafeFreeAndNil(Self.FParameters);
  Self.FParametersJsonSchemaNeedFree := FALSE;
  Self.behavior := '';
  Self.description := '';
  Self.name := '';
  inherited Destroy();
end;

function TFunctionDeclaration.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TFunctionDeclaration.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'parameters') then
  begin
    TParameterReality.CopyWithJson(FParameters, TSchema, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'parametersJsonSchema') then
  begin
    TParameterReality.CloneWithJson(FParametersJsonSchema, FParametersJsonSchemaNeedFree, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'response') then
  begin
    TParameterReality.CopyWithJson(FResponse, TSchema, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'responseJsonSchema') then
  begin
    TParameterReality.CloneWithJson(FResponseJsonSchema, FResponseJsonSchemaNeedFree, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TFunctionDeclaration.SetParameters(const Value: TSchema);
begin
  if (Value <> FParameters) then
    TParameterReality.CopyWithClass(FParameters, Value);
end;

procedure TFunctionDeclaration.SetParametersJsonSchema(const Value: TObject);
begin
  if (Value <> FParametersJsonSchema) then
    TParameterReality.CloneWithClass(FParametersJsonSchema, FParametersJsonSchemaNeedFree, Value);
end;

procedure TFunctionDeclaration.SetResponse(const Value: TSchema);
begin
  if (Value <> FResponse) then
    TParameterReality.CopyWithClass(FResponse, Value);
end;

procedure TFunctionDeclaration.SetResponseJsonSchema(const Value: TObject);
begin
  if (Value <> FResponseJsonSchema) then
    TParameterReality.CloneWithClass(FResponseJsonSchema, FResponseJsonSchemaNeedFree, Value);
end;

end.
