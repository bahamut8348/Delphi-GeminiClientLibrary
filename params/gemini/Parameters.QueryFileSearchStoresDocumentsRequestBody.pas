unit Parameters.QueryFileSearchStoresDocumentsRequestBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.MetadataFilter;

type
{
  https://ai.google.dev/api/file-search/documents#request-body_3
  fileSearchStores.documents.query 请求正文
}
  TQueryFileSearchStoresDocumentsRequestBody = class(TParameterReality)
  private
    { private declarations }
    FQuery: String;
    FResultsCount: Integer;
    FMetadataFilters: TArray<TMetadataFilter>;
    procedure SetMetadataFilters(const Value: TArray<TMetadataFilter>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。用于执行语义搜索的查询字符串。
    property query: String read FQuery write FQuery;
    // 可选。要返回的 Chunk 数量上限。服务返回的 Chunk 数量可能较少。
    // 如果未指定，则最多返回 10 个 Chunk。指定的结果数量上限为 100。
    property resultsCount: Integer read FResultsCount write FResultsCount;
    // 可选。过滤 Chunk 元数据。每个 MetadataFilter 对象都应对应一个唯一的键。多个 MetadataFilter 对象通过逻辑“AND”联接。
    // 注意：此请求不支持 Document 级过滤，因为已指定 Document 名称。
    // 查询示例：(year >= 2020 OR year < 2010) AND (genre = drama OR genre = action)
    // MetadataFilter object list: metadataFilters = [ {key = "chunk.custom_metadata.year" conditions = [{int_value = 2020, operation = GREATER_EQUAL}, {int_value = 2010, operation = LESS}}, {key = "chunk.custom_metadata.genre" conditions = [{stringValue = "drama", operation = EQUAL}, {stringValue = "action", operation = EQUAL}}]
    // 数值范围的查询示例：（year > 2015 AND year <= 2020）
    // MetadataFilter object list: metadataFilters = [ {key = "chunk.custom_metadata.year" conditions = [{int_value = 2015, operation = GREATER}]}, {key = "chunk.custom_metadata.year" conditions = [{int_value = 2020, operation = LESS_EQUAL}]}]
    // 注意：同一键的“AND”仅支持数值。字符串值仅支持同一键的“或”关系。
    property metadataFilters: TArray<TMetadataFilter> read FMetadataFilters write SetMetadataFilters;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const szQuery: String; const nResultsCount: Integer;
      const pMetadataFilters: TArray<TMetadataFilter>): TQueryFileSearchStoresDocumentsRequestBody; inline; static;
  published
    { published declarations }
  end;

implementation

{ TQueryFileSearchStoresDocumentsRequestBody }

constructor TQueryFileSearchStoresDocumentsRequestBody.Create();
begin
  inherited Create();
  Self.FQuery := '';
  Self.FResultsCount := 10;
  SetLength(Self.FMetadataFilters, 0);
end;

class function TQueryFileSearchStoresDocumentsRequestBody.CreateWith(
  const szQuery: String; const nResultsCount: Integer;
  const pMetadataFilters: TArray<TMetadataFilter>): TQueryFileSearchStoresDocumentsRequestBody;
begin
  Result := TQueryFileSearchStoresDocumentsRequestBody.Create();
  Result.query := szQuery;
  if (0 <> nResultsCount) then
    Result.resultsCount := nResultsCount;
  Result.metadataFilters := pMetadataFilters;
end;

destructor TQueryFileSearchStoresDocumentsRequestBody.Destroy();
begin
  TParameterReality.ReleaseArray<TMetadataFilter>(Self.FMetadataFilters);
  Self.FResultsCount := 0;
  Self.FQuery := '';
  inherited Destroy();
end;

function TQueryFileSearchStoresDocumentsRequestBody.GetMemberValue(
  var sName: String; out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TQueryFileSearchStoresDocumentsRequestBody.SetMemberValue(
  const sName: String; const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'metadataFilters') then
  begin
    TParameterReality.CopyArrayWithJson<TMetadataFilter>(Self.FMetadataFilters, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TQueryFileSearchStoresDocumentsRequestBody.SetMetadataFilters(
  const Value: TArray<TMetadataFilter>);
begin
  TParameterReality.CopyArrayWithClass<TMetadataFilter>(FMetadataFilters, Value);
end;

end.
