unit Parameters.NetworkStatement;

interface

uses
  Parameters.BasedParameterStatement;

type
  INetworkParameterContract = interface(IParameterContract)
    ['{9A96AACC-16C4-4A18-9C1E-0660538CB8AB}']
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
  end;

implementation

end.
