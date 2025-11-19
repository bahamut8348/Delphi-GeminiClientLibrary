unit Parameters.InlinedEmbedContentResponse;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Status, Parameters.EmbedContentResponse;

type
{
  https://ai.google.dev/api/embeddings#InlinedEmbedContentResponse
  对批处理中单个请求的响应。
}
  TInlinedEmbedContentResponse = class(TParameterReality)
  private
    { private declarations }
    // 联合属性序号，联合属性 output 不能全部发送，否则服务器将返回错误.
    FUnionProperty: (upError, upResponse, upOther);

    FMetadataNeedFree: Boolean;
    FMetadata: TObject; // TDictionary<TKey, TValue>
    { Union type output start }
    FError: TStatus;
    FResponse: TEmbedContentResponse;
    { Union type output end }

    procedure SetError(const Value: TStatus);
    procedure SetResponse(const Value: TEmbedContentResponse);
    procedure SetMetadata(const Value: TObject);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 仅限输出。与请求相关联的元数据。
    property metadata: TObject read FMetadata write SetMetadata; // TDictionary<TKey, TValue>

    { Union type output start }
    // 请求的输出。output 只能是下列其中一项：
    // 仅限输出。处理请求时遇到的错误。
    property error: TStatus read FError write SetError;
    // 仅限输出。对请求的响应。
    property response: TEmbedContentResponse read FResponse write SetResponse;
    { Union type output end }
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

{ TInlinedEmbedContentResponse }

constructor TInlinedEmbedContentResponse.Create();
begin
  inherited Create();
  Self.FUnionProperty := upError;
  Self.FMetadataNeedFree := FALSE;
  Self.FMetadata := nil;
  Self.FError := nil;
  Self.FResponse := nil;
end;

destructor TInlinedEmbedContentResponse.Destroy();
begin
  SafeFreeAndNil(Self.FResponse);
  SafeFreeAndNil(Self.FError);
  if (Self.FMetadataNeedFree) then
    SafeFreeAndNil(Self.FMetadata);
  Self.FMetadataNeedFree := FALSE;
  Self.FUnionProperty := upOther;
  inherited Destroy();
end;

function TInlinedEmbedContentResponse.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  if SameText(sName, 'error') then
  begin
    if (upError = FUnionProperty) then
      pValue := TValue.From(FError)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'response') then
  begin
    if (upResponse = FUnionProperty) then
      pValue := TValue.From(FResponse)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else
    Result := inherited GetMemberValue(sName, pValue);
end;

procedure TInlinedEmbedContentResponse.SetError(const Value: TStatus);
begin
  FUnionProperty := upError;
  if (Value <> FError) then
    TParameterReality.CopyWithClass(FError, Value);
end;

function TInlinedEmbedContentResponse.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'metadata') then
  begin
    TParameterReality.CloneWithJson(FMetadata, FMetadataNeedFree, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'error') then
  begin
    FUnionProperty := upError;
    TParameterReality.CopyWithJson(Self.FError, TStatus, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'response') then
  begin
    FUnionProperty := upResponse;
    TParameterReality.CopyWithJson(Self.FResponse, TEmbedContentResponse, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TInlinedEmbedContentResponse.SetMetadata(const Value: TObject);
begin
  if (Value <> FMetadata) then
    TParameterReality.CloneWithClass(FMetadata, FMetadataNeedFree, Value);
end;

procedure TInlinedEmbedContentResponse.SetResponse(
  const Value: TEmbedContentResponse);
begin
  FUnionProperty := upResponse;
  if (Value <> FResponse) then
    TParameterReality.CopyWithClass(FResponse, Value);
end;

end.
