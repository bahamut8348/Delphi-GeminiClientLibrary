unit Parameters.UsageMetadata;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.ModalityTokenCount;

type
{
  https://ai.google.dev/api/generate-content#UsageMetadata
  https://ai.google.dev/api/caching#UsageMetadata
  生成请求的令牌使用情况的相关元数据。
}
  TUsageMetadata = class(TParameterReality)
  private
    { private declarations }
    // 提示中的 token 数量。设置 cachedContent 后，这仍然是有效提示的总大小，这意味着它包含缓存内容中的词元数。
    FPromptTokenCount: Integer;
    // 提示的缓存部分（即缓存的内容）中的 token 数量
    FCachedContentTokenCount: Integer;
    // 所有生成的回答候选词元总数。
    FCandidatesTokenCount: Integer;
    // 仅限输出。工具使用提示中的 token 数量。
    FToolUsePromptTokenCount: Integer;
    // 仅限输出。思考模型的思考 token 数。
    FThoughtsTokenCount: Integer;
    // 生成请求（提示 + 候选回答）的总 token 数。
    // 或
    // 缓存内容消耗的 token 总数。【在 https://ai.google.dev/api/caching#UsageMetadata 页面内的定义只有 totalTokenCount 一个属性。】
    FTotalTokenCount: Integer;
    // 仅限输出。请求输入中处理的模态列表。
    FPromptTokensDetails: TArray<TModalityTokenCount>;
    // 仅限输出。请求输入中缓存内容的模态列表。
    FCacheTokensDetails: TArray<TModalityTokenCount>;
    // 仅限输出。响应中返回的模态列表。
    FCandidatesTokensDetails: TArray<TModalityTokenCount>;
    // 仅限输出。为工具使用请求输入处理的模态列表。
    FToolUsePromptTokensDetails: TArray<TModalityTokenCount>;
    procedure SetCacheTokensDetails(const Value: TArray<TModalityTokenCount>);
    procedure SetCandidatesTokensDetails(
      const Value: TArray<TModalityTokenCount>);
    procedure SetPromptTokensDetails(const Value: TArray<TModalityTokenCount>);
    procedure SetToolUsePromptTokensDetails(
      const Value: TArray<TModalityTokenCount>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 提示中的 token 数量。设置 cachedContent 后，这仍然是有效提示的总大小，这意味着它包含缓存内容中的词元数。
    property promptTokenCount: Integer read FPromptTokenCount write FPromptTokenCount;
    // 提示的缓存部分（即缓存的内容）中的 token 数量
    property cachedContentTokenCount: Integer read FCachedContentTokenCount write FCachedContentTokenCount;
    // 所有生成的回答候选词元总数。
    property candidatesTokenCount: Integer read FCandidatesTokenCount write FCandidatesTokenCount;
    // 仅限输出。工具使用提示中的 token 数量。
    property toolUsePromptTokenCount: Integer read FToolUsePromptTokenCount write FToolUsePromptTokenCount;
    // 仅限输出。思考模型的思考 token 数。
    property thoughtsTokenCount: Integer read FThoughtsTokenCount write FThoughtsTokenCount;
    // 生成请求（提示 + 候选回答）的总 token 数。
    // 或
    // 缓存内容消耗的 token 总数。【在 https://ai.google.dev/api/caching#UsageMetadata 页面内的定义只有 totalTokenCount 一个属性。】
    property totalTokenCount: Integer read FTotalTokenCount write FTotalTokenCount;
    // 仅限输出。请求输入中处理的模态列表。
    property promptTokensDetails: TArray<TModalityTokenCount> read FPromptTokensDetails write SetPromptTokensDetails;
    // 仅限输出。请求输入中缓存内容的模态列表。
    property cacheTokensDetails: TArray<TModalityTokenCount> read FCacheTokensDetails write SetCacheTokensDetails;
    // 仅限输出。响应中返回的模态列表。
    property candidatesTokensDetails: TArray<TModalityTokenCount> read FCandidatesTokensDetails write SetCandidatesTokensDetails;
    // 仅限输出。为工具使用请求输入处理的模态列表。
    property toolUsePromptTokensDetails: TArray<TModalityTokenCount> read FToolUsePromptTokensDetails write SetToolUsePromptTokensDetails;
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

{ TUsageMetadata }

constructor TUsageMetadata.Create();
begin
  inherited Create();
  Self.FPromptTokenCount := 0;
  Self.FCachedContentTokenCount := 0;
  Self.FCandidatesTokenCount := 0;
  Self.FToolUsePromptTokenCount := 0;
  Self.FThoughtsTokenCount := 0;
  Self.FTotalTokenCount := 0;
  SetLength(Self.FPromptTokensDetails, 0);
  SetLength(Self.FCacheTokensDetails, 0);
  SetLength(Self.FCandidatesTokensDetails, 0);
  SetLength(Self.FToolUsePromptTokensDetails, 0);
end;

destructor TUsageMetadata.Destroy();
begin
  TParameterReality.ReleaseArray<TModalityTokenCount>(Self.FToolUsePromptTokensDetails);
  TParameterReality.ReleaseArray<TModalityTokenCount>(Self.FCandidatesTokensDetails);
  TParameterReality.ReleaseArray<TModalityTokenCount>(Self.FCacheTokensDetails);
  TParameterReality.ReleaseArray<TModalityTokenCount>(Self.FPromptTokensDetails);
  Self.FTotalTokenCount := 0;
  Self.FThoughtsTokenCount := 0;
  Self.FToolUsePromptTokenCount := 0;
  Self.FCandidatesTokenCount := 0;
  Self.FCachedContentTokenCount := 0;
  Self.FPromptTokenCount := 0;
  inherited Destroy();
end;

function TUsageMetadata.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TUsageMetadata.SetCacheTokensDetails(
  const Value: TArray<TModalityTokenCount>);
begin
  TParameterReality.CopyArrayWithClass<TModalityTokenCount>(FCacheTokensDetails, Value);
end;

procedure TUsageMetadata.SetCandidatesTokensDetails(
  const Value: TArray<TModalityTokenCount>);
begin
  TParameterReality.CopyArrayWithClass<TModalityTokenCount>(FCandidatesTokensDetails, Value);
end;

function TUsageMetadata.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'promptTokensDetails') then
  begin
    TParameterReality.CopyArrayWithJson<TModalityTokenCount>(Self.FPromptTokensDetails, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'cacheTokensDetails') then
  begin
    TParameterReality.CopyArrayWithJson<TModalityTokenCount>(Self.FCacheTokensDetails, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'candidatesTokensDetails') then
  begin
    TParameterReality.CopyArrayWithJson<TModalityTokenCount>(Self.FCandidatesTokensDetails, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'toolUsePromptTokensDetails') then
  begin
    TParameterReality.CopyArrayWithJson<TModalityTokenCount>(Self.FToolUsePromptTokensDetails, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TUsageMetadata.SetPromptTokensDetails(
  const Value: TArray<TModalityTokenCount>);
begin
  TParameterReality.CopyArrayWithClass<TModalityTokenCount>(FPromptTokensDetails, Value);
end;

procedure TUsageMetadata.SetToolUsePromptTokensDetails(
  const Value: TArray<TModalityTokenCount>);
begin
  TParameterReality.CopyArrayWithClass<TModalityTokenCount>(FToolUsePromptTokensDetails, Value);
end;

end.
