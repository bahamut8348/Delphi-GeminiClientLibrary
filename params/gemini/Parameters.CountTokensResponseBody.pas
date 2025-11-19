unit Parameters.CountTokensResponseBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.ModalityTokenCount;

type
{
  https://ai.google.dev/api/tokens#response-body
  来自 models.countTokens 的回答。
  它会返回 prompt 的模型 tokenCount。
  如果成功，响应正文将包含结构如下的数据：
}
  TCountTokensResponseBody = class(TParameterReality)
  private
    { private declarations }
    FTotalTokens: Integer;
    FCachedContentTokenCount: Integer;
    FPromptTokensDetails: TArray<TModalityTokenCount>;
    FCacheTokensDetails: TArray<TModalityTokenCount>;

    procedure SetCachedContentTokenCount(const Value: Integer);
    procedure SetCacheTokensDetails(const Value: TArray<TModalityTokenCount>);
    procedure SetPromptTokensDetails(const Value: TArray<TModalityTokenCount>);
    procedure SetTotalTokens(const Value: Integer);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // Model 将 prompt 分词为的令牌数量。始终为非负数。
    property totalTokens: Integer read FTotalTokens write SetTotalTokens;
    // 提示的缓存部分（即缓存的内容）中的 token 数量。
    property cachedContentTokenCount: Integer read FCachedContentTokenCount write SetCachedContentTokenCount;
    // 仅限输出。请求输入中处理的模态列表。
    property promptTokensDetails: TArray<TModalityTokenCount> read FPromptTokensDetails write SetPromptTokensDetails;
    // 仅限输出。缓存内容中处理的模态列表。
    property cacheTokensDetails: TArray<TModalityTokenCount> read FCacheTokensDetails write SetCacheTokensDetails;
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

{ TCountTokensResponseBody }

constructor TCountTokensResponseBody.Create();
begin
  inherited Create();
  Self.FTotalTokens := 0;
  Self.FCachedContentTokenCount := 0;
  SetLength(Self.FPromptTokensDetails, 0);
  SetLength(Self.FCacheTokensDetails, 0);
end;

destructor TCountTokensResponseBody.Destroy();
begin
  TParameterReality.ReleaseArray<TModalityTokenCount>(Self.FCacheTokensDetails);
  TParameterReality.ReleaseArray<TModalityTokenCount>(Self.FPromptTokensDetails);
  Self.FCachedContentTokenCount := 0;
  Self.FTotalTokens := 0;

  inherited Destroy();
end;

function TCountTokensResponseBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TCountTokensResponseBody.SetCachedContentTokenCount(
  const Value: Integer);
begin
  FCachedContentTokenCount := Value;
end;

procedure TCountTokensResponseBody.SetCacheTokensDetails(
  const Value: TArray<TModalityTokenCount>);
begin
  TParameterReality.CopyArrayWithClass<TModalityTokenCount>(FCacheTokensDetails, Value);
end;

function TCountTokensResponseBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'promptTokensDetails') then
  begin
    TParameterReality.CopyArrayWithJson<TModalityTokenCount>(FPromptTokensDetails, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'cacheTokensDetails') then
  begin
    TParameterReality.CopyArrayWithJson<TModalityTokenCount>(FCacheTokensDetails, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TCountTokensResponseBody.SetPromptTokensDetails(
  const Value: TArray<TModalityTokenCount>);
begin
  TParameterReality.CopyArrayWithClass<TModalityTokenCount>(FPromptTokensDetails, Value);
end;

procedure TCountTokensResponseBody.SetTotalTokens(const Value: Integer);
begin
  FTotalTokens := Value;
end;

end.