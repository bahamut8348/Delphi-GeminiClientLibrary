unit Parameters.QueryFileSearchStoresDocumentsResponseBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.RelevantChunk;

type
{
  https://ai.google.dev/api/file-search/documents#response-body_3
  来自 documents.query 的响应，其中包含相关块的列表。
}
  TQueryFileSearchStoresDocumentsResponseBody = class(TParameterReality)
  private
    { private declarations }
    FRelevantChunks: TArray<TRelevantChunk>;
    procedure SetRelevantChunks(const Value: TArray<TRelevantChunk>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 返回的相关块。
    property relevantChunks: TArray<TRelevantChunk> read FRelevantChunks write SetRelevantChunks;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    function ExtractRelevantChunk(const nIndex: Integer): TRelevantChunk; inline;
    function ExtractRelevantChunks(): TArray<TRelevantChunk>; inline;
  published
    { published declarations }
  end;

implementation

{ TQueryFileSearchStoresDocumentsResponseBody }

constructor TQueryFileSearchStoresDocumentsResponseBody.Create();
begin
  inherited Create();
  SetLength(Self.FRelevantChunks, 0);
end;

destructor TQueryFileSearchStoresDocumentsResponseBody.Destroy();
begin
  TParameterReality.ReleaseArray<TRelevantChunk>(Self.FRelevantChunks);
  inherited Destroy();
end;

function TQueryFileSearchStoresDocumentsResponseBody.ExtractRelevantChunk(
  const nIndex: Integer): TRelevantChunk;
var
  nLength: Integer;
begin
  Result := nil;
  if (nIndex < Low(Self.FRelevantChunks)) or (nIndex > High(Self.FRelevantChunks)) then
    Exit;

  nLength := Length(Self.FRelevantChunks);
  Result := Self.FRelevantChunks[nIndex];
  Self.FRelevantChunks[nIndex] := nil;
  Dec(nLength);
  if (nIndex < nLength) then
    Move(Self.FRelevantChunks[nIndex + 1], Self.FRelevantChunks[nIndex], (nLength - nIndex) * SizeOf(TRelevantChunk));
  SetLength(Self.FRelevantChunks, nLength);
end;

function TQueryFileSearchStoresDocumentsResponseBody.ExtractRelevantChunks(): TArray<TRelevantChunk>;
begin
  Result := Self.FRelevantChunks;
  Self.FRelevantChunks := [];
end;

function TQueryFileSearchStoresDocumentsResponseBody.GetMemberValue(
  var sName: String; out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TQueryFileSearchStoresDocumentsResponseBody.SetMemberValue(
  const sName: String; const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'relevantChunks') then
  begin
    TParameterReality.CopyArrayWithJson<TRelevantChunk>(Self.FRelevantChunks, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TQueryFileSearchStoresDocumentsResponseBody.SetRelevantChunks(
  const Value: TArray<TRelevantChunk>);
begin
  TParameterReality.CopyArrayWithClass<TRelevantChunk>(Self.FRelevantChunks, Value);
end;

end.
