unit Applications.BasedApplicationStatement;

interface

uses
  Models.BasedModelStatement;

type
  IApplicationContract = interface(IUnknown)
    ['{40576D6D-48E1-4821-BA5C-A74F8516DD8B}']
    function GetModel(const szModelName: WideString): IModelContract; stdcall;

    // 获取代理服务器地址，【完整连接，包括代理类型、服务器域名或地址、端口，例如：socks5=socks5://127.0.0.1:1080】
    function GetProxyAddress(): WideString; stdcall;
    function SetProxyAddress(const szProxyAddress: WideString): HRESULT; stdcall;
    // 获取代理服务器登录账户
    function GetProxyUsername(): WideString; stdcall;
    function SetProxyUsername(const szProxyUsername: WideString): HRESULT; stdcall;
    // 获取代理服务器登录密码
    function GetProxyPassword(): WideString; stdcall;
    function SetProxyPassword(const szProxyPassword: WideString): HRESULT; stdcall;
  end;

implementation

end.

