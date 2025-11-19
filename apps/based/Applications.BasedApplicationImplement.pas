unit Applications.BasedApplicationImplement;

interface

uses
  Applications.BasedApplicationStatement,
  Models.BasedModelStatement;

type
{$M+}
{$METHODINFO ON}
  TApplicationReality = class(TInterfacedObject, IApplicationContract)
  private
    { private declarations }
    FProxyAddress: WideString;
    FProxyUsername: WideString;
    FProxyPassword: WideString;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(); reintroduce; virtual;
    destructor Destroy(); override;
  public
    { public declarations }

    { IApplicationContract Method }
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
  published
    { published declarations }
  end;
{$METHODINFO OFF}
{$M-}

implementation

{ TApplicationReality }

constructor TApplicationReality.Create();
begin
  inherited Create();
  Self.FProxyAddress := '';
  Self.FProxyUsername := '';
  Self.FProxyPassword := '';
end;

destructor TApplicationReality.Destroy();
begin
  Self.FProxyPassword := '';
  Self.FProxyUsername := '';
  Self.FProxyAddress := '';
  inherited Destroy();
end;

function TApplicationReality.GetModel(
  const szModelName: WideString): IModelContract;
begin
  Result := nil;
end;

function TApplicationReality.GetProxyAddress(): WideString;
begin
  Result := Self.FProxyAddress;
end;

function TApplicationReality.GetProxyPassword(): WideString;
begin
  Result := Self.FProxyPassword;
end;

function TApplicationReality.GetProxyUsername(): WideString;
begin
  Result := Self.FProxyUsername;
end;

function TApplicationReality.SetProxyAddress(
  const szProxyAddress: WideString): HRESULT;
begin
  Self.FProxyAddress := szProxyAddress;
  Result := S_OK;
end;

function TApplicationReality.SetProxyPassword(
  const szProxyPassword: WideString): HRESULT;
begin
  Self.FProxyPassword := szProxyPassword;
  Result := S_OK;
end;

function TApplicationReality.SetProxyUsername(
  const szProxyUsername: WideString): HRESULT;
begin
  Self.FProxyUsername := szProxyUsername;
  Result := S_OK;
end;

end.

