unit Constants.ProtocolType;

interface

const

  {**
   * [<protocol>=][<scheme>://]<proxy>[:<port>]
   *}
  {**
   * proxy server type
   *
   * https://en.wikipedia.org/wiki/Proxy_server
   * https://zh.wikipedia.org/wiki/%E4%BB%A3%E7%90%86%E6%9C%8D%E5%8A%A1%E5%99%A8
   *}
  PROXYTYPE_NONE                       = '';

  // PROXYTYPE_HTTP HTTP代理服务器：主要用于访问网页，一般有内容过滤和缓存功能。端口一般为80、8080、3128等。
  PROXYTYPE_HTTP                       = 'HTTP';
  // PROXYTYPE_HTTPS SSL/TLS代理（HTTPS代理）：主要用于访问HTTPS网站。端口一般为443。
  PROXYTYPE_HTTPS                      = 'HTTPS';
  // PROXYTYPE_SOCKS SOCKS代理：只是单纯传递数据包，不关心具体协议和用法，所以速度快很多。端口一般为1080。
  PROXYTYPE_SOCKS                      = 'SOCKS';
  // PROXYTYPE_SOCKS4 SOCKS4代理：只是单纯传递数据包，不关心具体协议和用法，所以速度快很多。端口一般为1080。
  PROXYTYPE_SOCKS4                     = 'SOCKS4';
  // PROXYTYPE_SOCKS4A SOCKS4A代理：只是单纯传递数据包，不关心具体协议和用法，所以速度快很多。端口一般为1080。
  PROXYTYPE_SOCKS4A                    = 'SOCKS4A';
  // PROXYTYPE_SOCKS5 SOCKS代理：只是单纯传递数据包，不关心具体协议和用法，所以速度快很多。端口一般为1080。
  PROXYTYPE_SOCKS5                     = 'SOCKS5';

  PROXYTYPE_FTP                        = 'FTP';
  PROXYTYPE_FTPS                       = 'FTPS';
  PROXYTYPE_FILE                       = 'FILE';
  PROXYTYPE_RTSP                       = 'RTSP';
  PROXYTYPE_POP3                       = 'POP3';
  PROXYTYPE_SMTP                       = 'SMTP';

  // 方案类型
  SCHEMETYPE_NONE                      = '';
  SCHEMETYPE_FTP                       = 'ftp';
  SCHEMETYPE_FILE                      = 'file';
  SCHEMETYPE_HTTP                      = 'http';
  SCHEMETYPE_HTTPS                     = 'https';
  SCHEMETYPE_SOCKS                     = 'socks';
  SCHEMETYPE_SOCKS4                    = 'socks4';
  SCHEMETYPE_SOCKS4A                   = 'socks4a';
  SCHEMETYPE_SOCKS5                    = 'socks5';

  // 地址中的方案
  SCHEME_FTP                           = 'ftp://';
  SCHEME_FILE                          = 'file://';
  SCHEME_HTTP                          = 'http://';
  SCHEME_HTTPS                         = 'https://';
  SCHEME_SOCKS                         = 'socks://';
  SCHEME_SOCKS4                        = 'socks4://';
  SCHEME_SOCKS4A                       = 'socks4://';
  SCHEME_SOCKS5                        = 'socks5://';

  // 协议分隔符（http=、https=、ftp=、ftps=、ws=、wss=、socks=、socks5=等）
  DELIMITER_PROTOCOL                   = '=';
  // 方案分隔符（http://、https://、ftp://、ftps://、ws://、wss://、socks://、socks5://等）
  DELIMITER_SCHEME                     = '://';
  // 地址与端口分隔符
  DELIMITER_ADDRESS_PORT               = ':';
  // 账号与密码分隔符
  DELIMITER_USERNAME_PASSWORD          = '@';
  // 请求参数分隔符
  DELIMITER_QUERY_PARAMETER            = '?';
  // 标记分隔符
  DELIMITER_FRAGMENT                   = '#';
  // 两个参数间的分隔符
  DELIMITER_PARAMETER                  = '&';
  // HTTP请求头与报文正文分隔符
  DELIMITER_HTTPDOCUMENT_HEADER_CONTENT = #13#10#13#10;

  ADDRESS_NONE_V4                      = '0.0.0.0';
  ADDRESS_NONE_V6                      = '::/128';

implementation

end.
