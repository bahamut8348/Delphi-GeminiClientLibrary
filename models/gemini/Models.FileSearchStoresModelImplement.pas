unit Models.FileSearchStoresModelImplement;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Defaults, System.Generics.Collections,
  System.Rtti, System.JSON, System.TypInfo, System.ObjAuto,
  Models.BasedModelStatement, Models.BasedModelImplement,
  Models.GeminiBasedModelStatement, Models.GeminiBasedModelImplement,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.FileSearchStore,
  Parameters.CustomMetadata, Parameters.ChunkingConfig, Parameters.Operation,
  Parameters.ImportFileRequestBody, Parameters.ListFileSearchStoresResponseBody,
  Parameters.UploadToFileSearchStoreRequestBody, Parameters.UploadToFileSearchStoreResponseBody,
  Parameters.Document, Parameters.ListFileSearchStoresDocumentResponseBody,
  Parameters.MetadataFilter,
  Parameters.QueryFileSearchStoresDocumentsRequestBody, Parameters.QueryFileSearchStoresDocumentsResponseBody;

type
{
  https://ai.google.dev/api/file-search/file-search-stores
  File Search API 提供托管的问答服务，用于使用 Google 的基础架构构建检索增强生成 (RAG) 系统。
}
  TFileSearchStoresModelReality = class(TGeminiModelReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  public
    { public declarations }
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.create
    // POST /v1beta/fileSearchStores
    // Creates an empty FileSearchStore.
    function CreateNew(const szDisplayName: String): TFileSearchStore;
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.delete
    // DELETE /v1beta/{name=fileSearchStores/*}
    // Deletes a FileSearchStore.
    function Delete(const szFileSearchStoresName: String; const bForce: Boolean = FALSE): Boolean;
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.get
    // GET /v1beta/{name=fileSearchStores/*}
    // Gets information about a specific FileSearchStore.
    function Get(const szDisplayName: String): TFileSearchStore;
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.importFile
    // POST /v1beta/{fileSearchStoreName=fileSearchStores/*}:importFile
    // Imports a File from File Service to a FileSearchStore.
    function ImportFile(const szFileSearchStoresName: String; const szFileName: String;
      const pCustomMetadata: TArray<TCustomMetadata>; const pChunkingConfig: TChunkingConfig): TOperation;
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.list
    // GET /v1beta/fileSearchStores
    // Lists all FileSearchStores owned by the user.
    function List(const nPageSize: Integer = 0; const szPageToken: String = '';
      const bAutoExpansion: Boolean = TRUE): TArray<TFileSearchStore>;


    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.media.uploadToFileSearchStore
    // POST /v1beta/{fileSearchStoreName=fileSearchStores/*}:uploadToFileSearchStore
    // POST /upload/v1beta/{fileSearchStoreName=fileSearchStores/*}:uploadToFileSearchStore
    // Uploads data to a FileSearchStore, preprocesses and chunks before storing it in a FileSearchStore Document.
    function UploadToFileSearchStore(const szFileSearchStoresName: String;
      const szDisplayName: String; const pCustomMetadata: TArray<TCustomMetadata>;
      const pChunkingConfig: TChunkingConfig; const szMimeType: String;
      const bUpdateIsRaw: Boolean = FALSE): TUploadToFileSearchStoreResponseBody;
  published
    { published declarations }
  end;

  TFileSearchStoresDocumentsModelReality = class(TGeminiModelReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  public
    { public declarations }
    // https://ai.google.dev/api/file-search/documents#v1beta.fileSearchStores.documents.delete
    // DELETE /v1beta/{name=fileSearchStores/*/documents/*}
    // Deletes a Document.
    function Delete(const szFileSearchStoresName: String;
      const szDocumentsName: String; const bForce: Boolean = FALSE): Boolean;
    // https://ai.google.dev/api/file-search/documents#v1beta.fileSearchStores.documents.get
    // GET /v1beta/{name=fileSearchStores/*/documents/*}
    // Gets information about a specific Document.
    function Get(const szFileSearchStoresName: String; const szDocumentsName: String): TDocument;
    // https://ai.google.dev/api/file-search/documents#v1beta.fileSearchStores.documents.list
    // GET /v1beta/{parent=fileSearchStores/*}/documents
    // Lists all Documents in a Corpus.
    function List(const szFileSearchStoresName: String; const nPageSize: Integer = 0;
      const szPageToken: String = ''; const bAutoExpansion: Boolean = TRUE): TArray<TDocument>;
    // https://ai.google.dev/api/file-search/documents#v1beta.fileSearchStores.documents.query
    // POST /v1beta/{name=fileSearchStores/*/documents/*}:query
    // Performs semantic search over a Document.
    function Query(const szFileSearchStoresName: String; const szDocumentsName: String;
      const szQuery: String; const nResultsCount: Integer;
      const pMetadataFilters: TArray<TMetadataFilter>): TQueryFileSearchStoresDocumentsResponseBody; stdcall;
  published
    { published declarations }
  end;

  TFileSearchStoresOperationsModelReality = class(TGeminiModelReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  public
    { public declarations }
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.operations.get
    // GET /v1beta/{name=fileSearchStores/*/operations/*}
    // Gets the latest state of a long-running operation.
    function Get(const szFileSearchStoresName: String; const szDocumentsName: String): TOperation;
  published
    { published declarations }
  end;

  TFileSearchStoresUploadOperationsModelReality = class(TGeminiModelReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  public
    { public declarations }
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.upload.operations.get
    // GET /v1beta/{name=fileSearchStores/*/upload/operations/*}
    // Gets the latest state of a long-running operation.
    function Get(const szFileSearchStoresName: String; const szDocumentsName: String): TOperation;
  published
    { published declarations }
  end;

implementation

uses
  Constants.ContentType, Constants.RequestMethod, Constants.HttpStatusCode,
  Functions.StringsUtils, Functions.SystemExtended;

{ TFileSearchStoresModelReality }

constructor TFileSearchStoresModelReality.Create();
begin
  inherited Create();
  Self.SetModelPath('fileSearchStores');
end;

function TFileSearchStoresModelReality.CreateNew(
  const szDisplayName: String): TFileSearchStore;
var
  pRequest: TFileSearchStore;
  szRequestContent: AnsiString;
begin
  Result := nil;
  pRequest := TFileSearchStore.CreateWith(szDisplayName);

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_POST, // 请求方式
    pRequest, // 请求参数
    Self.GetPostRequestHeader(), // 请求头
    '', // 模块名
    ''); // 方法名

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TFileSearchStore.Create();
    if not Result.Parse(StringValueS(szRequestContent)) then
    begin
      SafeFreeAndNil(Result);
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
  end;

  SafeFreeAndNil(pRequest);
  szRequestContent := '';
end;

function TFileSearchStoresModelReality.Delete(const szFileSearchStoresName: String;
  const bForce: Boolean): Boolean;
var
  szRequestAddress: String;
begin
  Result := FALSE;

  if ('' = szFileSearchStoresName) then
    szRequestAddress := Format('%s?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()),
      Self.GetApiKey()]) // GEMINI_API_KEY
  else
    szRequestAddress := Format('%s?key=%s', [
      Self.GetModelRequestAddress(szFileSearchStoresName),
      Self.GetApiKey()]); // GEMINI_API_KEY

  if (bForce) then
    szRequestAddress := Format('%s&force=true', [szRequestAddress])
  else
    szRequestAddress := Format('%s&force=false', [szRequestAddress]);

  Self.SendRequest(
    REQUESTMETHOD_HTTP_DELETE, // 请求方式
    AnsiStringValue(szRequestAddress)); // 请求地址

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TRUE;
  end;

  szRequestAddress := '';
end;

destructor TFileSearchStoresModelReality.Destroy();
begin
  inherited Destroy();
end;

function TFileSearchStoresModelReality.Get(const szDisplayName: String): TFileSearchStore;
var
  szRequestAddress, szRequestContent: AnsiString;
begin
  Result := nil;

  if ('' = szDisplayName) then
    szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()),
      Self.GetApiKey()])) // GEMINI_API_KEY
  else
    szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
      Self.GetModelRequestAddress(szDisplayName),
      Self.GetApiKey()])); // GEMINI_API_KEY

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_GET, // 请求方式
    szRequestAddress); // 请求地址

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TFileSearchStore.Create();
    if not Result.Parse(StringValueS(szRequestContent)) then
    begin
      SafeFreeAndNil(Result);
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
  end;

  szRequestContent := '';
  szRequestAddress := '';
end;

function TFileSearchStoresModelReality.ImportFile(const szFileSearchStoresName,
  szFileName: String; const pCustomMetadata: TArray<TCustomMetadata>;
  const pChunkingConfig: TChunkingConfig): TOperation;
var
  pRequest: TImportFileRequestBody;
  szRequestContent: AnsiString;
begin
  Result := nil;
  pRequest := TImportFileRequestBody.CreateWith(szFileName, pCustomMetadata, pChunkingConfig);

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_POST, // 请求方式
    pRequest, // 请求参数
    Self.GetPostRequestHeader(), // 请求头
    szFileSearchStoresName, // 模块名
    'importFile'); // 方法名

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TOperation.Create();
    if not Result.Parse(StringValueS(szRequestContent)) then
    begin
      SafeFreeAndNil(Result);
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
  end;

  SafeFreeAndNil(pRequest);
  szRequestContent := '';
end;

function TFileSearchStoresModelReality.List(const nPageSize: Integer;
  const szPageToken: String;
  const bAutoExpansion: Boolean): TArray<TFileSearchStore>;
var
  szAddress, szRequestAddress, szToken: String;
  szRequestContent: AnsiString;
  pResponseBody: TListFileSearchStoresResponseBody;
begin
  // 拼接请求地址
  if (0 = nPageSize) then
    szAddress := Format('%s?key=%s', [
      Self.GetModelRequestAddress(), // 请求地址
      Self.GetApiKey()]) // GEMINI_API_KEY
  else
    szAddress := Format('%s?key=%s&pageSize=%d', [
      Self.GetModelRequestAddress(), // 请求地址
      Self.GetApiKey(), // GEMINI_API_KEY
      nPageSize]);

  Result := []; //
  pResponseBody := TListFileSearchStoresResponseBody.Create(); // 响应对象
  szToken := Trim(szPageToken); // token
  repeat
    szRequestAddress := Format('%s&pageToken=%s', [szAddress, szToken]);
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_GET, // 请求方式
      AnsiStringValue(szRequestAddress) // 请求地址
    );

    // 请求失败，退出循环
    if (S_OK <> Self.GetLastErrorCode()) then
      Break;

    pResponseBody.nextPageToken := '';
    if not pResponseBody.Parse(StringValueS(szRequestContent)) then
    begin
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
      Break;
    end;

    szToken := pResponseBody.nextPageToken;
    Result := Result + pResponseBody.ExtractFileSearchStores();
  until (not bAutoExpansion) or ('' = szToken);

  szToken := '';
  szAddress := '';
  szRequestContent := '';
  szRequestAddress := '';
  SafeFreeAndNil(pResponseBody);
end;

function TFileSearchStoresModelReality.UploadToFileSearchStore(const szFileSearchStoresName, szDisplayName: String;
  const pCustomMetadata: TArray<TCustomMetadata>; const pChunkingConfig: TChunkingConfig;
  const szMimeType: String; const bUpdateIsRaw: Boolean): TUploadToFileSearchStoreResponseBody;
var
  szRequestAddress, szRequestContent: AnsiString;
  pRequest: TUploadToFileSearchStoreRequestBody;
begin
  Result := nil;
  pRequest := TUploadToFileSearchStoreRequestBody.CreateWith(szDisplayName, pCustomMetadata, pChunkingConfig, szMimeType);

  // 请求地址有两个：
  // 上传 URI，用于媒体上传请求：
  // POST https://generativelanguage.googleapis.com/upload/v1beta/{fileSearchStoreName=fileSearchStores/*}:uploadToFileSearchStore
  // 元数据 URI，用于仅涉及元数据的请求：
  // POST https://generativelanguage.googleapis.com/v1beta/{fileSearchStoreName=fileSearchStores/*}:uploadToFileSearchStore
  if (bUpdateIsRaw) then // 元数据
    szRequestAddress := Self.GetModelRequestAddress(Self.GetModelName(), 'uploadToFileSearchStore')
  else // 媒体
    szRequestAddress := AnsiStringValue(Format('%s/upload/%s/%s:uploadToFileSearchStore', [
      Self.GetApiBaseUrl(), Self.GetApiVersion(), Self.GetModelPath()]));

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_POST, // 请求方式
    szRequestAddress, // 请求地址
    pRequest, // 请求参数
    Self.GetPostRequestHeader()); // 请求头

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TUploadToFileSearchStoreResponseBody.Create();
    if not Result.Parse(StringValueS(szRequestContent)) then
    begin
      SafeFreeAndNil(Result);
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
  end;

  SafeFreeAndNil(pRequest);
  szRequestContent := '';
end;

{ TFileSearchStoresDocumentsModelReality }

constructor TFileSearchStoresDocumentsModelReality.Create();
begin
  inherited Create();
  Self.SetModelPath('fileSearchStores');
end;

function TFileSearchStoresDocumentsModelReality.Delete(const szFileSearchStoresName,
  szDocumentsName: String; const bForce: Boolean): Boolean;
var
  szRequestAddress: String;
begin
  Result := FALSE;

  if ('' = szFileSearchStoresName) then
    szRequestAddress := Format('%s/documents/%s?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()),
      szDocumentsName, Self.GetApiKey()]) // GEMINI_API_KEY
  else
    szRequestAddress := Format('%s/documents/%s?key=%s', [
      Self.GetModelRequestAddress(szFileSearchStoresName),
      szDocumentsName, Self.GetApiKey()]); // GEMINI_API_KEY

  if (bForce) then
    szRequestAddress := Format('%s&force=true', [szRequestAddress])
  else
    szRequestAddress := Format('%s&force=false', [szRequestAddress]);

  Self.SendRequest(
    REQUESTMETHOD_HTTP_DELETE, // 请求方式
    AnsiStringValue(szRequestAddress)); // 请求地址

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TRUE;
  end;

  szRequestAddress := '';
end;

destructor TFileSearchStoresDocumentsModelReality.Destroy();
begin
  inherited Destroy();
end;

function TFileSearchStoresDocumentsModelReality.Get(const szFileSearchStoresName,
  szDocumentsName: String): TDocument;
var
  szRequestAddress: String;
  szRequestContent: AnsiString;
begin
  Result := nil;

  if ('' = szFileSearchStoresName) then
    szRequestAddress := Format('%s/documents/%s?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()),
      szDocumentsName, Self.GetApiKey()]) // GEMINI_API_KEY
  else
    szRequestAddress := Format('%s/documents/%s?key=%s', [
      Self.GetModelRequestAddress(szFileSearchStoresName),
      szDocumentsName, Self.GetApiKey()]); // GEMINI_API_KEY

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_GET, // 请求方式
    AnsiStringValue(szRequestAddress)); // 请求地址

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TDocument.Create();
    if not Result.Parse(StringValueS(szRequestContent)) then
    begin
      SafeFreeAndNil(Result);
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
  end;

  szRequestContent := '';
  szRequestAddress := '';
end;

function TFileSearchStoresDocumentsModelReality.List(
  const szFileSearchStoresName: String; const nPageSize: Integer;
  const szPageToken: String; const bAutoExpansion: Boolean): TArray<TDocument>;
var
  szAddress, szRequestAddress, szToken: String;
  szRequestContent: AnsiString;
  pResponseBody: TListFileSearchStoresDocumentResponseBody;
begin
  // 拼接请求地址
  if ('' = szFileSearchStoresName) then
    szAddress := Format('%s/documents?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()),
      Self.GetApiKey()]) // GEMINI_API_KEY
  else
    szAddress := Format('%s/documents?key=%s', [
      Self.GetModelRequestAddress(szFileSearchStoresName),
      Self.GetApiKey()]); // GEMINI_API_KEY

  if (0 <> nPageSize) then
    szAddress := Format('%s&pageSize=%d', [szAddress, nPageSize]);

  Result := []; //
  pResponseBody := TListFileSearchStoresDocumentResponseBody.Create(); // 响应对象
  szToken := Trim(szPageToken); // token
  repeat
    szRequestAddress := Format('%s&pageToken=%s', [szAddress, szToken]);
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_GET, // 请求方式
      AnsiStringValue(szRequestAddress) // 请求地址
    );

    // 请求失败，退出循环
    if (S_OK <> Self.GetLastErrorCode()) then
      Break;

    pResponseBody.nextPageToken := '';
    if not pResponseBody.Parse(StringValueS(szRequestContent)) then
    begin
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
      Break;
    end;

    szToken := pResponseBody.nextPageToken;
    Result := Result + pResponseBody.ExtractDocuments();
  until (not bAutoExpansion) or ('' = szToken);

  szToken := '';
  szAddress := '';
  szRequestContent := '';
  szRequestAddress := '';
  SafeFreeAndNil(pResponseBody);
end;

function TFileSearchStoresDocumentsModelReality.Query(const szFileSearchStoresName,
  szDocumentsName, szQuery: String; const nResultsCount: Integer;
  const pMetadataFilters: TArray<TMetadataFilter>): TQueryFileSearchStoresDocumentsResponseBody;
var
  pRequest: TQueryFileSearchStoresDocumentsRequestBody;
  szRequestContent: AnsiString;
begin
  Result := nil;

  // 请求参数
  pRequest := TQueryFileSearchStoresDocumentsRequestBody.CreateWith(szQuery, nResultsCount, pMetadataFilters);
  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_POST, // 请求方式
    pRequest, // 请求数据
    Self.GetPostRequestHeader(), // 自定义请求头
    Format('%s/documents/%s', [szFileSearchStoresName, szDocumentsName]), // 模块名
    'query' // 方法名
  );

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TQueryFileSearchStoresDocumentsResponseBody.Create();
    if not Result.Parse(StringValueS(szRequestContent)) then
    begin
      SafeFreeAndNil(Result);
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
  end;

  SafeFreeAndNil(pRequest);
  szRequestContent := '';
end;

{ TFileSearchStoresOperationsModelReality }

constructor TFileSearchStoresOperationsModelReality.Create();
begin
  inherited Create();
  Self.SetModelPath('fileSearchStores');
end;

destructor TFileSearchStoresOperationsModelReality.Destroy();
begin
  inherited Destroy();
end;

function TFileSearchStoresOperationsModelReality.Get(const szFileSearchStoresName,
  szDocumentsName: String): TOperation;
var
  szRequestAddress: String;
  szRequestContent: AnsiString;
begin
  Result := nil;

  if ('' = szFileSearchStoresName) then
    szRequestAddress := Format('%s/operations/%s?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()),
      szDocumentsName, Self.GetApiKey()]) // GEMINI_API_KEY
  else
    szRequestAddress := Format('%s/operations/%s?key=%s', [
      Self.GetModelRequestAddress(szFileSearchStoresName),
      szDocumentsName, Self.GetApiKey()]); // GEMINI_API_KEY

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_GET, // 请求方式
    AnsiStringValue(szRequestAddress)); // 请求地址

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TOperation.Create();
    if not Result.Parse(StringValueS(szRequestContent)) then
    begin
      SafeFreeAndNil(Result);
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
  end;

  szRequestContent := '';
  szRequestAddress := '';
end;

{ TFileSearchStoresUploadOperationsModelReality }

constructor TFileSearchStoresUploadOperationsModelReality.Create();
begin
  inherited Create();
  Self.SetModelPath('fileSearchStores');
end;

destructor TFileSearchStoresUploadOperationsModelReality.Destroy();
begin
  inherited Destroy();
end;

function TFileSearchStoresUploadOperationsModelReality.Get(
  const szFileSearchStoresName, szDocumentsName: String): TOperation;
var
  szRequestAddress: String;
  szRequestContent: AnsiString;
begin
  Result := nil;

  if ('' = szFileSearchStoresName) then
    szRequestAddress := Format('%s/upload/operations/%s?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()),
      szDocumentsName, Self.GetApiKey()]) // GEMINI_API_KEY
  else
    szRequestAddress := Format('%s/upload/operations/%s?key=%s', [
      Self.GetModelRequestAddress(szFileSearchStoresName),
      szDocumentsName, Self.GetApiKey()]); // GEMINI_API_KEY

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_GET, // 请求方式
    AnsiStringValue(szRequestAddress)); // 请求地址

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TOperation.Create();
    if not Result.Parse(StringValueS(szRequestContent)) then
    begin
      SafeFreeAndNil(Result);
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
  end;

  szRequestContent := '';
  szRequestAddress := '';
end;

end.

