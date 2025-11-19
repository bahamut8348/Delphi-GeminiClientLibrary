unit Parameters.Part;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Blob, Parameters.FunctionCall,
  Parameters.FunctionResponse, Parameters.FileData, Parameters.ExecutableCode,
  Parameters.CodeExecutionResult, Parameters.VideoMetadata;

type
{
  https://ai.google.dev/api/caching#Part
  一种数据类型，包含属于多部分 Content 消息一部分的媒体。
  Part 由具有关联数据类型的数据组成。Part 只能包含 Part.data 中接受的类型之一。
  如果 inlineData 字段填充了原始字节，则 Part 必须具有固定的 IANA MIME 类型，用于标识媒体的类型和子类型。
}
  TPart = class(TParameterReality)
  private
    { private declarations }

    // 联合字段的序号，data 只允许存在一种值，如果全部都赋值发送给接口会返回错误。
    FUnionProperty: (upText, upInlineData, upFunctionCall, upFunctionResponse, upFileData, upExecutableCode, upCodeExecutionResult, upOther);
    // FPartMetadata 是否需要释放，当外部赋值以后将不再在实例销毁时调用释放函数释放该实例变量
    FPartMetadataNeedFree: Boolean;

    // 可选。表示相应部分是否由模型生成。
    FThought: Boolean;
    // 可选。一种不透明的思路签名，以便在后续请求中重复使用。使用 base64 编码的字符串。
    FThoughtSignature: String;
    // 与部件关联的自定义元数据。使用 genai.Part 作为内容表示形式的代理可能需要跟踪其他信息。例如，它可以是 Part 的来源文件/源的名称，也可以是多路复用多个 Part 流的方式。
    FPartMetadata: TObject; // TDictionary<String, TValue>;

    { Union type data start }
    // data 只能是下列其中一项：
    // 内嵌文本。
    FText: String;
    // 内嵌媒体字节。
    FInlineData: TBlob;
    // 从模型返回的预测 FunctionCall，其中包含表示 FunctionDeclaration.name（包含实参及其值）的字符串。
    FFunctionCall: TFunctionCall;
    // FunctionCall 的结果输出，其中包含表示 FunctionDeclaration.name 的字符串和包含函数调用的任何输出的结构化 JSON 对象，用作模型的上下文。
    FFunctionResponse: TFunctionResponse;
    // 基于 URI 的数据。
    FFileData: TFileData;
    // 模型生成的旨在执行的代码。
    FExecutableCode: TExecutableCode;
    // 执行 ExecutableCode 的结果。
    FCodeExecutionResult: TCodeExecutionResult;
    { Union type data end }

    { Union type metadata start }
    // 控制数据的额外预处理。metadata 只能是下列其中一项：
    // 可选。视频元数据。仅当视频数据以 inlineData 或 fileData 形式呈现时，才应指定元数据。
    FVideoMetadata: TVideoMetadata;
    { Union type metadata end }


    procedure SetCodeExecutionResult(const Value: TCodeExecutionResult);
    procedure SetExecutableCode(const Value: TExecutableCode);
    procedure SetFileData(const Value: TFileData);
    procedure SetFunctionCall(const Value: TFunctionCall);
    procedure SetFunctionResponse(const Value: TFunctionResponse);
    procedure SetInlineData(const Value: TBlob);
    procedure SetPartMetadata(const Value: TObject);
    procedure SetText(const Value: String);
    procedure SetThought(const Value: Boolean);
    procedure SetThoughtSignature(const Value: String);
    procedure SetVideoMetadata(const Value: TVideoMetadata);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。表示相应部分是否由模型生成。
    property thought: Boolean read FThought write SetThought;
    // 可选。一种不透明的思路签名，以便在后续请求中重复使用。使用 base64 编码的字符串。
    property thoughtSignature: String read FThoughtSignature write SetThoughtSignature;
    // 与部件关联的自定义元数据。使用 genai.Part 作为内容表示形式的代理可能需要跟踪其他信息。例如，它可以是 Part 的来源文件/源的名称，也可以是多路复用多个 Part 流的方式。
    property partMetadata: TObject read FPartMetadata write SetPartMetadata; // TDictionary<String, TValue>;

    { Union type data start }
    // data 只能是下列其中一项：
    // 内嵌文本。
    property text: String read FText write SetText;
    // 内嵌媒体字节。
    property inlineData: TBlob read FInlineData write SetInlineData;
    // 从模型返回的预测 FunctionCall，其中包含表示 FunctionDeclaration.name（包含实参及其值）的字符串。
    property functionCall: TFunctionCall read FFunctionCall write SetFunctionCall;
    // FunctionCall 的结果输出，其中包含表示 FunctionDeclaration.name 的字符串和包含函数调用的任何输出的结构化 JSON 对象，用作模型的上下文。
    property functionResponse: TFunctionResponse read FFunctionResponse write SetFunctionResponse;
    // 基于 URI 的数据。
    property fileData: TFileData read FFileData write SetFileData;
    // 模型生成的旨在执行的代码。
    property executableCode: TExecutableCode read FExecutableCode write SetExecutableCode;
    // 执行 ExecutableCode 的结果。
    property codeExecutionResult: TCodeExecutionResult read FCodeExecutionResult write SetCodeExecutionResult;
    { Union type data end }

    { Union type metadata start }
    // 控制数据的额外预处理。metadata 只能是下列其中一项：
    // 可选。视频元数据。仅当视频数据以 inlineData 或 fileData 形式呈现时，才应指定元数据。
    property videoMetadata: TVideoMetadata read FVideoMetadata write SetVideoMetadata;
    { Union type metadata end }
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    // =======
    class function CreateWith(const szText: String): TPart; overload; inline; static;
    class function CreateWith(const pInlineData: TBlob): TPart; overload; inline; static;
    class function CreateWith(const pFunctionCall: TFunctionCall): TPart; overload; inline; static;
    class function CreateWith(const pFunctionResponse: TFunctionResponse): TPart; overload; inline; static;
    class function CreateWith(const pFileData: TFileData): TPart; overload; inline; static;
    class function CreateWith(const pExecutableCode: TExecutableCode): TPart; overload; inline; static;
    class function CreateWith(const pCodeExecutionResult: TCodeExecutionResult): TPart; overload; inline; static;
    class function CreateWith(const pPart: TPart): TPart; overload; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TPart }

constructor TPart.Create();
begin
  inherited Create();
  Self.FUnionProperty := upText; // 默认 Text 属性有效
  Self.FPartMetadataNeedFree := FALSE; // 默认无需释放
  Self.FThought := FALSE;
  Self.FThoughtSignature := '';
  Self.FPartMetadata := nil;

  { Union type data start }
  Self.FText := '';
  Self.FInlineData := nil;
  Self.FFunctionCall := nil;
  Self.FFunctionResponse := nil;
  Self.FFileData := nil;
  Self.FExecutableCode := nil;
  Self.FCodeExecutionResult := nil;
  { Union type data end }

  { Union type metadata start }
  Self.FVideoMetadata := nil;
  { Union type metadata end }
end;

class function TPart.CreateWith(const pFunctionCall: TFunctionCall): TPart;
begin
  Result := TPart.Create();
  Result.functionCall.Assign(pFunctionCall);
end;

class function TPart.CreateWith(const pInlineData: TBlob): TPart;
begin
  Result := TPart.Create();
  Result.inlineData.Assign(pInlineData);
end;

class function TPart.CreateWith(const szText: String): TPart;
begin
  Result := TPart.Create();
  Result.text := szText;
end;

class function TPart.CreateWith(
  const pFunctionResponse: TFunctionResponse): TPart;
begin
  Result := TPart.Create();
  Result.functionResponse.Assign(pFunctionResponse);
end;

class function TPart.CreateWith(
  const pCodeExecutionResult: TCodeExecutionResult): TPart;
begin
  Result := TPart.Create();
  Result.codeExecutionResult.Assign(pCodeExecutionResult);
end;

class function TPart.CreateWith(const pExecutableCode: TExecutableCode): TPart;
begin
  Result := TPart.Create();
  Result.executableCode.Assign(pExecutableCode);
end;

class function TPart.CreateWith(const pFileData: TFileData): TPart;
begin
  Result := TPart.Create();
  Result.fileData.Assign(pFileData);
end;

class function TPart.CreateWith(const pPart: TPart): TPart;
begin
  if (nil = pPart) then
    Exit(nil);

  Result := TPart.Create();
  Result.Assign(pPart);
end;

destructor TPart.Destroy();
begin
  { Union type metadata start }
  SafeFreeAndNil(Self.FVideoMetadata);
  { Union type metadata end }

  { Union type data start }
  SafeFreeAndNil(Self.FCodeExecutionResult);
  SafeFreeAndNil(Self.FExecutableCode);
  SafeFreeAndNil(Self.FFileData);
  SafeFreeAndNil(Self.FFunctionResponse);
  SafeFreeAndNil(Self.FFunctionCall);
  SafeFreeAndNil(Self.FInlineData);
  Self.FText := '';
  { Union type data end }

  Self.FThoughtSignature := '';
  if Self.FPartMetadataNeedFree then
    SafeFreeAndNil(Self.FPartMetadata);
  Self.FThought := FALSE;

  Self.FPartMetadataNeedFree := FALSE;
  Self.FUnionProperty := upOther;
  inherited Destroy();
end;

function TPart.GetMemberValue(var sName: String; out pValue: TValue): Boolean;
begin
  // 判断联合属性之中成员是否有效
  if SameText(sName, 'text') then
  begin
    if (FUnionProperty in [upText, upOther]) then
      pValue := TValue.From(Self.FText)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'inlineData') then
  begin
    if (FUnionProperty = upInlineData) then
      pValue := TValue.From(Self.FInlineData)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'functionCall') then
  begin
    if (FUnionProperty = upFunctionCall) then
      pValue := TValue.From(Self.FFunctionCall)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'functionResponse') then
  begin
    if (FUnionProperty = upFunctionResponse) then
      pValue := TValue.From(Self.FFunctionResponse)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'fileData') then
  begin
    if (FUnionProperty = upFileData) then
      pValue := TValue.From(Self.FFileData)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'executableCode') then
  begin
    if (FUnionProperty = upExecutableCode) then
      pValue := TValue.From(Self.FExecutableCode)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'codeExecutionResult') then
  begin
    if (FUnionProperty = upCodeExecutionResult) then
      pValue := TValue.From(Self.FCodeExecutionResult)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'thought') then
  begin
    if Self.FThought then
      pValue := TValue.From(Self.FThought)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'thoughtSignature') then
  begin
    if ('' = Self.FThoughtSignature) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(Self.FThoughtSignature);

    Result := TRUE;
  end
  else if SameText(sName, 'partMetadata') then
  begin
    if (nil = Self.FPartMetadata) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(Self.FPartMetadata);

    Result := TRUE;
  end
  else if SameText(sName, 'videoMetadata') then
  begin
    if (nil = Self.FVideoMetadata) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(Self.FVideoMetadata);

    Result := TRUE;
  end
  else
    Result := inherited GetMemberValue(sName, pValue);
end;

procedure TPart.SetCodeExecutionResult(const Value: TCodeExecutionResult);
begin
  FUnionProperty := upCodeExecutionResult; // CodeExecutionResult 属性有效
  if (Value <> FCodeExecutionResult) then
    TParameterReality.CopyWithClass(FCodeExecutionResult, Value);
end;

procedure TPart.SetExecutableCode(const Value: TExecutableCode);
begin
  FUnionProperty := upExecutableCode; // ExecutableCode 属性有效
  if (Value <> FExecutableCode) then
    TParameterReality.CopyWithClass(FExecutableCode, Value);
end;

procedure TPart.SetFileData(const Value: TFileData);
begin
  FUnionProperty := upFileData; // FileData 属性有效
  if (Value <> FFileData) then
    TParameterReality.CopyWithClass(FFileData, Value);
end;

procedure TPart.SetFunctionCall(const Value: TFunctionCall);
begin
  FUnionProperty := upFunctionCall; // FunctionCall 属性有效
  if (Value <> FFunctionCall) then
    TParameterReality.CopyWithClass(FFunctionCall, Value);
end;

procedure TPart.SetFunctionResponse(const Value: TFunctionResponse);
begin
  FUnionProperty := upFunctionResponse; // FunctionResponse 属性有效
  if (Value <> FFunctionResponse) then
    TParameterReality.CopyWithClass(FFunctionResponse, Value);
end;

procedure TPart.SetInlineData(const Value: TBlob);
begin
  FUnionProperty := upInlineData; // InlineData 属性有效
  if (Value <> FInlineData) then
    TParameterReality.CopyWithClass(FInlineData, Value);
end;

function TPart.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'partMetadata') then
  begin
    TParameterReality.CloneWithJson(FPartMetadata, FPartMetadataNeedFree, pValue);
    Result := TRUE;
  end
  else if (SameText(sName, 'text')) then
  begin
    FUnionProperty := upText;
    FText := GetJsonStringValue(pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'inlineData') then
  begin
    FUnionProperty := upInlineData;
    TParameterReality.CopyWithJson(FInlineData, TBlob, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'functionCall') then
  begin
    FUnionProperty := upFunctionCall;
    TParameterReality.CopyWithJson(FFunctionCall, TFunctionCall, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'functionResponse') then
  begin
    FUnionProperty := upFunctionResponse;
    TParameterReality.CopyWithJson(FFunctionResponse, TFunctionResponse, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'fileData') then
  begin
    FUnionProperty := upFileData;
    TParameterReality.CopyWithJson(FFileData, TFileData, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'executableCode') then
  begin
    FUnionProperty := upExecutableCode;
    TParameterReality.CopyWithJson(FExecutableCode, TExecutableCode, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'codeExecutionResult') then
  begin
    FUnionProperty := upCodeExecutionResult;
    TParameterReality.CopyWithJson(FCodeExecutionResult, TCodeExecutionResult, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'videoMetadata') then
  begin
    TParameterReality.CopyWithJson(FVideoMetadata, TVideoMetadata, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TPart.SetPartMetadata(const Value: TObject);
begin
  if (Value <> FPartMetadata) then
    TParameterReality.CloneWithClass(FPartMetadata, FPartMetadataNeedFree, Value);
end;

procedure TPart.SetText(const Value: String);
begin
  FUnionProperty := upText; // Text 属性有效
  FText := Value;
end;

procedure TPart.SetThought(const Value: Boolean);
begin
  FThought := Value;
end;

procedure TPart.SetThoughtSignature(const Value: String);
begin
  FThoughtSignature := Value;
end;

procedure TPart.SetVideoMetadata(const Value: TVideoMetadata);
begin
  if (Value <> FVideoMetadata) then
    TParameterReality.CopyWithClass(FVideoMetadata, Value);
end;

end.
