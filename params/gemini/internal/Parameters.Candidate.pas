unit Parameters.Candidate;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Content, Parameters.SafetyRating,
  Parameters.CitationMetadata, Parameters.GroundingAttribution,
  Parameters.GroundingMetadata, Parameters.LogprobsResult,
  Parameters.TopCandidates, Parameters.UrlContextMetadata;

type
  TTopCandidates = class;
  TLogprobsResult = class;

{
  https://ai.google.dev/api/generate-content#candidate
  模型生成的回答候选对象。
}
  TCandidate = class(TParameterReality)
  private
    { private declarations }

    FContent: TContent;
    FFinishReason: String;
    FSafetyRatings: TArray<TSafetyRating>;
    FCitationMetadata: TCitationMetadata;
    FTokenCount: Integer;
    FGroundingAttributions: TArray<TGroundingAttribution>;
    FGroundingMetadata: TGroundingMetadata;
    FAvgLogprobs: Double;
    FLogprobsResult: TLogprobsResult;
    FUrlContextMetadata: TUrlContextMetadata;
    FIndex: Integer;
    FFinishMessage: String;

    procedure SetAvgLogprobs(const Value: Double);
    procedure SetCitationMetadata(const Value: TCitationMetadata);
    procedure SetContent(const Value: TContent);
    procedure SetFinishMessage(const Value: String);
    procedure SetFinishReason(const Value: String);
    procedure SetGroundingMetadata(const Value: TGroundingMetadata);
    procedure SetIndex(const Value: Integer);
    procedure SetLogprobsResult(const Value: TLogprobsResult);
    procedure SetTokenCount(const Value: Integer);
    procedure SetUrlContextMetadata(const Value: TUrlContextMetadata);
    procedure SetGroundingAttributions(const Value: TArray<TGroundingAttribution>);
    procedure SetSafetyRatings(const Value: TArray<TSafetyRating>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 仅限输出。模型返回的生成内容。
    property content: TContent read FContent write SetContent;
    // 可选。仅限输出。模型停止生成词元的原因。如果为空，则模型尚未停止生成词元。
    //
    // 值                           | 说明
    // FINISH_REASON_UNSPECIFIED    | 默认值。此值未使用。
    // STOP                         | 模型的自然停止点或提供的停止序列。
    // MAX_TOKENS                   | 已达到请求中指定的 token 数量上限。
    // SAFETY                       | 出于安全原因，系统标记了候选回答内容。
    // RECITATION                   | 回答候选内容因背诵原因而被标记。
    // LANGUAGE                     | 系统标记了候选回答内容，原因是其中使用了不支持的语言。
    // OTHER                        | 原因未知。
    // BLOCKLIST                    | 由于内容包含禁用词，因此 token 生成操作已停止。
    // PROHIBITED_CONTENT           | 由于可能包含禁止的内容，因此 token 生成操作已停止。
    // SPII                         | 由于内容可能包含敏感的个人身份信息 (SPII)，因此 token 生成操作已停止。
    // MALFORMED_FUNCTION_CALL      | 模型生成的函数调用无效。
    // IMAGE_SAFETY                 | 由于生成的图片包含违规内容，因此 token 生成已停止。
    // IMAGE_PROHIBITED_CONTENT     | 图片生成已停止，因为生成的图片包含其他禁止的内容。
    // IMAGE_OTHER                  | 由于其他杂项问题，图片生成已停止。
    // NO_IMAGE                     | 模型本应生成图片，但却未生成任何图片。
    // IMAGE_RECITATION             | 由于存在重复内容，图片生成操作已停止。
    // UNEXPECTED_TOOL_CALL         | 模型生成了工具调用，但请求中未启用任何工具。
    // TOO_MANY_TOOL_CALLS          | 模型连续调用了过多的工具，因此系统退出了执行。
    property finishReason: String read FFinishReason write SetFinishReason;
    // 响应候选项安全性的评分列表。每个类别最多只能有一个评分。
    property safetyRatings: TArray<TSafetyRating> read FSafetyRatings write SetSafetyRatings;
    // 仅限输出。模型生成的候选回答的引用信息。此字段可能会填充 content 中包含的任何文本的朗读信息。这些内容是从基础 LLM 的训练数据中的受版权保护的材料“背诵”出来的。
    property citationMetadata: TCitationMetadata read FCitationMetadata write SetCitationMetadata;
    // 仅限输出。相应候选对象的令牌数量。
    property tokenCount: Integer read FTokenCount write SetTokenCount;
    // 仅限输出。为有依据的答案做出贡献的来源的提供方信息。系统会针对 GenerateAnswer 调用填充此字段。
    property groundingAttributions: TArray<TGroundingAttribution> read FGroundingAttributions write SetGroundingAttributions;
    // 仅限输出。候选对象的 grounding 元数据。系统会针对 GenerateContent 调用填充此字段。
    property groundingMetadata: TGroundingMetadata read FGroundingMetadata write SetGroundingMetadata;
    // 仅限输出。候选者的平均对数概率得分。
    property avgLogprobs: Double read FAvgLogprobs write SetAvgLogprobs;
    // 仅限输出。回答 token 和热门 token 的对数似然得分
    property logprobsResult: TLogprobsResult read FLogprobsResult write SetLogprobsResult;
    // 仅限输出。与网址上下文检索工具相关的元数据。
    property urlContextMetadata: TUrlContextMetadata read FUrlContextMetadata write SetUrlContextMetadata;
    // 仅限输出。响应候选列表中的候选索引。
    property index: Integer read FIndex write SetIndex;
    // 可选。仅限输出。详细说明了模型停止生成词元的原因。仅当设置了 finishReason 时，系统才会填充此字段。
    property finishMessage: String read FFinishMessage write SetFinishMessage;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

{
  https://ai.google.dev/api/generate-content#TopCandidates
  每个解码步骤中具有最高对数概率的候选对象。
}
  TTopCandidates = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 按对数概率降序排序。
    candidates: TArray<TCandidate>;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

{
  https://ai.google.dev/api/generate-content#LogprobsResult
  Logprobs 结果
}
  TLogprobsResult = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 长度 = 解码步总数。
    topCandidates: TArray<TTopCandidates>;
    // 长度 = 解码步总数。所选候选词元可能位于 topCandidates 中，也可能不在其中。
    chosenCandidates: TArray<TCandidate>;
    // 所有 token 的对数概率之和。
    logProbabilitySum: Double;
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

{ TCandidate }

constructor TCandidate.Create();
begin
  inherited Create();
  Self.FContent := nil;
  Self.FFinishReason := '';
  SetLength(Self.FSafetyRatings, 0);
  Self.FCitationMetadata := nil;
  Self.FTokenCount := 0;
  SetLength(Self.FGroundingAttributions, 0);
  Self.FGroundingMetadata := nil;
  Self.FAvgLogprobs := 0;
  Self.FLogprobsResult := nil;
  Self.FUrlContextMetadata := nil;
  Self.FIndex := 0;
  Self.FFinishMessage := '';
end;

destructor TCandidate.Destroy();
begin
  Self.FFinishMessage := '';
  Self.FIndex := 0;
  SafeFreeAndNil(Self.FUrlContextMetadata);
  SafeFreeAndNil(Self.FLogprobsResult);
  Self.FAvgLogprobs := 0;
  SafeFreeAndNil(Self.FGroundingMetadata);
  TParameterReality.ReleaseArray<TGroundingAttribution>(Self.FGroundingAttributions);
  Self.FTokenCount := 0;
  SafeFreeAndNil(Self.FCitationMetadata);
  TParameterReality.ReleaseArray<TSafetyRating>(Self.FSafetyRatings);
  Self.FFinishReason := '';
  SafeFreeAndNil(Self.FContent);
  inherited Destroy();
end;

function TCandidate.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TCandidate.SetAvgLogprobs(const Value: Double);
begin
  FAvgLogprobs := Value;
end;

procedure TCandidate.SetCitationMetadata(const Value: TCitationMetadata);
begin
  if (Value <> FCitationMetadata) then
    TParameterReality.CopyWithClass(FCitationMetadata, Value);
end;

procedure TCandidate.SetContent(const Value: TContent);
begin
  if (Value <> FContent) then
    TParameterReality.CopyWithClass(FContent, Value);
end;

procedure TCandidate.SetFinishMessage(const Value: String);
begin
  FFinishMessage := Value;
end;

procedure TCandidate.SetFinishReason(const Value: String);
begin
  FFinishReason := Value;
end;

procedure TCandidate.SetGroundingAttributions(const Value: TArray<TGroundingAttribution>);
begin
  TParameterReality.CopyArrayWithClass<TGroundingAttribution>(FGroundingAttributions, Value);
end;

procedure TCandidate.SetGroundingMetadata(const Value: TGroundingMetadata);
begin
  if (Value <> FGroundingMetadata) then
    TParameterReality.CopyWithClass(FGroundingMetadata, Value);
end;

procedure TCandidate.SetIndex(const Value: Integer);
begin
  FIndex := Value;
end;

procedure TCandidate.SetLogprobsResult(const Value: TLogprobsResult);
begin
  if (Value <> FLogprobsResult) then
    TParameterReality.CopyWithClass(FLogprobsResult, Value);
end;

function TCandidate.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'safetyRatings') then
  begin
    TParameterReality.CopyArrayWithJson<TSafetyRating>(Self.FSafetyRatings, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'groundingAttributions') then
  begin
    TParameterReality.CopyArrayWithJson<TGroundingAttribution>(Self.FGroundingAttributions, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'content') then
  begin
    TParameterReality.CopyWithJson(Self.FContent, TContent, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'citationMetadata') then
  begin
    TParameterReality.CopyWithJson(Self.FCitationMetadata, TCitationMetadata, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'groundingMetadata') then
  begin
    TParameterReality.CopyWithJson(Self.FGroundingMetadata, TGroundingMetadata, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'logprobsResult') then
  begin
    TParameterReality.CopyWithJson(Self.FLogprobsResult, TLogprobsResult, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'urlContextMetadata') then
  begin
    TParameterReality.CopyWithJson(Self.FUrlContextMetadata, TUrlContextMetadata, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TCandidate.SetSafetyRatings(const Value: TArray<TSafetyRating>);
begin
  TParameterReality.CopyArrayWithClass<TSafetyRating>(FSafetyRatings, Value);
end;

procedure TCandidate.SetTokenCount(const Value: Integer);
begin
  FTokenCount := Value;
end;

procedure TCandidate.SetUrlContextMetadata(const Value: TUrlContextMetadata);
begin
  if (Value <> FUrlContextMetadata) then
    TParameterReality.CopyWithClass(FUrlContextMetadata, Value);
end;

{ TLogprobsResult }

constructor TLogprobsResult.Create();
begin
  inherited Create();
  SetLength(Self.topCandidates, 0);
  SetLength(Self.chosenCandidates, 0);
  Self.logProbabilitySum := 0;
end;

destructor TLogprobsResult.Destroy();
begin
  Self.logProbabilitySum := 0;
  TParameterReality.ReleaseArray<TCandidate>(Self.chosenCandidates);
  TParameterReality.ReleaseArray<TTopCandidates>(Self.topCandidates);
  inherited Destroy();
end;

function TLogprobsResult.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TLogprobsResult.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'topCandidates') then
  begin
    TParameterReality.CopyArrayWithJson<TTopCandidates>(Self.topCandidates, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'chosenCandidates') then
  begin
    TParameterReality.CopyArrayWithJson<TCandidate>(Self.chosenCandidates, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

{ TTopCandidates }

constructor TTopCandidates.Create();
begin
  inherited Create();
  SetLength(Self.candidates, 0);
end;

destructor TTopCandidates.Destroy();
begin
  TParameterReality.ReleaseArray<TCandidate>(Self.candidates);
  inherited Destroy();
end;

function TTopCandidates.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TTopCandidates.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'candidates') then
  begin
    TParameterReality.CopyArrayWithJson<TCandidate>(Self.candidates, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
