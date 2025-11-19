unit Parameters.InlinedRequests;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.InlinedRequest;

type
{
  https://ai.google.dev/api/batch-api#InlinedRequests
  如果作为批次创建请求的一部分提供，则为要在批次中处理的请求。
}
  TInlinedRequests = class(TParameterReality)
  private
    { private declarations }
    FRequests: TArray<TInlinedRequest>;
    procedure SetRequests(const Value: TArray<TInlinedRequest>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。批次中要处理的请求。
    property requests: TArray<TInlinedRequest> read FRequests write SetRequests;
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

{ TInlinedRequests }

constructor TInlinedRequests.Create();
begin
  inherited Create();
  SetLength(Self.FRequests, 0);
end;

destructor TInlinedRequests.Destroy();
begin
  TParameterReality.ReleaseArray<TInlinedRequest>(Self.FRequests);
  inherited Destroy();
end;

function TInlinedRequests.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TInlinedRequests.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'requests') then
  begin
    TParameterReality.CopyArrayWithJson<TInlinedRequest>(Self.FRequests, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TInlinedRequests.SetRequests(const Value: TArray<TInlinedRequest>);
begin
  TParameterReality.CopyArrayWithClass<TInlinedRequest>(Self.FRequests, Value);
end;

end.
