unit Parameters.PredictRequestBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/models#path-parameters_1
  执行预测请求。
}
  TPredictRequestBody = class(TParameterReality)
  private
    { private declarations }
    FInstancesNeedFree: Boolean;
    FParametersNeedFree: Boolean;

    FInstances: TArray<TObject>;
    FParameters: TObject;
    procedure SetInstances(const Value: TArray<TObject>);
    procedure SetParameters(const Value: TObject);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。作为预测调用的输入的实例。
    property instances: TArray<TObject> read FInstances write SetInstances;
    // 可选。用于控制预测调用的参数。
    property parameters: TObject read FParameters write SetParameters;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const pInstances: TArray<TObject>;
      const pParameters: TObject = nil): TPredictRequestBody;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TPredictRequestBody }

constructor TPredictRequestBody.Create();
begin
  inherited Create();
  Self.FInstancesNeedFree := FALSE;
  Self.FParametersNeedFree := FALSE;

  SetLength(Self.FInstances, 0);
  Self.FParameters := nil;
end;

class function TPredictRequestBody.CreateWith(const pInstances: TArray<TObject>;
  const pParameters: TObject): TPredictRequestBody;
begin
  Result := TPredictRequestBody.Create();
  Result.instances := pInstances;
  Result.parameters := pParameters;
end;

destructor TPredictRequestBody.Destroy();
begin
  TParameterReality.ReleaseArray<TObject>(Self.FInstances, Self.FInstancesNeedFree);
  if (Self.FParametersNeedFree) then
    SafeFreeAndNil(Self.FParameters);
  Self.FInstancesNeedFree := FALSE;
  Self.FParametersNeedFree := FALSE;
  inherited Destroy();
end;

function TPredictRequestBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TPredictRequestBody.SetInstances(const Value: TArray<TObject>);
begin
  TParameterReality.CloneArrayWithClass(FInstances, FInstancesNeedFree, Value);
end;

function TPredictRequestBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'instances') then
  begin
    TParameterReality.CloneArrayWithJson(Self.FInstances, Self.FInstancesNeedFree, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'parameters') then
  begin
    TParameterReality.CloneWithJson(Self.FParameters, Self.FParametersNeedFree, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TPredictRequestBody.SetParameters(const Value: TObject);
begin
  if (Value <> FParameters) then
    TParameterReality.CloneWithClass(FParameters, FParametersNeedFree, Value);
end;

end.