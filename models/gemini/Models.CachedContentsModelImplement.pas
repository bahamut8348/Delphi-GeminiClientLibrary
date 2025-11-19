unit Models.CachedContentsModelImplement;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Defaults, System.Generics.Collections,
  System.Rtti, System.JSON, System.TypInfo, System.ObjAuto,
  Models.BasedModelStatement, Models.BasedModelImplement,
  Models.GeminiBasedModelStatement, Models.GeminiBasedModelImplement,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.Content, Parameters.Part, Parameters.Tool, Parameters.ToolConfig,
  Parameters.CachedContent, Parameters.ListCachedContentsResponseBody;

type
{
  https://ai.google.dev/api/caching
  借助上下文缓存，您可以保存并重复使用预计算的输入 token，例如在针对同一媒体文件提出不同问题时。这有助于节省费用和时间，具体取决于使用情况。如需详细介绍，请参阅上下文缓存指南。
}
  TCachedContentsModelReality = class(TGeminiModelReality)
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
    // https://ai.google.dev/api/caching#v1beta.cachedContents.create
    // POST /v1beta/cachedContents
    // Creates CachedContent resource.
    function CreateNew(const pContents: TArray<TContent>; const pTools: TArray<TTool>;
      { Union type expiration start }
      const szExpireTime: String; const szTtl: String;
      { Union type expiration end }
      const szDisplayName: String; const szModelName: String;
      const pSystemInstruction: TContent; const pToolConfig: TToolConfig ): TCachedContent;
    // https://ai.google.dev/api/caching#v1beta.cachedContents.delete
    // DELETE /v1beta/{name=cachedContents/*}
    // Deletes CachedContent resource.
    function Delete(const szCachedContentsName: String): Boolean;
    // https://ai.google.dev/api/caching#v1beta.cachedContents.get
    // GET /v1beta/{name=cachedContents/*}
    // Reads CachedContent resource.
    function Get(const szCachedContentsName: String): TCachedContent;
    // https://ai.google.dev/api/caching#v1beta.cachedContents.list
    // GET /v1beta/cachedContents
    // Lists CachedContents.
    function List(const nPageSize: Integer = 0; const szPageToken: String = '';
      const bAutoExpansion: Boolean = TRUE): TArray<TCachedContent>;
    // https://ai.google.dev/api/caching#v1beta.cachedContents.patch
    // PATCH /v1beta/{cachedContent.name=cachedContents/*}
    // Updates CachedContent resource (only expiration is updatable).
    function Patch(const szCachedContentsName: String; const szUpdateMask: String;
      { Union type expiration start }
      const szExpireTime: String; const szTtl: String
      { Union type expiration end } ): TCachedContent;
  published
    { published declarations }
  end;

implementation

uses
  Constants.ContentType, Constants.RequestMethod, Constants.HttpStatusCode,
  Functions.StringsUtils, Functions.SystemExtended;

{ TCachedContentsModelReality }

constructor TCachedContentsModelReality.Create();
begin
  inherited Create();
  Self.SetModelPath('cachedContents');
end;

function TCachedContentsModelReality.CreateNew(
  const pContents: TArray<TContent>; const pTools: TArray<TTool>;
  const szExpireTime, szTtl, szDisplayName, szModelName: String;
  const pSystemInstruction: TContent;
  const pToolConfig: TToolConfig): TCachedContent;
var
  pRequest: TCachedContent;
  szRequestContent: AnsiString;
begin
  Result := nil;
  pRequest := TCachedContent.CreateWith(pContents, pTools, szExpireTime, szTtl,
    szDisplayName, szModelName, pSystemInstruction, pToolConfig);

    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_POST, // 请求方式
      pRequest, // 请求参数
      Self.GetPostRequestHeader(), // 请求头
      '', // 模块名
      ''); // 方法名

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TCachedContent.Create();
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

function TCachedContentsModelReality.Delete(
  const szCachedContentsName: String): Boolean;
var
  szRequestAddress: AnsiString;
begin
  Result := FALSE;

  if ('' = szCachedContentsName) then
    szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()),
      Self.GetApiKey()])) // GEMINI_API_KEY
  else
    szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
      Self.GetModelRequestAddress(szCachedContentsName),
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

destructor TCachedContentsModelReality.Destroy();
begin
  inherited Destroy();
end;

function TCachedContentsModelReality.Get(
  const szCachedContentsName: String): TCachedContent;
var
  szRequestAddress, szRequestContent: AnsiString;
begin
  Result := nil;

  if ('' = szCachedContentsName) then
    szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
      Self.GetModelRequestAddress(Self.GetModelName()),
      Self.GetApiKey()])) // GEMINI_API_KEY
  else
    szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
      Self.GetModelRequestAddress(szCachedContentsName),
      Self.GetApiKey()])); // GEMINI_API_KEY

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_GET, // 请求方式
    szRequestAddress); // 请求地址

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TCachedContent.Create();
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

function TCachedContentsModelReality.List(const nPageSize: Integer;
  const szPageToken: String;
  const bAutoExpansion: Boolean): TArray<TCachedContent>;
var
  szAddress, szRequestAddress, szToken: String;
  szRequestContent: AnsiString;
  pResponseBody: TListCachedContentsResponseBody;
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
  pResponseBody := TListCachedContentsResponseBody.Create(); // 响应对象
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
    Result := Result + pResponseBody.ExtractCachedContents();
  until (not bAutoExpansion) or ('' = szToken);

  szToken := '';
  szAddress := '';
  szRequestContent := '';
  szRequestAddress := '';
  SafeFreeAndNil(pResponseBody);
end;

function TCachedContentsModelReality.Patch(const szCachedContentsName,
  szUpdateMask, szExpireTime, szTtl: String): TCachedContent;
var
  pRequest: TCachedContent;
  szRequestContent: AnsiString;
begin
  Result := nil;
  pRequest := TCachedContent.CreateWith(szExpireTime, szTtl);

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_PATCH, // 请求方式
    pRequest, // 请求参数
    Self.GetPostRequestHeader(), // 请求头
    szCachedContentsName, // 模块名
    ''); // 方法名

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TCachedContent.Create();
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

