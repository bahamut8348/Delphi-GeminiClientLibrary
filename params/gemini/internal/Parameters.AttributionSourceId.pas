unit Parameters.AttributionSourceId;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.GroundingPassageId,
  Parameters.SemanticRetrieverChunk;

type
{
  https://ai.google.dev/api/generate-content#AttributionSourceId
  促成相应归因的来源的标识符。
}
  TAttributionSourceId = class(TParameterReality)
  private
    { private declarations }

    // 联合字段的序号，source 只允许存在一种值，如果全部都赋值发送给接口会返回错误。
    FUnionProperty: (upGroundingPassage, upSemanticRetrieverChunk, upOther);

    FGroundingPassage: TGroundingPassageId;
    FSemanticRetrieverChunk: TSemanticRetrieverChunk;

    procedure SetGroundingPassage(const Value: TGroundingPassageId);
    procedure SetSemanticRetrieverChunk(const Value: TSemanticRetrieverChunk);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    { Union type source start }
    // source 只能是下列其中一项：
    // 内嵌段落的标识符。
    property groundingPassage: TGroundingPassageId read FGroundingPassage write SetGroundingPassage;
    // 通过语义检索器提取的 Chunk 的标识符。
    property semanticRetrieverChunk: TSemanticRetrieverChunk read FSemanticRetrieverChunk write SetSemanticRetrieverChunk;
    { Union type $source end }
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

{ TAttributionSourceId }

constructor TAttributionSourceId.Create();
begin
  inherited Create();
  Self.FUnionProperty := upGroundingPassage;
  Self.FGroundingPassage := nil;
  Self.FSemanticRetrieverChunk := nil;
end;

destructor TAttributionSourceId.Destroy();
begin
  SafeFreeAndNil(Self.FSemanticRetrieverChunk);
  SafeFreeAndNil(Self.FGroundingPassage);
  Self.FUnionProperty := upOther;
  inherited Destroy();
end;

function TAttributionSourceId.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  if SameText(sName, 'groundingPassage') then
  begin
    if (upGroundingPassage = FUnionProperty) then
      pValue := TValue.From(Self.FGroundingPassage)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'semanticRetrieverChunk') then
  begin
    if (upSemanticRetrieverChunk = FUnionProperty) then
      pValue := TValue.From(Self.FSemanticRetrieverChunk)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else
    Result := inherited GetMemberValue(sName, pValue);
end;

procedure TAttributionSourceId.SetGroundingPassage(
  const Value: TGroundingPassageId);
begin
  FUnionProperty := upGroundingPassage; // GroundingPassage 属性有效
  if (Value <> FGroundingPassage) then
    TParameterReality.CopyWithClass(FGroundingPassage, Value);
end;

function TAttributionSourceId.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'groundingPassage') then
  begin
    FUnionProperty := upGroundingPassage; // GroundingPassage 属性有效
    TParameterReality.CopyWithJson(Self.FGroundingPassage, TGroundingPassageId, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'semanticRetrieverChunk') then
  begin
    FUnionProperty := upSemanticRetrieverChunk; // SemanticRetrieverChunk 属性有效
    TParameterReality.CopyWithJson(Self.FSemanticRetrieverChunk, TSemanticRetrieverChunk, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TAttributionSourceId.SetSemanticRetrieverChunk(
  const Value: TSemanticRetrieverChunk);
begin
  FUnionProperty := upSemanticRetrieverChunk; // SemanticRetrieverChunk 属性有效
  if (Value <> FSemanticRetrieverChunk) then
    TParameterReality.CopyWithClass(FSemanticRetrieverChunk, Value);
end;

initialization
  //RegisterClass
finalization

end.
