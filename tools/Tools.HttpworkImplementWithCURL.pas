unit Tools.HttpworkImplementWithCURL;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Defaults, System.Generics.Collections,
  System.Rtti, System.JSON,
  Tools.NetworkStatement, Tools.NetworkImplement,
  Tools.HttpworkStatement,
  Parameters.HttpworkStatement, Parameters.HttpworkImplement,
  Curl.Lib;

type
  CURL           = HCURL;
  CURLCode       = (
    CURLE_OK = 0,
    CURLE_UNSUPPORTED_PROTOCOL,    { 1 }
    CURLE_FAILED_INIT,             { 2 }
    CURLE_URL_MALFORMAT,           { 3 }
    CURLE_NOT_BUILT_IN,            { 4 - [was obsoleted in August 2007 for
                                      7.17.0, reused in April 2011 for 7.21.5] }
    CURLE_COULDNT_RESOLVE_PROXY,   { 5 }
    CURLE_COULDNT_RESOLVE_HOST,    { 6 }
    CURLE_COULDNT_CONNECT,         { 7 }
    CURLE_WEIRD_SERVER_REPLY,      { 8 }
    CURLE_REMOTE_ACCESS_DENIED,    { 9 a service was denied by the server
                                      due to lack of access - when login fails
                                      this is not returned. }
    CURLE_FTP_ACCEPT_FAILED,       { 10 - [was obsoleted in April 2006 for
                                      7.15.4, reused in Dec 2011 for 7.24.0]}
    CURLE_FTP_WEIRD_PASS_REPLY,    { 11 }
    CURLE_FTP_ACCEPT_TIMEOUT,      { 12 - timeout occurred accepting server
                                      [was obsoleted in August 2007 for 7.17.0,
                                      reused in Dec 2011 for 7.24.0]}
    CURLE_FTP_WEIRD_PASV_REPLY,    { 13 }
    CURLE_FTP_WEIRD_227_FORMAT,    { 14 }
    CURLE_FTP_CANT_GET_HOST,       { 15 }
    CURLE_HTTP2,                   { 16 - A problem in the http2 framing layer.
                                      [was obsoleted in August 2007 for 7.17.0,
                                      reused in July 2014 for 7.38.0] }
    CURLE_FTP_COULDNT_SET_TYPE,    { 17 }
    CURLE_PARTIAL_FILE,            { 18 }
    CURLE_FTP_COULDNT_RETR_FILE,   { 19 }
    CURLE_OBSOLETE20,              { 20 - NOT USED }
    CURLE_QUOTE_ERROR,             { 21 - quote command failure }
    CURLE_HTTP_RETURNED_ERROR,     { 22 }
    CURLE_WRITE_ERROR,             { 23 }
    CURLE_OBSOLETE24,              { 24 - NOT USED }
    CURLE_UPLOAD_FAILED,           { 25 - failed upload "command" }
    CURLE_READ_ERROR,              { 26 - could not open/read from file }
    CURLE_OUT_OF_MEMORY,           { 27 }
    CURLE_OPERATION_TIMEDOUT,      { 28 - the timeout time was reached }
    CURLE_OBSOLETE29,              { 29 - NOT USED }
    CURLE_FTP_PORT_FAILED,         { 30 - FTP PORT operation failed }
    CURLE_FTP_COULDNT_USE_REST,    { 31 - the REST command failed }
    CURLE_OBSOLETE32,              { 32 - NOT USED }
    CURLE_RANGE_ERROR,             { 33 - RANGE "command" did not work }
    CURLE_HTTP_POST_ERROR,         { 34 }
    CURLE_SSL_CONNECT_ERROR,       { 35 - wrong when connecting with SSL }
    CURLE_BAD_DOWNLOAD_RESUME,     { 36 - could not resume download }
    CURLE_FILE_COULDNT_READ_FILE,  { 37 }
    CURLE_LDAP_CANNOT_BIND,        { 38 }
    CURLE_LDAP_SEARCH_FAILED,      { 39 }
    CURLE_OBSOLETE40,              { 40 - NOT USED }
    CURLE_FUNCTION_NOT_FOUND,      { 41 - NOT USED starting with 7.53.0 }
    CURLE_ABORTED_BY_CALLBACK,     { 42 }
    CURLE_BAD_FUNCTION_ARGUMENT,   { 43 }
    CURLE_OBSOLETE44,              { 44 - NOT USED }
    CURLE_INTERFACE_FAILED,        { 45 - CURLOPT_INTERFACE failed }
    CURLE_OBSOLETE46,              { 46 - NOT USED }
    CURLE_TOO_MANY_REDIRECTS,      { 47 - catch endless re-direct loops }
    CURLE_UNKNOWN_OPTION,          { 48 - User specified an unknown option }
    CURLE_SETOPT_OPTION_SYNTAX,    { 49 - Malformed setopt option }
    CURLE_OBSOLETE50,              { 50 - NOT USED }
    CURLE_OBSOLETE51,              { 51 - NOT USED }
    CURLE_GOT_NOTHING,             { 52 - when this is a specific error }
    CURLE_SSL_ENGINE_NOTFOUND,     { 53 - SSL crypto engine not found }
    CURLE_SSL_ENGINE_SETFAILED,    { 54 - can not set SSL crypto engine as
                                      default }
    CURLE_SEND_ERROR,              { 55 - failed sending network data }
    CURLE_RECV_ERROR,              { 56 - failure in receiving network data }
    CURLE_OBSOLETE57,              { 57 - NOT IN USE }
    CURLE_SSL_CERTPROBLEM,         { 58 - problem with the local certificate }
    CURLE_SSL_CIPHER,              { 59 - could not use specified cipher }
    CURLE_PEER_FAILED_VERIFICATION, { 60 - peer's certificate or fingerprint
                                       was not verified fine }
    CURLE_BAD_CONTENT_ENCODING,    { 61 - Unrecognized/bad encoding }
    CURLE_OBSOLETE62,              { 62 - NOT IN USE since 7.82.0 }
    CURLE_FILESIZE_EXCEEDED,       { 63 - Maximum file size exceeded }
    CURLE_USE_SSL_FAILED,          { 64 - Requested FTP SSL level failed }
    CURLE_SEND_FAIL_REWIND,        { 65 - Sending the data requires a rewind
                                      that failed }
    CURLE_SSL_ENGINE_INITFAILED,   { 66 - failed to initialise ENGINE }
    CURLE_LOGIN_DENIED,            { 67 - user, password or similar was not
                                      accepted and we failed to login }
    CURLE_TFTP_NOTFOUND,           { 68 - file not found on server }
    CURLE_TFTP_PERM,               { 69 - permission problem on server }
    CURLE_REMOTE_DISK_FULL,        { 70 - out of disk space on server }
    CURLE_TFTP_ILLEGAL,            { 71 - Illegal TFTP operation }
    CURLE_TFTP_UNKNOWNID,          { 72 - Unknown transfer ID }
    CURLE_REMOTE_FILE_EXISTS,      { 73 - File already exists }
    CURLE_TFTP_NOSUCHUSER,         { 74 - No such user }
    CURLE_OBSOLETE75,              { 75 - NOT IN USE since 7.82.0 }
    CURLE_OBSOLETE76,              { 76 - NOT IN USE since 7.82.0 }
    CURLE_SSL_CACERT_BADFILE,      { 77 - could not load CACERT file, missing
                                      or wrong format }
    CURLE_REMOTE_FILE_NOT_FOUND,   { 78 - remote file not found }
    CURLE_SSH,                     { 79 - error from the SSH layer, somewhat
                                      generic so the error message will be of
                                      interest when this has happened }

    CURLE_SSL_SHUTDOWN_FAILED,     { 80 - Failed to shut down the SSL
                                      connection }
    CURLE_AGAIN,                   { 81 - socket is not ready for send/recv,
                                      wait till it is ready and try again (Added
                                      in 7.18.2) }
    CURLE_SSL_CRL_BADFILE,         { 82 - could not load CRL file, missing or
                                      wrong format (Added in 7.19.0) }
    CURLE_SSL_ISSUER_ERROR,        { 83 - Issuer check failed.  (Added in
                                      7.19.0) }
    CURLE_FTP_PRET_FAILED,         { 84 - a PRET command failed }
    CURLE_RTSP_CSEQ_ERROR,         { 85 - mismatch of RTSP CSeq numbers }
    CURLE_RTSP_SESSION_ERROR,      { 86 - mismatch of RTSP Session Ids }
    CURLE_FTP_BAD_FILE_LIST,       { 87 - unable to parse FTP file list }
    CURLE_CHUNK_FAILED,            { 88 - chunk callback reported error }
    CURLE_NO_CONNECTION_AVAILABLE, { 89 - No connection available, the
                                      session will be queued }
    CURLE_SSL_PINNEDPUBKEYNOTMATCH, { 90 - specified pinned public key did not
                                       match }
    CURLE_SSL_INVALIDCERTSTATUS,   { 91 - invalid certificate status }
    CURLE_HTTP2_STREAM,            { 92 - stream error in HTTP/2 framing layer
                                      }
    CURLE_RECURSIVE_API_CALL,      { 93 - an api function was called from
                                      inside a callback }
    CURLE_AUTH_ERROR,              { 94 - an authentication function returned an
                                      error }
    CURLE_HTTP3,                   { 95 - An HTTP/3 layer problem }
    CURLE_QUIC_CONNECT_ERROR,      { 96 - QUIC connection error }
    CURLE_PROXY,                   { 97 - proxy handshake error }
    CURLE_SSL_CLIENTCERT,          { 98 - client-side certificate required }
    CURLE_UNRECOVERABLE_POLL,      { 99 - poll/select returned fatal error }
    CURLE_TOO_LARGE,               { 100 - a value/data met its maximum }
    CURLE_ECH_REQUIRED,            { 101 - ECH tried but failed }
    CURL_LAST { never use! }
  );
  PCURL_SLIST    = PCurlSList;
  CURL_PROXYTYPE = (
    CURLPROXY_NONE             = -1,
    CURLPROXY_HTTP             = 0, //* added in 7.10, new in 7.19.4 default is to use CONNECT HTTP/1.1 */
    CURLPROXY_HTTP_1_0         = 1, //* added in 7.19.4, force to use CONNECT HTTP/1.0  */
    CURLPROXY_HTTPS            = 2, //* HTTPS but stick to HTTP/1 added in 7.52.0 */
    CURLPROXY_HTTPS2           = 3, //* HTTPS and attempt HTTP/2 added in 8.2.0 */
    CURLPROXY_SOCKS4           = 4, //* support added in 7.15.2, enum existed already in 7.10 */
    CURLPROXY_SOCKS5           = 5, //* added in 7.10 */
    CURLPROXY_SOCKS4A          = 6, //* added in 7.18.0 */
    CURLPROXY_SOCKS5_HOSTNAME  = 7  //* Use the SOCKS5 protocol but pass along the hostname rather than the IP address. added in 7.18.0 */
  );
{
(*******************************************************************************
 * 功  能: 下载文件回调函数                                                    *
 * 参  数:                                                                     *
 *   szRemoteName: 网络文件名                                                  *
 *   szLocaleName: 本地文件名                                                  *
 *   nProgress：当前进度                                                       *
 *   nTotalSize：总大小                                                        *
 *   pParameter: 附加参数（调用函数时传入）                                    *
 * 返回值:                                                                     *
 *   为TRUE继续未完成的操作，为FALSE停止下载                                   *
 *******************************************************************************)
  TDownloadFileRoutineA = function(
    const szRemoteName: PAnsiChar;
    const szLocaleName: PAnsiChar;
    const nProgress: UINT64;
    const nTotalSize: UINT64;
    const pParameter: Pointer): LongBool; stdcall;

(*******************************************************************************
 * 功  能: 下载文件回调函数                                                    *
 * 参  数:                                                                     *
 *   szRemoteName: 网络文件名                                                  *
 *   szLocaleName: 本地文件名                                                  *
 *   nProgress：当前进度                                                       *
 *   nTotalSize：总大小                                                        *
 *   pParameter: 附加参数（调用函数时传入）                                    *
 * 返回值:                                                                     *
 *   为TRUE继续未完成的操作，为FALSE停止下载                                   *
 *******************************************************************************)
  TDownloadFileRoutineW = function(
    const szRemoteName: PAnsiChar;
    const szLocaleName: PWideChar;
    const nProgress: UINT64;
    const nTotalSize: UINT64;
    const pParameter: Pointer): LongBool; stdcall;

(*******************************************************************************
 * 功  能: 上传文件回调函数                                                    *
 * 参  数:                                                                     *
 *   szRemoteName: 网络文件名                                                  *
 *   szLocaleName: 本地文件名                                                  *
 *   nProgress：当前进度                                                       *
 *   nTotalSize：总大小                                                        *
 *   pParameter: 附加参数（调用函数时传入）                                    *
 * 返回值:                                                                     *
 *   为TRUE继续未完成的操作，为FALSE停止上传                                   *
 *******************************************************************************)
  TUploadFileRoutineA = function(
    const szRemoteName: PAnsiChar;
    const szLocaleName: PAnsiChar;
    const nProgress: UINT64;
    const nTotalSize: UINT64;
    const pParameter: Pointer): LongBool; stdcall;

(*******************************************************************************
 * 功  能: 上传文件回调函数                                                    *
 * 参  数:                                                                     *
 *   szRemoteName: 网络文件名                                                  *
 *   szLocaleName: 本地文件名                                                  *
 *   nProgress：当前进度                                                       *
 *   nTotalSize：总大小                                                        *
 *   pParameter: 附加参数（调用函数时传入）                                    *
 * 返回值:                                                                     *
 *   为TRUE继续未完成的操作，为FALSE停止上传                                   *
 *******************************************************************************)
  TUploadFileRoutineW = function(
    const szRemoteName: PAnsiChar;
    const szLocaleName: PWideChar;
    const nProgress: UINT64;
    const nTotalSize: UINT64;
    const pParameter: Pointer): LongBool; stdcall;
}

type
  THttpworkRealityWithCURL = class(TNetworkReality, IHttpworkContract)
  private
    { private declarations }
    FRequestParameter: IHttpworkParameterContract; // http请求参数
    FResponseCode: Integer; // 响应码
    FResponseHeader: AnsiString; // 响应头
    FResponseContent: AnsiString; // 响应内容
    FLastErrorCode: CURLCode; // 最后一次操作的错误码
    FLastErrorInfo: WideString; // 最后一次操作的错误信息

    FDownloadFileCallback: ITransferFileCallback; // 下载文件回调对象
    FUploadFileCallback: ITransferFileCallback; // 下载文件回调对象
  private
    { private declarations }
    function GetErrorMessage(const nErrorCode: CURLCode): String;
  protected
    { protected declarations }

    (*******************************************************************************
     * 功  能: 发送请求                                                            *
     * 参  数:                                                                     *
     *   pszRequestMethod: 请求方式，如：GET/POST/PUT/DELETE，详情查阅【RequestMethod.pas】
     *   pszRequestAddress: 请求地址                                               *
     *   pszRequestParameters: 请求数据/请求参数                                   *
     *   pRequestHeaders: 请求头数组                                               *
     *   nRequestHeaderCount: 请求头总数                                           *
     *   pszLocaleFileName: 本地文件名【上传/下载文件时使用】                      *
     *   pszRemoteFileName: 远程文件名【上传/下载文件时使用】                      *
     *   pszProxyType: 代理服务器类型，如：socks5、http、https等，详情请查阅【ProxyType.pas】
     *   pszProxyServerHost: 代理服务器地址，如：socks5://127.0.0.1:1080           *
     *   nProxyServerPort: 代理服务器地址，如：1080                                *
     *   pszProxyUsername: 代理服务器登录账户                                      *
     *   pszProxyPassword: 代理服务器登录密码                                      *
     * 返回值:                                                                     *
     *   成功返回 TRUE , 否则返回 FALSE 。                                         *
     *   错误码与错误信息可通过 FLastErrorCode 与 FLastErrorInfo 查看。            *
     *******************************************************************************)
    function SendRequest(
      pszRequestMethod: PAnsiChar; // 请求方式，如：GET/POST/PUT/DELETE，详情查阅【RequestMethod.pas】
      pszRequestAddress: PAnsiChar; // 请求地址
      pszRequestParameters: PAnsiChar; // 请求数据/请求参数
      pRequestHeaders: PPAnsiChar; // 请求头
      nRequestHeaderCount: Integer; // 请求头总数
      pszLocaleFileName: PAnsiChar; // 本地文件名【上传/下载文件时使用】
      pszRemoteFileName: PAnsiChar; // 远程文件名【上传/下载文件时使用】
      pszProxyType: PAnsiChar; // 代理服务器类型，如：socks5、http、https等，详情请查阅【ProxyType.pas】
      pszProxyServerHost: PAnsiChar; // 代理服务器地址，如：socks5://127.0.0.1:1080
      nProxyServerPort: Integer; // 代理服务器地址，如：1080
      pszProxyUsername: PAnsiChar; // 代理服务器登录账户
      pszProxyPassword: PAnsiChar // 代理服务器登录密码
    ): Boolean; virtual;
  public
    { public declarations }

    constructor Create(); override;
    destructor Destroy(); override;

  public
    { public declarations }

    { INetworkContract Method }
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

    // 获取最后一次的错误信息
    function GetLastErrorCode(): Integer; stdcall;
    function GetLastErrorInfo(): WideString; stdcall;

    { IHttpworkContract Method }
    // 获取请求方式，如：GET/POST/PUT/DELETE，详情查阅【RequestMethod.pas】
    function GetMethod(): PAnsiChar; stdcall;
    // 获取请求地址
    function GetAddress(): PAnsiChar; stdcall;
    // 获取请求参数
    function GetParameters(): PAnsiChar; stdcall;
    // 获取请求头
    function GetCustomHeader(const nIndex: Integer): PAnsiChar; stdcall;
    // 获取请求头总数
    function GetCustomHeaderCount(): Integer; stdcall;
    // 获取请求内容
    function GetRequestContent(): PAnsiChar; stdcall;
    // 获取响应码
    function GetResponseCode(): Integer; stdcall;
    // 获取响应头
    function GetResponseHeader(): PAnsiChar; stdcall;
    // 获取响应内容
    function GetResponseContent(): PAnsiChar; stdcall;
    // 获取本地文件名【上传/下载文件时使用】
    function GetLocaleFileName(): PAnsiChar; stdcall;
    // 获取远程文件名【上传/下载文件时使用】
    function GetRemoteFileName(): PAnsiChar; stdcall;
    // 获取文件的mime类型【上传/下载文件时使用】【详情查阅MimeType.pas】
    //function GetFileMimeType(): PAnsiChar; stdcall;

    // 设置/获取下载文件回调对象
    function SetDownloadFileCallback(const pCallback: ITransferFileCallback): HRESULT; stdcall;
    function GetDownloadFileCallback(out pCallback: ITransferFileCallback): HRESULT; stdcall;
    // 设置/获取上传文件回调对象
    function SetUploadFileCallback(const pCallback: ITransferFileCallback): HRESULT; stdcall;
    function GetUploadFileCallback(out pCallback: ITransferFileCallback): HRESULT; stdcall;

    (*******************************************************************************
     * 功  能: 发送请求                                                            *
     * 参  数:                                                                     *
     *   pRequestParameter: 请求参数，详情参见【HttpworkParameterStatement.pas】   *
     * 返回值:                                                                     *
     *   成功返回S_OK, 否则返回对应的错误码.                                       *
     *******************************************************************************)
    function Request(const pRequestParameter: IHttpworkParameterContract): HRESULT; stdcall;

    (*******************************************************************************
     * 功  能: 上传文件                                                            *
     * 参  数:                                                                     *
     *   pszRequestAddress: 上传地址                                               *
     *   pszRequestParameters: 请求数据/请求参数                                   *
     *   pRequestHeaders: 请求头数组                                               *
     *   nRequestHeaderCount: 请求头总数                                           *
     *   pszLocaleFileName: 要上传的本地文件名【上传/下载文件时使用】              *
     *   pszProxyAddress: 代理服务器地址，如：socks5://127.0.0.1:1080              *
     *   pszProxyUsername: 代理服务器登录账户                                      *
     *   pszProxyPassword: 代理服务器登录密码                                      *
     * 返回值:                                                                     *
     *   成功返回S_OK, 否则返回对应的错误码.                                       *
     *******************************************************************************)
    function UploadFile(const pszRequestAddress: PAnsiChar; const pszRequestParameters: PAnsiChar;
      const pRequestHeaders: PPAnsiChar; const nRequestHeaderCount: Integer;
      const pszLocaleFileName: PAnsiChar; const pszProxyAddress: PAnsiChar = nil;
      const pszProxyUsername: PAnsiChar = nil; const pszProxyPassword: PAnsiChar = nil): HRESULT; stdcall;

    (*******************************************************************************
     * 功  能: 下载文件                                                            *
     * 参  数:                                                                     *
     *   pszRequestAddress: 上传地址                                               *
     *   pRequestHeaders: 请求头数组                                               *
     *   nRequestHeaderCount: 请求头总数                                           *
     *   pszLocaleFileName: 要上传的本地文件名【上传/下载文件时使用】              *
     *   pszProxyAddress: 代理服务器地址，如：socks5://127.0.0.1:1080              *
     *   pszProxyUsername: 代理服务器登录账户                                      *
     *   pszProxyPassword: 代理服务器登录密码                                      *
     * 返回值:                                                                     *
     *   成功返回S_OK, 否则返回对应的错误码.                                       *
     *******************************************************************************)
    function DownloadFile(const pszRequestAddress: PAnsiChar;
      const pRequestHeaders: PPAnsiChar; const nRequestHeaderCount: Integer;
      const pszLocaleFileName: PAnsiChar; const pszProxyAddress: PAnsiChar = nil;
      const pszProxyUsername: PAnsiChar = nil; const pszProxyPassword: PAnsiChar = nil): HRESULT; stdcall;
  //published
    { published declarations }
  end;

implementation

uses
  System.AnsiStrings,
{$IFDEF MSWINDOWS}
  Winapi.Windows,
{$ENDIF MSWINDOWS}
  Constants.ProtocolType, Constants.RequestMethod, Functions.StringsUtils;

type
  // 下载文件回调
  PCURL_RESPONSE_FILE_CONTENT_PARAMETER  = ^CURL_RESPONSE_FILE_CONTENT_PARAMETER;
  _CURL_RESPONSE_FILE_CONTENT_PARAMETER_ = record
    hFile: THANDLE; // 文件句柄
    pSender: IUnknown; // 调用方，即传递给回调方法的 pSender
    pDownloadFileRoutine: ITransferFileCallback; // 回调对象
    pDownloadFileRoutineParameter: record // 回调函数对应的参数
      szRemoteName: PAnsiChar; // 远程文件名
      szLocaleName: PAnsiChar; // 本地文件名
      nProgress:    UINT64;    // 当前文件进度
      nTotalSize:   UINT64;    // 文件总大小
    end;
  end;
  CURL_RESPONSE_FILE_CONTENT_PARAMETER   = _CURL_RESPONSE_FILE_CONTENT_PARAMETER_;

  // 上传文件回调
  PCURL_REQUEST_FILE_CONTENT_PARAMETER   = ^CURL_REQUEST_FILE_CONTENT_PARAMETER;
  _CURL_REQUEST_FILE_CONTENT_PARAMETER_  = record
    hFile: THANDLE; // 文件句柄
    pSender: IUnknown; // 调用方，即传递给回调方法的 pSender
    pUploadFileRoutine: ITransferFileCallback; // 回调对象
    pUploadFileRoutineParameter: record // 回调函数对应的参数
      szRemoteName: PAnsiChar; // 远程文件名
      szLocaleName: PAnsiChar; // 本地文件名
      nProgress:    UINT64;    // 当前文件进度
      nTotalSize:   UINT64;    // 文件总大小
    end;
  end;
  CURL_REQUEST_FILE_CONTENT_PARAMETER    = _CURL_REQUEST_FILE_CONTENT_PARAMETER_;

const
  // Winapi.MMSystem
  SEEK_SET = 0; // The offset is set to offset bytes. offset为0时表示文件开始位置。
  SEEK_CUR = 1; // The offset is set to its current location plus offset bytes. offset为0时表示当前位置。
  SEEK_END = 2; // The offset is set to the size of the file plus offset bytes. offset为0时表示结尾位置

var
  __pGlobalContextTokenLockObject__: TObject = nil;

function GlobalContextTokenLockObject(): TObject; inline;
begin
  if (nil = __pGlobalContextTokenLockObject__) then
    __pGlobalContextTokenLockObject__ := TObject.Create();
  Result := __pGlobalContextTokenLockObject__;
end;

function ResponseContentCallback(pContents: Pointer;
  nMemberSize: LongWord; nMemberCount: LongWord;
  pUserParameter: Pointer): LongWord; cdecl;
var
  nContentSize: LongWord;
  sContent: AnsiString;
  psParameter: PAnsiString;
begin
  TMonitor.Enter(GlobalContextTokenLockObject());
  try
    nContentSize := nMemberSize * nMemberCount;
    SetString(sContent, PAnsiChar(pContents), nMemberCount);
    if (nil <> pUserParameter) then
    begin
      psParameter := PAnsiString(pUserParameter);
      psParameter^ := psParameter^ + sContent;
    end;
    Result := nContentSize;
  finally
    TMonitor.Exit(GlobalContextTokenLockObject());
  end;
end;

function ResponseHeaderCallback(pHeaders: Pointer;
  nMemberSize: LongWord; nMemberCount: LongWord;
  pUserParameter: Pointer): LongWord; cdecl;
var
  nHeaderSize: LongWord;
  sHeader: AnsiString;
  psParameter: PAnsiString;
begin
  TMonitor.Enter(GlobalContextTokenLockObject());
  try
    nHeaderSize := nMemberSize * nMemberCount;
    SetString(sHeader, PAnsiChar(pHeaders), nMemberCount);
    if (nil <> pUserParameter) then
    begin
      psParameter := PAnsiString(pUserParameter);
      psParameter^ := psParameter^ + sHeader;
    end;
    Result := nHeaderSize;
  finally
    TMonitor.Exit(GlobalContextTokenLockObject());
  end;
end;

function ResponseFileContentCallback(pContents: Pointer;
  nMemberSize: LongWord; nMemberCount: LongWord;
  pUserParameter: Pointer): LongWord; cdecl;
var
  nContentSize, nReturnSize: LongWord;
  pParameter: PCURL_RESPONSE_FILE_CONTENT_PARAMETER;
begin
  TMonitor.Enter(GlobalContextTokenLockObject());
  try
    nContentSize := nMemberSize * nMemberCount;
    pParameter := PCURL_RESPONSE_FILE_CONTENT_PARAMETER(pUserParameter);

    if ((nil <> pParameter) and (INVALID_HANDLE_VALUE <> pParameter^.hFile) and (0 <> pParameter^.hFile)) then
    begin
      //WriteFile(pParameter^.hFile, pContents^, nContentSize, nReturnSize, nil);
      nReturnSize := FileWrite(pParameter^.hFile, pContents^, nContentSize);

      Inc(pParameter^.pDownloadFileRoutineParameter.nProgress, nReturnSize);
      if Assigned(pParameter^.pDownloadFileRoutine) then
      begin
        pParameter^.pDownloadFileRoutine.Progress(
          pParameter^.pSender,
          pParameter^.pDownloadFileRoutineParameter.szRemoteName,
          pParameter^.pDownloadFileRoutineParameter.szLocaleName,
          pParameter^.pDownloadFileRoutineParameter.nProgress,
          pParameter^.pDownloadFileRoutineParameter.nTotalSize
        );
      end;
    end;

    Result := nContentSize;
  finally
    TMonitor.Exit(GlobalContextTokenLockObject());
  end;
end;

function RequestFileContentCallback(pContents: Pointer;
  nMemberSize: LongWord; nMemberCount: LongWord;
  pUserParameter: Pointer): LongWord; cdecl;
var
  nContentSize, nReturnSize: LongWord;
  pParameter: PCURL_REQUEST_FILE_CONTENT_PARAMETER;
begin
  TMonitor.Enter(GlobalContextTokenLockObject());
  try
    nContentSize := nMemberSize * nMemberCount;
    pParameter := PCURL_REQUEST_FILE_CONTENT_PARAMETER(pUserParameter);

    if ((nil <> pParameter) and (INVALID_HANDLE_VALUE <> pParameter^.hFile) and (0 <> pParameter^.hFile)) then
    begin
      //ReadFile(pParameter^.hFile, pContents^, nContentSize, nReturnSize, nil);
      nReturnSize := FileRead(pParameter^.hFile, pContents^, nContentSize);

      Inc(pParameter^.pUploadFileRoutineParameter.nProgress, nReturnSize);
      if Assigned(pParameter^.pUploadFileRoutine) then
      begin
        pParameter^.pUploadFileRoutine.Progress(
          pParameter^.pSender,
          pParameter^.pUploadFileRoutineParameter.szRemoteName,
          pParameter^.pUploadFileRoutineParameter.szLocaleName,
          pParameter^.pUploadFileRoutineParameter.nProgress,
          pParameter^.pUploadFileRoutineParameter.nTotalSize
        );
      end;
    end;

    Result := nContentSize;
  finally
    TMonitor.Exit(GlobalContextTokenLockObject());
  end;
end;

function ForceFileFolder(const szFileName: PWideChar): Boolean; overload;
var
  nIndex, nLength: Integer;
  szBuffer: PWideChar;
begin
  Result := FALSE;
  if StringIsEmpty(szFileName) then
    Exit;

  szBuffer := StrNewW(szFileName);
  nLength := System.SysUtils.StrLen(szBuffer);

  for nIndex := nLength - 1 downto 0 do
  begin
    case szBuffer[nIndex] of
{$IFDEF MSWINDOWS}
      '/', '\', ':':
{$ELSE !MSWINDOWS}
      '/':
{$ENDIF MSWINDOWS}
      begin
{$WARNINGS OFF}
        szBuffer[nIndex + 1] := #0;
        ForceDirectories(szBuffer);
        StrDisposeW(szBuffer);
{$WARNINGS ON}
        Result := TRUE;
        Exit;
      end;
    end;
  end;
end;

function ForceFileFolder(const szFileName: PAnsiChar): Boolean; overload;
var
  nIndex, nLength: Integer;
  szBuffer: PAnsiChar;
begin
  Result := FALSE;
  if StringIsEmpty(szFileName) then
    Exit;

  szBuffer := StrNewA(szFileName);
  nLength := System.AnsiStrings.StrLen(szBuffer);

  for nIndex := nLength - 1 downto 0 do
  begin
    case szBuffer[nIndex] of
{$IFDEF MSWINDOWS}
      '/', '\', ':':
{$ELSE !MSWINDOWS}
      '/':
{$ENDIF MSWINDOWS}
      begin
{$WARNINGS OFF}
        szBuffer[nIndex + 1] := #0;
        ForceDirectories(szBuffer);
        StrDisposeA(szBuffer);
{$WARNINGS ON}
        Result := TRUE;
        Exit;
      end;
    end;
  end;
end;

{ THttpworkRealityWithCURL }

constructor THttpworkRealityWithCURL.Create();
begin
  inherited Create();
  FRequestParameter := nil;
  FResponseCode := 0;
  FResponseHeader := '';
  FResponseContent := '';
  FLastErrorCode := CURLE_OK;
  FLastErrorInfo := '';
  FDownloadFileCallback := nil;
  FUploadFileCallback := nil;
end;

destructor THttpworkRealityWithCURL.Destroy();
begin
  FUploadFileCallback := nil;
  FDownloadFileCallback := nil;
  FLastErrorInfo := '';
  FLastErrorCode := CURLE_OK;
  FResponseContent := '';
  FResponseHeader := '';
  FResponseCode := 0;
  //FRequestParameter := nil;
  inherited Destroy();
end;

function THttpworkRealityWithCURL.DownloadFile(
  const pszRequestAddress: PAnsiChar; const pRequestHeaders: PPAnsiChar;
  const nRequestHeaderCount: Integer; const pszLocaleFileName, pszProxyAddress,
  pszProxyUsername, pszProxyPassword: PAnsiChar): HRESULT;
begin
  Result := Self.Request(
    THttpworkParameterReality.From(REQUESTMETHOD_HTTP_GET,
      pszRequestAddress, nil,
      pRequestHeaders, nRequestHeaderCount,
      pszLocaleFileName, nil,
      pszProxyAddress, pszProxyUsername, pszProxyPassword
    )
  );
end;

function THttpworkRealityWithCURL.GetAddress(): PAnsiChar;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetAddress()
  else
    Result := nil;
end;

function THttpworkRealityWithCURL.GetCustomHeader(
  const nIndex: Integer): PAnsiChar;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetCustomHeader(nIndex)
  else
    Result := nil;
end;

function THttpworkRealityWithCURL.GetCustomHeaderCount(): Integer;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetCustomHeaderCount()
  else
    Result := -1;
end;

function THttpworkRealityWithCURL.GetDownloadFileCallback(
  out pCallback: ITransferFileCallback): HRESULT;
begin
  pCallback := FDownloadFileCallback;
  Result := S_OK;
end;

function THttpworkRealityWithCURL.GetErrorMessage(
  const nErrorCode: CURLCode): String;
begin
  case nErrorCode of
    CURLE_OK: { 0 }
      Result := 'success!';

    CURLE_UNSUPPORTED_PROTOCOL: { 1 }
      Result := 'unsupported protocol!';

    CURLE_FAILED_INIT: { 2 }
      Result := 'failed init!';

    CURLE_URL_MALFORMAT: { 3 }
      Result := 'URL malformat!';

    CURLE_NOT_BUILT_IN: { 4 - [was obsoleted in August 2007 for 7.17.0, reused in April 2011 for 7.21.5] }
      Result := 'not built in!';

    CURLE_COULDNT_RESOLVE_PROXY: { 5 }
      Result := 'could not resolve proxy!';

    CURLE_COULDNT_RESOLVE_HOST: { 6 }
      Result := 'could not resolve host!';

    CURLE_COULDNT_CONNECT: { 7 }
      Result := 'could not connect!';

    CURLE_WEIRD_SERVER_REPLY: { 8 }
      Result := 'weird server reply!';

    CURLE_REMOTE_ACCESS_DENIED: { 9 a service was denied by the server due to lack of access - when login fails this is not returned. }
      Result := 'a service was denied by the server due to lack of access - when login fails this is not returned.!';

    CURLE_FTP_ACCEPT_FAILED: { 10 - [was obsoleted in April 2006 for 7.15.4, reused in Dec 2011 for 7.24.0]}
      Result := 'FTP accept failed!';

    CURLE_FTP_WEIRD_PASS_REPLY: { 11 }
      Result := 'FTP weird pass reply!';

    CURLE_FTP_ACCEPT_TIMEOUT: { 12 - timeout occurred accepting server [was obsoleted in August 2007 for 7.17.0, reused in Dec 2011 for 7.24.0]}
      Result := 'FTP timeout occurred accepting server!';

    CURLE_FTP_WEIRD_PASV_REPLY: { 13 }
      Result := 'FTP weird pasv reply!';

    CURLE_FTP_WEIRD_227_FORMAT: { 14 }
      Result := 'FTP weird 227 format!';

    CURLE_FTP_CANT_GET_HOST: { 15 }
      Result := 'FTP can not get host!';

    CURLE_HTTP2: { 16 - A problem in the http2 framing layer. [was obsoleted in August 2007 for 7.17.0, reused in July 2014 for 7.38.0] }
      Result := 'a problem in the http2 framing layer!';

    CURLE_FTP_COULDNT_SET_TYPE: { 17 }
      Result := 'FTP could not set type!';

    CURLE_PARTIAL_FILE: { 18 }
      Result := 'partial file!';

    CURLE_FTP_COULDNT_RETR_FILE: { 19 }
      Result := 'FTP could not retr file!';

    CURLE_OBSOLETE20: { 20 - NOT USED }
      Result := 'unknown error code: 20!';

    CURLE_QUOTE_ERROR: { 21 - quote command failure }
      Result := 'quote command failure!';

    CURLE_HTTP_RETURNED_ERROR: { 22 }
      Result := 'HTTP returned error!';

    CURLE_WRITE_ERROR: { 23 }
      Result := 'write error!';

    CURLE_OBSOLETE24: { 24 - NOT USED }
      Result := 'unknown error code: 24!';

    CURLE_UPLOAD_FAILED: { 25 - failed upload "command" }
      Result := 'failed upload "command"!';

    CURLE_READ_ERROR: { 26 - could not open/read from file }
      Result := 'could not open|read from file!';

    CURLE_OUT_OF_MEMORY: { 27 }
      Result := 'out of memory!';

    CURLE_OPERATION_TIMEDOUT: { 28 - the timeout time was reached }
      Result := 'the timeout time was reached!';

    CURLE_OBSOLETE29: { 29 - NOT USED }
      Result := 'unknown error code: 29!';

    CURLE_FTP_PORT_FAILED: { 30 - FTP PORT operation failed }
      Result := 'FTP PORT operation failed!';

    CURLE_FTP_COULDNT_USE_REST: { 31 - the REST command failed }
      Result := 'the REST command failed!';

    CURLE_OBSOLETE32: { 32 - NOT USED }
      Result := 'unknown error code: 32!';

    CURLE_RANGE_ERROR: { 33 - RANGE "command" did not work }
      Result := 'RANGE "command" did not work!';

    CURLE_HTTP_POST_ERROR: { 34 }
      Result := 'HTTP post error!';

    CURLE_SSL_CONNECT_ERROR: { 35 - wrong when connecting with SSL }
      Result := 'wrong when connecting with SSL!';

    CURLE_BAD_DOWNLOAD_RESUME: { 36 - could not resume download }
      Result := 'could not resume download!';

    CURLE_FILE_COULDNT_READ_FILE: { 37 }
      Result := 'could not open|read file content from file!';

    CURLE_LDAP_CANNOT_BIND: { 38 }
      Result := 'LDAP cannot bind!';

    CURLE_LDAP_SEARCH_FAILED: { 39 }
      Result := 'LDAP search failed!';

    CURLE_OBSOLETE40: { 40 - NOT USED }
      Result := 'unknown error code: 40!';

    CURLE_FUNCTION_NOT_FOUND: { 41 - NOT USED starting with 7.53.0 }
      Result := 'can not found this function!';

    CURLE_ABORTED_BY_CALLBACK: { 42 }
      Result := 'aborted by callback!';

    CURLE_BAD_FUNCTION_ARGUMENT: { 43 }
      Result := 'bad function argument!';

    CURLE_OBSOLETE44: { 44 - NOT USED }
      Result := 'unknown error code: 44!';

    CURLE_INTERFACE_FAILED: { 45 - CURLOPT_INTERFACE failed }
      Result := 'option interface failed!';

    CURLE_OBSOLETE46: { 46 - NOT USED }
      Result := 'unknown error code: 46!';

    CURLE_TOO_MANY_REDIRECTS: { 47 - catch endless re-direct loops }
      Result := 'catch endless re-direct loops!';

    CURLE_UNKNOWN_OPTION: { 48 - User specified an unknown option }
      Result := 'user specified an unknown option!';

    CURLE_SETOPT_OPTION_SYNTAX: { 49 - Malformed setopt option }
      Result := 'malformed setopt option!';

    CURLE_OBSOLETE50: { 50 - NOT USED }
      Result := 'unknown error code: 50!';

    CURLE_OBSOLETE51: { 51 - NOT USED }
      Result := 'unknown error code: 51!';

    CURLE_GOT_NOTHING: { 52 - when this is a specific error }
      Result := 'when this is a specific error!';

    CURLE_SSL_ENGINE_NOTFOUND: { 53 - SSL crypto engine not found }
      Result := 'SSL crypto engine not found!';

    CURLE_SSL_ENGINE_SETFAILED: { 54 - can not set SSL crypto engine as default }
      Result := 'can not set SSL crypto engine as default!';

    CURLE_SEND_ERROR: { 55 - failed sending network data }
      Result := 'failed sending network data!';

    CURLE_RECV_ERROR: { 56 - failure in receiving network data }
      Result := 'failure in receiving network data!';

    CURLE_OBSOLETE57: { 57 - NOT IN USE }
      Result := 'unknown error code: 57!';

    CURLE_SSL_CERTPROBLEM: { 58 - problem with the local certificate }
      Result := 'problem with the local certificate!';

    CURLE_SSL_CIPHER: { 59 - could not use specified cipher }
      Result := 'could not use specified cipher!';

    CURLE_PEER_FAILED_VERIFICATION: { 60 - peer's certificate or fingerprint was not verified fine }
      Result := 'peer''s certificate or fingerprint was not verified fine!';

    CURLE_BAD_CONTENT_ENCODING: { 61 - Unrecognized/bad encoding }
      Result := 'unrecognized|bad encoding!';

    CURLE_OBSOLETE62: { 62 - NOT IN USE since 7.82.0 }
      Result := 'unknown error code: 62!';

    CURLE_FILESIZE_EXCEEDED: { 63 - Maximum file size exceeded }
      Result := 'maximum file size exceeded!';

    CURLE_USE_SSL_FAILED: { 64 - Requested FTP SSL level failed }
      Result := 'requested FTP SSL level failed!';

    CURLE_SEND_FAIL_REWIND: { 65 - Sending the data requires a rewind that failed }
      Result := 'sending the data requires a rewind that failed!';

    CURLE_SSL_ENGINE_INITFAILED: { 66 - failed to initialise ENGINE }
      Result := 'failed to initialise ENGINE!';

    CURLE_LOGIN_DENIED: { 67 - user, password or similar was not accepted and we failed to login }
      Result := 'user, password or similar was not accepted and we failed to login!';

    CURLE_TFTP_NOTFOUND: { 68 - file not found on server }
      Result := 'file not found on server!';

    CURLE_TFTP_PERM: { 69 - permission problem on server }
      Result := 'permission problem on server!';

    CURLE_REMOTE_DISK_FULL: { 70 - out of disk space on server }
      Result := 'out of disk space on server!';

    CURLE_TFTP_ILLEGAL: { 71 - Illegal TFTP operation }
      Result := 'illegal TFTP operation!';

    CURLE_TFTP_UNKNOWNID: { 72 - Unknown transfer ID }
      Result := 'unknown transfer ID!';

    CURLE_REMOTE_FILE_EXISTS: { 73 - File already exists }
      Result := 'file already exists!';

    CURLE_TFTP_NOSUCHUSER: { 74 - No such user }
      Result := 'no such user!';

    CURLE_OBSOLETE75: { 75 - NOT IN USE since 7.82.0 }
      Result := 'unknown error code: 75!';

    CURLE_OBSOLETE76: { 76 - NOT IN USE since 7.82.0 }
      Result := 'unknown error code: 76!';

    CURLE_SSL_CACERT_BADFILE: { 77 - could not load CACERT file, missing or wrong format }
      Result := 'could not load CACERT file, missing or wrong format!';

    CURLE_REMOTE_FILE_NOT_FOUND: { 78 - remote file not found }
      Result := 'remote file not found!';

    CURLE_SSH: { 79 - error from the SSH layer, somewhat generic so the error message will be of interest when this has happened }
      Result := 'error from the SSH layer, somewhat generic so the error message will be of interest when this has happened!';

    CURLE_SSL_SHUTDOWN_FAILED: { 80 - Failed to shut down the SSL connection }
      Result := 'failed to shut down the SSL connection!';

    CURLE_AGAIN: { 81 - socket is not ready for send/recv, wait till it is ready and try again (Added in 7.18.2) }
      Result := 'socket is not ready for send/recv, wait till it is ready and try again!';

    CURLE_SSL_CRL_BADFILE: { 82 - could not load CRL file, missing or wrong format (Added in 7.19.0) }
      Result := 'could not load CRL file, missing or wrong format!';

    CURLE_SSL_ISSUER_ERROR: { 83 - Issuer check failed.  (Added in 7.19.0) }
      Result := 'issuer check failed.!';

    CURLE_FTP_PRET_FAILED: { 84 - a PRET command failed }
      Result := 'a PRET command failed!';

    CURLE_RTSP_CSEQ_ERROR: { 85 - mismatch of RTSP CSeq numbers }
      Result := 'mismatch of RTSP CSEQ numbers!';

    CURLE_RTSP_SESSION_ERROR: { 86 - mismatch of RTSP Session Ids }
      Result := 'mismatch of RTSP Session IDS!';

    CURLE_FTP_BAD_FILE_LIST: { 87 - unable to parse FTP file list }
      Result := 'unable to parse FTP file list!';

    CURLE_CHUNK_FAILED: { 88 - chunk callback reported error }
      Result := 'chunk callback reported error!';

    CURLE_NO_CONNECTION_AVAILABLE: { 89 - No connection available, the session will be queued }
      Result := 'no connection available, the session will be queued!';

    CURLE_SSL_PINNEDPUBKEYNOTMATCH: { 90 - specified pinned public key did not match }
      Result := 'specified pinned public key did not match!';

    CURLE_SSL_INVALIDCERTSTATUS: { 91 - invalid certificate status }
      Result := 'invalid certificate status!';

    CURLE_HTTP2_STREAM: { 92 - stream error in HTTP/2 framing layer }
      Result := 'stream error in HTTP/2 framing layer!';

    CURLE_RECURSIVE_API_CALL: { 93 - an api function was called from inside a callback }
      Result := 'an api function was called from inside a callback!';

    CURLE_AUTH_ERROR: { 94 - an authentication function returned an error }
      Result := 'an authentication function returned an error!';

    CURLE_HTTP3: { 95 - An HTTP/3 layer problem }
      Result := 'an HTTP/3 layer problem!';

    CURLE_QUIC_CONNECT_ERROR: { 96 - QUIC connection error }
      Result := 'QUIC connection error!';

    CURLE_PROXY: { 97 - proxy handshake error }
      Result := 'proxy handshake error!';

    CURLE_SSL_CLIENTCERT: { 98 - client-side certificate required }
      Result := 'client-side certificate required!';

    CURLE_UNRECOVERABLE_POLL: { 99 - poll/select returned fatal error }
      Result := 'poll|select returned fatal error!';

    CURLE_TOO_LARGE: { 100 - a value/data met its maximum }
      Result := 'a value|data met its maximum!';

    CURLE_ECH_REQUIRED: { 101 - ECH tried but failed }
      Result := 'ECH tried but failed!';

    //CURL_LAST: { never use! }
    else
      Result := Format('unknown and not used error code: %d!', [Ord(nErrorCode)]);
  end;
end;

//function THttpworkRealityWithCURL.GetFileMimeType(): PAnsiChar;
//begin
//  if (nil <> FRequestParameter) then
//    Result := FRequestParameter.GetFileMimeType()
//  else
//    Result := nil;
//end;

function THttpworkRealityWithCURL.GetLastErrorCode(): Integer;
begin
  Result := Ord(FLastErrorCode);
end;

function THttpworkRealityWithCURL.GetLastErrorInfo(): WideString;
begin
  Result := FLastErrorInfo;
end;

function THttpworkRealityWithCURL.GetLocaleFileName(): PAnsiChar;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetLocaleFileName()
  else
    Result := nil;
end;

function THttpworkRealityWithCURL.GetMethod(): PAnsiChar;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetMethod()
  else
    Result := nil;
end;

function THttpworkRealityWithCURL.GetParameters(): PAnsiChar;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetParameters()
  else
    Result := nil;
end;

function THttpworkRealityWithCURL.GetProxyAddress(): PAnsiChar;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetProxyAddress()
  else
    Result := nil;
end;

function THttpworkRealityWithCURL.GetProxyPassword(): PAnsiChar;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetProxyPassword()
  else
    Result := nil;
end;

function THttpworkRealityWithCURL.GetProxyServerHost(): PAnsiChar;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetProxyServerHost()
  else
    Result := nil;
end;

function THttpworkRealityWithCURL.GetProxyServerPort(): Integer;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetProxyServerPort()
  else
    Result := 0;
end;

function THttpworkRealityWithCURL.GetProxyType(): PAnsiChar;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetProxyType()
  else
    Result := nil;
end;

function THttpworkRealityWithCURL.GetProxyUsername(): PAnsiChar;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetProxyUsername()
  else
    Result := nil;
end;

function THttpworkRealityWithCURL.GetRemoteFileName(): PAnsiChar;
begin
  if (nil <> FRequestParameter) then
    Result := FRequestParameter.GetRemoteFileName()
  else
    Result := nil;
end;

function THttpworkRealityWithCURL.GetRequestContent(): PAnsiChar;
begin
  Result := nil;
end;

function THttpworkRealityWithCURL.GetResponseCode(): Integer;
begin
  Result := FResponseCode;
end;

function THttpworkRealityWithCURL.GetResponseContent(): PAnsiChar;
begin
  Result := PAnsiChar(FResponseContent);
end;

function THttpworkRealityWithCURL.GetResponseHeader(): PAnsiChar;
begin
  Result := PAnsiChar(FResponseHeader);
end;

function THttpworkRealityWithCURL.GetUploadFileCallback(
  out pCallback: ITransferFileCallback): HRESULT;
begin
  pCallback := FUploadFileCallback;
  Result := S_OK;
end;

function THttpworkRealityWithCURL.Request(
  const pRequestParameter: IHttpworkParameterContract): HRESULT;
begin
  FRequestParameter := pRequestParameter;
  if (nil = FRequestParameter) then
  begin
    FLastErrorCode := CURLE_FAILED_INIT;
    FLastErrorInfo := Self.GetErrorMessage(FLastErrorCode);
  end
  else
  begin
    Self.SendRequest(
      FRequestParameter.GetMethod(),
      FRequestParameter.GetAddress(),
      FRequestParameter.GetParameters(),
      FRequestParameter.GetCustomHeaders(),
      FRequestParameter.GetCustomHeaderCount(),
      FRequestParameter.GetLocaleFileName(),
      FRequestParameter.GetRemoteFileName(),
      FRequestParameter.GetProxyType(),
      FRequestParameter.GetProxyServerHost(),
      FRequestParameter.GetProxyServerPort(),
      FRequestParameter.GetProxyUsername(),
      FRequestParameter.GetProxyPassword()
    );
  end;
  Result := HRESULT(Ord(FLastErrorCode));
end;

(*******************************************************************************
 * 功  能: 发送请求                                                            *
 * 参  数:                                                                     *
 *   pszRequestMethod: 请求方式，如：GET/POST/PUT/DELETE，详情查阅【RequestMethod.pas】
 *   pszRequestAddress: 请求地址                                               *
 *   pszRequestParameters: 请求数据/请求参数                                   *
 *   pRequestHeaders: 请求头数组                                               *
 *   nRequestHeaderCount: 请求头总数                                           *
 *   pszLocaleFileName: 本地文件名【上传/下载文件时使用】                      *
 *   pszRemoteFileName: 远程文件名【上传/下载文件时使用】                      *
 *   pszProxyType: 代理服务器类型，如：socks5、http、https等，详情请查阅【ProxyType.pas】
 *   pszProxyServerHost: 代理服务器地址，如：socks5://127.0.0.1:1080           *
 *   nProxyServerPort: 代理服务器地址，如：1080                                *
 *   pszProxyUsername: 代理服务器登录账户                                      *
 *   pszProxyPassword: 代理服务器登录密码                                      *
 * 返回值:                                                                     *
 *   成功返回 TRUE , 否则返回 FALSE 。                                         *
 *   错误码与错误信息可通过 FLastErrorCode 与 FLastErrorInfo 查看。            *
 *******************************************************************************)
function THttpworkRealityWithCURL.SendRequest(pszRequestMethod,
  pszRequestAddress, pszRequestParameters: PAnsiChar;
  pRequestHeaders: PPAnsiChar; nRequestHeaderCount: Integer; pszLocaleFileName,
  pszRemoteFileName, pszProxyType, pszProxyServerHost: PAnsiChar;
  nProxyServerPort: Integer; pszProxyUsername, pszProxyPassword: PAnsiChar): Boolean;
var
  pHandle: CURL;
  pHeaders: PCURL_SLIST;
  ptType: CURL_PROXYTYPE;
  pszRequestHeader: PAnsiChar;
  nIndex: Integer;

  sResponseContent, sResponseHeader, sContentLength: AnsiString;
  szResult: PAnsiChar;
  nResult: LongWord;
  hLocaleFileHandle: THANDLE;

  pRequestFileParameter: CURL_REQUEST_FILE_CONTENT_PARAMETER; // 请求【上传文件】回调函数参数对象
  pResponseFileParameter: CURL_RESPONSE_FILE_CONTENT_PARAMETER; // 响应【下载文件】回调函数参数对象

  rtRequestType: (rtDownloadFile, rtUploadFile, rtOther);
begin
  // 初始化
  FLastErrorCode := CURLCode(curl_global_init(CURL_GLOBAL_DEFAULT));
  if (CURLE_OK <> FLastErrorCode) then
  begin
    //Result := CURLE_FAILED_INIT;
    FLastErrorInfo := Self.GetErrorMessage(FLastErrorCode);
    Exit(FALSE);
  end;

  pHandle := curl_easy_init();
  if (nil = pHandle) then
  begin
    curl_global_cleanup();
    FLastErrorCode := CURLE_FAILED_INIT;
    FLastErrorInfo := Self.GetErrorMessage(FLastErrorCode);
    Exit(FALSE);
  end;

  pHeaders := nil;
  hLocaleFileHandle := 0;
  rtRequestType := rtOther;

  { 设置curl参数 }
  // 请求地址
  curl_easy_setopt(pHandle, CURLOPT_URL, pszRequestAddress);
  // referer头地址
  curl_easy_setopt(pHandle, CURLOPT_REFERER, pszRequestAddress);

  //curl_easy_setopt($pHandle, );
  //curl_easy_setopt($pHandle, );
  if (nil <> pszRequestParameters) and (#0 <> pszRequestParameters^) then
  begin
    sContentLength := AnsiString(Format('Content-length: %d', [Length(pszRequestParameters)]));
    curl_slist_append(pHeaders, PAnsiChar(sContentLength));
  end;

  // 自定义请求头
  if (nil <> pRequestHeaders) and (0 <> nRequestHeaderCount) then
  begin
    for nIndex := 0 to nRequestHeaderCount - 1 do
    begin
      pszRequestHeader := pRequestHeaders^;
      //curl_easy_setopt(pHandle, CURLOPT_HTTPHEADER, pszRequestHeader);
      pHeaders := curl_slist_append(pHeaders, pszRequestHeader);
      Inc(pRequestHeaders);
    end;
    // 请求头信息
    curl_easy_setopt(pHandle, CURLOPT_HTTPHEADER, pHeaders);
  end;


  // 设置保存HTTP请求头信息到response data
  //curl_easy_setopt(pHandle, CURLOPT_HEADER, 1);

  // 设置是否根据服务器返回 HTTP 头中的 "Location: " 重定向。（注意：这是递归的，"Location: " 发送几次就重定向几次，除非设置了 CURLOPT_MAXREDIRS，限制最大重定向次数。）。
  curl_easy_setopt(pHandle, CURLOPT_FOLLOWLOCATION, 1);

  // 设置是否验证对等证书（peer's certificate）。要验证的交换证书可以在 CURLOPT_CAINFO 选项中设置，或在 CURLOPT_CAPATH中设置证书目录。
  curl_easy_setopt(pHandle, CURLOPT_SSL_VERIFYPEER, 0);
  // 设置是否检查服务器SSL证书中是否存在一个公用名(common name)。
  curl_easy_setopt(pHandle, CURLOPT_SSL_VERIFYHOST, 0);
  // 设置是否验证证书状态。
  curl_easy_setopt(pHandle, CURLOPT_SSL_VERIFYSTATUS, 0);
  // 设置ssl版本
  curl_easy_setopt(pHandle, CURLOPT_SSLVERSION, CURL_SSLVERSION_DEFAULT);


  // 根据不同的请求方式，如：GET/POST/PUT/DELETE，详情查阅【RequestMethod.pas】进行不同的初始化设置
  if Functions.StringsUtils.SameText(pszRequestMethod, REQUESTMETHOD_HTTP_GET) then // GET
  begin
    curl_easy_setopt(pHandle, CURLOPT_HTTPGET, TRUE); // 请求类型为GET

    // 设置响应内容回调函数用于处理接收到的数据。
    if (StringIsEmpty(pszLocaleFileName)) then
    begin
      // 当本地文件名为空表示不是下载文件，此时将直接接收响应数据到指定的变量中。
      sResponseContent := '';
      curl_easy_setopt(pHandle, CURLOPT_WRITEFUNCTION, Pointer(@ResponseContentCallback));
      curl_easy_setopt(pHandle, CURLOPT_WRITEDATA, Pointer(@sResponseContent));
    end
    else
    begin
      // 当本地文件名不为空时表示本次需要下载文件，此时将接收响应数据到指定文件中。
      pResponseFileParameter.pDownloadFileRoutine := FDownloadFileCallback; // 指定的下载回调对象
      pResponseFileParameter.pSender := Self as IUnknown;
      pResponseFileParameter.pDownloadFileRoutineParameter.nTotalSize := 0; // 文件总大小
      pResponseFileParameter.pDownloadFileRoutineParameter.nProgress := 0; // 已下载大小
      pResponseFileParameter.pDownloadFileRoutineParameter.szRemoteName := pszRequestAddress; // 远程文件名
      pResponseFileParameter.pDownloadFileRoutineParameter.szLocaleName := pszLocaleFileName; // 本地文件名
      pResponseFileParameter.hFile := FileCreate(String(AnsiString(pszLocaleFileName))); // 创建文件
      hLocaleFileHandle := pResponseFileParameter.hFile;

      // 设置响应内容回调函数
      curl_easy_setopt(pHandle, CURLOPT_WRITEFUNCTION, Pointer(@ResponseFileContentCallback));
      curl_easy_setopt(pHandle, CURLOPT_WRITEDATA, Pointer(@pResponseFileParameter));

      // 标记为下载文件
      rtRequestType := rtDownloadFile;
    end;
  end
  else if Functions.StringsUtils.SameText(pszRequestMethod, REQUESTMETHOD_HTTP_POST) // POST
    or Functions.StringsUtils.SameText(pszRequestMethod, REQUESTMETHOD_HTTP_PUT) // PUT
    or Functions.StringsUtils.SameText(pszRequestMethod, REQUESTMETHOD_HTTP_PATCH) // PATCH
  then
  begin
    if Functions.StringsUtils.SameText(pszRequestMethod, REQUESTMETHOD_HTTP_POST) then
      curl_easy_setopt(pHandle, CURLOPT_POST, TRUE) // 请求类型为POST
    else
      curl_easy_setopt(pHandle, CURLOPT_CUSTOMREQUEST, pszRequestMethod); // 请求类型为自定义

    // 绑定请求参数
    if (StringIsEmpty(pszRequestParameters)) then
      curl_easy_setopt(pHandle, CURLOPT_POSTFIELDS, PAnsiChar(''))
    else
      curl_easy_setopt(pHandle, CURLOPT_POSTFIELDS, pszRequestParameters);

    if (not StringIsEmpty(pszLocaleFileName)) then
    begin
      // 如果指定了本地文件名则表示本次请求为上传文件，则需要设置读取回调函数读取文件内容并发送至服务器。
      pRequestFileParameter.pUploadFileRoutine := FUploadFileCallback; // 指定的上传回调函数
      pRequestFileParameter.pSender := Self as IUnknown;
      pRequestFileParameter.pUploadFileRoutineParameter.nTotalSize := 0; // 文件总大小
      pRequestFileParameter.pUploadFileRoutineParameter.nProgress := 0; // 已上传大小
      pRequestFileParameter.pUploadFileRoutineParameter.szRemoteName := pszRequestAddress; // 远程文件名
      pRequestFileParameter.pUploadFileRoutineParameter.szLocaleName := pszLocaleFileName; // 本地文件名
      pRequestFileParameter.hFile := FileOpen(String(AnsiString(pszLocaleFileName)), fmOpenRead); // 打开文件
      hLocaleFileHandle := pRequestFileParameter.hFile;
      if (INVALID_HANDLE_VALUE <> hLocaleFileHandle) and (0 <> hLocaleFileHandle) then
      begin
        pRequestFileParameter.pUploadFileRoutineParameter.nTotalSize := FileSeek(hLocaleFileHandle, Int64(0), SEEK_END);
        FileSeek(hLocaleFileHandle, Int64(0), SEEK_SET);
      end;

      // 设置请求内容回调函数
      curl_easy_setopt(pHandle, CURLOPT_READFUNCTION, Pointer(@RequestFileContentCallback));
      curl_easy_setopt(pHandle, CURLOPT_READDATA, Pointer(@pRequestFileParameter));

      // 标记为上传文件
      rtRequestType := rtUploadFile;
    end;

    // 设置响应内容回调函数
    sResponseContent := '';
    curl_easy_setopt(pHandle, CURLOPT_WRITEFUNCTION, Pointer(@ResponseContentCallback));
    curl_easy_setopt(pHandle, CURLOPT_WRITEDATA, Pointer(@sResponseContent));
  end
  else
  begin
    curl_easy_setopt(pHandle, CURLOPT_CUSTOMREQUEST, pszRequestMethod); // 请求类型为自定义

    // 当本地文件名为空表示不是下载文件，此时将直接接收响应数据到指定的变量中。
    sResponseContent := '';
    curl_easy_setopt(pHandle, CURLOPT_WRITEFUNCTION, Pointer(@ResponseContentCallback));
    curl_easy_setopt(pHandle, CURLOPT_WRITEDATA, Pointer(@sResponseContent));
  end;

  // 设置响应头回调函数
  sResponseHeader := '';
  curl_easy_setopt(pHandle, CURLOPT_HEADERFUNCTION, Pointer(@ResponseHeaderCallback));
  curl_easy_setopt(pHandle, CURLOPT_HEADERDATA, Pointer(@sResponseHeader));


  // 设置请求内容回调函数
  //curl_easy_setopt(pHandle, CURLOPT_READFUNCTION, Pointer(@RequestFileContentCallbackW));
  //curl_easy_setopt(pHandle, CURLOPT_READDATA, Pointer(@pParameter));

  // 设置响应内容回调函数
  //sResponseContent := '';
  //curl_easy_setopt(pHandle, CURLOPT_WRITEFUNCTION, Pointer(@ResponseContentCallback));
  //curl_easy_setopt(pHandle, CURLOPT_WRITEDATA, Pointer(@sResponseContent));

  // 设置响应头回调函数
  //sResponseHeader := '';
  //curl_easy_setopt(pHandle, CURLOPT_HEADERFUNCTION, Pointer(@ResponseHeaderCallback));
  //curl_easy_setopt(pHandle, CURLOPT_HEADERDATA, Pointer(@sResponseHeader));

  // 设置超时
  curl_easy_setopt(pHandle, CURLOPT_TIMEOUT, 0);


  // 代理信息
  if not (StringIsEmpty(pszProxyType) or StringIsEmpty(pszProxyServerHost)) then
  begin
    if (Functions.StringsUtils.SameText(pszProxyType, PROXYTYPE_NONE)) then
      ptType := CURLPROXY_NONE
    else if (Functions.StringsUtils.SameText(pszProxyType, PROXYTYPE_HTTP)) then
      ptType := CURLPROXY_HTTP
    else if (Functions.StringsUtils.SameText(pszProxyType, PROXYTYPE_HTTPS)) then
      ptType := CURLPROXY_HTTPS
    else if (Functions.StringsUtils.SameText(pszProxyType, PROXYTYPE_SOCKS)) then
      ptType := CURLPROXY_SOCKS4
    else if (Functions.StringsUtils.SameText(pszProxyType, PROXYTYPE_SOCKS4)) then
      ptType := CURLPROXY_SOCKS4
    else if (Functions.StringsUtils.SameText(pszProxyType, PROXYTYPE_SOCKS4A)) then
      ptType := CURLPROXY_SOCKS4A
    else if (Functions.StringsUtils.SameText(pszProxyType, PROXYTYPE_SOCKS5)) then
      ptType := CURLPROXY_SOCKS5
    else
      ptType := CURLPROXY_HTTP;
  end
  else
    ptType := CURLPROXY_NONE;

  if (CURLPROXY_NONE <> ptType) then
  begin
    curl_easy_setopt(pHandle, CURLOPT_PROXYTYPE, TCurlProxyType(ptType));
    curl_easy_setopt(pHandle, CURLOPT_PROXY, pszProxyServerHost);
    curl_easy_setopt(pHandle, CURLOPT_PROXYPORT, nProxyServerPort);
    if (not StringIsEmpty(pszProxyUsername)) then
      curl_easy_setopt(pHandle, CURLOPT_PROXYUSERNAME, pszProxyUsername);
    if (not StringIsEmpty(pszProxyPassword)) then
      curl_easy_setopt(pHandle, CURLOPT_PROXYPASSWORD, pszProxyPassword);
  end;

  // 判断行为，如果是传输文件则需要调用回调对象的指定方法。
  case rtRequestType of
    rtDownloadFile:
    begin
      // 开始下载回调
      if Assigned(FDownloadFileCallback) then
        FDownloadFileCallback.Start(Self, pszRequestAddress, pszLocaleFileName);
    end;

    rtUploadFile:
    begin
      // 开始上传回调
      if Assigned(FUploadFileCallback) then
        FUploadFileCallback.Start(Self, pszRequestAddress, pszLocaleFileName);
    end;
  end;

  // 执行数据请求
  FLastErrorCode := CURLCode(curl_easy_perform(pHandle));
  // 获取对应的错误信息
  FLastErrorInfo := Self.GetErrorMessage(FLastErrorCode);
  // 关闭文件
  if (INVALID_HANDLE_VALUE <> hLocaleFileHandle) or (0 <> hLocaleFileHandle) then
  begin
    FileClose(hLocaleFileHandle);
  end;

  if (CURLE_OK = FLastErrorCode) then
  begin
    // 获取HTTP响应码
    curl_easy_getinfo(pHandle, CURLINFO_HTTP_CODE, FResponseCode);

    szResult := nil; // 解压后的数据
    nResult := 0; // 解压后数据的长度

    if (ProcessData(PAnsiChar(sResponseContent), Length(sResponseContent), szResult, nResult)) then
      SetString(FResponseContent, szResult, nResult) // 响应内容
    else
      FResponseContent := sResponseContent; // 响应内容

    FResponseHeader := sResponseHeader; // 响应头

    // 判断行为，如果是传输文件则需要调用回调对象的指定方法。
    case rtRequestType of
      rtDownloadFile:
      begin
        // 完成下载回调
        if Assigned(FDownloadFileCallback) then
          FDownloadFileCallback.Done(Self, pszRequestAddress, pszLocaleFileName);
      end;

      rtUploadFile:
      begin
        // 完成上传回调
        if Assigned(FUploadFileCallback) then
          FUploadFileCallback.Done(Self, pszRequestAddress, pszLocaleFileName);
      end;
    end;
  end
  else //if Functions.StringsUtils.SameText(pszRequestMethod, REQUESTMETHOD_HTTP_GET) then
  begin
    // 判断行为，如果是传输文件则需要调用回调对象的指定方法。
    case rtRequestType of
      rtDownloadFile:
      begin
        // 下载错误要删除未下载完毕的文件
        System.SysUtils.DeleteFile(StringValueP(pszLocaleFileName));

        // 下载发生错误回调
        if Assigned(FDownloadFileCallback) then
          FDownloadFileCallback.Error(Self, pszRequestAddress, pszLocaleFileName,
            Ord(FLastErrorCode), FLastErrorInfo);
      end;

      rtUploadFile:
      begin
        // 上传发生错误回调
        if Assigned(FUploadFileCallback) then
          FUploadFileCallback.Error(Self, pszRequestAddress, pszLocaleFileName,
            Ord(FLastErrorCode), FLastErrorInfo);
      end;
    end;
  end;

  // 清理资源
  if (nil <> pHeaders) then
    curl_slist_free_all(pHeaders);
  if (nil <> pHandle) then
    curl_easy_cleanup(pHandle);
  curl_global_cleanup();

  Result := (CURLE_OK = FLastErrorCode);
end;

function THttpworkRealityWithCURL.SetDownloadFileCallback(
  const pCallback: ITransferFileCallback): HRESULT;
begin
  FDownloadFileCallback := pCallback;
  Result := S_OK;
end;

function THttpworkRealityWithCURL.SetUploadFileCallback(
  const pCallback: ITransferFileCallback): HRESULT;
begin
  FUploadFileCallback := pCallback;
  Result := S_OK;
end;

function THttpworkRealityWithCURL.UploadFile(const pszRequestAddress,
  pszRequestParameters: PAnsiChar; const pRequestHeaders: PPAnsiChar;
  const nRequestHeaderCount: Integer; const pszLocaleFileName, pszProxyAddress,
  pszProxyUsername, pszProxyPassword: PAnsiChar): HRESULT;
begin
  Result := Self.Request(
    THttpworkParameterReality.From(REQUESTMETHOD_HTTP_POST,
      pszRequestAddress, pszRequestParameters,
      pRequestHeaders, nRequestHeaderCount,
      pszLocaleFileName, nil,
      pszProxyAddress, pszProxyUsername, pszProxyPassword
    )
  );
end;

initialization

finalization
  if (nil <> __pGlobalContextTokenLockObject__) then
    FreeAndNil(__pGlobalContextTokenLockObject__);
end.
