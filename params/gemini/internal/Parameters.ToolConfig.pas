unit Parameters.ToolConfig;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement,
  Parameters.FunctionCallingConfig, Parameters.RetrievalConfig;

type
{
  https://ai.google.dev/api/caching#ToolConfig
  包含用于指定请求中 Tool 用法的参数的工具配置。
}
  TToolConfig = class(TParameterReality)
  private
    { private declarations }
    FFunctionCallingConfig: TFunctionCallingConfig;
    FRetrievalConfig: TRetrievalConfig;
    procedure SetFunctionCallingConfig(const Value: TFunctionCallingConfig);
    procedure SetRetrievalConfig(const Value: TRetrievalConfig);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。函数调用配置。
    property functionCallingConfig: TFunctionCallingConfig read FFunctionCallingConfig write SetFunctionCallingConfig;
    // 可选。检索配置。
    property retrievalConfig: TRetrievalConfig read FRetrievalConfig write SetRetrievalConfig;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const pFunctionCallingConfig: TFunctionCallingConfig): TToolConfig; overload; inline; static;
    class function CreateWith(const pRetrievalConfig: TRetrievalConfig): TToolConfig; overload; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TToolConfig }

constructor TToolConfig.Create();
begin
  inherited Create();
  Self.FFunctionCallingConfig := nil;
  Self.FRetrievalConfig := nil;
end;

class function TToolConfig.CreateWith(
  const pRetrievalConfig: TRetrievalConfig): TToolConfig;
begin
  Result := TToolConfig.Create();
  Result.retrievalConfig := pRetrievalConfig;
end;

class function TToolConfig.CreateWith(
  const pFunctionCallingConfig: TFunctionCallingConfig): TToolConfig;
begin
  Result := TToolConfig.Create();
  Result.functionCallingConfig := pFunctionCallingConfig;
end;

destructor TToolConfig.Destroy();
begin
  SafeFreeAndNil(Self.FRetrievalConfig);
  SafeFreeAndNil(Self.FFunctionCallingConfig);
  inherited Destroy();
end;

function TToolConfig.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TToolConfig.SetFunctionCallingConfig(
  const Value: TFunctionCallingConfig);
begin
  if (Value <> FFunctionCallingConfig) then
    TParameterReality.CopyWithClass(FFunctionCallingConfig, Value);
end;

function TToolConfig.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'functionCallingConfig') then
  begin
    TParameterReality.CopyWithJson(FFunctionCallingConfig, TFunctionCallingConfig, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'retrievalConfig') then
  begin
    TParameterReality.CopyWithJson(FRetrievalConfig, TRetrievalConfig, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TToolConfig.SetRetrievalConfig(const Value: TRetrievalConfig);
begin
  if (Value <> FRetrievalConfig) then
    TParameterReality.CopyWithClass(FRetrievalConfig, Value);
end;

end.
