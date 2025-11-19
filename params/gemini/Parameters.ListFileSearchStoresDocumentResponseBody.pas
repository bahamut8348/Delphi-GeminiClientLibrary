unit Parameters.ListFileSearchStoresDocumentResponseBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.Document;

type
{
  https://ai.google.dev/api/file-search/documents#response-body_2
  来自 documents.list 的响应，包含分页的 Document 列表。Document 按升序 document.create_time 排序。
}
  TListFileSearchStoresDocumentResponseBody = class(TParameterReality)
  private
    { private declarations }
    FDocuments: TArray<TDocument>;
    FNextPageToken: String;
    procedure SetDocuments(const Value: TArray<TDocument>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 返回的 Document。
    property documents: TArray<TDocument> read FDocuments write SetDocuments;
    // 可作为 pageToken 发送并用于检索下一页的令牌。如果省略此字段，则没有更多页面。
    property nextPageToken: String read FNextPageToken write FNextPageToken;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    function ExtractDocument(const nIndex: Integer): TDocument; inline;
    function ExtractDocuments(): TArray<TDocument>; inline;
  published
    { published declarations }
  end;

implementation

{ TListFileSearchStoresDocumentResponseBody }

constructor TListFileSearchStoresDocumentResponseBody.Create();
begin
  inherited Create();
  SetLength(Self.FDocuments, 0);
  Self.FNextPageToken := '';
end;

destructor TListFileSearchStoresDocumentResponseBody.Destroy();
begin
  Self.FNextPageToken := '';
  TParameterReality.ReleaseArray<TDocument>(Self.FDocuments);
  inherited Destroy();
end;

function TListFileSearchStoresDocumentResponseBody.ExtractDocument(
  const nIndex: Integer): TDocument;
var
  nLength: Integer;
begin
  Result := nil;
  if (nIndex < Low(Self.FDocuments)) or (nIndex > High(Self.FDocuments)) then
    Exit;

  nLength := Length(Self.FDocuments);
  Result := Self.FDocuments[nIndex];
  Self.FDocuments[nIndex] := nil;
  Dec(nLength);
  if (nIndex < nLength) then
    Move(Self.FDocuments[nIndex + 1], Self.FDocuments[nIndex], (nLength - nIndex) * SizeOf(TDocument));
  SetLength(Self.FDocuments, nLength);
end;

function TListFileSearchStoresDocumentResponseBody.ExtractDocuments(): TArray<TDocument>;
begin
  Result := Self.FDocuments;
  Self.FDocuments := [];
end;

function TListFileSearchStoresDocumentResponseBody.GetMemberValue(
  var sName: String; out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TListFileSearchStoresDocumentResponseBody.SetDocuments(
  const Value: TArray<TDocument>);
begin
  TParameterReality.CopyArrayWithClass<TDocument>(FDocuments, Value);
end;

function TListFileSearchStoresDocumentResponseBody.SetMemberValue(
  const sName: String; const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'documents') then
  begin
    TParameterReality.CopyArrayWithJson<TDocument>(Self.FDocuments, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
