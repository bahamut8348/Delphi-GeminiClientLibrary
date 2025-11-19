unit Parameters.BatchEmbedContentsResponseBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.ContentEmbedding;

type
{
  https://ai.google.dev/api/embeddings#response-body_1
  对 BatchEmbedContentsRequest 的响应。
}
  TBatchEmbedContentsResponseBody = class(TParameterReality)
  private
    { private declarations }
    FEmbeddings: TArray<TContentEmbedding>;
    procedure SetEmbeddings(const Value: TArray<TContentEmbedding>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 仅限输出。每个请求的嵌入内容，按批处理请求中提供的顺序排列。
    property embeddings: TArray<TContentEmbedding> read FEmbeddings write SetEmbeddings;
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

{ TBatchEmbedContentsResponseBody }

constructor TBatchEmbedContentsResponseBody.Create();
begin
  inherited Create();
  SetLength(Self.FEmbeddings, 0);
end;

destructor TBatchEmbedContentsResponseBody.Destroy();
begin
  TParameterReality.ReleaseArray<TContentEmbedding>(Self.FEmbeddings);
  inherited Destroy();
end;

function TBatchEmbedContentsResponseBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TBatchEmbedContentsResponseBody.SetEmbeddings(
  const Value: TArray<TContentEmbedding>);
begin
  TParameterReality.CopyArrayWithClass<TContentEmbedding>(FEmbeddings, Value);
end;

function TBatchEmbedContentsResponseBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'embeddings') then
  begin
    TParameterReality.CopyArrayWithJson<TContentEmbedding>(Self.FEmbeddings, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.

