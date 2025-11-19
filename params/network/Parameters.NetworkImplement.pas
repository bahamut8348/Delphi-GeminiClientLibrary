unit Parameters.NetworkImplement;

interface

uses
  System.SysUtils, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement,
  Parameters.NetworkStatement;

type
  TNetworkParameterReality = class(TParameterReality, INetworkParameterContract)
  private
    { private declarations }

    // 代理类型，详情查阅【ProtocolType.pas】，【解析后的结果，只包含单独的类型信息】
    FProxyType: AnsiString;
    // 代理服务器地址，【解析后的结果，只包含单独的服务器域名或地址信息】
    FProxyServerHost: AnsiString;
    // 代理服务器端口、【解析后的结果，只包含单独的服务器端口信息】
    FProxyServerPort: Integer;

    // 代理服务器地址，【完整连接，包括代理类型、服务器域名或地址、端口，例如：socks5=socks5://127.0.0.1:1080】
    FProxyAddress: AnsiString;
    // 代理服务器登录账户
    FProxyUsername: AnsiString;
    // 代理服务器登录密码
    FProxyPassword: AnsiString;

    (*******************************************************************************
     * 功  能: 通过传入的代理服务器地址解析代理服务器信息                          *
     * 参  数:                                                                     *
     *   szAddress: 代理服务器地址，如：socks5://127.0.0.1:1080 这里不考虑代理地址存在登录账户与密码的情况 *
     *   szType: 代理类型【输出用】                                                *
     *   szHost: 代理服务器域名或地址【输出用】                                    *
     *   nPort: 代理服务器端口【输出用】                                           *
     * 返回值:                                                                     *
     *   成功返回true，否则返回false。                                             *
     *******************************************************************************)
    function ParseProxyInformation(const szAddress: AnsiString;
      out pszType, pszHost: AnsiString; out pnPort: Integer): Boolean;
  protected
    { protected declarations }

    (*******************************************************************************
     * 功  能: 设置指定的属性值（解析json格式字符串时会被调用）                    *
     * 参  数:                                                                     *
     *   sName: 要获取的属性名                                                     *
     *   pValue: 属性的值                                                          *
     * 返回值:                                                                     *
     *   返回true则不会调用默认方式设置属性的值，否则使用默认方法设置该属性值。    *
     *******************************************************************************)
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;

    // 代理服务器地址，【完整连接，包括代理类型、服务器域名或地址、端口，例如：socks5=socks5://127.0.0.1:1080】
    procedure SetProxyAddress(const Value: AnsiString);
    // 代理服务器登录账户
    procedure SetProxyPassword(const Value: AnsiString);
    // 服务器登录密码
    procedure SetProxyUsername(const Value: AnsiString);
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  public
    { public declarations }
    { INetworkParameterContract Method }

    // 获取代理类型，详情查阅【ProtocolType.pas】，【解析后的结果，只包含单独的类型信息】
    function GetProxyType(): PAnsiChar; stdcall;
    // 获取代理服务器地址，【解析后的结果，只包含单独的服务器域名或地址信息】
    function GetProxyServerHost(): PAnsiChar; stdcall;
    // 获取代理服务器端口、【解析后的结果，只包含单独的服务器端口信息】
    function GetProxyServerPort(): Integer; stdcall;

    // 获取代理服务器地址，【完整连接，包括代理类型、服务器域名或地址、端口，例如：socks5=socks5://127.0.0.1:1080】
    function GetProxyAddress(): PAnsiChar; stdcall;
    // 获取代理服务器登录账户
    function GetProxyUsername(): PAnsiChar; stdcall;
    // 获取代理服务器登录密码
    function GetProxyPassword(): PAnsiChar; stdcall;

  public
    { public declarations }

    (*******************************************************************************
     * 功  能: 根据传入的参数创建对象实例                                          *
     * 参  数:                                                                     *
     *   pJsonObject: json对象实例                                                 *
     * 返回值:                                                                     *
     *   解析成功返回创建的实例，否则返回空。                                      *
     *******************************************************************************)
    class function From(
      const szProxyAddress: AnsiString; // 代理服务器地址
      const szProxyUsername: AnsiString; // 代理服务器登录账户
      const szProxyPassword: AnsiString  // 服务器登录密码
    ): INetworkParameterContract; overload;
  published
    { published declarations }
  end;

implementation

uses
  Constants.ProtocolType,
  Constants.ParameterName,
  Functions.StringsUtils,
  Functions.SystemExtended,
  System.AnsiStrings;

{ TNetworkParameterReality }

constructor TNetworkParameterReality.Create();
begin
  inherited Create();

  FProxyType := ''; // 代理类型，详情查阅【ProtocolType.pas】，【解析后的结果，只包含单独的类型信息】
  FProxyServerHost := ''; // 代理服务器地址，【解析后的结果，只包含单独的服务器域名或地址信息】
  FProxyServerPort := 0; // 代理服务器端口、【解析后的结果，只包含单独的服务器端口信息】
  FProxyAddress := ''; // 代理服务器地址，【完整连接，包括代理类型、服务器域名或地址、端口，例如：socks5=socks5://127.0.0.1:1080】
  FProxyUsername := ''; // 代理服务器登录账户
  FProxyPassword := ''; // 服务器登录密码
end;

destructor TNetworkParameterReality.Destroy();
begin
  FProxyPassword := ''; // 服务器登录密码
  FProxyUsername := ''; // 代理服务器登录账户
  FProxyAddress := ''; // 代理服务器地址，【完整连接，包括代理类型、服务器域名或地址、端口，例如：socks5=socks5://127.0.0.1:1080】
  FProxyServerPort := 0; // 代理服务器端口、【解析后的结果，只包含单独的服务器端口信息】
  FProxyServerHost := ''; // 代理服务器地址，【解析后的结果，只包含单独的服务器域名或地址信息】
  FProxyType := ''; // 代理类型，详情查阅【ProtocolType.pas】，【解析后的结果，只包含单独的类型信息】

  inherited Destroy();
end;

class function TNetworkParameterReality.From(const szProxyAddress,
  szProxyUsername, szProxyPassword: AnsiString): INetworkParameterContract;
var
  pResult: TNetworkParameterReality;
begin
  pResult := TNetworkParameterReality.Create();
  if (nil <> pResult) then
  begin
    pResult.SetProxyAddress(szProxyAddress);
    pResult.SetProxyUsername(szProxyUsername);
    pResult.SetProxyPassword(szProxyPassword);

    if (pResult.QueryInterface(INetworkParameterContract, Result) <> S_OK) then
      Result := nil;
  end
  else
    Result := nil;
end;

function TNetworkParameterReality.GetProxyAddress(): PAnsiChar;
begin
  Result := PAnsiChar(FProxyAddress);
end;

function TNetworkParameterReality.GetProxyPassword(): PAnsiChar;
begin
  Result := PAnsiChar(FProxyPassword);
end;

function TNetworkParameterReality.GetProxyServerHost(): PAnsiChar;
begin
  Result := PAnsiChar(FProxyServerHost);
end;

function TNetworkParameterReality.GetProxyServerPort(): Integer;
begin
  Result := FProxyServerPort;
end;

function TNetworkParameterReality.GetProxyType(): PAnsiChar;
begin
  Result := PAnsiChar(FProxyType);
end;

function TNetworkParameterReality.GetProxyUsername(): PAnsiChar;
begin
  Result := PAnsiChar(FProxyUsername);
end;

function TNetworkParameterReality.ParseProxyInformation(
  const szAddress: AnsiString; out pszType, pszHost: AnsiString;
  out pnPort: Integer): Boolean;
var
  pszProxyAddress: PAnsiChar;
  pszProxyType, pszProxyServer, pszProxyPort, pszOther: PAnsiChar;
  nProxyPort: Integer;
begin
  Result := FALSE;

  if ('' = szAddress) then
  begin
    if (nil <> @pszType) then
      pszType := PROXYTYPE_NONE;
    if (nil <> @pszHost) then
      pszHost := ADDRESS_NONE_V4;
    if (nil <> @pnPort) then
      pnPort := 0;

    Exit;
  end;

  pszProxyAddress := StrNewA(PAnsiChar(szAddress));
  nProxyPort := 0;
{$IFDEF UNICODE}

{$IF CompilerVersion >= 23.0}
  if (System.AnsiStrings.AnsiStrLIComp(SCHEMETYPE_SOCKS5, pszProxyAddress, Length(SCHEMETYPE_SOCKS5)) = 0) then
    pszProxyType := PROXYTYPE_SOCKS5
  else if (System.AnsiStrings.AnsiStrLIComp(SCHEMETYPE_SOCKS4A, pszProxyAddress, Length(SCHEMETYPE_SOCKS4A)) = 0) then
    pszProxyType := PROXYTYPE_SOCKS4A
  else if (System.AnsiStrings.AnsiStrLIComp(SCHEMETYPE_SOCKS4, pszProxyAddress, Length(SCHEMETYPE_SOCKS4)) = 0) then
    pszProxyType := PROXYTYPE_SOCKS4
  else if (System.AnsiStrings.AnsiStrLIComp(SCHEMETYPE_SOCKS, pszProxyAddress, Length(SCHEMETYPE_SOCKS)) = 0) then
    pszProxyType := PROXYTYPE_SOCKS4
  else if (System.AnsiStrings.AnsiStrLIComp(SCHEMETYPE_HTTPS, pszProxyAddress, Length(SCHEMETYPE_HTTPS)) = 0) then
    pszProxyType := PROXYTYPE_HTTPS
  else if (System.AnsiStrings.AnsiStrLIComp(SCHEMETYPE_HTTP, pszProxyAddress, Length(SCHEMETYPE_HTTP)) = 0) then
    pszProxyType := PROXYTYPE_HTTP
  else
    pszProxyType := PROXYTYPE_HTTP;

  pszProxyServer := System.AnsiStrings.AnsiStrPos(pszProxyAddress, DELIMITER_SCHEME);
  if (nil <> pszProxyServer) then
    Inc(pszProxyServer, Length(DELIMITER_SCHEME))
  else
  begin
    pszProxyServer := System.AnsiStrings.AnsiStrPos(pszProxyAddress, DELIMITER_PROTOCOL);
    if (nil <> pszProxyServer) then
      Inc(pszProxyServer, Length(DELIMITER_PROTOCOL))
    else
      pszProxyServer := pszProxyAddress;
  end;

  pszProxyPort := System.AnsiStrings.AnsiStrPos(pszProxyServer, DELIMITER_ADDRESS_PORT);
  if (nil <> pszProxyPort) then
  begin
    pszProxyPort^ := #0; // 把冒号变成空字符，这样pszProxyServer就只剩服务器名了
    Inc(pszProxyPort, Length(DELIMITER_ADDRESS_PORT)); // 跳过分隔符

    // 尝试查找是否包含请求参数【即是否包含问号?】
    pszOther := System.AnsiStrings.AnsiStrPos(pszProxyPort, DELIMITER_QUERY_PARAMETER);
    if (nil <> pszOther) then
      pszOther^ := #0;
    // 尝试查找是否包含标记【即是否包含井号#】
    pszOther := System.AnsiStrings.AnsiStrPos(pszProxyPort, DELIMITER_FRAGMENT);
    if (nil <> pszOther) then
      pszOther^ := #0;

{$WARNINGS OFF}
    // 去除所有可能存在的部分之后，剩余部分即为端口号，将端口号转为整数
    nProxyPort := StrToIntDef(AnsiString(pszProxyPort), 0);
{$WARNINGS ON}
  end;

{$ELSE CompilerVersion < 23.0}

  if (AnsiStrLIComp(SCHEMETYPE_SOCKS5, pszProxyAddress, Length(SCHEMETYPE_SOCKS5)) = 0) then
    pszProxyType := PROXYTYPE_SOCKS5
  else if (AnsiStrLIComp(SCHEMETYPE_SOCKS4A, pszProxyAddress, Length(SCHEMETYPE_SOCKS4A)) = 0) then
    pszProxyType := PROXYTYPE_SOCKS4A
  else if (AnsiStrLIComp(SCHEMETYPE_SOCKS4, pszProxyAddress, Length(SCHEMETYPE_SOCKS4)) = 0) then
    pszProxyType := PROXYTYPE_SOCKS4
  else if (AnsiStrLIComp(SCHEMETYPE_SOCKS, pszProxyAddress, Length(SCHEMETYPE_SOCKS)) = 0) then
    pszProxyType := PROXYTYPE_SOCKS4
  else if (AnsiStrLIComp(SCHEMETYPE_HTTPS, pszProxyAddress, Length(SCHEMETYPE_HTTPS)) = 0) then
    pszProxyType := PROXYTYPE_HTTPS
  else if (AnsiStrLIComp(SCHEMETYPE_HTTP, pszProxyAddress, Length(SCHEMETYPE_HTTP)) = 0) then
    pszProxyType := PROXYTYPE_HTTP
  else
    pszProxyType := PROXYTYPE_HTTP;

  pszProxyServer := AnsiStrPos(pszProxyAddress, DELIMITER_SCHEME);
  if (nil <> pszProxyServer) then
    Inc(pszProxyServer, Length(DELIMITER_SCHEME))
  else
  begin
    pszProxyServer := AnsiStrPos(pszProxyAddress, DELIMITER_PROTOCOL);
    if (nil <> pszProxyServer) then
      Inc(pszProxyServer, Length(DELIMITER_PROTOCOL))
    else
      pszProxyServer := pszProxyAddress;
  end;

  pszProxyPort := AnsiStrPos(pszProxyServer, DELIMITER_ADDRESS_PORT);
  if (nil <> pszProxyPort) then
  begin
    pszProxyPort^ := #0; // 把冒号变成空字符，这样pszProxyServer就只剩服务器名了
    Inc(pszProxyPort, Length(DELIMITER_ADDRESS_PORT)); // 跳过分隔符

    // 尝试查找是否包含请求参数【即是否包含问号?】
    pszOther := AnsiStrPos(pszProxyPort, DELIMITER_QUERY_PARAMETER);
    if (nil <> pszOther) then
      pszOther^ := #0;
    // 尝试查找是否包含标记【即是否包含井号#】
    pszOther := AnsiStrPos(pszProxyPort, DELIMITER_FRAGMENT);
    if (nil <> pszOther) then
      pszOther^ := #0;

{$WARNINGS OFF}
    // 去除所有可能存在的部分之后，剩余部分即为端口号，将端口号转为整数
    nProxyPort := StrToIntDef(AnsiString(pszProxyPort), 0);
{$WARNINGS ON}
  end;
{$IFEND CompilerVersion >= 23.0}

{$ELSE !UNICODE}
  if (StrLIComp(SCHEMETYPE_SOCKS5, pszProxyAddress, Length(SCHEMETYPE_SOCKS5)) = 0) then
    pszProxyType := PROXYTYPE_SOCKS5
  else if (StrLIComp(SCHEMETYPE_SOCKS4A, pszProxyAddress, Length(SCHEMETYPE_SOCKS4A)) = 0) then
    pszProxyType := PROXYTYPE_SOCKS4A
  else if (StrLIComp(SCHEMETYPE_SOCKS4, pszProxyAddress, Length(SCHEMETYPE_SOCKS4)) = 0) then
    pszProxyType := PROXYTYPE_SOCKS4
  else if (StrLIComp(SCHEMETYPE_SOCKS, pszProxyAddress, Length(SCHEMETYPE_SOCKS)) = 0) then
    pszProxyType := PROXYTYPE_SOCKS4
  else if (StrLIComp(SCHEMETYPE_HTTPS, pszProxyAddress, Length(SCHEMETYPE_HTTPS)) = 0) then
    pszProxyType := PROXYTYPE_HTTPS
  else if (StrLIComp(SCHEMETYPE_HTTP, pszProxyAddress, Length(SCHEMETYPE_HTTP)) = 0) then
    pszProxyType := PROXYTYPE_HTTP
  else
    pszProxyType := PROXYTYPE_HTTP;

  pszProxyServer := StrPos(pszProxyAddress, DELIMITER_SCHEME);
  if (nil <> pszProxyServer) then
    Inc(pszProxyServer, Length(DELIMITER_SCHEME))
  else
  begin
    pszProxyServer := StrPos(pszProxyAddress, DELIMITER_PROTOCOL);
    if (nil <> pszProxyServer) then
      Inc(pszProxyServer, Length(DELIMITER_PROTOCOL))
    else
      pszProxyServer := pszProxyAddress;
  end;

  pszProxyPort := StrPos(pszProxyServer, DELIMITER_ADDRESS_PORT);
  if (nil <> pszProxyPort) then
  begin
    pszProxyPort^ := #0; // 把冒号变成空字符，这样pszProxyServer就只剩服务器名了
    Inc(pszProxyPort, Length(DELIMITER_ADDRESS_PORT)); // 跳过分隔符

    // 尝试查找是否包含请求参数【即是否包含问号?】
    pszOther := StrPos(pszProxyPort, DELIMITER_QUERY_PARAMETER);
    if (nil <> pszOther) then
      pszOther^ := #0;
    // 尝试查找是否包含标记【即是否包含井号#】
    pszOther := StrPos(pszProxyPort, DELIMITER_FRAGMENT);
    if (nil <> pszOther) then
      pszOther^ := #0;

{$WARNINGS OFF}
    // 去除所有可能存在的部分之后，剩余部分即为端口号，将端口号转为整数
    nProxyPort := StrToIntDef(pszProxyPort, 0);
{$WARNINGS ON}
  end;
{$ENDIF UNICODE}

  if (nil <> @pszType) then
    pszType := pszProxyType;

  if (nil <> @pszHost) then
    pszHost := pszProxyServer;

  if (nil <> @pnPort) then
    pnPort := nProxyPort;

  StrDisposeA(pszProxyAddress);

  Result := TRUE;
end;

function TNetworkParameterReality.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if (SameText(sName, PARAMETERNAME_PROXY_ADDRESS)) then
  begin
    // 代理服务器地址，如：socks5://127.0.0.1:1080
    FProxyAddress := GetJsonAnsiStringValue(pValue);
    Result := TRUE;
  end
  else if (SameText(sName, PARAMETERNAME_PROXY_USERNAME)) then
  begin
    // 代理服务器登录账户
    FProxyUsername := GetJsonAnsiStringValue(pValue);
    Result := TRUE;
  end
  else if (SameText(sName, PARAMETERNAME_PROXY_PASSWORD)) then
  begin
    // 代理服务器登录密码
    FProxyPassword := GetJsonAnsiStringValue(pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TNetworkParameterReality.SetProxyAddress(const Value: AnsiString);
begin
  FProxyAddress := Value;
  Self.ParseProxyInformation(Value, FProxyType, FProxyServerHost, FProxyServerPort);
end;

procedure TNetworkParameterReality.SetProxyPassword(const Value: AnsiString);
begin
  FProxyPassword := Value;
end;

procedure TNetworkParameterReality.SetProxyUsername(const Value: AnsiString);
begin
  FProxyUsername := Value;
end;

end.
