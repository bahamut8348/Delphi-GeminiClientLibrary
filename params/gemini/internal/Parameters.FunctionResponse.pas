unit Parameters.FunctionResponse;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.FunctionResponsePart;

type
{
  https://ai.google.dev/api/caching#FunctionResponse
  FunctionCall 的结果输出（其中包含表示 FunctionDeclaration.name 的字符串和包含函数任何输出的结构化 JSON 对象）用作模型的上下文。这应包含根据模型预测生成的 FunctionCall 的结果。
}
  TFunctionResponse = class(TParameterReality)
  private
    { private declarations }
    FResponseNeedFree: Boolean;
    FId: String;
    FName: String;
    FResponse: TObject;
    FParts: TArray<TFunctionResponsePart>;
    FWillContinue: Boolean;
    FScheduling: String;
    procedure SetResponse(const Value: TObject);
    procedure SetParts(const Value: TArray<TFunctionResponsePart>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。相应函数调用的 ID。由客户端填充，以匹配相应的函数调用 id。
    property id: String read FId write FId;
    // 必需。要调用的函数名称。必须是 a-z、A-Z、0-9 或包含下划线和短划线，长度上限为 64。
    property name: String read FName write FName;
    // 必需。以 JSON 对象格式表示的函数响应。调用者可以使用符合函数语法的任意键来返回函数输出，例如“output”“result”等。特别是，如果函数调用未能成功执行，响应可以包含“error”键，以便向模型返回错误详情。
    property response: TObject read FResponse write SetResponse; // TDictionary<String, TValue>;

    // 可选。构成函数响应的有序 Parts。各部分可能具有不同的 IANA MIME 类型。
    property parts: TArray<TFunctionResponsePart> read FParts write SetParts;
    // 可选。表示函数调用继续，并且将返回更多响应，从而将函数调用转换为生成器。仅适用于非阻塞函数调用，否则会被忽略。如果设置为 false，则不会考虑未来的回答。允许返回带有 willContinue=False 的空 response，以表明函数调用已完成。这可能仍会触发模型生成。为避免触发生成并完成函数调用，请额外将 scheduling 设置为 SILENT。
    property willContinue: Boolean read FWillContinue write FWillContinue;
    // 可选。指定在对话中如何安排回答。仅适用于 NON_BLOCKING 函数调用，否则会被忽略。默认为 WHEN_IDLE。
    //
    // 值                       | 说明
    // SCHEDULING_UNSPECIFIED   | 此值未使用。
    // SILENT                   | 仅将结果添加到对话上下文中，不中断或触发生成。
    // WHEN_IDLE	              | 将结果添加到对话上下文，并提示生成输出，而不会中断正在进行的生成。
    // INTERRUPT	              | 将结果添加到对话上下文，中断正在进行的生成操作，并提示生成输出。
    property scheduling: String read FScheduling write FScheduling;
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

{ TFunctionResponse }

constructor TFunctionResponse.Create();
begin
  inherited Create();
  Self.FResponseNeedFree := FALSE;

  Self.FId := '';
  Self.FName := '';
  Self.FResponse := nil;
  SetLength(Self.FParts, 0);
  Self.FWillContinue := FALSE;
  Self.FScheduling := GEMINI_SCHEDULING_WHEN_IDLE;
end;

destructor TFunctionResponse.Destroy();
begin
  Self.FScheduling := '';
  Self.FWillContinue := FALSE;
  TParameterReality.ReleaseArray<TFunctionResponsePart>(Self.FParts);
  if (Self.FResponseNeedFree) then
    SafeFreeAndNil(Self.FResponse);
   Self.FName := '';
  Self.FId := '';

  Self.FResponseNeedFree := FALSE;
  inherited Destroy();
end;

function TFunctionResponse.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TFunctionResponse.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'parts') then
  begin
    TParameterReality.CopyArrayWithJson<TFunctionResponsePart>(Self.FParts, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'response') then
  begin
    // response为一个未定义的 json 类型，这里直接保存源 json 对象的副本，这样才能在调用 tojson 时被正确转换。
    TParameterReality.CloneWithJson(FResponse, FResponseNeedFree, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TFunctionResponse.SetParts(
  const Value: TArray<TFunctionResponsePart>);
begin
  TParameterReality.CopyArrayWithClass<TFunctionResponsePart>(FParts, Value);
end;

procedure TFunctionResponse.SetResponse(const Value: TObject);
begin
  if (Value <> FResponse) then
    TParameterReality.CloneWithClass(FResponse, FResponseNeedFree, Value);
end;

end.
