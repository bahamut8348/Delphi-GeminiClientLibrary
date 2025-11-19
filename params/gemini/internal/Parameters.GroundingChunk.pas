unit Parameters.GroundingChunk;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Web,
  Parameters.RetrievedContext, Parameters.Maps;

type
{
  https://ai.google.dev/api/generate-content#GroundingChunk
  接地块。
}
  TGroundingChunk = class(TParameterReality)
  private
    { private declarations }
    // 联合字段的序号，chunk_type 只允许存在一种值，如果全部都赋值发送给接口会返回错误。
    FUnionProperty: (upWeb, upRetrievedContext, upMaps, upOther);

    FWeb: TWeb;
    FRetrievedContext: TRetrievedContext;
    FMaps: TMaps;
    procedure SetMaps(const Value: TMaps);
    procedure SetRetrievedContext(const Value: TRetrievedContext);
    procedure SetWeb(const Value: TWeb);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    { Union type chunk_type start }
    // 分块类型。chunk_type 只能是下列其中一项：
    // 来自网络的接地块。
    property web: TWeb read FWeb write SetWeb;
    // 可选。通过文件搜索工具检索到的上下文中的标准答案块。
    property retrievedContext: TRetrievedContext read FRetrievedContext write SetRetrievedContext;
    // 可选。来自 Google 地图的接地块。
    property maps: TMaps read FMaps write SetMaps;
    { Union type chunk_type end }

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

{ TGroundingChunk }

constructor TGroundingChunk.Create();
begin
  inherited Create();
  Self.FUnionProperty := upWeb;
  Self.FWeb := nil;
  Self.FRetrievedContext := nil;
  Self.FMaps := nil;
end;

destructor TGroundingChunk.Destroy();
begin
  SafeFreeAndNil(Self.FMaps);
  SafeFreeAndNil(Self.FRetrievedContext);
  SafeFreeAndNil(Self.FWeb);
  Self.FUnionProperty := upOther;
  inherited Destroy();
end;

function TGroundingChunk.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  if SameText(sName, 'web') then
  begin
    if (upWeb = FUnionProperty) then
      pValue := TValue.From(FWeb)
    else
      pValue := TValue.Empty;
    Result := TRUE;
  end
  else if SameText(sName, 'retrievedContext') then
  begin
    if (upRetrievedContext = FUnionProperty) then
      pValue := TValue.From(FRetrievedContext)
    else
      pValue := TValue.Empty;
    Result := TRUE;
  end
  else if SameText(sName, 'maps') then
  begin
    if (upMaps = FUnionProperty) then
      pValue := TValue.From(FMaps)
    else
      pValue := TValue.Empty;
    Result := TRUE;
  end
  else
    Result := inherited GetMemberValue(sName, pValue);
end;

procedure TGroundingChunk.SetMaps(const Value: TMaps);
begin
  FUnionProperty := upMaps;
  if (Value <> FMaps) then
    TParameterReality.CopyWithClass(FMaps, Value);
end;

function TGroundingChunk.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'web') then
  begin
    FUnionProperty := upWeb;
    TParameterReality.CopyWithJson(FWeb, TWeb, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'retrievedContext') then
  begin
    FUnionProperty := upRetrievedContext;
    TParameterReality.CopyWithJson(FRetrievedContext, TRetrievedContext, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'maps') then
  begin
    FUnionProperty := upMaps;
    TParameterReality.CopyWithJson(FMaps, TMaps, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TGroundingChunk.SetRetrievedContext(const Value: TRetrievedContext);
begin
  FUnionProperty := upRetrievedContext;
  if (Value <> FRetrievedContext) then
    TParameterReality.CopyWithClass(FRetrievedContext, Value);
end;

procedure TGroundingChunk.SetWeb(const Value: TWeb);
begin
  FUnionProperty := upWeb;
  if (Value <> FWeb) then
    TParameterReality.CopyWithClass(FWeb, Value);
end;

end.
