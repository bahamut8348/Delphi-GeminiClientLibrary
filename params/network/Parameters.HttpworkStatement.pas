unit Parameters.HttpworkStatement;

interface

uses
  Parameters.NetworkStatement;

type
  IHttpworkParameterContract = interface(INetworkParameterContract)
    ['{138EED11-9DC3-45D6-B36D-478CCE79628E}']
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
  end;

implementation

end.
