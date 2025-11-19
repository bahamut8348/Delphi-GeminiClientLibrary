unit Applications.Gemini;

interface

uses
  System.Rtti, System.TypInfo,
  Applications.GeminiBasedApplicationImplement,
  Models.BasedModelImplement, Models.GeminiBasedModelImplement,

  Models.BatchesModelImplement,
  Models.CachedContentsModelImplement,
  Models.EmbeddingsModelImplement,
  Models.FileSearchStoresModelImplement,
  Models.FilesModelImplement,
  Models.GenerativeModelImplement,
  Models.ModelsModelImplement;

type
  TGemini = class(TGeminiBasedApplication)
  private
    { private declarations }
    FBatchesModel: TBatchesModelReality;
    FCachedContentsModel: TCachedContentsModelReality;
    FEmbeddingModel: TEmbeddingsModelReality;
    FFileSearchStoresModel: TFileSearchStoresModelReality;
    FFileSearchStoresDocumentsModel: TFileSearchStoresDocumentsModelReality;
    FFileSearchStoresOperationsModel: TFileSearchStoresOperationsModelReality;
    FFileSearchStoresUploadOperationsModel: TFileSearchStoresUploadOperationsModelReality;
    FFilesModel: TFilesModelReality;
    FGenerativeModel: TGenerativeModelReality;
    FModelsModel: TModelsModelReality;

    function ModelNeeded(const pModel: TGeminiModelReality; const pTypeInfo: Pointer;
      const szModelPath, szModelName: String): TGeminiModelReality;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    function BatchesModel(): TBatchesModelReality;
    function CachedContentsModel(): TCachedContentsModelReality;
    function EmbeddingModel(const szModelName: String): TEmbeddingsModelReality;
    function FileSearchStoresModel(): TFileSearchStoresModelReality;
    function FileSearchStoresDocumentsModel(): TFileSearchStoresDocumentsModelReality;
    function FileSearchStoresOperationsModel(): TFileSearchStoresOperationsModelReality;
    function FileSearchStoresUploadOperationsModel(): TFileSearchStoresUploadOperationsModelReality;
    function FilesModel(): TFilesModelReality;
    function GenerativeModel(const szModelName: String): TGenerativeModelReality;
    function ModelsModel(): TModelsModelReality;
  published
    { published declarations }
  end;

implementation

uses
  Functions.StringsUtils,
  Functions.SystemExtended;

{ TGemini }

function TGemini.BatchesModel(): TBatchesModelReality;
begin
  FBatchesModel := Self.ModelNeeded(FBatchesModel,
    System.TypeInfo(TBatchesModelReality),
    'batches', '') as TBatchesModelReality;
  Result := FBatchesModel;
end;

function TGemini.CachedContentsModel(): TCachedContentsModelReality;
begin
  FCachedContentsModel := Self.ModelNeeded(FCachedContentsModel,
    System.TypeInfo(TCachedContentsModelReality),
    'cachedContents', '') as TCachedContentsModelReality;
  Result := FCachedContentsModel;
end;

constructor TGemini.Create();
begin
  inherited Create();
  Self.FBatchesModel := nil;
  Self.FCachedContentsModel := nil;
  Self.FEmbeddingModel := nil;
  Self.FFileSearchStoresModel := nil;
  Self.FFileSearchStoresDocumentsModel := nil;
  Self.FFileSearchStoresOperationsModel := nil;
  Self.FFileSearchStoresUploadOperationsModel := nil;
  Self.FFilesModel := nil;
  Self.FGenerativeModel := nil;
  Self.FModelsModel := nil;
end;

destructor TGemini.Destroy();
begin
  SafeFreeAndNil(Self.FModelsModel);
  SafeFreeAndNil(Self.FGenerativeModel);
  SafeFreeAndNil(Self.FFilesModel);
  SafeFreeAndNil(Self.FFileSearchStoresUploadOperationsModel);
  SafeFreeAndNil(Self.FFileSearchStoresOperationsModel);
  SafeFreeAndNil(Self.FFileSearchStoresDocumentsModel);
  SafeFreeAndNil(Self.FFileSearchStoresModel);
  SafeFreeAndNil(Self.FEmbeddingModel);
  SafeFreeAndNil(Self.FCachedContentsModel);
  SafeFreeAndNil(Self.FBatchesModel);
  inherited Destroy();
end;

function TGemini.EmbeddingModel(const szModelName: String): TEmbeddingsModelReality;
begin
  FEmbeddingModel := Self.ModelNeeded(FEmbeddingModel,
    System.TypeInfo(TEmbeddingsModelReality),
    'models', szModelName) as TEmbeddingsModelReality;
  Result := FEmbeddingModel;
end;

function TGemini.FileSearchStoresDocumentsModel(): TFileSearchStoresDocumentsModelReality;
begin
  FFileSearchStoresDocumentsModel := Self.ModelNeeded(FFileSearchStoresDocumentsModel,
    System.TypeInfo(TFileSearchStoresDocumentsModelReality),
    'fileSearchStores', '') as TFileSearchStoresDocumentsModelReality;
  Result := FFileSearchStoresDocumentsModel;
end;

function TGemini.FileSearchStoresModel(): TFileSearchStoresModelReality;
begin
  FFileSearchStoresModel := Self.ModelNeeded(FFileSearchStoresModel,
    System.TypeInfo(TFileSearchStoresModelReality),
    'fileSearchStores', '') as TFileSearchStoresModelReality;
  Result := FFileSearchStoresModel;
end;

function TGemini.FileSearchStoresOperationsModel(): TFileSearchStoresOperationsModelReality;
begin
  FFileSearchStoresOperationsModel := Self.ModelNeeded(FFileSearchStoresOperationsModel,
    System.TypeInfo(TFileSearchStoresOperationsModelReality),
    'fileSearchStores', '') as TFileSearchStoresOperationsModelReality;
  Result := FFileSearchStoresOperationsModel;
end;

function TGemini.FileSearchStoresUploadOperationsModel(): TFileSearchStoresUploadOperationsModelReality;
begin
  FFileSearchStoresUploadOperationsModel := Self.ModelNeeded(FFileSearchStoresUploadOperationsModel,
    System.TypeInfo(TFileSearchStoresUploadOperationsModelReality),
    'fileSearchStores', '') as TFileSearchStoresUploadOperationsModelReality;
  Result := FFileSearchStoresUploadOperationsModel;
end;

function TGemini.FilesModel(): TFilesModelReality;
begin
  FFilesModel := Self.ModelNeeded(FFilesModel,
    System.TypeInfo(TFilesModelReality),
    'files', '') as TFilesModelReality;
  Result := FFilesModel;
end;

function TGemini.GenerativeModel(const szModelName: String): TGenerativeModelReality;
begin
  FGenerativeModel := Self.ModelNeeded(FGenerativeModel,
    System.TypeInfo(TGenerativeModelReality),
    'models', szModelName) as TGenerativeModelReality;
  Result := FGenerativeModel;
end;

function TGemini.ModelNeeded(const pModel: TGeminiModelReality; const pTypeInfo: Pointer;
  const szModelPath, szModelName: String): TGeminiModelReality;
begin
  if (nil = pModel) then
    Result := TModelReality.CreateWithTypeInfo(pTypeInfo) as TGeminiModelReality
  else
    Result := pModel;

  if (nil = Result) then
    Exit;

  Result.SetProxyAddress(AnsiStringValue(Self.GetProxyAddress()));
  Result.SetProxyUsername(AnsiStringValue(Self.GetProxyUsername()));
  Result.SetProxyPassword(AnsiStringValue(Self.GetProxyPassword()));
  Result.SetApiBaseUrl(Self.GetApiBaseUrl());
  Result.SetApiVersion(Self.GetApiVersion());
  Result.SetApiKey(Self.GetApiKey());
  Result.SetModelPath(szModelPath);
  Result.SetModelName(szModelName);
end;

function TGemini.ModelsModel(): TModelsModelReality;
begin
  FModelsModel := Self.ModelNeeded(FModelsModel,
    System.TypeInfo(TModelsModelReality),
    'models', '') as TModelsModelReality;
  Result := FModelsModel;
end;

end.

