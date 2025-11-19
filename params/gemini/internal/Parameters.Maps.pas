unit Parameters.Maps;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.PlaceAnswerSources;

type
{
  https://ai.google.dev/api/generate-content#Maps
  Google 地图中的一个接地块。一个地图块对应于一个地点。
}
  TMaps = class(TParameterReality)
  private
    { private declarations }
    FUri: String;
    FTitle: String;
    FText: String;
    FPlaceId: String;
    FPlaceAnswerSources: TPlaceAnswerSources;
    procedure SetPlaceAnswerSources(const Value: TPlaceAnswerSources);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 地点的 URI 引用。
    property uri: String read FUri write FUri;
    // 地点的标题。
    property title: String read FTitle write FTitle;
    // 地点答案的文字说明。
    property text: String read FText write FText;
    // 相应地点的 ID，采用 places/{placeId} 格式。用户可以使用此 ID 查找相应地点。
    property placeId: String read FPlaceId write FPlaceId;
    // 提供有关 Google 地图中特定地点的特征的答案的来源。
    property placeAnswerSources: TPlaceAnswerSources read FPlaceAnswerSources write SetPlaceAnswerSources;
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

{ TMaps }

constructor TMaps.Create();
begin
  inherited Create();
  Self.FUri := '';
  Self.FTitle := '';
  Self.FText := '';
  Self.FPlaceId := '';
  Self.FPlaceAnswerSources := nil;
end;

destructor TMaps.Destroy();
begin
  SafeFreeAndNil(Self.FPlaceAnswerSources);
  Self.FPlaceId := '';
  Self.FText := '';
  Self.FTitle := '';
  Self.FUri := '';
  inherited Destroy();
end;

function TMaps.GetMemberValue(var sName: String; out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TMaps.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'placeAnswerSources') then
  begin
    TParameterReality.CopyWithJson(FPlaceAnswerSources, TPlaceAnswerSources, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TMaps.SetPlaceAnswerSources(const Value: TPlaceAnswerSources);
begin
  if (Value <> FPlaceAnswerSources) then
    TParameterReality.CopyWithClass(FPlaceAnswerSources, Value);
end;

end.
