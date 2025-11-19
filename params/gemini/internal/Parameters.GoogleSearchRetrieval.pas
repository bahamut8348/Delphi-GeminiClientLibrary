unit Parameters.GoogleSearchRetrieval;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.DynamicRetrievalConfig;

type
{
  https://ai.google.dev/api/caching#GoogleSearchRetrieval
  由 Google 提供支持的工具，用于检索公开 Web 数据以建立回答依据。
}
  TGoogleSearchRetrieval = class(TParameterReality)
  private
    { private declarations }
    FDynamicRetrievalConfig: TDynamicRetrievalConfig;
    procedure SetDynamicRetrievalConfig(const Value: TDynamicRetrievalConfig);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 为指定来源指定动态检索配置。
    property dynamicRetrievalConfig: TDynamicRetrievalConfig read FDynamicRetrievalConfig write SetDynamicRetrievalConfig;

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

{ TGoogleSearchRetrieval }

constructor TGoogleSearchRetrieval.Create();
begin
  inherited Create();
  Self.FDynamicRetrievalConfig := nil;
end;

destructor TGoogleSearchRetrieval.Destroy();
begin
  SafeFreeAndNil(Self.FDynamicRetrievalConfig);
  inherited Destroy();
end;

function TGoogleSearchRetrieval.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TGoogleSearchRetrieval.SetDynamicRetrievalConfig(
  const Value: TDynamicRetrievalConfig);
begin
  if (Value <> FDynamicRetrievalConfig) then
    TParameterReality.CopyWithClass(FDynamicRetrievalConfig, Value);
end;

function TGoogleSearchRetrieval.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'dynamicRetrievalConfig') then
  begin
    TParameterReality.CopyWithJson(FDynamicRetrievalConfig, TDynamicRetrievalConfig, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
