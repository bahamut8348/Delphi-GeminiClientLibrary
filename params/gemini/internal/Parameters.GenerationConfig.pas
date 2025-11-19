unit Parameters.GenerationConfig;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Schema, Parameters.SpeechConfig,
  Parameters.ThinkingConfig, Parameters.ImageConfig;

type
{
  https://ai.google.dev/api/generate-content?hl=zh-cn#generationconfig
  模型生成和输出的配置选项。并非所有模型的全部参数都可以配置。
}
  TGenerationConfig = class(TParameterReality)
  private
    { private declarations }
    F_ResponseJsonSchemaNeedFree: Boolean;
    FResponseJsonSchemaNeedFree: Boolean;

    FStopSequences: TArray<String>;
    FResponseMimeType: String;
    FResponseSchema: TSchema;
    F_ResponseJsonSchema: TObject; // TDictionary<String, TValue>;
    FResponseJsonSchema: TObject; // TDictionary<String, TValue>;
    FResponseModalities: TArray<String>;
    FCandidateCount: Integer;
    FMaxOutputTokens: Integer;
    FTemperature: Double;
    FTopP: Double;
    FTopK: Integer;
    FSeed: Integer;
    FPresencePenalty: Double;
    FFrequencyPenalty: Double;
    FResponseLogprobs: Boolean;
    FLogprobs: Integer;
    FEnableEnhancedCivicAnswers: Boolean;
    FSpeechConfig: TSpeechConfig;
    FThinkingConfig: TThinkingConfig;
    FImageConfig: TImageConfig;
    FMediaResolution: String;

    procedure SetImageConfig(const Value: TImageConfig);
    procedure SetResponseSchema(const Value: TSchema);
    procedure SetSpeechConfig(const Value: TSpeechConfig);
    procedure SetThinkingConfig(const Value: TThinkingConfig);
    procedure Set_ResponseJsonSchema(const Value: TObject);
    procedure SetResponseJsonSchema(const Value: TObject);
    procedure SetResponseModalities(const Value: TArray<String>);
    procedure SetStopSequences(const Value: TArray<String>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。将停止输出生成的字符序列集（最多 5 个）。如果指定，API 将在首次出现 stop_sequence 时停止。停止序列不会包含在回答中。
    property stopSequences: TArray<String> read FStopSequences write SetStopSequences;
    // 可选。生成的候选文本的 MIME 类型。支持的 MIME 类型包括：text/plain：（默认）文本输出。application/json：响应候选项中的 JSON 响应。text/x.enum：响应候选项中以字符串形式表示的 ENUM。如需查看所有受支持的文本 MIME 类型的列表，请参阅文档。
    property responseMimeType: String read FResponseMimeType write FResponseMimeType;
    // 可选。生成的候选文本的输出架构。架构必须是 OpenAPI 架构的子集，并且可以是对象、基元或数组。
    // 如果设置了此字段，还必须设置兼容的 responseMimeType。兼容的 MIME 类型：application/json：JSON 响应的架构。如需了解详情，请参阅 JSON 文本生成指南。
    property responseSchema: TSchema read FResponseSchema write SetResponseSchema;
    // 可选。生成的回答的输出架构。这是 responseSchema 的替代方案，可接受 JSON 架构。
    // 如果设置了此属性，则必须省略 responseSchema，但必须设置 responseMimeType。
    // 虽然可以发送完整的 JSON 架构，但并非所有功能都受支持。具体来说，仅支持以下属性：
    // $id
    // $defs
    // $ref
    // $anchor
    // type
    // format
    // title
    // description
    // enum（适用于字符串和数字）
    // items
    // prefixItems
    // minItems
    // maxItems
    // minimum
    // maximum
    // anyOf
    // oneOf（与 anyOf 的解读方式相同）
    // properties
    // additionalProperties
    // required
    // 还可以设置非标准 propertyOrdering 属性。
    // 循环引用会展开到一定程度，因此只能在非必需属性中使用。（可为 null 的属性不足。）如果子架构中设置了 $ref，则除了以 $ 开头的属性之外，不得设置任何其他属性。
    property _responseJsonSchema: TObject read F_ResponseJsonSchema write Set_ResponseJsonSchema; // TDictionary<String, TValue>;
    // 可选。内部详细信息。请使用 responseJsonSchema ，而不是此字段。
    property responseJsonSchema: TObject read FResponseJsonSchema write SetResponseJsonSchema; // TDictionary<String, TValue>;

    // 可选。所请求的响应模态。表示模型可以返回且应在响应中预期的模态集合。这与回答的模态完全匹配。
    // 一个模型可能支持多种模态组合。如果请求的模态与任何支持的组合都不匹配，则会返回错误。
    // 空列表相当于仅请求文本。
    //
    // 值                               | 说明
    // MODALITY_UNSPECIFIED             | 默认值。
    // TEXT                             | 表示模型应返回文本。
    // IMAGE                            | 表示模型应返回图片。
    // AUDIO                            | 表示模型应返回音频。
    property responseModalities: TArray<String> read FResponseModalities write SetResponseModalities;
    // 可选。要返回的生成响应数量。如果未设置，则默认为 1。请注意，此功能不适用于上一代模型（Gemini 1.0 系列）
    property candidateCount: Integer read FCandidateCount write FCandidateCount;
    // 可选。候选回答中包含的 token 数量上限。
    // 注意：默认值因模型而异，请参阅 getModel 函数返回的 Model 的 Model.output_token_limit 属性。
    property maxOutputTokens: Integer read FMaxOutputTokens write FMaxOutputTokens;
    // 可选。控制输出的随机性。
    // 注意：默认值因模型而异，请参阅 getModel 函数返回的 Model 的 Model.temperature 属性。
    // 值可介于 [0.0, 2.0] 之间。
    property temperature: Double read FTemperature write FTemperature;
    // 可选。抽样时要考虑的 token 的最大累积概率。
    // 该模型使用 Top-k 和 Top-p（核）采样相结合的方式。
    // 系统会根据词元的分配概率对其进行排序，以便仅考虑最有可能的词元。Top-k 抽样直接限制要考虑的 token 的数量上限，而 Nucleus 抽样则根据累积概率限制 token 的数量。
    // 注意：默认值因 Model 而异，由 getModel 函数返回的 Model.top_p 属性指定。如果 topK 属性为空，则表示模型不应用 top-k 抽样，并且不允许在请求中设置 topK。
    property topP: Double read FTopP write FTopP;
    // 可选。抽样时要考虑的令牌数量上限。
    // Gemini 模型使用 Top-p（核）采样或 Top-k 与核采样的组合。Top-k 抽样会考虑 topK 个最有可能的 token。以核采样方式运行的模型不允许进行 topK 设置。
    // 注意：默认值因 Model 而异，由 getModel 函数返回的 Model.top_p 属性指定。如果 topK 属性为空，则表示模型不应用 top-k 抽样，并且不允许在请求中设置 topK。
    property topK: Integer read FTopK write FTopK;
    // 可选。解码中使用的种子。如果未设置，请求将使用随机生成的种子。
    property seed: Integer read FSeed write FSeed;
    // 可选。如果下一个令牌已在响应中出现，则应用于该令牌的 logprobs 的存在惩罚。
    // 此惩罚是二元（开启/关闭）的，不取决于令牌的使用次数（首次使用后）。使用 frequencyPenalty 表示每次使用都会增加的惩罚。
    // 正值惩罚会阻止使用已在回答中使用的令牌，从而增加词汇量。
    // 负惩罚会鼓励使用已在回答中使用的令牌，从而减少词汇量。
    property presencePenalty: Double read FPresencePenalty write FPresencePenalty;
    // 可选。应用于下一个词元的对数概率的频次惩罚，乘以每个词元在目前为止的回答中出现的次数。
    // 正惩罚会抑制对已使用过的 token 的使用，抑制程度与 token 的使用次数成正比：token 的使用次数越多，模型就越难再次使用该 token，从而增加回答的词汇量。
    // 注意：负惩罚会促使模型重复使用 token，重复使用的次数与 token 的使用次数成正比。较小的负值会减少回答的词汇量。负值越大，模型开始重复常见令牌的次数就越多，直到达到 maxOutputTokens 限制。
    property frequencyPenalty: Double read FFrequencyPenalty write FFrequencyPenalty;
    // 可选。如果为 true，则在响应中导出 logprobs 结果。
    property responseLogprobs: Boolean read FResponseLogprobs write FResponseLogprobs;
    // 可选。仅在 responseLogprobs=True 时有效。此参数用于设置在 Candidate.logprobs_result 中每个解码步骤中返回的对数概率最高的数量。该数字必须介于 [0, 20] 之间。
    property logprobs: Integer read FLogprobs write FLogprobs;
    // 可选。启用增强型公民信息回答。此功能可能仅适用于部分型号。
    property enableEnhancedCivicAnswers: Boolean read FEnableEnhancedCivicAnswers write FEnableEnhancedCivicAnswers;
    // 可选。语音生成配置。
    property speechConfig: TSpeechConfig read FSpeechConfig write SetSpeechConfig;
    // 可选。思考功能的配置。如果为不支持思考的模型设置此字段，系统将返回错误。
    property thinkingConfig: TThinkingConfig read FThinkingConfig write SetThinkingConfig;
    // 可选。图片生成配置。如果为不支持这些配置选项的模型设置此字段，系统将返回错误。
    property imageConfig: TImageConfig read FImageConfig write SetImageConfig;
    // 可选。如果指定，则使用指定的媒体分辨率。
    //
    // 值                               | 说明
    // MEDIA_RESOLUTION_UNSPECIFIED     | 媒体分辨率尚未设置。
    // MEDIA_RESOLUTION_LOW             | 媒体分辨率设置为低（64 个 token）。
    // MEDIA_RESOLUTION_MEDIUM          | 媒体分辨率设置为中等（256 个 token）。
    // MEDIA_RESOLUTION_HIGH            | 媒体分辨率设置为高（缩放重构，256 个 token）。
    property mediaResolution: String read FMediaResolution write FMediaResolution;

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

{ TGenerationConfig }

constructor TGenerationConfig.Create();
begin
  inherited Create();
  Self.F_ResponseJsonSchemaNeedFree := FALSE;
  Self.FResponseJsonSchemaNeedFree := FALSE;

  SetLength(Self.FStopSequences, 0);
  Self.FResponseMimeType := '';
  Self.FResponseSchema := nil;
  Self.F_ResponseJsonSchema := nil; // TDictionary<String, TValue>;
  Self.FResponseJsonSchema := nil; // TDictionary<String, TValue>;
  SetLength(Self.FResponseModalities, 0);
  Self.FCandidateCount := 0;
  Self.FMaxOutputTokens := 0;
  Self.FTemperature := 0;
  Self.FTopP := 0;
  Self.FTopK := 0;
  Self.FSeed := 0;
  Self.FPresencePenalty := 0;
  Self.FFrequencyPenalty := 0;
  Self.FResponseLogprobs := FALSE;
  Self.FLogprobs := 0;
  Self.FEnableEnhancedCivicAnswers := FALSE;
  Self.FSpeechConfig := nil;
  Self.FThinkingConfig := nil;
  Self.FImageConfig := nil;
  Self.FMediaResolution := GEMINI_MEDIA_RESOLUTION_UNSPECIFIED;
end;

destructor TGenerationConfig.Destroy();
begin
  Self.FMediaResolution := '';
  SafeFreeAndNil(Self.FImageConfig);
  SafeFreeAndNil(Self.FThinkingConfig);
  SafeFreeAndNil(Self.FSpeechConfig);
  Self.FEnableEnhancedCivicAnswers := FALSE;
  Self.FLogprobs := 0;
  Self.FResponseLogprobs := FALSE;
  Self.FFrequencyPenalty := 0;
  Self.FPresencePenalty := 0;
  Self.FSeed := 0;
  Self.FTopK := 0;
  Self.FTopP := 0;
  Self.FTemperature := 0;
  Self.FMaxOutputTokens := 0;
  Self.FCandidateCount := 0;
  ReleaseStringArray(Self.FResponseModalities);
  if (FResponseJsonSchemaNeedFree) then
    SafeFreeAndNil(Self.FResponseJsonSchema);
  if (F_ResponseJsonSchemaNeedFree) then
    SafeFreeAndNil(Self.F_ResponseJsonSchema);
  SafeFreeAndNil(Self.FResponseSchema);
  Self.FResponseMimeType := '';
  ReleaseStringArray(Self.FStopSequences);

  Self.FResponseJsonSchemaNeedFree := FALSE;
  Self.F_ResponseJsonSchemaNeedFree := FALSE;
  inherited Destroy();
end;

function TGenerationConfig.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TGenerationConfig.SetImageConfig(const Value: TImageConfig);
begin
  if (Value <> FImageConfig) then
    TParameterReality.CopyWithClass(FImageConfig, Value);
end;

function TGenerationConfig.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'stopSequences') then
  begin
    CopyStringArrayWithJson(Self.FStopSequences, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'responseModalities') then
  begin
    CopyStringArrayWithJson(Self.FResponseModalities, pValue);
    Result := TRUE;
  end
  else if SameText(sName, '_responseJsonSchema') then
  begin
    TParameterReality.CloneWithJson(F_ResponseJsonSchema, F_ResponseJsonSchemaNeedFree, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'responseJsonSchema') then
  begin
    TParameterReality.CloneWithJson(FResponseJsonSchema, FResponseJsonSchemaNeedFree, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'responseSchema') then
  begin
    TParameterReality.CopyWithJson(FResponseSchema, TSchema, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'speechConfig') then
  begin
    TParameterReality.CopyWithJson(FSpeechConfig, TSpeechConfig, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'thinkingConfig') then
  begin
    TParameterReality.CopyWithJson(FThinkingConfig, TThinkingConfig, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'imageConfig') then
  begin
    TParameterReality.CopyWithJson(FImageConfig, TImageConfig, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TGenerationConfig.SetResponseJsonSchema(const Value: TObject);
begin
  if (Value <> FResponseJsonSchema) then
    TParameterReality.CloneWithClass(FResponseJsonSchema, FResponseJsonSchemaNeedFree, Value);
end;

procedure TGenerationConfig.SetResponseModalities(const Value: TArray<String>);
begin
  CopyStringArrayWithArray(FResponseModalities, Value);
end;

procedure TGenerationConfig.SetResponseSchema(const Value: TSchema);
begin
  if (Value <> FResponseSchema) then
    TParameterReality.CopyWithClass(FResponseSchema, Value);
end;

procedure TGenerationConfig.SetSpeechConfig(const Value: TSpeechConfig);
begin
  if (Value <> FSpeechConfig) then
    TParameterReality.CopyWithClass(FSpeechConfig, Value);
end;

procedure TGenerationConfig.SetStopSequences(const Value: TArray<String>);
begin
  CopyStringArrayWithArray(FStopSequences, Value);
end;

procedure TGenerationConfig.SetThinkingConfig(const Value: TThinkingConfig);
begin
  if (Value <> FThinkingConfig) then
    TParameterReality.CopyWithClass(FThinkingConfig, Value);
end;

procedure TGenerationConfig.Set_ResponseJsonSchema(const Value: TObject);
begin
  if (Value <> F_ResponseJsonSchema) then
    TParameterReality.CloneWithClass(F_ResponseJsonSchema, F_ResponseJsonSchemaNeedFree, Value);
end;

end.
