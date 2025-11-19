unit Parameters.InlinedEmbedContentRequests;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.InlinedEmbedContentRequest;

type
{
  https://ai.google.dev/api/embeddings#InlinedEmbedContentRequests
  如果作为批次创建请求的一部分提供，则为要在批次中处理的请求。
}
  TInlinedEmbedContentRequests = class(TParameterReality)
  private
    { private declarations }
    FRequests: TArray<TInlinedEmbedContentRequest>;
    procedure SetRequests(const Value: TArray<TInlinedEmbedContentRequest>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。批次中要处理的请求。
    property requests: TArray<TInlinedEmbedContentRequest> read FRequests write SetRequests;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const pRequests: TArray<TInlinedEmbedContentRequest>): TInlinedEmbedContentRequests; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TInlinedEmbedContentRequests }

constructor TInlinedEmbedContentRequests.Create();
begin
  inherited Create();
  SetLength(Self.FRequests, 0);
end;

class function TInlinedEmbedContentRequests.CreateWith(
  const pRequests: TArray<TInlinedEmbedContentRequest>): TInlinedEmbedContentRequests;
begin
  Result := TInlinedEmbedContentRequests.Create();
  Result.requests := pRequests;
end;

destructor TInlinedEmbedContentRequests.Destroy();
begin
  TParameterReality.ReleaseArray<TInlinedEmbedContentRequest>(Self.FRequests);
  inherited Destroy();
end;

function TInlinedEmbedContentRequests.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TInlinedEmbedContentRequests.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'requests') then
  begin
    TParameterReality.CopyArrayWithJson<TInlinedEmbedContentRequest>(Self.FRequests, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TInlinedEmbedContentRequests.SetRequests(
  const Value: TArray<TInlinedEmbedContentRequest>);
begin
  TParameterReality.CopyArrayWithClass<TInlinedEmbedContentRequest>(FRequests, Value);
end;

end.
