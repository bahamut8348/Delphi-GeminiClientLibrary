unit Models.BatchesModelImplement;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Defaults, System.Generics.Collections,
  System.Rtti, System.JSON, System.TypInfo, System.ObjAuto,
  Models.BasedModelStatement, Models.BasedModelImplement,
  Models.GeminiBasedModelStatement, Models.GeminiBasedModelImplement,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.Operation, Parameters.ListOperationsResponseBody,
  Parameters.InputConfig, Parameters.InputEmbedContentConfig,
  Parameters.EmbedContentBatch, Parameters.GenerateContentBatch;

type
{
  https://ai.google.dev/api/batch-api
  Gemini API 支持批处理 API，可让您在一次调用中处理多个请求。如需了解详情，请参阅 Batch API 指南。
}
  TBatchesModelReality = class(TGeminiModelReality)
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
    // https://ai.google.dev/api/batch-api#v1beta.batches.cancel
    // POST /v1beta/{name=batches/*}:cancel
    // Starts asynchronous cancellation on a long-running operation.
    function Cancel(const szBatchesName: String): Boolean;

    // https://ai.google.dev/api/batch-api#v1beta.batches.delete
    // DELETE /v1beta/{name=batches/*}
    // Deletes a long-running operation.
    function Delete(const szBatchesName: String): Boolean;

    // https://ai.google.dev/api/batch-api#v1beta.batches.get
    // GET /v1beta/{name=batches/*}
    // Gets the latest state of a long-running operation.
    function Get(const szBatchesName: String): TOperation;

    // https://ai.google.dev/api/batch-api#v1beta.batches.list
    // GET /v1beta/{name=batches}
    // Lists operations that match the specified filter in the request.
    function List(const szBatchesName: String;
      const szFilter: String = ''; const nPageSize: Integer = 0;
      const szPageToken: String = ''; const bReturnPartialSuccess: Boolean = TRUE;
      const bAutoExpansion: Boolean = TRUE): TArray<TOperation>;

    // https://ai.google.dev/api/batch-api#v1beta.batches.updateEmbedContentBatch
    // PATCH /v1beta/{embedContentBatch.name=batches/*}:updateEmbedContentBatch
    // Updates a batch of EmbedContent requests for batch processing.
    function UpdateEmbedContentBatch(const szBatchesName: String;
      const szUpdateMask: String; const szModelName, szDisplayName: String;
      const pInputConfig: TInputEmbedContentConfig; const szPriority: String): TEmbedContentBatch;

    // https://ai.google.dev/api/batch-api#v1beta.batches.updateGenerateContentBatch
    // PATCH /v1beta/{generateContentBatch.name=batches/*}:updateGenerateContentBatch
    // Updates a batch of GenerateContent requests for batch processing.
    function UpdateGenerateContentBatch(const szBatchesName: String;
      const szUpdateMask: String; const szModelName, szDisplayName: String;
      const pInputConfig: TInputconfig; const szPriority: String): TGenerateContentBatch;
  published
    { published declarations }
  end;

implementation

uses
  Constants.ContentType, Constants.RequestMethod, Constants.HttpStatusCode,
  Functions.StringsUtils, Functions.SystemExtended;

{ TBatchesModelReality }

function TBatchesModelReality.Cancel(const szBatchesName: String): Boolean;
begin
  Result := FALSE;

  if ('' = szBatchesName) then
    Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      '', // 请求参数
      Self.GetPostRequestHeader(), // 请求头
      Self.GetModelName(), // 批处理名为空时使用设置的 model 名作为批处理名
      'cancel') // 方法名
  else
    Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      '', // 请求参数
      Self.GetPostRequestHeader(), // 请求头
      szBatchesName, // 批处理名
      'cancel'); // 方法名

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TRUE;
  end;
end;

constructor TBatchesModelReality.Create();
begin
  inherited Create();
  Self.SetModelPath('batches');
end;

function TBatchesModelReality.Delete(const szBatchesName: String): Boolean;
var
  szRequestAddress: AnsiString;
begin
  Result := FALSE;

  if ('' = szBatchesName) then
    szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()),
      Self.GetApiKey()])) // GEMINI_API_KEY
  else
    szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
      Self.GetModelRequestAddress(szBatchesName),
      Self.GetApiKey()])); // GEMINI_API_KEY

  Self.SendRequest(
    REQUESTMETHOD_HTTP_DELETE, // 请求方式
    szRequestAddress); // 请求地址

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TRUE;
  end;

  szRequestAddress := '';
end;

destructor TBatchesModelReality.Destroy();
begin
  inherited Destroy();
end;

function TBatchesModelReality.Get(const szBatchesName: String): TOperation;
var
  szRequestAddress, szRequestContent: AnsiString;
begin
  Result := nil;

  if ('' = szBatchesName) then
    szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()),
      Self.GetApiKey()])) // GEMINI_API_KEY
  else
    szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
      Self.GetModelRequestAddress(szBatchesName),
      Self.GetApiKey()])); // GEMINI_API_KEY

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_GET, // 请求方式
    szRequestAddress); // 请求地址

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

function TBatchesModelReality.List(const szBatchesName, szFilter: String;
  const nPageSize: Integer; const szPageToken: String;
  const bReturnPartialSuccess,
  bAutoExpansion: Boolean): TArray<TOperation>;
var
  szAddress, szRequestAddress, szToken: String;
  szRequestContent: AnsiString;
  pResponseBody: TListOperationsResponseBody;
begin
  // 拼接请求地址
  if ('' = szBatchesName) then
    szAddress := Format('%s?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()), // 请求地址
      Self.GetApiKey()]) // GEMINI_API_KEY
  else
    szAddress := Format('%s?key=%s', [
      Self.GetModelRequestAddress(szBatchesName), // 请求地址
      Self.GetApiKey()]); // GEMINI_API_KEY

  if ('' <> szFilter) then
    szAddress := Format('%s&filter=%s', [szAddress, szFilter]);
  if (0 <> nPageSize) then
    szAddress := Format('%s&pageSize=%d', [szAddress, nPageSize]);
  if (bReturnPartialSuccess) then
    szAddress := Format('%s&returnPartialSuccess=true', [szAddress]);

  Result := []; //
  pResponseBody := TListOperationsResponseBody.Create(); // 响应对象
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
    Result := Result + pResponseBody.ExtractOperations();
  until (not bAutoExpansion) or ('' = szToken);

  szToken := '';
  szAddress := '';
  szRequestContent := '';
  szRequestAddress := '';
  SafeFreeAndNil(pResponseBody);
end;

function TBatchesModelReality.UpdateEmbedContentBatch(const szBatchesName,
  szUpdateMask, szModelName, szDisplayName: String;
  const pInputConfig: TInputEmbedContentConfig;
  const szPriority: String): TEmbedContentBatch;
var
  pRequest: TEmbedContentBatch;
  szRequestContent: AnsiString;
begin
  Result := nil;
  pRequest := TEmbedContentBatch.CreateWith(szModelName, szDisplayName, pInputConfig, szPriority);

  if ('' = szBatchesName) then
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_PATCH, // 请求方式
      pRequest, // 请求参数
      Self.GetPostRequestHeader(), // 请求头
      Self.GetModelName(), // 批处理名为空时使用设置的 model 名作为批处理名
      'updateEmbedContentBatch') // 方法名
  else
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_PATCH, // 请求方式
      pRequest, // 请求参数
      Self.GetPostRequestHeader(), // 请求头
      szBatchesName, // 批处理名
      'updateEmbedContentBatch'); // 方法名

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TEmbedContentBatch.Create();
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

function TBatchesModelReality.UpdateGenerateContentBatch(const szBatchesName,
  szUpdateMask, szModelName, szDisplayName: String;
  const pInputConfig: TInputconfig;
  const szPriority: String): TGenerateContentBatch;
var
  pRequest: TGenerateContentBatch;
  szRequestContent: AnsiString;
begin
  Result := nil;
  pRequest := TGenerateContentBatch.CreateWith(szModelName, szDisplayName, pInputConfig, szPriority);

  if ('' = szBatchesName) then
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_PATCH, // 请求方式
      pRequest, // 请求参数
      Self.GetPostRequestHeader(), // 请求头
      Self.GetModelName(), // 批处理名为空时使用设置的 model 名作为批处理名
      'updateGenerateContentBatch') // 方法名
  else
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_PATCH, // 请求方式
      pRequest, // 请求参数
      Self.GetPostRequestHeader(), // 请求头
      szBatchesName, // 批处理名
      'updateGenerateContentBatch'); // 方法名

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TGenerateContentBatch.Create();
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

end.

