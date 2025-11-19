unit Parameters.InlinedEmbedContentRequest;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.EmbedContentRequest;

type
{
  https://ai.google.dev/api/embeddings#InlinedEmbedContentRequest
  要在批处理中处理的请求。
}
  TInlinedEmbedContentRequest = class(TParameterReality)
  private
    { private declarations }

    FRequest: TEmbedContentRequest;

    FMetadataNeedFree: Boolean;
    FMetadata: TObject;

    procedure SetMetadata(const Value: TObject);
    procedure SetRequest(const Value: TEmbedContentRequest); // TDictionary<String, TValue>;
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。要在批处理中处理的请求。
    property request: TEmbedContentRequest read FRequest write SetRequest;
    // 可选。要与请求相关联的元数据。
    property metadata: TObject read FMetadata write SetMetadata; // TDictionary<String, TValue>;
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

{ TInlinedEmbedContentRequest }

constructor TInlinedEmbedContentRequest.Create();
begin
  inherited Create();
  Self.FMetadataNeedFree := FALSE;
  Self.FRequest := nil;
  Self.FMetadata := nil;
end;

destructor TInlinedEmbedContentRequest.Destroy();
begin
  if (Self.FMetadataNeedFree) then
    SafeFreeAndNil(Self.FMetadata);
  SafeFreeAndNil(Self.FRequest);
  Self.FMetadataNeedFree := FALSE;
  inherited Destroy();
end;

function TInlinedEmbedContentRequest.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TInlinedEmbedContentRequest.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'metadata') then
  begin
    TParameterReality.CloneWithJson(FMetadata, FMetadataNeedFree, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'request') then
  begin
    TParameterReality.CopyWithJson(FRequest, TEmbedContentRequest, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TInlinedEmbedContentRequest.SetMetadata(const Value: TObject);
begin
  if (Value <> FMetadata) then
    TParameterReality.CloneWithClass(FMetadata, FMetadataNeedFree, Value);
end;

procedure TInlinedEmbedContentRequest.SetRequest(
  const Value: TEmbedContentRequest);
begin
  if (Value <> FRequest) then
    TParameterReality.CopyWithClass(FRequest, Value);
end;

end.
