unit Parameters.FunctionCallingConfig;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#FunctionCallingConfig
  用于指定函数调用行为的配置。
}
  TFunctionCallingConfig = class(TParameterReality)
  private
    { private declarations }
    FMode: String;
    FAllowedFunctionNames: TArray<String>;
    procedure SetAllowedFunctionNames(const Value: TArray<String>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。指定函数调用应以何种模式执行。如果未指定，则默认值将设置为 AUTO。
    //
    // 值                 | 说明
    // MODE_UNSPECIFIED   | 未指定函数调用模式。请勿使用此值。
    // AUTO               | 默认模型行为，模型决定预测函数调用或自然语言回答。
    // ANY                | 模型会受到限制，始终仅预测函数调用。如果设置了“allowedFunctionNames”，预测的函数调用将仅限于“allowedFunctionNames”中的任何一个；否则，预测的函数调用将是所提供的“functionDeclarations”中的任何一个。
    // NONE               | 模型不会预测任何函数调用。模型行为与不传递任何函数声明时相同。
    // VALIDATED          | 模型决定预测函数调用或自然语言回答，但会通过受限解码来验证函数调用。如果设置了“allowedFunctionNames”，预测的函数调用将仅限于“allowedFunctionNames”中的任何一个；否则，预测的函数调用将是所提供的“functionDeclarations”中的任何一个。
    property mode: String read FMode write FMode;

    // 可选。一组函数名称，提供后可限制模型将调用的函数。
    // 仅当模式为“ANY”或“VALIDATED”时，才应设置此字段。函数名称应与 [FunctionDeclaration.name] 匹配。设置后，模型将仅根据允许的函数名称预测函数调用。
    property allowedFunctionNames: TArray<String> read FAllowedFunctionNames write SetAllowedFunctionNames;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const szMode: String): TFunctionCallingConfig; overload; inline; static;
    class function CreateWith(const pAllowedFunctionNames: TArray<String>): TFunctionCallingConfig; overload; static;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType,
  Functions.SystemExtended;

{ TFunctionCallingConfig }

constructor TFunctionCallingConfig.Create();
begin
  inherited Create();
  Self.FMode := GEMINI_MODE_AUTO;
  SetLength(Self.FAllowedFunctionNames, 0);
end;

class function TFunctionCallingConfig.CreateWith(
  const pAllowedFunctionNames: TArray<String>): TFunctionCallingConfig;
begin
  Result := TFunctionCallingConfig.Create();
  Result.allowedFunctionNames := pAllowedFunctionNames;
end;

class function TFunctionCallingConfig.CreateWith(
  const szMode: String): TFunctionCallingConfig;
begin
  Result := TFunctionCallingConfig.Create();
  Result.FMode := szMode;
end;

destructor TFunctionCallingConfig.Destroy();
begin
  ReleaseStringArray(Self.FAllowedFunctionNames);
  Self.FMode := '';
  inherited Destroy();
end;

function TFunctionCallingConfig.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TFunctionCallingConfig.SetAllowedFunctionNames(
  const Value: TArray<String>);
begin
  CopyStringArrayWithArray(Self.FAllowedFunctionNames, Value);
end;

function TFunctionCallingConfig.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'allowedFunctionNames') then
  begin
    CopyStringArrayWithJson(Self.FAllowedFunctionNames, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
