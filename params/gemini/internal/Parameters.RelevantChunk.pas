unit Parameters.RelevantChunk;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.Chunk;

type
  TRelevantChunk = class(TParameterReality)
  private
    { private declarations }
    FChunkRelevanceScore: Double;
    FChunk: TChunk;
    procedure SetChunk(const Value: TChunk);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // Chunk relevance to the query.
    property chunkRelevanceScore: Double read FChunkRelevanceScore write FChunkRelevanceScore;
    // Chunk associated with the query.
    property chunk: TChunk read FChunk write SetChunk;
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

{ TRelevantChunk }

constructor TRelevantChunk.Create();
begin
  inherited Create();
  Self.FChunkRelevanceScore := 0;
  Self.FChunk := nil;
end;

destructor TRelevantChunk.Destroy();
begin
  SafeFreeAndNil(Self.FChunk);
  Self.FChunkRelevanceScore := 0;
  inherited Destroy();
end;

function TRelevantChunk.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TRelevantChunk.SetChunk(const Value: TChunk);
begin
  if (Value <> FChunk) then
    TParameterReality.CopyWithClass(FChunk, Value);
end;

function TRelevantChunk.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'chunk') then
  begin
    TParameterReality.CopyWithJson(Self.FChunk, TChunk, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
