unit Parameters.InlinedRequest;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.GenerateContentBatchRequest;

type
{
  https://ai.google.dev/api/batch-api#InlinedRequest
  要在批处理中处理的请求。
}
  TInlinedRequest = class(TParameterReality)
  private
    { private declarations }
    FRequest: TGenerateContentBatchRequest;
    FMetadataNeedFree: Boolean;
    FMetadata: TObject; // TDictionary<TKey, TValue>
    procedure SetMetadata(const Value: TObject);
    procedure SetRequest(const Value: TGenerateContentBatchRequest);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。要在批处理中处理的请求。
    property request: TGenerateContentBatchRequest read FRequest write SetRequest;
    // 可选。要与请求相关联的元数据。
    property metadata: TObject read FMetadata write SetMetadata; // TDictionary<TKey, TValue>
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

{ TInlinedRequest }

constructor TInlinedRequest.Create();
begin
  inherited Create();
  Self.FMetadataNeedFree := FALSE;
  Self.FRequest := nil;
  Self.FMetadata := nil;
end;

destructor TInlinedRequest.Destroy();
begin
  if (Self.FMetadataNeedFree) then
    SafeFreeAndNil(Self.FMetadata);
  SafeFreeAndNil(Self.FRequest);
  Self.FMetadataNeedFree := FALSE;
  inherited Destroy();
end;

function TInlinedRequest.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TInlinedRequest.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'metadata') then
  begin
    TParameterReality.CloneWithJson(FMetadata, FMetadataNeedFree, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'request') then
  begin
    TParameterReality.CopyWithJson(FRequest, TGenerateContentBatchRequest, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TInlinedRequest.SetMetadata(const Value: TObject);
begin
  if (Value <> FMetadata) then
    TParameterReality.CloneWithClass(FMetadata, FMetadataNeedFree, Value);
end;

procedure TInlinedRequest.SetRequest(const Value: TGenerateContentBatchRequest);
begin
  if (Value <> FRequest) then
    TParameterReality.CopyWithClass(FRequest, Value);
end;

end.
