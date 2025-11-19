unit Parameters.RetrievalConfig;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.LatLng;

type
{
  https://ai.google.dev/api/caching#RetrievalConfig
  检索配置。
}
  TRetrievalConfig = class(TParameterReality)
  private
    { private declarations }
    FLatLng: TLatLng;
    FLanguageCode: String;
    procedure SetLatLng(const Value: TLatLng);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。用户的位置。
    property latLng: TLatLng read FLatLng write SetLatLng;
    // 可选。用户的语言代码。内容的语言代码。使用 <a href='https://www.rfc-editor.org/rfc/bcp/bcp47.txt'>BCP47</a> 定义的语言标记。
    property languageCode: String read FLanguageCode write FLanguageCode;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const llLatLng: TLatLng): TRetrievalConfig; overload; inline; static;
    class function CreateWith(const szLanguageCode: String): TRetrievalConfig; overload; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TRetrievalConfig }

constructor TRetrievalConfig.Create();
begin
  inherited Create();
  Self.FLatLng := nil;
  Self.FLanguageCode := '';
end;

class function TRetrievalConfig.CreateWith(
  const szLanguageCode: String): TRetrievalConfig;
begin
  Result := TRetrievalConfig.Create();
  Result.languageCode := szLanguageCode;
end;

class function TRetrievalConfig.CreateWith(
  const llLatLng: TLatLng): TRetrievalConfig;
begin
  Result := TRetrievalConfig.Create();
  Result.latLng := llLatLng;
end;

destructor TRetrievalConfig.Destroy();
begin
  Self.FLanguageCode := '';
  SafeFreeAndNil(Self.FLatLng);
  inherited Destroy();
end;

function TRetrievalConfig.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TRetrievalConfig.SetLatLng(const Value: TLatLng);
begin
  if (Value <> FLatLng) then
    TParameterReality.CopyWithClass(FLatLng, Value);
end;

function TRetrievalConfig.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'latLng') then
  begin
    TParameterReality.CopyWithJson(FLatLng, TLatLng, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
