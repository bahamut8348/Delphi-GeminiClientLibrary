unit Parameters.GroundingMetadata;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.GroundingChunk,
  Parameters.GroundingSupport, Parameters.SearchEntryPoint,
  Parameters.RetrievalMetadata;

type
{
  https://ai.google.dev/api/generate-content#GroundingMetadata
  启用 grounding 后返回给客户端的元数据。
}
  TGroundingMetadata = class(TParameterReality)
  private
    { private declarations }

    FSearchEntryPoint: TSearchEntryPoint;
    FRetrievalMetadata: TRetrievalMetadata;
    FGoogleMapsWidgetContextToken: String;
    procedure SetRetrievalMetadata(const Value: TRetrievalMetadata);
    procedure SetSearchEntryPoint(const Value: TSearchEntryPoint);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 从指定的事实依据来源检索到的佐证参考资料列表。
    groundingChunks: TArray<TGroundingChunk>;
    // 接地支持列表。
    groundingSupports: TArray<TGroundingSupport>;
    // 后续网页搜索的网页搜索查询。
    webSearchQueries: TArray<String>;
    // 可选。Google 搜索条目，用于后续的网页搜索。
    property searchEntryPoint: TSearchEntryPoint read FSearchEntryPoint write SetSearchEntryPoint;
    // 与接地流程中的检索相关的元数据。
    property retrievalMetadata: TRetrievalMetadata read FRetrievalMetadata write SetRetrievalMetadata;
    // 可选。Google 地图 widget 上下文令牌的资源名称，可与 PlacesContextElement widget 搭配使用，以渲染内容相关数据。仅在启用依托 Google 地图进行接地的情况下填充。
    property googleMapsWidgetContextToken: String read FGoogleMapsWidgetContextToken write FGoogleMapsWidgetContextToken;

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

{ TGroundingMetadata }

constructor TGroundingMetadata.Create();
begin
  inherited Create();
  SetLength(Self.groundingChunks, 0);
  SetLength(Self.groundingSupports, 0);
  SetLength(Self.webSearchQueries, 0);
  Self.FSearchEntryPoint := nil;
  Self.FRetrievalMetadata := nil;
  Self.FGoogleMapsWidgetContextToken := '';
end;

destructor TGroundingMetadata.Destroy();
begin
  Self.FGoogleMapsWidgetContextToken := '';
  SafeFreeAndNil(Self.FRetrievalMetadata);
  SafeFreeAndNil(Self.FSearchEntryPoint);

  ReleaseStringArray(Self.webSearchQueries);
  TParameterReality.ReleaseArray<TGroundingSupport>(Self.groundingSupports);
  TParameterReality.ReleaseArray<TGroundingChunk>(Self.groundingChunks);

  inherited Destroy();
end;

function TGroundingMetadata.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TGroundingMetadata.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'groundingChunks') then
  begin
    TParameterReality.CopyArrayWithJson<TGroundingChunk>(Self.groundingChunks, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'groundingSupports') then
  begin
    TParameterReality.CopyArrayWithJson<TGroundingSupport>(Self.groundingSupports, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'webSearchQueries') then
  begin
    CopyStringArrayWithJson(Self.webSearchQueries, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'searchEntryPoint') then
  begin
    TParameterReality.CopyWithJson(FSearchEntryPoint, TSearchEntryPoint, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'retrievalMetadata') then
  begin
    TParameterReality.CopyWithJson(FRetrievalMetadata, TRetrievalMetadata, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TGroundingMetadata.SetRetrievalMetadata(
  const Value: TRetrievalMetadata);
begin
  if (Value <> FRetrievalMetadata) then
    TParameterReality.CopyWithClass(FRetrievalMetadata, Value);
end;

procedure TGroundingMetadata.SetSearchEntryPoint(
  const Value: TSearchEntryPoint);
begin
  if (Value <> FSearchEntryPoint) then
    TParameterReality.CopyWithClass(FSearchEntryPoint, Value);
end;

end.
