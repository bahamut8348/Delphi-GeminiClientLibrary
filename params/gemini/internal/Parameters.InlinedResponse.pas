unit Parameters.InlinedResponse;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.GenerateContentResponse, Parameters.Status;

type
{
  https://ai.google.dev/api/batch-api#InlinedResponse
  对批处理中单个请求的响应。
}
  TInlinedResponse = class(TParameterReality)
  private
    { private declarations }
    // 联合属性序号，联合属性 output 不能全部发送，否则服务器将返回错误.
    FUnionProperty: (upError, upResponse, upOther);

    FMetadataNeedFree: Boolean;
    FMetadata: TObject; // TDictionary<TKey, TValue>
    { Union type output start }
    FError: TStatus;
    FResponse: TGenerateContentResponse;
    { Union type output end }

    procedure SetError(const Value: TStatus);
    procedure SetResponse(const Value: TGenerateContentResponse);
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
    property response: TGenerateContentResponse read FResponse write SetResponse;
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

{ TInlinedResponse }

constructor TInlinedResponse.Create();
begin
  inherited Create();
  Self.FUnionProperty := upError;
  Self.FMetadataNeedFree := FALSE;
  Self.FMetadata := nil;
  Self.FError := nil;
  Self.FResponse := nil;
end;

destructor TInlinedResponse.Destroy();
begin
  SafeFreeAndNil(Self.FResponse);
  SafeFreeAndNil(Self.FError);
  if (Self.FMetadataNeedFree) then
    SafeFreeAndNil(Self.FMetadata);
  Self.FMetadataNeedFree := FALSE;
  Self.FUnionProperty := upOther;
  inherited Destroy();
end;

function TInlinedResponse.GetMemberValue(var sName: String;
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

procedure TInlinedResponse.SetError(const Value: TStatus);
begin
  FUnionProperty := upError;
  if (Value <> FError) then
    TParameterReality.CopyWithClass(FError, Value);
end;

function TInlinedResponse.SetMemberValue(const sName: String;
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
    TParameterReality.CopyWithJson(Self.FResponse, TGenerateContentResponse, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TInlinedResponse.SetMetadata(const Value: TObject);
begin
  if (Value <> FMetadata) then
    TParameterReality.CloneWithClass(FMetadata, FMetadataNeedFree, Value);
end;

procedure TInlinedResponse.SetResponse(const Value: TGenerateContentResponse);
begin
  FUnionProperty := upResponse;
  if (Value <> FResponse) then
    TParameterReality.CopyWithClass(FResponse, Value);
end;

end.
