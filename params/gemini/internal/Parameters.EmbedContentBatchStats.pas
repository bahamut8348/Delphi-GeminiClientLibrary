unit Parameters.EmbedContentBatchStats;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/embeddings#EmbedContentBatchStats
  有关批次的统计信息。
}
  TEmbedContentBatchStats = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 仅限输出。批次中的请求数量。
    requestCount: String;
    // 仅限输出。成功处理的请求数。
    successfulRequestCount: String;
    // 仅限输出。未能成功处理的请求数。
    failedRequestCount: String;
    // 仅限输出。仍处于待处理状态的请求数。
    pendingRequestCount: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TEmbedContentBatchStats }

constructor TEmbedContentBatchStats.Create();
begin
  inherited Create();
  Self.requestCount := '';
  Self.successfulRequestCount := '';
  Self.failedRequestCount := '';
  Self.pendingRequestCount := '';
end;

destructor TEmbedContentBatchStats.Destroy();
begin
  Self.pendingRequestCount := '';
  Self.failedRequestCount := '';
  Self.successfulRequestCount := '';
  Self.requestCount := '';
  inherited Destroy();
end;

end.
