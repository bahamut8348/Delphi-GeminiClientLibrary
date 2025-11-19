unit Parameters.Chunk;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.ChunkData, Parameters.CustomMetadata;

type
  TChunk = class(TParameterReality)
  private
    { private declarations }
    FData: TChunkData;
    FName: String;
    FCustomMetadata: TArray<TCustomMetadata>;
    FCreateTime: String; // (Timestamp format)
    FUpdateTime: String; // (Timestamp format)
    FState: String;
    procedure SetCustomMetadata(const Value: TArray<TCustomMetadata>);
    procedure SetData(const Value: TChunkData);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // The content for the Chunk, such as the text string. The maximum number of tokens per chunk is 2043.
    property data: TChunkData read FData write SetData;
    // The Chunk resource name.
    property name: String read FName write FName;
    // User provided custom metadata stored as key-value pairs. The maximum number of CustomMetadata per chunk is 20.
    property customMetadata: TArray<TCustomMetadata> read FCustomMetadata write SetCustomMetadata;
    // The Timestamp of when the Chunk was created.
    property createTime: String read FCreateTime write FCreateTime; // (Timestamp format)
    // The Timestamp of when the Chunk was last updated.
    property updateTime: String read FUpdateTime write FUpdateTime; // (Timestamp format)
    // Current state of the Chunk.
    //
    // STATE_UNSPECIFIED = 'STATE_UNSPECIFIED';
    // STATE_PENDING_PROCESSING = 'STATE_PENDING_PROCESSING';
    // STATE_ACTIVE = 'STATE_ACTIVE';
    // STATE_FAILED = 'STATE_FAILED';
    property state: String read FState write FState;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType,
  Functions.SystemExtended;

{ TChunk }

constructor TChunk.Create();
begin
  inherited Create();
  Self.FData := nil;
  Self.FName := '';
  SetLength(Self.FCustomMetadata, 0);
  Self.FCreateTime := '';
  Self.FUpdateTime := '';
  Self.FState := GEMINI_CHUNK_STATE_UNSPECIFIED;
end;

destructor TChunk.Destroy();
begin
  Self.FState := '';
  Self.FUpdateTime := '';
  Self.FCreateTime := '';
  TParameterReality.ReleaseArray<TCustomMetadata>(Self.FCustomMetadata);
  Self.FName := '';
  SafeFreeAndNil(Self.FData);
  inherited Destroy();
end;

function TChunk.GetMemberValue(var sName: String; out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TChunk.SetCustomMetadata(const Value: TArray<TCustomMetadata>);
begin
  TParameterReality.CopyArrayWithClass<TCustomMetadata>(Self.FCustomMetadata, Value);
end;

procedure TChunk.SetData(const Value: TChunkData);
begin
  if (Value <> FData) then
    TParameterReality.CopyWithClass(Self.FData, Value);
end;

function TChunk.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'data') then
  begin
    TParameterReality.CopyWithJson(Self.FData, TChunkData, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'customMetadata') then
  begin
    TParameterReality.CopyArrayWithJson<TCustomMetadata>(Self.FCustomMetadata, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
