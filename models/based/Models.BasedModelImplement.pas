unit Models.BasedModelImplement;

interface

uses
  System.SysUtils, System.Classes,
  System.Rtti, System.TypInfo, System.ObjAuto,
  System.Generics.Defaults, System.Generics.Collections,

  Models.BasedModelStatement;

type
{$M+}
{$METHODINFO ON}
  TModelReality = class abstract(TInterfacedObject, IModelContract)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(); reintroduce; virtual;
    destructor Destroy(); override;

    // 获取代理服务器地址，【完整连接，包括代理类型、服务器域名或地址、端口，例如：socks5=socks5://127.0.0.1:1080】
    function GetProxyAddress(): PAnsiChar; stdcall;
    // 获取代理服务器登录账户
    function GetProxyUsername(): PAnsiChar; stdcall;
    // 获取服务器登录密码
    function GetProxyPassword(): PAnsiChar; stdcall;

    // 获取最后一次的错误信息
    function GetLastErrorCode(): Integer; stdcall;
    function GetLastErrorInfo(): WideString; stdcall;

    class function CreateWithTypeInfo(const pTypeInfo: Pointer): TModelReality; inline; static;
  published
    { published declarations }
  end;
{$METHODINFO OFF}
{$M-}

implementation

{ TModelReality }

constructor TModelReality.Create();
begin
  inherited Create();
end;

class function TModelReality.CreateWithTypeInfo(
  const pTypeInfo: Pointer): TModelReality;
var
  pRttiType: TRttiType;
  pMethods: TArray<TRttiMethod>;
  nIndex: Integer;
begin
  Result := nil;
  // 获取指定类型的 rtti 类型信息
  pRttiType := TRttiContext.Create().GetType(pTypeInfo);

  // 遍历所有方法，找到要求的构造函数并检查没有纯虚函数
  //pConstructor := nil;
  pMethods := pRttiType.GetMethods();
  if not Assigned(pMethods) then
    Exit;
  for nIndex := Low(pMethods) to High(pMethods) do
  begin
    if pMethods[nIndex].IsConstructor then // 静态方法
    begin
      //if (pMethods[nIndex].Visibility = mvPublic) and (Length(pMethods[nIndex].GetParameters) = 0) then
      //  pConstructor := pMethods[nIndex];
    end
    else if (nil = pMethods[nIndex].CodeAddress) then // 抽象方法
      Exit;
  end;

  // 创建实例
  Result := pRttiType.Handle.TypeData.ClassType.NewInstance() as TModelReality;
  try
    // 调用默认构造函数创建实例
    //pConstructor.Invoke(Result, []);
    Result.Create();
  except
    Result.FreeInstance(); // 出错则回收内存，这里不调用 Destory
    Result := nil;
  end;
end;

destructor TModelReality.Destroy();
begin
  inherited Destroy();
end;

function TModelReality.GetLastErrorCode(): Integer;
begin
  Result := -1;
end;

function TModelReality.GetLastErrorInfo(): WideString;
begin
  Result := 'not implemented!'
end;

function TModelReality.GetProxyAddress(): PAnsiChar;
begin
  Result := nil;
end;

function TModelReality.GetProxyPassword(): PAnsiChar;
begin
  Result := nil;
end;

function TModelReality.GetProxyUsername(): PAnsiChar;
begin
  Result := nil;
end;

end.
