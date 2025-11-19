unit Parameters.HttpworkImplement;

interface

uses
  System.SysUtils, System.Rtti, System.JSON,
  System.Generics.Defaults, System.Generics.Collections,
  Constants.RequestMethod,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.HttpworkStatement, Parameters.NetworkImplement;

type
  THttpworkParameterReality = class(TNetworkParameterReality, IHttpworkParameterContract)
  private
    { private declarations }
    FMethod: AnsiString; // 请求方式
    FAddress: AnsiString; // 请求地址
    FParameters: AnsiString; // 请求数据
    FCustomHeaders: array of AnsiString; // 自定义请求头
    FCustomHeaderList: array of PAnsiChar; // 自定义请求头
    FLocaleFileName: AnsiString; // 本地文件名【上传/下载文件时使用】
    FRemoteFileName: AnsiString; // 远程文件名【上传/下载文件时使用】
    //FFileMimeType: AnsiString; // 文件的mime类型【上传/下载文件时使用】【详情查阅MimeType.pas】
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

    // 请求地址
    procedure SetAddress(const Value: AnsiString);
    // 自定义请求头
    procedure SetCustomHeaders(const pCustomHeaders: array of AnsiString); overload;
    procedure SetCustomHeaders(const pCustomHeaders: PPAnsiChar; const nCustomHeaderCount: Integer); overload;
    // 文件的mime类型【上传/下载文件时使用】【详情查阅MimeType.pas】
    //procedure SetFileMimeType(const Value: AnsiString);
    // 本地文件名【上传/下载文件时使用】
    procedure SetLocaleFileName(const Value: AnsiString);
    // 请求方式
    procedure SetMethod(const Value: AnsiString);
    // 请求数据
    procedure SetParameters(const Value: AnsiString);
    // 远程文件名【上传/下载文件时使用】
    procedure SetRemoteFileName(const Value: AnsiString);
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  public
    { public declarations }
    { IHttpworkParameterContract Method }
    // 获取请求方式
    function GetMethod(): PAnsiChar; stdcall;
    // 获取请求地址
    function GetAddress(): PAnsiChar; stdcall;
    // 获取请求数据
    function GetParameters(): PAnsiChar; stdcall;
    // 获取请求头总数
    function GetCustomHeaderCount(): Integer; stdcall;
    // 获取指定序号的请求头
    function GetCustomHeader(const nIndex: Integer): PAnsiChar; stdcall;
    // 获取所有的请求头
    function GetCustomHeaders(): PPAnsiChar; stdcall;
    // 获取本地文件名【上传/下载文件时使用】
    function GetLocaleFileName(): PAnsiChar; stdcall;
    // 获取远程文件名【上传/下载文件时使用】
    function GetRemoteFileName(): PAnsiChar; stdcall;
    // 获取文件的mime类型【上传/下载文件时使用】【详情查阅MimeType.pas】
    //function GetFileMimeType(): PAnsiChar; stdcall;

  public
    class function From(
      const szMethod: AnsiString; // 请求方式
      const szAddress: AnsiString; // 请求地址
      const szParameters: AnsiString; // 请求数据
      const pCustomHeaders: array of AnsiString; // 请求头
      const szLocaleFileName: AnsiString = ''; // 本地文件名【上传/下载文件时使用】
      const szRemoteFileName: AnsiString = ''; // 远程文件名【上传/下载文件时使用】
      //const szFileMimeType: AnsiString = ''; // 文件的mime类型【上传/下载文件时使用】【详情查阅MimeType.pas】
      const szProxyAddress: AnsiString = ''; // 代理服务器地址
      const szProxyUsername: AnsiString = ''; // 代理服务器登录账户
      const szProxyPassword: AnsiString = ''  // 服务器登录密码
    ): IHttpworkParameterContract; overload;

    class function From(
      const pszMethod: PAnsiChar; // 请求方式
      const pszAddress: PAnsiChar; // 请求地址
      const pszParameters: PAnsiChar; // 请求数据
      const pCustomHeaders: PPAnsiChar; // 请求头
      const nCustomHeaderCount: Integer; // 请求头总数
      const pszLocaleFileName: PAnsiChar = nil; // 本地文件名【上传/下载文件时使用】
      const pszRemoteFileName: PAnsiChar = nil; // 远程文件名【上传/下载文件时使用】
      //const pszFileMimeType: PAnsiChar = nil; // 文件的mime类型【上传/下载文件时使用】【详情查阅MimeType.pas】
      const pszProxyAddress: PAnsiChar = nil; // 代理服务器地址
      const pszProxyUsername: PAnsiChar = nil; // 代理服务器登录账户
      const pszProxyPassword: PAnsiChar = nil  // 服务器登录密码
    ): IHttpworkParameterContract; overload;
  published
    { published declarations }
  end;

implementation

uses
  Constants.ParameterName,
  Functions.SystemExtended;

{ THttpworkParameterReality }

constructor THttpworkParameterReality.Create();
begin
  inherited Create();

  FMethod := ''; // 请求方式
  FAddress := ''; // 请求地址
  FParameters := ''; // 请求数据
  FLocaleFileName := ''; // 本地文件名【上传/下载文件时使用】
  FRemoteFileName := ''; // 远程文件名【上传/下载文件时使用】
  //FFileMimeType := ''; // 文件的mime类型【上传/下载文件时使用】【详情查阅MimeType.pas】

  SetLength(FCustomHeaders, 0); // 请求头
  SetLength(FCustomHeaderList, 0);
end;

destructor THttpworkParameterReality.Destroy();
var
  nIndex: Integer;
begin
  //FFileMimeType := ''; // 文件的mime类型【上传/下载文件时使用】【详情查阅MimeType.pas】
  FRemoteFileName := ''; // 远程文件名【上传/下载文件时使用】
  FLocaleFileName := ''; // 本地文件名【上传/下载文件时使用】
  FParameters := ''; // 请求数据
  FAddress := ''; // 请求地址
  FMethod := ''; // 请求方式

  // 请求头
  SetLength(FCustomHeaderList, 0);
  for nIndex := High(FCustomHeaders) downto Low(FCustomHeaders) do
  begin
    FCustomHeaders[nIndex] := '';
  end;
  SetLength(FCustomHeaders, 0);

  inherited Destroy();
end;

class function THttpworkParameterReality.From(const pszMethod, pszAddress,
  pszParameters: PAnsiChar; const pCustomHeaders: PPAnsiChar;
  const nCustomHeaderCount: Integer; const pszLocaleFileName, pszRemoteFileName,
  pszProxyAddress, pszProxyUsername,
  pszProxyPassword: PAnsiChar): IHttpworkParameterContract;
var
  pResult: THttpworkParameterReality;
begin
  pResult := THttpworkParameterReality.Create();
  if (nil <> pResult) then
  begin
    pResult.SetProxyAddress(pszProxyAddress);
    pResult.SetProxyUsername(pszProxyUsername);
    pResult.SetProxyPassword(pszProxyPassword);

    pResult.SetMethod(pszMethod); // 请求方式
    pResult.SetAddress(pszAddress); // 请求地址
    pResult.SetParameters(pszParameters); // 请求数据
    pResult.SetCustomHeaders(pCustomHeaders, nCustomHeaderCount); // 请求头
    pResult.SetLocaleFileName(pszLocaleFileName); // 本地文件名【上传/下载文件时使用】
    pResult.SetRemoteFileName(pszRemoteFileName); // 远程文件名【上传/下载文件时使用】
    //pResult.SetFileMimeType(szFileMimeType); // 文件的mime类型【上传/下载文件时使用】【详情查阅MimeType.pas】

    if (S_OK <> pResult.QueryInterface(IHttpworkParameterContract, Result)) then
      Result := nil;
  end
  else
    Result := nil;
end;

class function THttpworkParameterReality.From(const szMethod,
  szAddress, szParameters: AnsiString;
  const pCustomHeaders: array of AnsiString; const szLocaleFileName,
  szRemoteFileName, szProxyAddress, szProxyUsername,
  szProxyPassword: AnsiString): IHttpworkParameterContract;
var
  pResult: THttpworkParameterReality;
begin
  pResult := THttpworkParameterReality.Create();
  if (nil <> pResult) then
  begin
    pResult.SetProxyAddress(szProxyAddress);
    pResult.SetProxyUsername(szProxyUsername);
    pResult.SetProxyPassword(szProxyPassword);

    pResult.SetMethod(szMethod); // 请求方式
    pResult.SetAddress(szAddress); // 请求地址
    pResult.SetParameters(szParameters); // 请求数据
    pResult.SetCustomHeaders(pCustomHeaders); // 请求头
    pResult.SetLocaleFileName(szLocaleFileName); // 本地文件名【上传/下载文件时使用】
    pResult.SetRemoteFileName(szRemoteFileName); // 远程文件名【上传/下载文件时使用】
    //pResult.SetFileMimeType(szFileMimeType); // 文件的mime类型【上传/下载文件时使用】【详情查阅MimeType.pas】

    if (S_OK <> pResult.QueryInterface(IHttpworkParameterContract, Result)) then
      Result := nil;
  end
  else
    Result := nil;
end;

function THttpworkParameterReality.GetAddress(): PAnsiChar;
begin
  Result := PAnsiChar(FAddress);
end;

function THttpworkParameterReality.GetCustomHeader(
  const nIndex: Integer): PAnsiChar;
begin
  if ((nIndex >= Low(FCustomHeaderList)) and (nIndex <= High(FCustomHeaderList))) then
    Result := FCustomHeaderList[nIndex]
  else
    Result := nil;
end;

function THttpworkParameterReality.GetCustomHeaderCount(): Integer;
begin
  Result := Length(FCustomHeaderList);
end;

function THttpworkParameterReality.GetCustomHeaders(): PPAnsiChar;
begin
  if Length(FCustomHeaderList) = 0 then
    Result := nil
  else
    Result := @(FCustomHeaderList[0]);
end;

//function THttpworkParameterReality.GetFileMimeType(): PAnsiChar;
//begin
//  Result := PAnsiChar(FFileMimeType);
//end;

function THttpworkParameterReality.GetLocaleFileName(): PAnsiChar;
begin
  Result := PAnsiChar(FLocaleFileName);
end;

function THttpworkParameterReality.GetMethod(): PAnsiChar;
begin
  Result := PAnsiChar(FMethod);
end;

function THttpworkParameterReality.GetParameters(): PAnsiChar;
begin
  Result := PAnsiChar(FParameters);
end;

function THttpworkParameterReality.GetRemoteFileName(): PAnsiChar;
begin
  Result := PAnsiChar(FRemoteFileName);
end;

procedure THttpworkParameterReality.SetAddress(const Value: AnsiString);
begin
  FAddress := Value;
end;

procedure THttpworkParameterReality.SetCustomHeaders(
  const pCustomHeaders: PPAnsiChar; const nCustomHeaderCount: Integer);
var
  nIndex: Integer;
  pIndex: PAnsiChar;
begin
  for nIndex := High(FCustomHeaders) downto Low(FCustomHeaders) do
  begin
    FCustomHeaders[nIndex] := '';
  end;

  SetLength(FCustomHeaders, nCustomHeaderCount);
  SetLength(FCustomHeaderList, nCustomHeaderCount);
  if (nCustomHeaderCount > 0) and (nil <> pCustomHeaders) then
  begin
    pIndex := pCustomHeaders^;
    for nIndex := 0 to nCustomHeaderCount - 1 do
    begin
      FCustomHeaders[nIndex] := pIndex;
      FCustomHeaderList[nIndex] := pIndex;
      Inc(pIndex);
    end;
  end;
end;

procedure THttpworkParameterReality.SetCustomHeaders(
  const pCustomHeaders: array of AnsiString);
var
  nIndex: Integer;
begin
  for nIndex := High(FCustomHeaders) downto Low(FCustomHeaders) do
  begin
    FCustomHeaders[nIndex] := '';
  end;

  SetLength(FCustomHeaders, Length(pCustomHeaders));
  SetLength(FCustomHeaderList, Length(pCustomHeaders));
  for nIndex := Low(pCustomHeaders) to High(pCustomHeaders) do
  begin
    FCustomHeaders[nIndex] := pCustomHeaders[nIndex];
    FCustomHeaderList[nIndex] := PAnsiChar(FCustomHeaders[nIndex]);
  end;
end;

//procedure THttpworkParameterReality.SetFileMimeType(const Value: AnsiString);
//begin
//  FFileMimeType := Value;
//end;

procedure THttpworkParameterReality.SetLocaleFileName(const Value: AnsiString);
begin
  FLocaleFileName := Value;
end;

function THttpworkParameterReality.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
var
  nIndex: Integer;
begin
  if SameText(sName, PARAMETERNAME_HTTP_METHOD) then
  begin
    // 请求方式
    FMethod := GetJsonAnsiStringValue(pValue);
    Result := TRUE;
  end
  else if SameText(sName, PARAMETERNAME_HTTP_ADDRESS) then
  begin
    // 请求地址
    FAddress := GetJsonAnsiStringValue(pValue);
    Result := TRUE;
  end
  else if SameText(sName, PARAMETERNAME_HTTP_REQUEST_PARAMETERS) then
  begin
    // 请求数据
    FParameters := GetJsonAnsiStringValue(pValue);
    Result := TRUE;
  end
  else if SameText(sName, PARAMETERNAME_HTTP_REQUEST_HEADER) then
  begin
    // 请求头
    if (nil = pValue) then
      Exit(FALSE);

    for nIndex := High(FCustomHeaders) downto Low(FCustomHeaders) do
      FCustomHeaders[nIndex] := '';

    if (pValue is TJSONArray) then
    begin
      SetLength(FCustomHeaders, (pValue as TJSONArray).Count);
      SetLength(FCustomHeaderList, (pValue as TJSONArray).Count);
      for nIndex := 0 to (pValue as TJSONArray).Count - 1 do
      begin
        FCustomHeaders[nIndex] := GetJsonAnsiStringValue((pValue as TJSONArray).Items[nIndex]);
        FCustomHeaderList[nIndex] := PAnsiChar(FCustomHeaders[nIndex]);
      end;
    end
    else if (nil <> pValue) then
    begin
      SetLength(FCustomHeaders, 1);
      SetLength(FCustomHeaderList, 1);
      FCustomHeaders[0] := GetJsonAnsiStringValue(pValue);
      FCustomHeaderList[0] := PAnsiChar(FCustomHeaders[0]);
    end
    else
    begin
      SetLength(FCustomHeaders, 0);
      SetLength(FCustomHeaderList, 0);
    end;

    Result := TRUE;
  end
  else if SameText(sName, PARAMETERNAME_HTTP_LOCALE_FILE_NAME) then
  begin
    // 本地文件名【上传/下载文件时使用】
    FLocaleFileName := GetJsonAnsiStringValue(pValue);
    Result := TRUE;
  end
  else if SameText(sName, PARAMETERNAME_HTTP_REMOTE_FILE_NAME) then
  begin
    // 远程文件名【上传/下载文件时使用】
    FRemoteFileName := GetJsonAnsiStringValue(pValue);
    Result := TRUE;
  end
  //else if SameText(sName, PARAMETERNAME_HTTP_FILE_MIME_TYPE) then
  //begin
  //  // 文件的mime类型【上传/下载文件时使用】【详情查阅MimeType.pas】
  //  FFileMimeType := TParameterReality.GetJsonAnsiStringValue(pValue);
  //  Result := TRUE;
  //end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure THttpworkParameterReality.SetMethod(const Value: AnsiString);
begin
  FMethod := Value;
end;

procedure THttpworkParameterReality.SetParameters(const Value: AnsiString);
begin
  FParameters := Value;
end;

procedure THttpworkParameterReality.SetRemoteFileName(const Value: AnsiString);
begin
  FRemoteFileName := Value;
end;

end.
