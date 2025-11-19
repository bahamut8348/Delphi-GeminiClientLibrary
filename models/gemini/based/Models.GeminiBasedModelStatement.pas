unit Models.GeminiBasedModelStatement;

interface

uses
  Models.BasedModelStatement;

type
{
  https://ai.google.dev/api/all-methods
  模块接口的基类接口
}
  IGeminiModelContract = interface(IModelContract)
    ['{413112A6-B1F8-4B11-BC59-D4DD5D9AC198}']
    // 获取 API KEY 【 https://ai.google.dev/gemini-api/docs/api-key 】
    function GetApiKey(): WideString; stdcall;
    // 获取 API 接口的基础地址 【 https://ai.google.dev/api/all-methods#service-endpoint 】
    function GetApiBaseUrl(): WideString; stdcall;
    // 获取 API 版本号 【 https://ai.google.dev/gemini-api/docs/api-versions 】
    function GetApiVersion(): WideString; stdcall;

    // 获取原始的响应数据
    function GetResponseData(): PAnsiChar; stdcall;
  end;

// base url:
// https://generativelanguage.googleapis.com

{
  REST Resource: v1beta.batches
  https://ai.google.dev/api/all-methods#rest-resource:-v1beta.batches
}
  IResourceBatchesContract = interface(IGeminiModelContract)
    ['{56D8AA1C-AE86-46D1-A925-6C5EFBC100F9}']
    // https://ai.google.dev/api/batch-api#v1beta.batches.cancel
    // POST /v1beta/{name=batches/*}:cancel
    // Starts asynchronous cancellation on a long-running operation.
    function cancel(): HRESULT; stdcall;
    // https://ai.google.dev/api/batch-api#v1beta.batches.delete
    // DELETE /v1beta/{name=batches/*}
    // Deletes a long-running operation.
    function delete(): HRESULT; stdcall;
    // https://ai.google.dev/api/batch-api#v1beta.batches.get
    // GET /v1beta/{name=batches/*}
    // Gets the latest state of a long-running operation.
    function get(): HRESULT; stdcall;
    // https://ai.google.dev/api/batch-api#v1beta.batches.list
    // GET /v1beta/{name=batches}
    // Lists operations that match the specified filter in the request.
    function list(): HRESULT; stdcall;
    // https://ai.google.dev/api/batch-api#v1beta.batches.updateEmbedContentBatch
    // PATCH /v1beta/{embedContentBatch.name=batches/*}:updateEmbedContentBatch
    // Updates a batch of EmbedContent requests for batch processing.
    function updateEmbedContentBatch(): HRESULT; stdcall;
    // https://ai.google.dev/api/batch-api#v1beta.batches.updateGenerateContentBatch
    // PATCH /v1beta/{generateContentBatch.name=batches/*}:updateGenerateContentBatch
    // Updates a batch of GenerateContent requests for batch processing.
    function updateGenerateContentBatch(): HRESULT; stdcall;
  end;

{
  REST Resource: v1beta.cachedContents
  https://ai.google.dev/api/all-methods#rest-resource:-v1beta.cachedcontents
}
  IResourceCachedContentsContract = interface(IGeminiModelContract)
    ['{1E5436FB-931C-47A3-BE4C-0C2E96EAB647}']
    // https://ai.google.dev/api/caching#v1beta.cachedContents.create
    // POST /v1beta/cachedContents
    // Creates CachedContent resource.
    function create(): HRESULT; stdcall;
    // https://ai.google.dev/api/caching#v1beta.cachedContents.delete
    // DELETE /v1beta/{name=cachedContents/*}
    // Deletes CachedContent resource.
    function delete(): HRESULT; stdcall;
    // https://ai.google.dev/api/caching#v1beta.cachedContents.get
    // GET /v1beta/{name=cachedContents/*}
    // Reads CachedContent resource.
    function get(): HRESULT; stdcall;
    // https://ai.google.dev/api/caching#v1beta.cachedContents.list
    // GET /v1beta/cachedContents
    // Lists CachedContents.
    function list(): HRESULT; stdcall;
    // https://ai.google.dev/api/caching#v1beta.cachedContents.patch
    // PATCH /v1beta/{cachedContent.name=cachedContents/*}
    // Updates CachedContent resource (only expiration is updatable).
    function patch(): HRESULT; stdcall;
  end;

{
  REST Resource: v1beta.fileSearchStores
  https://ai.google.dev/api/all-methods#rest-resource:-v1beta.filesearchstores
}
  IResourceFileSearchStoresContract = interface(IGeminiModelContract)
    ['{CCA4EE04-6950-4D5E-B210-76FE8A382D5A}']
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.create
    // POST /v1beta/fileSearchStores
    // Creates an empty FileSearchStore.
    function create(): HRESULT; stdcall;
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.delete
    // DELETE /v1beta/{name=fileSearchStores/*}
    // Deletes a FileSearchStore.
    function delete(): HRESULT; stdcall;
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.get
    // GET /v1beta/{name=fileSearchStores/*}
    // Gets information about a specific FileSearchStore.
    function get(): HRESULT; stdcall;
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.importFile
    // POST /v1beta/{fileSearchStoreName=fileSearchStores/*}:importFile
    // Imports a File from File Service to a FileSearchStore.
    function importFile(): HRESULT; stdcall;
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.list
    // GET /v1beta/fileSearchStores
    // Lists all FileSearchStores owned by the user.
    function list(): HRESULT; stdcall;
  end;

{
  REST Resource: v1beta.fileSearchStores.documents
  https://ai.google.dev/api/all-methods#rest-resource:-v1beta.filesearchstores.documents
}
  IResourceFileSearchStoresDocumentsContract = interface(IGeminiModelContract)
    ['{F42FDA01-D764-4178-BB27-6F2D84FF346F}']
    // https://ai.google.dev/api/file-search/documents#v1beta.fileSearchStores.documents.delete
    // DELETE /v1beta/{name=fileSearchStores/*/documents/*}
    // Deletes a Document.
    function delete(): HRESULT; stdcall;
    // https://ai.google.dev/api/file-search/documents#v1beta.fileSearchStores.documents.get
    // GET /v1beta/{name=fileSearchStores/*/documents/*}
    // Gets information about a specific Document.
    function get(): HRESULT; stdcall;
    // https://ai.google.dev/api/file-search/documents#v1beta.fileSearchStores.documents.list
    // GET /v1beta/{parent=fileSearchStores/*}/documents
    // Lists all Documents in a Corpus.
    function list(): HRESULT; stdcall;
    // https://ai.google.dev/api/file-search/documents#v1beta.fileSearchStores.documents.query
    // POST /v1beta/{name=fileSearchStores/*/documents/*}:query
    // Performs semantic search over a Document.
    function query(): HRESULT; stdcall;
  end;

{
  REST Resource: v1beta.fileSearchStores.operations
  https://ai.google.dev/api/all-methods#rest-resource:-v1beta.filesearchstores.operations
}
  IResourceFileSearchStoresOperationsContract = interface(IGeminiModelContract)
    ['{A0B30D3C-85A4-47FA-9631-34A958EC5AEB}']
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.operations.get
    // GET /v1beta/{name=fileSearchStores/*/operations/*}
    // Gets the latest state of a long-running operation.
    function get(): HRESULT; stdcall;
  end;

{
  REST Resource: v1beta.fileSearchStores.upload.operations
  https://ai.google.dev/api/all-methods#rest-resource:-v1beta.filesearchstores.upload.operations
}
  IResourceFileSearchStoresUploadOperationsContract = interface(IGeminiModelContract)
    ['{1E7471D7-F07D-47C7-82A1-AC1B5B2939C7}']
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.fileSearchStores.upload.operations.get
    // GET /v1beta/{name=fileSearchStores/*/upload/operations/*}
    // Gets the latest state of a long-running operation.
    function get(): HRESULT; stdcall;
  end;

{
  REST Resource: v1beta.files
  https://ai.google.dev/api/all-methods#rest-resource:-v1beta.files
}
  IResourceFielsContract = interface(IGeminiModelContract)
    ['{9F29B49D-4404-4AE3-8F6C-8CF5C904CCEE}']
    // https://ai.google.dev/api/files#v1beta.files.delete
    // DELETE /v1beta/{name=files/*}
    // Deletes the File.
    function delete(): HRESULT; stdcall;
    // https://ai.google.dev/api/files#v1beta.files.get
    // GET /v1beta/{name=files/*}
    // Gets the metadata for the given File.
    function get(): HRESULT; stdcall;
    // https://ai.google.dev/api/files#v1beta.files.list
    // GET /v1beta/files
    // Lists the metadata for Files owned by the requesting project.
    function list(): HRESULT; stdcall;
  end;

{
  REST Resource: v1beta.media
  https://ai.google.dev/api/all-methods#rest-resource:-v1beta.media
}
  IResourceMediaContract = interface(IGeminiModelContract)
    ['{FC5316FE-F5AF-403C-9B4D-E997EA3FF8FE}']
    // https://ai.google.dev/api/files#v1beta.media.upload
    // POST /v1beta/files
    // POST /upload/v1beta/files
    // Creates a File.
    function upload(): HRESULT; stdcall;
    // https://ai.google.dev/api/file-search/file-search-stores#v1beta.media.uploadToFileSearchStore
    // POST /v1beta/{fileSearchStoreName=fileSearchStores/*}:uploadToFileSearchStore
    // POST /upload/v1beta/{fileSearchStoreName=fileSearchStores/*}:uploadToFileSearchStore
    // Uploads data to a FileSearchStore, preprocesses and chunks before storing it in a FileSearchStore Document.
    function uploadToFileSearchStore(): HRESULT; stdcall;
  end;

{
  REST Resource: v1beta.models
  https://ai.google.dev/api/all-methods#rest-resource:-v1beta.models
}
  IResourceModelsContract = interface(IGeminiModelContract)
    ['{2AAE3684-7DB3-428D-87D2-73BE18A726CA}']
    // https://ai.google.dev/api/embeddings#v1beta.models.asyncBatchEmbedContent
    // POST /v1beta/{batch.model=models/*}:asyncBatchEmbedContent
    // Enqueues a batch of EmbedContent requests for batch processing.
    function asyncBatchEmbedContent(): HRESULT; stdcall;
    // https://ai.google.dev/api/embeddings#v1beta.models.batchEmbedContents
    // POST /v1beta/{model=models/*}:batchEmbedContents
    // Generates multiple embedding vectors from the input Content which consists of a batch of strings represented as EmbedContentRequest objects.
    function batchEmbedContents(): HRESULT; stdcall;
    // https://ai.google.dev/api/palm#v1beta.models.batchEmbedText
    // POST /v1beta/{model=models/*}:batchEmbedText
    // Generates multiple embeddings from the model given input text in a synchronous call.
    function batchEmbedText(): HRESULT; stdcall;
    // https://ai.google.dev/api/batch-api#v1beta.models.batchGenerateContent
    // POST /v1beta/{batch.model=models/*}:batchGenerateContent
    // Enqueues a batch of GenerateContent requests for batch processing.
    function batchGenerateContent(): HRESULT; stdcall;
    // https://ai.google.dev/api/palm#v1beta.models.countMessageTokens
    // POST /v1beta/{model=models/*}:countMessageTokens
    // Runs a model's tokenizer on a string and returns the token count.
    function countMessageTokens(): HRESULT; stdcall;
    // https://ai.google.dev/api/palm#v1beta.models.countTextTokens
    // POST /v1beta/{model=models/*}:countTextTokens
    // Runs a model's tokenizer on a text and returns the token count.
    function countTextTokens(): HRESULT; stdcall;
    // https://ai.google.dev/api/tokens#v1beta.models.countTokens
    // POST /v1beta/{model=models/*}:countTokens
    // Runs a model's tokenizer on input Content and returns the token count.
    function countTokens(): HRESULT; stdcall;
    // https://ai.google.dev/api/embeddings#v1beta.models.embedContent
    // POST /v1beta/{model=models/*}:embedContent
    // Generates a text embedding vector from the input Content using the specified <a href="https://ai.google.dev/gemini-api/docs/models/gemini#text-embedding">Gemini Embedding model</a>.
    function embedContent(): HRESULT; stdcall;
    // https://ai.google.dev/api/palm#v1beta.models.embedText
    // POST /v1beta/{model=models/*}:embedText
    // Generates an embedding from the model given an input message.
    function embedText(): HRESULT; stdcall;
    // https://ai.google.dev/api/generate-content#v1beta.models.generateContent
    // POST /v1beta/{model=models/*}:generateContent
    // Generates a model response given an input GenerateContentRequest.
    function generateContent(): HRESULT; stdcall;
    // https://ai.google.dev/api/palm#v1beta.models.generateMessage
    // POST /v1beta/{model=models/*}:generateMessage
    // Generates a response from the model given an input MessagePrompt.
    function generateMessage(): HRESULT; stdcall;
    // https://ai.google.dev/api/palm#v1beta.models.generateText
    // POST /v1beta/{model=models/*}:generateText
    // Generates a response from the model given an input message.
    function generateText(): HRESULT; stdcall;
    // https://ai.google.dev/api/models#v1beta.models.get
    // GET /v1beta/{name=models/*}
    // Gets information about a specific Model such as its version number, token limits, <a href="https://ai.google.dev/gemini-api/docs/models/generative-models#model-parameters">parameters</a> and other metadata.
    function get(): HRESULT; stdcall;
    // https://ai.google.dev/api/models#v1beta.models.list
    // GET /v1beta/models
    // Lists the <a href="https://ai.google.dev/gemini-api/docs/models/gemini">Models</a> available through the Gemini API.
    function list(): HRESULT; stdcall;
    // https://ai.google.dev/api/models#v1beta.models.predict
    // POST /v1beta/{model=models/*}:predict
    // Performs a prediction request.
    function predict(): HRESULT; stdcall;
    // https://ai.google.dev/api/models#v1beta.models.predictLongRunning
    // POST /v1beta/{model=models/*}:predictLongRunning
    // Same as Predict but returns an LRO.
    function predictLongRunning(): HRESULT; stdcall;
    // https://ai.google.dev/api/generate-content#v1beta.models.streamGenerateContent
    // POST /v1beta/{model=models/*}:streamGenerateContent
    // Generates a <a href="https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream">streamed response</a> from the model given an input GenerateContentRequest.
    function streamGenerateContent(): HRESULT; stdcall;
  end;

implementation

end.
