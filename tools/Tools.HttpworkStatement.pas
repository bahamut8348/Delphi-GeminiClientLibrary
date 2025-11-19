unit Tools.HttpworkStatement;

interface

uses
  Tools.NetworkStatement, Parameters.HttpworkStatement;

type
  (*******************************************************************************
   * 名称: ITransferFileCallback                                                 *
   * 说明: 传输文件的回调对象【上传/下载】                                       *
   * 方法:                                                                       *
   *   Start: 开始传输时被调用                                                   *
   *   Progress: 传输过程中被调用                                                *
   *   Done：传输完毕时被调用                                                    *
   *   Error：发生错误时被调用                                                   *
   *   SetParameter: 设置附加参数，可供其他回调过程中被访问                      *
   *   GetParameter: 获取附加参数，可供其他回调过程中被访问                      *
   *******************************************************************************)
  ITransferFileCallback = interface(IUnknown)
    ['{6DAF0972-3D84-446A-8598-5A33C816BADF}']
    (*******************************************************************************
     * 名  称: Start                                                               *
     * 功  能: 开始传输时被调用                                                    *
     * 参  数:                                                                     *
     *   szRemoteName: 网络文件名【上传|下载地址】                                 *
     *   szLocaleName: 本地文件名                                                  *
     * 返回值: 忽略                                                                *
     *******************************************************************************)
    function Start(const pSender: IUnknown;
      const szRemoteName: PAnsiChar; const szLocaleName: PAnsiChar): HRESULT; stdcall;
    (*******************************************************************************
     * 名  称: Progress                                                            *
     * 功  能: 传输过程中被调用                                                    *
     * 参  数:                                                                     *
     *   szRemoteName: 网络文件名【上传|下载地址】                                 *
     *   szLocaleName: 本地文件名                                                  *
     *   nProgress：当前进度                                                       *
     *   nTotalSize：文件总大小                                                    *
     *   pParameter: 附加参数（调用函数时传入）                                    *
     * 返回值: 忽略                                                                *
     *******************************************************************************)
    function Progress(const pSender: IUnknown;
      const szRemoteName: PAnsiChar; const szLocaleName: PAnsiChar;
      const nProgress: UINT64; const nTotalSize: UINT64): HRESULT; stdcall;
    (*******************************************************************************
     * 名  称: Done                                                                *
     * 功  能: 传输完毕时被调用                                                    *
     * 参  数:                                                                     *
     *   szRemoteName: 网络文件名【上传|下载地址】                                 *
     *   szLocaleName: 本地文件名                                                  *
     * 返回值: 忽略                                                                *
     *******************************************************************************)
    function Done(const pSender: IUnknown;
      const szRemoteName: PAnsiChar; const szLocaleName: PAnsiChar): HRESULT; stdcall;
    (*******************************************************************************
     * 名  称: Error                                                               *
     * 功  能: 发生错误时被调用                                                    *
     * 参  数:                                                                     *
     *   szRemoteName: 网络文件名【上传|下载地址】                                 *
     *   szLocaleName: 本地文件名                                                  *
     *   nErrorCode: 错误码                                                        *
     *   szErrorMessage: 错误信息                                                  *
     * 返回值: 忽略                                                                *
     *******************************************************************************)
    function Error(const pSender: IUnknown;
      const szRemoteName: PAnsiChar; const szLocaleName: PAnsiChar;
      const nErrorCode: Integer; const szErrorMessage: WideString): HRESULT; stdcall;

    (*******************************************************************************
     * 名  称: SetParameter | GetParameter                                         *
     * 功  能: 读写附加参数时被调用【set为设置、get为获取】                        *
     * 参  数:                                                                     *
     *   pParameter: 要设置的参数                                                  *
     * 返回值:                                                                     *
     *   成功返回 S_OK 否则返回错误码                                              *
     *******************************************************************************)
    function SetParameter(const pParameter: Pointer): HRESULT; stdcall;
    function GetParameter(out pParameter: Pointer): HRESULT; stdcall;
  end;

  IHttpworkContract = interface(INetworkContract)
    ['{D0292969-2847-4743-B54D-2A061CA19C04}']
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
     *   成功返回CURLE_OK, 否则返回错误值                                          *
     *******************************************************************************)

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
      const pszLocaleFileName: PAnsiChar; const pszProxyAddress: PAnsiChar;
      const pszProxyUsername: PAnsiChar; const pszProxyPassword: PAnsiChar): HRESULT; stdcall;

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
      const pszLocaleFileName: PAnsiChar; const pszProxyAddress: PAnsiChar;
      const pszProxyUsername: PAnsiChar; const pszProxyPassword: PAnsiChar): HRESULT; stdcall;
  end;

implementation

end.
