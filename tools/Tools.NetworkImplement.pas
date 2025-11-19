unit Tools.NetworkImplement;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Defaults, System.Generics.Collections,
  Tools.NetworkStatement;

type
{$M+}
{$METHODINFO ON}
  TNetworkReality = class(TInterfacedObject, INetworkContract)
  private
    { private declarations }
  protected
    { protected declarations }
    (*******************************************************************************
     * 函数名: ProcessData                                                         *
     * 功  能: 解压web服务器返回的页面数据                                         *
     * 参  数:                                                                     *
     *   szString: 要解压的原始数据                                                *
     *   cchLength: 原始数据长度                                                   *
     *   pszOutput: 输出缓冲区，用来存放解压后的数据                               *
     *   pnOutput: 输出缓冲区长度                                                  *
     * 返回值:                                                                     *
     *   成功返回true, 否则返回false                                               *
     *******************************************************************************)
    function ProcessData(
      const szString: PAnsiChar;
      const cchLength: LongWord;
      out pszOutput: PAnsiChar;
      out pnOutput: LongWord): Boolean;
  public
    { public declarations }
    constructor Create(); reintroduce; virtual;
    destructor Destroy(); override;

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
  published
    { published declarations }
  end;
{$METHODINFO OFF}
{$M-}

implementation

uses
  BR, GZIP,
  Functions.SystemExtended, Functions.StringsUtils;

{ TNetworkReality }

constructor TNetworkReality.Create();
begin
  inherited Create();
end;

destructor TNetworkReality.Destroy();
begin
  inherited Destroy();
end;

function TNetworkReality.GetLastErrorCode(): Integer;
begin
  Result := -1;
end;

function TNetworkReality.GetLastErrorInfo(): WideString;
begin
  Result := 'not implemented!'
end;

function TNetworkReality.GetProxyAddress(): PAnsiChar;
begin
  Result := nil;
end;

function TNetworkReality.GetProxyPassword(): PAnsiChar;
begin
  Result := nil;
end;

function TNetworkReality.GetProxyServerHost(): PAnsiChar;
begin
  Result := nil;
end;

function TNetworkReality.GetProxyServerPort(): Integer;
begin
  Result := 0;
end;

function TNetworkReality.GetProxyType(): PAnsiChar;
begin
  Result := nil;
end;

function TNetworkReality.GetProxyUsername(): PAnsiChar;
begin
  Result := nil;
end;

(*******************************************************************************
 * 函数名: ProcessData                                                         *
 * 功  能: 解压web服务器返回的页面数据                                         *
 * 参  数:                                                                     *
 *   szString: 要解压的原始数据                                                *
 *   cchLength: 原始数据长度                                                   *
 *   pszOutput: 输出缓冲区，用来存放解压后的数据                               *
 *   pnOutput: 输出缓冲区长度                                                  *
 * 返回值:                                                                     *
 *   成功返回true, 否则返回false                                               *
 *******************************************************************************)
function TNetworkReality.ProcessData(const szString: PAnsiChar;
  const cchLength: LongWord; out pszOutput: PAnsiChar;
  out pnOutput: LongWord): Boolean;
var
  szBuffer: PAnsiChar;
  nBufferSize: Cardinal;
  pBRContent: Pointer;
  nTotal: Cardinal;
  bdResult: Integer; // BrotliDecoderResult;
begin
  if (StringIsEmpty(szString) or (0 = cchLength)) then
    Exit(FALSE);

  szBuffer := nil;
	nBufferSize := 0;

  // 第一次尝试用GZIP压缩算法解压缩字符串并计算需要的缓冲区大小
  DecompressGZIP(szString, cchLength, szBuffer, nBufferSize);
  if (nBufferSize > 0) then // 返回非0表示可以通过GZIP算法进行解压
  begin
		nBufferSize := ALIGNOFINT((nBufferSize + SizeOf(Integer)) * SizeOf(szBuffer^));
    GetMem(szBuffer, nBufferSize);
		if (nil <> szBuffer) then
		begin
			// 第二次才实际解压
			if (0 = DecompressGZIP(szString, cchLength, szBuffer, nBufferSize)) then // 0[Z_OK]表示成功
			begin
				szBuffer[nBufferSize] := #0; // 结束标志
				if (nil <> @pszOutput) then
					pszOutput := szBuffer; // 输出解压后的内容
				if (nil <> @pnOutput) then
					pnOutput := nBufferSize; // 输出解压后的字节长度
			end
			else
			begin
        // 解压失败了则回收内存
				FreeMem(szBuffer);
				Exit(FALSE);
			end;
		end
		else // 缓冲区申请失败则退出。
      Exit(FALSE);
  end
  else // 输出缓冲区长度为0表示无法用GZIP解压，这时尝试使用BR算法解压
  begin
		pBRContent := nil; // brstate
		nTotal := 0;
    // 计算输出缓冲区长度，默认用sizeof(int)*10倍的输入内容长度
		nBufferSize := ALIGNOFINT(cchLength * SizeOf(Integer) * 10 * SizeOf(szBuffer^));
    GetMem(szBuffer, nBufferSize); // 申请缓冲区
		if (nil <> szBuffer) then
		begin
			szBuffer^ := #0; // 首字符置为结束符，表示该缓冲区内容无意义。
      bdResult := DecompressBR(szString, cchLength, szBuffer, nBufferSize, @pBRContent, nTotal);
			if (BROTLI_DECODER_RESULT_SUCCESS = bdResult) then // 成功
			begin
				szBuffer[nBufferSize] := #0; // 结束标志
				if (nil <> @pszOutput) then
					pszOutput := szBuffer; // 输出解压后的内容
				if (nil <> @pnOutput) then
					pnOutput := nBufferSize; // 输出解压后的字节长度
			end
			else
			begin
        // 解压失败了则回收内存
				FreeMem(szBuffer);
				Exit(FALSE);
			end;
		end
		else
      Exit(FALSE);
  end;

  Result := TRUE;
end;

end.
