unit Parameters.FunctionCall;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#FunctionCall
  从模型返回的预测 FunctionCall，其中包含表示 FunctionDeclaration.name（包含实参及其值）的字符串。
}
  TFunctionCall = class(TParameterReality)
  private
    { private declarations }
    FArgsNeedFree: Boolean;
    FArgs: TObject;
    procedure SetArgs(const Value: TObject); // TDictionary<String, TValue>;
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。函数调用的唯一 ID。如果已填充，则客户端执行 functionCall 并返回具有匹配 id 的响应。
    id: String;
    // 必需。要调用的函数名称。必须是 a-z、A-Z、0-9 或包含下划线和短划线，长度上限为 64。
    name: String;
    // 可选。以 JSON 对象格式表示的函数参数和值。
    property args: TObject read FArgs write SetArgs; // TDictionary<String, TValue>;
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

{ TFunctionCall }

constructor TFunctionCall.Create();
begin
  inherited Create();
  Self.id := '';
  Self.name := '';
  Self.FArgsNeedFree := FALSE;
  Self.FArgs := nil;
end;

destructor TFunctionCall.Destroy();
begin
  if (Self.FArgsNeedFree) then
    SafeFreeAndNil(Self.FArgs);
  Self.FArgsNeedFree := TRUE;
  Self.name := '';
  Self.id := '';
  inherited Destroy();
end;

function TFunctionCall.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TFunctionCall.SetArgs(const Value: TObject);
begin
  if (Value <> FArgs) then
    TParameterReality.CloneWithClass(FArgs, FArgsNeedFree, Value);
end;

function TFunctionCall.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'args') then
  begin
    TParameterReality.CloneWithJson(FArgs, FArgsNeedFree, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
