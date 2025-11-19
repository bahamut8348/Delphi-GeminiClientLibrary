unit Parameters.BatchEmbedContentsRequestBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.EmbedContentRequest;

type
{
  https://ai.google.dev/api/embeddings#request-body_1
  models.batchEmbedContents 请求正文
}
  TBatchEmbedContentsRequestBody = class(TParameterReality)
  private
    { private declarations }
    FRequests: TArray<TEmbedContentRequest>;
    procedure SetRequests(const Value: TArray<TEmbedContentRequest>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。批次的嵌入请求。相应请求中的模型必须与指定的模型 BatchEmbedContentsRequest.model 一致。
    property requests: TArray<TEmbedContentRequest> read FRequests write SetRequests;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const pRequests: TArray<TEmbedContentRequest>): TBatchEmbedContentsRequestBody; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TBatchEmbedContentsRequestBody }

constructor TBatchEmbedContentsRequestBody.Create();
begin
  inherited Create();
  SetLength(Self.FRequests, 0);
end;

class function TBatchEmbedContentsRequestBody.CreateWith(
  const pRequests: TArray<TEmbedContentRequest>): TBatchEmbedContentsRequestBody;
begin
  Result := TBatchEmbedContentsRequestBody.Create();
  Result.requests := pRequests;
end;

destructor TBatchEmbedContentsRequestBody.Destroy();
begin
  TParameterReality.ReleaseArray<TEmbedContentRequest>(FRequests);
  inherited Destroy();
end;

function TBatchEmbedContentsRequestBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TBatchEmbedContentsRequestBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'requests') then
  begin
    TParameterReality.CopyArrayWithJson<TEmbedContentRequest>(Self.FRequests, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TBatchEmbedContentsRequestBody.SetRequests(
  const Value: TArray<TEmbedContentRequest>);
begin
  TParameterReality.CopyArrayWithClass<TEmbedContentRequest>(FRequests, Value);
end;

end.

