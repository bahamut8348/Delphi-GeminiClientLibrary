unit Models.GeminiBasedModelImplement;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement,
  Parameters.HttpworkStatement,
  Models.BasedModelImplement, Models.GeminiBasedModelStatement, Tools.HttpworkStatement;

type
  TGeminiModelReality = class(TModelReality, IGeminiModelContract)
  private
    { private declarations }
    FApiKey: WideString; // API密钥【 https://ai.google.dev/gemini-api/docs/api-key 】
    FApiBaseUrl: WideString; // API接口的基础地址【 https://ai.google.dev/api/all-methods#service-endpoint 】
    FApiVersion: WideString; // API版本【 https://ai.google.dev/gemini-api/docs/api-versions 】

    FProxyAddress: AnsiString; // 代理服务器地址，【完整连接，包括代理类型、服务器域名或地址、端口，例如：socks5=socks5://127.0.0.1:1080】
    FProxyUsername: AnsiString; // 代理服务器登录账户
    FProxyPassword: AnsiString; // 代理服务器登录密码

    FModelPath: WideString; // 模块所在目录
    FModelName: WideString; // 模块名

    FHttpClient: IHttpworkContract; // http 请求模块

    FPostRequestHeader: TArray<AnsiString>;

    FLastErrorCode: Integer;
    FLastErrorInfo: WideString;
  protected
    { protected declarations }
    // http 客户端对象，用来收发 http 报文
    property HttpClient: IHttpworkContract read FHttpClient;

  protected
    { protected declarations }
    (*******************************************************************************
     * 功  能: 获取 model 的请求地址                                               *
     * 参  数:                                                                     *
     *   szModelName: 模块名                                                       *
     *   szMethodName: 方法名                                                      *
     * 返回值:                                                                     *
     *   返回对应模块的请求地址                                                    *
     *******************************************************************************)
    function GetModelRequestAddress(const szModelName: String = '';
      szMethodName: String = ''): AnsiString;

    (*******************************************************************************
     * 功  能: 发送请求                                                            *
     * 参  数:                                                                     *
     *   szMethodType: 请求方式，如：GET/POST/PUT/DELETE，详情查阅【RequestMethod.pas】
     *   szRequestAddress: 请求地址                                                *
     *   szParameter: 请求数据/请求参数                                            *
     *   pParameter: 对象化的请求参数                                              *
     *   pHeaders: 请求头数组                                                      *
     *   szModelName: 模块名                                                       *
     *   szMethodName: 方法名                                                      *
     *   szLocaleFileName: 本地文件名【上传/下载文件时使用】                       *
     * 返回值:                                                                     *
     *   成功返回 响应数据 , 否则返回 空 。                                        *
     *   错误码与错误信息可通过 FLastErrorCode 与 FLastErrorInfo 查看。            *
     *******************************************************************************)
    function SendRequest(const szMethodType: AnsiString; const szParameter: AnsiString;
      const pHeaders: TArray<AnsiString>; const szModelName: String; const szMethodName: String;
      const szLocaleFileName: String = ''): AnsiString; overload;

    function SendRequest(const szMethodType: AnsiString; const pParameter: IParameterContract;
      const pHeaders: TArray<AnsiString>; const szModelName: String; const szMethodName: String;
      const szLocaleFileName: String = ''): AnsiString; overload;

    function SendRequest(const szMethodType: AnsiString; const szRequestAddress: AnsiString;
      const szParameter: AnsiString = ''; const pHeaders: TArray<AnsiString> = [];
      const szLocaleFileName: String = ''): AnsiString; overload;

    function SendRequest(const szMethodType: AnsiString; const szRequestAddress: AnsiString;
      const pParameter: IParameterContract; const pHeaders: TArray<AnsiString>;
      const szLocaleFileName: String = ''): AnsiString; overload;

    procedure SetLastErrorCode(const nLastErrorCode: Integer);
    procedure SetLastErrorInfo(const sLastErrorInfo: WideString);

    function GetPostRequestHeader(): TArray<AnsiString>;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;


    // 设置 API KEY
    procedure SetApiKey(const szApiKey: WideString);
    // 设置 API 接口的基础地址
    procedure SetApiBaseUrl(const szApiBaseUrl: WideString);
    // 设置 API 版本号
    procedure SetApiVersion(const szApiVersion: WideString);

    // 设置 model 所在的目录，用于拼接 model 请求地址
    procedure SetModelPath(const szModelPath: WideString);
    // 设置 model 名，用于拼接 model 请求地址
    procedure SetModelName(const szModelName: WideString);

    // 设置代理服务器地址，【完整连接，包括代理类型、服务器域名或地址、端口，例如：socks5=socks5://127.0.0.1:1080】
    procedure SetProxyAddress(const szProxyAddress: AnsiString);
    // 设置代理服务器登录账户
    procedure SetProxyUsername(const szProxyUsername: AnsiString);
    // 设置服务器登录密码
    procedure SetProxyPassword(const szProxyPassword: AnsiString);


    { IGeminiModelContract Method }
    // 获取 API KEY
    function GetApiKey(): WideString; stdcall;
    // 获取 API 接口的基础地址
    function GetApiBaseUrl(): WideString; stdcall;
    // 获取 API 版本号
    function GetApiVersion(): WideString; stdcall;

    // 获取原始的响应数据
    function GetResponseData(): PAnsiChar; stdcall;

    // 获取 model 所在的目录，用于拼接model请求地址
    function GetModelPath(): WideString;
    // 获取 model 名，用于拼接model请求地址
    function GetModelName(): WideString;

    { IModelContract Method }
    // 获取代理服务器地址，【完整连接，包括代理类型、服务器域名或地址、端口，例如：socks5=socks5://127.0.0.1:1080】
    function GetProxyAddress(): PAnsiChar; stdcall;
    // 获取代理服务器登录账户
    function GetProxyUsername(): PAnsiChar; stdcall;
    // 获取服务器登录密码
    function GetProxyPassword(): PAnsiChar; stdcall;

    // 获取最后一次的错误信息
    function GetLastErrorCode(): Integer; stdcall;
    function GetLastErrorInfo(): WideString; stdcall;
  published
    { published declarations }
  end;

implementation

uses
  System.AnsiStrings,
  Constants.ContentType, Constants.HttpStatusCode,
  Functions.StringsUtils, Functions.SystemExtended,
  Tools.HttpworkImplement,
  Parameters.HttpworkImplement;

{ TGeminiModelReality }

constructor TGeminiModelReality.Create();
begin
  inherited Create();
  Self.FHttpClient := GetHttpworkInstance();

  Self.FApiKey := '';
  Self.FApiBaseUrl := '';
  Self.FApiVersion := '';
  Self.FModelPath := '';
  Self.FModelName := '';
  Self.FProxyAddress := '';
  Self.FProxyUsername := '';
  Self.FProxyPassword := '';

  SetLength(Self.FPostRequestHeader, 0);
end;

destructor TGeminiModelReality.Destroy();
begin
  ReleaseStringArray(Self.FPostRequestHeader);

  Self.FProxyPassword := '';
  Self.FProxyUsername := '';
  Self.FProxyAddress := '';
  Self.FModelName := '';
  Self.FModelPath := '';
  Self.FApiVersion := '';
  Self.FApiBaseUrl := '';
  Self.FApiKey := '';

  Self.FHttpClient := nil;
  inherited Destroy();
end;

function TGeminiModelReality.GetApiBaseUrl(): WideString;
begin
  Result := FApiBaseUrl;
end;

function TGeminiModelReality.GetApiKey(): WideString;
begin
  Result := FApiKey;
end;

function TGeminiModelReality.GetApiVersion(): WideString;
begin
  Result := FApiVersion;
end;

function TGeminiModelReality.GetLastErrorCode(): Integer;
begin
  Result := FLastErrorCode;
end;

function TGeminiModelReality.GetLastErrorInfo(): WideString;
begin
  Result := FLastErrorInfo;
end;

function TGeminiModelReality.GetModelName(): WideString;
begin
  Result := FModelName;
end;

function TGeminiModelReality.GetModelPath(): WideString;
begin
  Result := FModelPath;
end;

function TGeminiModelReality.GetModelRequestAddress(const szModelName: String;
  szMethodName: String): AnsiString;
begin
  if ('' = szModelName) then // 未指定模块名时，方法名是无意义的。
  begin
    Result := AnsiStringValue(Format('%s/%s/%s', [
      Self.GetApiBaseUrl(), Self.GetApiVersion(), Self.GetModelPath()
    ]));
  end
  else if ('' = szMethodName) then
  begin
    Result := AnsiStringValue(Format('%s/%s/%s/%s', [
      Self.GetApiBaseUrl(), Self.GetApiVersion(), Self.GetModelPath(),
      szModelName
    ]))
  end
  else
  begin
    Result := AnsiStringValue(Format('%s/%s/%s/%s:%s', [
      Self.GetApiBaseUrl(), Self.GetApiVersion(), Self.GetModelPath(),
      szModelName, szMethodName
    ]));
  end;
end;

function TGeminiModelReality.GetPostRequestHeader(): TArray<AnsiString>;
begin
  Result := Self.FPostRequestHeader;
end;

function TGeminiModelReality.GetProxyAddress(): PAnsiChar;
begin
  Result := PAnsiChar(FProxyAddress);
end;

function TGeminiModelReality.GetProxyPassword(): PAnsiChar;
begin
  Result := PAnsiChar(FProxyPassword);
end;

function TGeminiModelReality.GetProxyUsername(): PAnsiChar;
begin
  Result := PAnsiChar(FProxyUsername);
end;

function TGeminiModelReality.GetResponseData(): PAnsiChar;
begin
  if (nil <> FHttpClient) then
    Result := FHttpClient.GetResponseContent()
  else
    Result := nil;
end;

function TGeminiModelReality.SendRequest(const szMethodType,
  szParameter: AnsiString; const pHeaders: TArray<AnsiString>;
  const szModelName, szMethodName, szLocaleFileName: String): AnsiString;
var
  pHttpParameter: IHttpworkParameterContract;
  nHttpStatusCode: Integer;
begin
  Result := '';

  pHttpParameter := THttpworkParameterReality.From(
    szMethodType, // 请求方式
    Self.GetModelRequestAddress(szModelName, szMethodName), // 请求地址
    szParameter, // 请求数据
    pHeaders,  // 自定义请求头
    AnsiStringValue(szLocaleFileName), // 本地文件名【上传/下载文件时使用】
    '', // 远程文件名【上传/下载文件时使用】
    Self.GetProxyAddress(), // 代理服务器地址
    Self.GetProxyUsername(), // 代理服务器登录账户
    Self.GetProxyPassword() // 服务器登录密码
  );

  FLastErrorCode := Self.HttpClient.Request(pHttpParameter);
  if (S_OK = FLastErrorCode) then
  begin
    nHttpStatusCode := Self.HttpClient.GetResponseCode();
    if (HTTP_STATUS_OK = nHttpStatusCode) then
      Result := Self.HttpClient.GetResponseContent()
    else
    begin
      FLastErrorCode := nHttpStatusCode;
      FLastErrorInfo := StringValueP(Self.HttpClient.GetResponseContent()); // GetHttpStatusMessage(FLastErrorCode);
    end;
  end
  else
    FLastErrorInfo := Self.HttpClient.GetLastErrorInfo(); //SysErrorMessage(FLastErrorCode);

  pHttpParameter := nil;
end;

function TGeminiModelReality.SendRequest(const szMethodType: AnsiString;
  const pParameter: IParameterContract; const pHeaders: TArray<AnsiString>;
  const szModelName, szMethodName, szLocaleFileName: String): AnsiString;
begin
  Result := '';
  if (nil = pParameter) then
  begin
    FLastErrorCode := S_FALSE;
    FLastErrorInfo := 'invalid parameter.';
    Exit;
  end;

  Result := Self.SendRequest(
    szMethodType, // 请求方式
    AnsiStringValue(pParameter.ToString()), // 请求数据
    pHeaders, // 自定义请求头
    szModelName, // 模块名
    szMethodName, // 方法名
    szLocaleFileName // 本地文件名【上传/下载文件时使用】
  );
end;

function TGeminiModelReality.SendRequest(const szMethodType, szRequestAddress,
  szParameter: AnsiString; const pHeaders: TArray<AnsiString>;
  const szLocaleFileName: String): AnsiString;
var
  pHttpParameter: IHttpworkParameterContract;
  nHttpStatusCode: Integer;
begin
  Result := '';

  pHttpParameter := THttpworkParameterReality.From(
    szMethodType, // 请求方式
    szRequestAddress, // 请求地址
    szParameter, // 请求数据
    pHeaders,  // 自定义请求头
    AnsiStringValue(szLocaleFileName), // 本地文件名【上传/下载文件时使用】
    '', // 远程文件名【上传/下载文件时使用】
    Self.GetProxyAddress(), // 代理服务器地址
    Self.GetProxyUsername(), // 代理服务器登录账户
    Self.GetProxyPassword() // 服务器登录密码
  );

  FLastErrorCode := Self.HttpClient.Request(pHttpParameter);
  if (S_OK = FLastErrorCode) then
  begin
    nHttpStatusCode := Self.HttpClient.GetResponseCode();
    if (HTTP_STATUS_OK = nHttpStatusCode) then
      Result := Self.HttpClient.GetResponseContent()
    else
    begin
      FLastErrorCode := nHttpStatusCode;
      FLastErrorInfo := StringValueP(Self.HttpClient.GetResponseContent()); // GetHttpStatusMessage(FLastErrorCode);
    end;
  end
  else
    FLastErrorInfo := Self.HttpClient.GetLastErrorInfo(); //SysErrorMessage(FLastErrorCode);

  pHttpParameter := nil;
end;

function TGeminiModelReality.SendRequest(const szMethodType, szRequestAddress: AnsiString;
  const pParameter: IParameterContract; const pHeaders: TArray<AnsiString>;
  const szLocaleFileName: String): AnsiString;
begin
  Result := '';
  if (nil = pParameter) then
  begin
    FLastErrorCode := S_FALSE;
    FLastErrorInfo := 'invalid parameter.';
    Exit;
  end;

  Result := Self.SendRequest(
    szMethodType, // 请求方式
    szRequestAddress, // 请求地址
    AnsiStringValue(pParameter.ToString()), // 请求数据
    pHeaders, // 自定义请求头
    szLocaleFileName // 本地文件名【上传/下载文件时使用】
  );
end;

procedure TGeminiModelReality.SetApiBaseUrl(const szApiBaseUrl: WideString);
begin
  FApiBaseUrl := szApiBaseUrl;
end;

procedure TGeminiModelReality.SetApiKey(const szApiKey: WideString);
begin
  FApiKey := szApiKey;

  if (Length(Self.FPostRequestHeader) = 0) then
  begin
    SetLength(Self.FPostRequestHeader, 2);
    Self.FPostRequestHeader[0] := AnsiStringValue(Format('Content-Type: %s', [CONTENT_TYPE_APPLICATION_JSON{, CONTENT_TYPE_UTF_8}])); // 数据格式为 json
  end;
  Self.FPostRequestHeader[1] := AnsiStringValue(Format('x-goog-api-key: %s', [Self.GetApiKey()])); // GEMINI_API_KEY
end;

procedure TGeminiModelReality.SetApiVersion(const szApiVersion: WideString);
begin
  FApiVersion := szApiVersion;
end;

procedure TGeminiModelReality.SetLastErrorCode(const nLastErrorCode: Integer);
begin
  FLastErrorCode := nLastErrorCode;
end;

procedure TGeminiModelReality.SetLastErrorInfo(
  const sLastErrorInfo: WideString);
begin
  FLastErrorInfo := sLastErrorInfo;
end;

procedure TGeminiModelReality.SetModelName(const szModelName: WideString);
begin
  FModelName := szModelName;
end;

procedure TGeminiModelReality.SetModelPath(const szModelPath: WideString);
begin
  FModelPath := szModelPath;
end;

procedure TGeminiModelReality.SetProxyAddress(const szProxyAddress: AnsiString);
begin
  FProxyAddress := szProxyAddress;
end;

procedure TGeminiModelReality.SetProxyPassword(
  const szProxyPassword: AnsiString);
begin
  FProxyPassword := szProxyPassword;
end;

procedure TGeminiModelReality.SetProxyUsername(
  const szProxyUsername: AnsiString);
begin
  FProxyUsername := szProxyUsername;
end;

end.
