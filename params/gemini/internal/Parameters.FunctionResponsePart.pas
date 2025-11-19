unit Parameters.FunctionResponsePart;

interface

uses
  System.SysUtils, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.FunctionResponseBlob;

type
{
  https://ai.google.dev/api/caching#FunctionResponsePart
  一种包含属于 FunctionResponse 消息一部分的媒体的数据类型。
  FunctionResponsePart 由具有关联数据类型的数据组成。FunctionResponsePart 只能包含 FunctionResponsePart.data 中接受的类型之一。
  如果 inlineData 字段填充了原始字节，则 FunctionResponsePart 必须具有固定的 IANA MIME 类型，用于标识媒体的类型和子类型。
}
  TFunctionResponsePart = class(TParameterReality)
  private
    { private declarations }
    FInlineData: TFunctionResponseBlob;
    procedure SetInlineData(const Value: TFunctionResponseBlob);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }

    { Union type data start }
    // 函数响应部分的数据。data 只能是下列其中一项：
    // 内嵌媒体字节。
    property inlineData: TFunctionResponseBlob read FInlineData write SetInlineData;
    { Union type data end }
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

{ TFunctionResponsePart }

constructor TFunctionResponsePart.Create();
begin
  inherited Create();
  Self.FInlineData := nil;
end;

destructor TFunctionResponsePart.Destroy();
begin
  SafeFreeAndNil(Self.FInlineData);
  inherited Destroy();
end;

function TFunctionResponsePart.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TFunctionResponsePart.SetInlineData(
  const Value: TFunctionResponseBlob);
begin
  if (Value <> FInlineData) then
    TParameterReality.CopyWithClass(FInlineData, Value);
end;

function TFunctionResponsePart.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'inlineData') then
  begin
    TParameterReality.CopyWithJson(FInlineData, TFunctionResponseBlob, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
