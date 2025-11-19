unit Parameters.GenerateContentBatchRequest;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Content, Parameters.Tool,
  Parameters.ToolConfig, Parameters.SafetySetting, Parameters.GenerationConfig;

type
{
  https://ai.google.dev/api/batch-api#GenerateContentRequest
  请求模型生成补全内容。
}
  TGenerateContentBatchRequest = class(TParameterReality)
  private
    { private declarations }
    FModel: String;
    FContents: TArray<TContent>;
    FTools: TArray<TTool>;
    FToolConfig: TToolConfig;
    FSafetySettings: TArray<TSafetySetting>;
    FSystemInstruction: TContent;
    FGenerationConfig: TGenerationConfig;
    FCachedContent: String;

    procedure SetCachedContent(const Value: String);
    procedure SetGenerationConfig(const Value: TGenerationConfig);
    procedure SetSystemInstruction(const Value: TContent);
    procedure SetToolConfig(const Value: TToolConfig);
    procedure SetContents(const Value: TArray<TContent>);
    procedure SetSafetySettings(const Value: TArray<TSafetySetting>);
    procedure SetTools(const Value: TArray<TTool>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。用于生成补全的 Model 的名称。
    // 格式：models/{model}。
    property model: String read FModel write FModel;
    // 必需。与模型当前对话的内容。
    // 对于单轮查询，这是单个实例。对于多轮查询（例如聊天），这是包含对话历史记录和最新请求的重复字段。
    property contents: TArray<TContent> read FContents write SetContents;
    // 可选。Model 可能用于生成下一个回答的 Tools 列表。
    // Tool 是一段代码，可让系统与外部系统进行交互，以在 Model 的知识和范围之外执行操作或一组操作。支持的 Tool 为 Function 和 codeExecution。如需了解详情，请参阅函数调用和代码执行指南。
    property tools: TArray<TTool> read FTools write SetTools;
    // 可选。请求中指定的任何 Tool 的工具配置。如需查看使用示例，请参阅函数调用指南。
    property toolConfig: TToolConfig read FToolConfig write SetToolConfig;
    // 可选。用于屏蔽不安全内容的唯一 SafetySetting 实例的列表。
    // 此限制将在 GenerateContentRequest.contents 和 GenerateContentResponse.candidates 上强制执行。每种 SafetyCategory 类型不应有多个设置。API 会屏蔽任何不符合这些设置所设阈值的内容和响应。此列表会替换 safetySettings 中指定的每个 SafetyCategory 的默认设置。如果列表中未提供指定 SafetyCategory 的 SafetySetting，API 将使用相应类别的默认安全设置。支持的危害类别包括 HARM_CATEGORY_HATE_SPEECH、HARM_CATEGORY_SEXUALLY_EXPLICIT、HARM_CATEGORY_DANGEROUS_CONTENT、HARM_CATEGORY_HARASSMENT、HARM_CATEGORY_CIVIC_INTEGRITY。如需详细了解可用的安全设置，请参阅指南。您还可以参阅安全指南，了解如何在 AI 应用中纳入安全考虑因素。
    property safetySettings: TArray<TSafetySetting> read FSafetySettings write SetSafetySettings;
    // 可选。开发者设置了系统指令。目前仅支持文本。
    property systemInstruction: TContent read FSystemInstruction write SetSystemInstruction;
    // 可选。模型生成和输出的配置选项。
    property generationConfig: TGenerationConfig read FGenerationConfig write SetGenerationConfig;
    // 可选。用作提供预测的上下文的缓存内容的名称。
    // 格式：cachedContents/{cachedContent}
    property cachedContent: String read FCachedContent write SetCachedContent;

  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TGenerateContentBatchRequest }

constructor TGenerateContentBatchRequest.Create();
begin
  inherited Create();
  Self.FModel := '';
  SetLength(Self.FContents, 0);
  SetLength(Self.FTools, 0);
  Self.FToolConfig := nil;
  SetLength(Self.FSafetySettings, 0);
  Self.FSystemInstruction := nil;
  Self.FGenerationConfig := nil;
  Self.FCachedContent := '';
end;

destructor TGenerateContentBatchRequest.Destroy();
begin
  Self.FCachedContent := '';
  SafeFreeAndNil(Self.FGenerationConfig);
  SafeFreeAndNil(Self.FSystemInstruction);
  TParameterReality.ReleaseArray<TSafetySetting>(Self.FSafetySettings);
  SafeFreeAndNil(Self.FToolConfig);
  TParameterReality.ReleaseArray<TTool>(Self.FTools);
  TParameterReality.ReleaseArray<TContent>(Self.FContents);
  Self.FModel := '';
  inherited Destroy();
end;

function TGenerateContentBatchRequest.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TGenerateContentBatchRequest.SetCachedContent(const Value: String);
begin
  FCachedContent := Value;
end;

procedure TGenerateContentBatchRequest.SetContents(
  const Value: TArray<TContent>);
begin
  TParameterReality.CopyArrayWithClass<TContent>(FContents, Value);
end;

procedure TGenerateContentBatchRequest.SetGenerationConfig(
  const Value: TGenerationConfig);
begin
  if (Value <> FGenerationConfig) then
    TParameterReality.CopyWithClass(FGenerationConfig, Value);
end;

function TGenerateContentBatchRequest.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'contents') then
  begin
    TParameterReality.CopyArrayWithJson<TContent>(Self.FContents, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'tools') then
  begin
    TParameterReality.CopyArrayWithJson<TTool>(Self.FTools, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'safetySettings') then
  begin
    TParameterReality.CopyArrayWithJson<TSafetySetting>(Self.FSafetySettings, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'toolConfig') then
  begin
    TParameterReality.CopyWithJson(FToolConfig, TToolConfig, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'systemInstruction') then
  begin
    TParameterReality.CopyWithJson(FSystemInstruction, TContent, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'generationConfig') then
  begin
    TParameterReality.CopyWithJson(FGenerationConfig, TGenerationConfig, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TGenerateContentBatchRequest.SetSafetySettings(
  const Value: TArray<TSafetySetting>);
begin
  TParameterReality.CopyArrayWithClass<TSafetySetting>(FSafetySettings, Value);
end;

procedure TGenerateContentBatchRequest.SetSystemInstruction(
  const Value: TContent);
begin
  if (Value <> FSystemInstruction) then
    TParameterReality.CopyWithClass(FSystemInstruction, Value);
end;

procedure TGenerateContentBatchRequest.SetToolConfig(const Value: TToolConfig);
begin
  if (Value <> FToolConfig) then
    TParameterReality.CopyWithClass(FToolConfig, Value);
end;

procedure TGenerateContentBatchRequest.SetTools(const Value: TArray<TTool>);
begin
  TParameterReality.CopyArrayWithClass<TTool>(FTools, Value);
end;

end.
