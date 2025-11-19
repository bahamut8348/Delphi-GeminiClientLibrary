unit Models.ModelsModelImplement;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Defaults, System.Generics.Collections,
  System.Rtti, System.JSON, System.TypInfo, System.ObjAuto,
  Models.GeminiBasedModelStatement, Models.GeminiBasedModelImplement,
  Parameters.BasedParameterImplement,
  Parameters.Tool, Parameters.ToolConfig, Parameters.SafetySetting,
  Parameters.GenerationConfig, Parameters.Blob, Parameters.FileData,
  Parameters.Part, Parameters.Content, Parameters.Model,
  Parameters.MessagePrompt, Parameters.CountMessageTokensRequestBody, Parameters.CountMessageTokensResponseBody,
  Parameters.TextPrompt, Parameters.CountTextTokensRequestBody, Parameters.CountTextTokensResponseBody,
  Parameters.GenerateContentRequest, Parameters.CountTokensRequestBody, Parameters.CountTokensResponseBody,
  Parameters.ListModelResponseBody,
  Parameters.PredictRequestBody, Parameters.PredictResponseBody,
  Parameters.Operation;

type
{
  https://ai.google.dev/api/models
  https://ai.google.dev/api/generate-content
  包含基础接口与生成文字内容
}
  TModelsModelReality = class(TGeminiModelReality)
  private

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
    // https://ai.google.dev/api/palm#v1beta.models.countMessageTokens
    // POST /v1beta/{model=models/*}:countMessageTokens
    // Runs a model's tokenizer on a string and returns the token count.
    function CountMessageTokens(const szModelName: String;
      const pMessagePrompt: TMessagePrompt): TCountMessageTokensResponseBody;

    // https://ai.google.dev/api/palm#v1beta.models.countTextTokens
    // POST /v1beta/{model=models/*}:countTextTokens
    // Runs a model's tokenizer on a text and returns the token count.
    function CountTextTokens(const szModelName: String;
      const pTextPrompt: TTextPrompt): TCountTextTokensResponseBody;

    // https://ai.google.dev/api/tokens#v1beta.models.countTokens
    // POST /v1beta/{model=models/*}:countTokens
    // Runs a model's tokenizer on input Content and returns the token count.
    function CountTokens(const szModelName: String;
      const pGenerateContentRequest: TGenerateContentRequest;
      const pContents: TArray<TContent> = []): TCountTokensResponseBody;

    // https://ai.google.dev/api/models#v1beta.models.get
    // GET /v1beta/{name=models/*}
    // Gets information about a specific Model such as its version number, token limits, <a href="https://ai.google.dev/gemini-api/docs/models/generative-models#model-parameters">parameters</a> and other metadata.
    function Get(const szModelName: String = ''): TModel;

    // https://ai.google.dev/api/models#v1beta.models.list
    // GET /v1beta/models
    // Lists the <a href="https://ai.google.dev/gemini-api/docs/models/gemini">Models</a> available through the Gemini API.
    function List(const nPageSize: Integer = 0; const szPageToken: String = '';
      const bAutoExpansion: Boolean = TRUE): TArray<TModel>;

    // https://ai.google.dev/api/models#v1beta.models.predict
    // POST /v1beta/{model=models/*}:predict
    // Performs a prediction request.
    function Predict(const szModelName: String;
      const pInstances: TArray<TObject> = [];
      const pParameters: TObject = nil): TPredictResponseBody;

    // https://ai.google.dev/api/models#v1beta.models.predictLongRunning
    // POST /v1beta/{model=models/*}:predictLongRunning
    // Same as Predict but returns an LRO.
    function PredictLongRunning(const szModelName: String;
      const pInstances: TArray<TObject> = [];
      const pParameters: TObject = nil): TOperation;
  published
    { published declarations }
  end;


implementation

uses
  System.AnsiStrings,
  Constants.RequestMethod, Constants.ContentType, Constants.HttpStatusCode, Constants.GeminiEnumType,
  Parameters.HttpworkStatement, Parameters.HttpworkImplement,
  Functions.StringsUtils, Functions.SystemExtended;

{ TModelsModelReality }

function TModelsModelReality.CountMessageTokens(const szModelName: String;
  const pMessagePrompt: TMessagePrompt): TCountMessageTokensResponseBody;
var
  szRequestContent: AnsiString;
  pRequestBody: TCountMessageTokensRequestBody;
begin
  Result := nil;

  // 请求参数
  pRequestBody := TCountMessageTokensRequestBody.CreateWith(pMessagePrompt);
  if ('' = szModelName) then
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      pRequestBody, // 请求数据
      Self.GetPostRequestHeader(), // 自定义请求头
      Self.GetModelName(), // 模块名
      'countMessageTokens' // 方法名
    )
  else
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      pRequestBody, // 请求数据
      Self.GetPostRequestHeader(), // 自定义请求头
      szModelName, // 模块名
      'countMessageTokens' // 方法名
    );

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TCountMessageTokensResponseBody.Create();
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

function TModelsModelReality.CountTextTokens(const szModelName: String;
  const pTextPrompt: TTextPrompt): TCountTextTokensResponseBody;
var
  szRequestContent: AnsiString;
  pRequestBody: TCountTextTokensRequestBody;
begin
  Result := nil;

  // 请求参数
  pRequestBody := TCountTextTokensRequestBody.CreateWith(pTextPrompt);
  if ('' = szModelName) then
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      pRequestBody, // 请求数据
      Self.GetPostRequestHeader(), // 自定义请求头
      Self.GetModelName(), // 模块名
      'countTextTokens' // 方法名
    )
  else
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      pRequestBody, // 请求数据
      Self.GetPostRequestHeader(), // 自定义请求头
      szModelName, // 模块名
      'countTextTokens' // 方法名
    );

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TCountTextTokensResponseBody.Create();
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

function TModelsModelReality.CountTokens(const szModelName: String;
  const pGenerateContentRequest: TGenerateContentRequest;
  const pContents: TArray<TContent>): TCountTokensResponseBody;
var
  szRequestContent: AnsiString;
  pRequestBody: TCountTokensRequestBody;
begin
  Result := nil;

  // 请求参数
  pRequestBody := TCountTokensRequestBody.CreateWith(pContents, pGenerateContentRequest);
  if ('' = szModelName) then
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      pRequestBody, // 请求数据
      Self.GetPostRequestHeader(), // 自定义请求头
      Self.GetModelName(), // 模块名
      'countTokens' // 方法名
    )
  else
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      pRequestBody, // 请求数据
      Self.GetPostRequestHeader(), // 自定义请求头
      szModelName, // 模块名
      'countTokens' // 方法名
    );

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TCountTokensResponseBody.Create();
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

constructor TModelsModelReality.Create();
begin
  inherited Create();
  Self.SetModelPath('models');
end;

destructor TModelsModelReality.Destroy();
begin
  inherited Destroy();
end;

function TModelsModelReality.Get(const szModelName: String): TModel;
var
  szRequestAddress, szRequestContent: AnsiString;
begin
  Result := nil;

  if ('' = szModelName) then
    szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()),
      Self.GetApiKey()])) // GEMINI_API_KEY
  else
    szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
      Self.GetModelRequestAddress(szModelName),
      Self.GetApiKey()])); // GEMINI_API_KEY

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_GET, // 请求方式
    szRequestAddress // 请求地址
  );

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TModel.Create();
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

function TModelsModelReality.List(const nPageSize: Integer;
  const szPageToken: String; const bAutoExpansion: Boolean): TArray<TModel>;
var
  szAddress, szRequestAddress, szToken: String;
  szRequestContent: AnsiString;
  pResponseBody: TListModelResponseBody;
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
  pResponseBody := TListModelResponseBody.Create(); // 响应对象
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
    Result := Result + pResponseBody.ExtractModels();
  until (not bAutoExpansion) or ('' = szToken);

  szToken := '';
  szAddress := '';
  szRequestContent := '';
  szRequestAddress := '';
  SafeFreeAndNil(pResponseBody);
end;

function TModelsModelReality.Predict(const szModelName: String;
  const pInstances: TArray<TObject>; const pParameters: TObject): TPredictResponseBody;
var
  szRequestContent: AnsiString;
  pRequestBody: TPredictRequestBody;
begin
  Result := nil;

  // 请求参数
  pRequestBody := TPredictRequestBody.CreateWith(pInstances, pParameters);
  if ('' = szModelName) then
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      pRequestBody, // 请求数据
      Self.GetPostRequestHeader(), // 自定义请求头
      Self.GetModelName(), // 模块名
      'predict' // 方法名
    )
  else
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      pRequestBody, // 请求数据
      Self.GetPostRequestHeader(), // 自定义请求头
      szModelName, // 模块名
      'predict' // 方法名
    );

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TPredictResponseBody.Create();
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

function TModelsModelReality.PredictLongRunning(const szModelName: String;
  const pInstances: TArray<TObject>; const pParameters: TObject): TOperation;
var
  szRequestContent: AnsiString;
  pRequestBody: TPredictRequestBody;
begin
  Result := nil;

  // 请求参数
  pRequestBody := TPredictRequestBody.CreateWith(pInstances, pParameters);
  if ('' = szModelName) then
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      pRequestBody, // 请求数据
      Self.GetPostRequestHeader(), // 自定义请求头
      Self.GetModelName(), // 模块名
      'predictLongRunning' // 方法名
    )
  else
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      pRequestBody, // 请求数据
      Self.GetPostRequestHeader(), // 自定义请求头
      szModelName, // 模块名
      'predictLongRunning' // 方法名
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

end.
