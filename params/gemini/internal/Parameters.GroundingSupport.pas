unit Parameters.GroundingSupport;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Segment;

type
{
  https://ai.google.dev/api/generate-content#GroundingSupport
  接地支持。
}
  TGroundingSupport = class(TParameterReality)
  private
    { private declarations }
    FSegment: TSegment;
    procedure SetSegment(const Value: TSegment);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 一个索引列表（指向“grounding_chunk”），用于指定与声明关联的引用。例如，[1,3,4] 表示 grounding_chunk[1]、grounding_chunk[3]、grounding_chunk[4] 是归因于相应声明的检索到的内容。
    groundingChunkIndices: TArray<Integer>;
    // 支持参考的置信度分数。范围为 0 到 1。1 表示最有信心。此列表的大小必须与 groundingChunkIndices 相同。
    confidenceScores: TArray<Double>;
    // 相应支持所涉及的内容片段。
    property segment: TSegment read FSegment write SetSegment;
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

{ TGroundingSupport }

constructor TGroundingSupport.Create();
begin
  inherited Create();
  SetLength(Self.groundingChunkIndices, 0);
  SetLength(Self.confidenceScores, 0);
  Self.FSegment := nil;
end;

destructor TGroundingSupport.Destroy();
begin
  SafeFreeAndNil(Self.FSegment);
  SetLength(Self.confidenceScores, 0);
  SetLength(Self.groundingChunkIndices, 0);
  inherited Destroy();
end;

function TGroundingSupport.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TGroundingSupport.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'groundingChunkIndices') then
  begin
    CopyIntArrayWithJson(Self.groundingChunkIndices, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'confidenceScores') then
  begin
    CopyDoubleArrayWithJson(Self.confidenceScores, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'segment') then
  begin
    TParameterReality.CopyWithJson(Self.FSegment, TSegment, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TGroundingSupport.SetSegment(const Value: TSegment);
begin
  if (Value <> FSegment) then
    TParameterReality.CopyWithClass(FSegment, Value);
end;

end.
