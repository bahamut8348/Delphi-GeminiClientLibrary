unit Models.EmbeddingsModelImplement;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Defaults, System.Generics.Collections,
  System.Rtti, System.JSON, System.TypInfo, System.ObjAuto,
  Models.GeminiBasedModelStatement, Models.GeminiBasedModelImplement,
  Parameters.BasedParameterImplement,
  Parameters.Content, Parameters.Part,
  Parameters.EmbedContentRequestBody, Parameters.EmbedContentResponseBody,
  Parameters.EmbedContentRequest,
  Parameters.BatchEmbedContentsRequestBody, Parameters.BatchEmbedContentsResponseBody,
  Parameters.InputEmbedContentConfig, Parameters.InputConfig, Parameters.Operation,
  Parameters.AsyncBatchEmbedContentRequestBody,
  Parameters.BatchGenerateContentRequestBody;

type
{
  https://ai.google.dev/api/embeddings
  嵌入是文本输入的数值表示形式，可实现许多独特的应用场景，例如聚类、相似度衡量和信息检索。如需了解相关简介，请参阅嵌入指南。
}
  TEmbeddingsModelReality = class(TGeminiModelReality)
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
    // https://ai.google.dev/api/embeddings#v1beta.models.embedContent
    // POST /v1beta/{model=models/*}:embedContent
    // Generates a text embedding vector from the input Content using the specified <a href="https://ai.google.dev/gemini-api/docs/models/gemini#text-embedding">Gemini Embedding model</a>.
    function EmbedContent(const szPartText: String;
      const szTaskType: String = ''; const szTitle: String = '';
      const nOutputDimensionality: Integer = 0): TEmbedContentResponseBody;

    // https://ai.google.dev/api/embeddings#v1beta.models.batchEmbedContents
    // POST /v1beta/{model=models/*}:batchEmbedContents
    // Generates multiple embedding vectors from the input Content which consists of a batch of strings represented as EmbedContentRequest objects.
    function BatchEmbedContents(const pRequests: TArray<TEmbedContentRequest>): TBatchEmbedContentsResponseBody; stdcall;

    // https://ai.google.dev/api/embeddings#v1beta.models.asyncBatchEmbedContent
    // POST /v1beta/{batch.model=models/*}:asyncBatchEmbedContent
    // Enqueues a batch of EmbedContent requests for batch processing.
    function AsyncBatchEmbedContent(const szDisplayName: String;
      pInputConfig: TInputEmbedContentConfig): TOperation;

    // https://ai.google.dev/api/batch-api#v1beta.models.batchGenerateContent
    // POST /v1beta/{batch.model=models/*}:batchGenerateContent
    // Enqueues a batch of GenerateContent requests for batch processing.
    function BatchGenerateContent(const szDisplayName: String;
      const pInputConfig: TInputConfig): TOperation;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType, Constants.ContentType, Constants.RequestMethod,
  Functions.StringsUtils, Functions.SystemExtended;

{ TEmbeddingsModelReality }

function TEmbeddingsModelReality.AsyncBatchEmbedContent(const szDisplayName: String;
  pInputConfig: TInputEmbedContentConfig): TOperation;
var
  szRequestContent: AnsiString;
  pRequestBody: TAsyncBatchEmbedContentRequestBody;
begin
  Result := nil;

  // 请求参数
  pRequestBody := TAsyncBatchEmbedContentRequestBody.CreateWith(szDisplayName, pInputConfig);
  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_POST, // 请求方式
    pRequestBody, // 请求数据
    Self.GetPostRequestHeader(), // 自定义请求头
    Self.GetModelName(), // 模块名
    'asyncBatchEmbedContent' // 方法名
  );

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

  SafeFreeAndNil(pRequestBody);
  szRequestContent := '';
end;

function TEmbeddingsModelReality.BatchEmbedContents(const pRequests: TArray<TEmbedContentRequest>): TBatchEmbedContentsResponseBody;
var
  szRequestContent: AnsiString;
  pRequestBody: TBatchEmbedContentsRequestBody;
begin
  Result := nil;

  // 请求参数
  pRequestBody := TBatchEmbedContentsRequestBody.CreateWith(pRequests);
  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_POST, // 请求方式
    pRequestBody, // 请求数据
    Self.GetPostRequestHeader(), // 自定义请求头
    Self.GetModelName(), // 模块名
    'batchEmbedContents' // 方法名
  );

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TBatchEmbedContentsResponseBody.Create();
    if not Result.Parse(StringValueS(szRequestContent)) then
    begin
      SafeFreeAndNil(Result);
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
  end;

  SafeFreeAndNil(pRequestBody);
  szRequestContent := '';
end;

function TEmbeddingsModelReality.BatchGenerateContent(
  const szDisplayName: String; const pInputConfig: TInputConfig): TOperation;
var
  szRequestContent: AnsiString;
  pRequestBody: TBatchGenerateContentRequestBody;
begin
  Result := nil;

  // 请求参数
  pRequestBody := TBatchGenerateContentRequestBody.CreateWith(szDisplayName, pInputConfig);

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_POST, // 请求方式
    pRequestBody, // 请求数据
    Self.GetPostRequestHeader(), // 自定义请求头
    Self.GetModelName(), // 模块名
    'batchGenerateContent' // 方法名
  );

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

  SafeFreeAndNil(pRequestBody);
  szRequestContent := '';
end;

constructor TEmbeddingsModelReality.Create();
begin
  inherited Create();
  Self.SetModelPath('models');
end;

destructor TEmbeddingsModelReality.Destroy();
begin
  inherited Destroy();
end;

function TEmbeddingsModelReality.EmbedContent(const szPartText, szTaskType, szTitle: String;
  const nOutputDimensionality: Integer): TEmbedContentResponseBody;
var
  szRequestContent: AnsiString;
  pRequestBody: TEmbedContentRequestBody;
begin
  Result := nil;

  // 请求参数
  pRequestBody := TEmbedContentRequestBody.CreateWith(szPartText);
  pRequestBody.taskType := szTaskType;
  pRequestBody.title := szTitle;
  pRequestBody.outputDimensionality := nOutputDimensionality;

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_POST, // 请求方式
    pRequestBody, // 请求数据
    Self.GetPostRequestHeader(), // 自定义请求头
    Self.GetModelName(), // 模块名
    'embedContent' // 方法名
  );

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TEmbedContentResponseBody.Create();
    if not Result.Parse(StringValueS(szRequestContent)) then
    begin
      SafeFreeAndNil(Result);
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
  end;

  SafeFreeAndNil(pRequestBody);
  szRequestContent := '';
end;

end.

