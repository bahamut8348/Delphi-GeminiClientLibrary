unit Models.BasedModelStatement;

interface

type
{
  模块接口的基类接口
}
  IModelContract = interface(IUnknown)
    ['{C3086B9E-A4C0-4A6A-ACC2-85759B9B8FF3}']
    // 获取代理服务器地址，【完整连接，包括代理类型、服务器域名或地址、端口，例如：socks5=socks5://127.0.0.1:1080】
    function GetProxyAddress(): PAnsiChar; stdcall;
    // 获取代理服务器登录账户
    function GetProxyUsername(): PAnsiChar; stdcall;
    // 获取服务器登录密码
    function GetProxyPassword(): PAnsiChar; stdcall;

    // 获取最后一次的错误信息
    function GetLastErrorCode(): Integer; stdcall;
    function GetLastErrorInfo(): WideString; stdcall;
  end;

implementation

end.
