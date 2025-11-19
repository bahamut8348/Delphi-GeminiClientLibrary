unit Constants.HttpStatusCode;

interface

const
  // https://learn.microsoft.com/zh-cn/windows/win32/winhttp/http-status-codes
  { http response code }
  HTTP_STATUS_CONTINUE                 = 100; // OK to continue with request
  HTTP_STATUS_SWITCH_PROTOCOLS         = 101; // server has switched protocols in upgrade header
  HTTP_STATUS_OK                       = 200; // request completed
  HTTP_STATUS_CREATED                  = 201; // object created, reason = new URI
  HTTP_STATUS_ACCEPTED                 = 202; // async completion (TBS)
  HTTP_STATUS_PARTIAL                  = 203; // partial completion
  HTTP_STATUS_NO_CONTENT               = 204; // no info to return
  HTTP_STATUS_RESET_CONTENT            = 205; // request completed, but clear form
  HTTP_STATUS_PARTIAL_CONTENT          = 206; // partial GET furfilled
  HTTP_STATUS_WEBDAV_MULTI_STATUS      = 207; // During a World Wide Web Distributed Authoring and Versioning (WebDAV) operation, this indicates multiple status codes for a single response. The response body contains Extensible Markup Language (XML) that describes the status codes. For more information, see <a href="https://learn.microsoft.com/en-us/windows/win32/webdav/webdav-portal">HTTP Extensions for Distributed Authoring</a>.

  HTTP_STATUS_AMBIGUOUS                = 300; // server couldn't decide what to return
  HTTP_STATUS_MOVED                    = 301; // object permanently moved
  HTTP_STATUS_REDIRECT                 = 302; // object temporarily moved
  HTTP_STATUS_REDIRECT_METHOD          = 303; // redirection w/ new access method
  HTTP_STATUS_NOT_MODIFIED             = 304; // if-modified-since was not modified
  HTTP_STATUS_USE_PROXY                = 305; // redirection to proxy, location header specifies proxy to use
  HTTP_STATUS_REDIRECT_KEEP_VERB       = 307; // HTTP/1.1: keep same verb
  HTTP_STATUS_PERMANENT_REDIRECT       = 308; // Object permanently moved keep verb

  HTTP_STATUS_BAD_REQUEST              = 400; // invalid syntax
  HTTP_STATUS_DENIED                   = 401; // access denied
  HTTP_STATUS_PAYMENT_REQ              = 402; // payment required
  HTTP_STATUS_FORBIDDEN                = 403; // request forbidden
  HTTP_STATUS_NOT_FOUND                = 404; // object not found
  HTTP_STATUS_BAD_METHOD               = 405; // method is not allowed
  HTTP_STATUS_NONE_ACCEPTABLE          = 406; // no response acceptable to client found
  HTTP_STATUS_PROXY_AUTH_REQ           = 407; // proxy authentication required
  HTTP_STATUS_REQUEST_TIMEOUT          = 408; // server timed out waiting for request
  HTTP_STATUS_CONFLICT                 = 409; // user should resubmit with more info
  HTTP_STATUS_GONE                     = 410; // the resource is no longer available
  HTTP_STATUS_LENGTH_REQUIRED          = 411; // the server refused to accept request w/o a length
  HTTP_STATUS_PRECOND_FAILED           = 412; // precondition given in request failed
  HTTP_STATUS_REQUEST_TOO_LARGE        = 413; // request entity was too large
  HTTP_STATUS_URI_TOO_LONG             = 414; // request URI too long
  HTTP_STATUS_UNSUPPORTED_MEDIA        = 415; // unsupported media type
  HTTP_STATUS_RETRY_WITH               = 449; // retry after doing the appropriate action.

  HTTP_STATUS_SERVER_ERROR             = 500; // internal server error
  HTTP_STATUS_NOT_SUPPORTED            = 501; // required not supported
  HTTP_STATUS_BAD_GATEWAY              = 502; // error response received from gateway
  HTTP_STATUS_SERVICE_UNAVAIL          = 503; // temporarily overloaded
  HTTP_STATUS_GATEWAY_TIMEOUT          = 504; // timed out waiting for gateway
  HTTP_STATUS_VERSION_NOT_SUP          = 505; // HTTP version not supported

  HTTP_STATUS_FIRST                    = HTTP_STATUS_CONTINUE;
  HTTP_STATUS_LAST                     = HTTP_STATUS_VERSION_NOT_SUP;

(*******************************************************************************
 * 名  称: GetHttpStatusMessage                                                *
 * 功  能: 根据 http 响应码获取对应的状态信息                                  *
 * 参  数:                                                                     *
 *   nHttpStatusCode: http server 返回的响应码                                 *
 * 返回值:                                                                     *
 *   返回指定响应码对应的状态说明信息文本。                                    *
 *******************************************************************************)
function GetHttpStatusMessage(const nHttpStatusCode: Integer): String;

implementation

uses
  System.SysUtils;

function GetHttpStatusMessage(const nHttpStatusCode: Integer): String;
begin
  case nHttpStatusCode of
    HTTP_STATUS_CONTINUE:
      Result := '可以继续请求。';
    HTTP_STATUS_SWITCH_PROTOCOLS:
      Result := '服务器在升级标头中交换了协议。';
    HTTP_STATUS_OK:
      Result := '请求已成功完成。';
    HTTP_STATUS_CREATED:
      Result := '请求已得到满足，并导致创建新资源。';
    HTTP_STATUS_ACCEPTED:
      Result := '已接受请求进行处理，但尚未完成处理。';
    HTTP_STATUS_PARTIAL:
      Result := 'entity-header 中返回的元信息不是原始服务器提供的权威集。';
    HTTP_STATUS_NO_CONTENT:
      Result := '服务器已满足请求，但没有要发送回的新信息。';
    HTTP_STATUS_RESET_CONTENT:
      Result := '请求已完成，客户端程序应重置导致发送请求的文档视图，以允许用户轻松启动另一个输入操作。';
    HTTP_STATUS_PARTIAL_CONTENT:
      Result := '服务器已完成对资源的部分 GET 请求。';
    HTTP_STATUS_WEBDAV_MULTI_STATUS:
      Result := '在万维网分布式创作和版本控制 (WebDAV) 操作期间，这表示单个响应的多个状态代码。 响应正文包含描述状态代码的可扩展标记语言 (XML) 。 有关详细信息，请参阅 分布式创作的 HTTP 扩展。';
    HTTP_STATUS_AMBIGUOUS:
      Result := '请求的资源在一个或多个位置可用。';
    HTTP_STATUS_MOVED:
      Result := '请求的资源已分配给新的永久统一资源标识符 (URI) ，将来对此资源的任何引用都应使用返回的 URI 之一完成。';
    HTTP_STATUS_REDIRECT:
      Result := '请求的资源暂时驻留在不同的 URI 下。';
    HTTP_STATUS_REDIRECT_METHOD:
      Result := '对请求的响应可以在不同的 URI 下找到，应使用该资源上的 GET HTTP 谓词 进行检索。';
    HTTP_STATUS_NOT_MODIFIED:
      Result := '请求的资源尚未修改。';
    HTTP_STATUS_USE_PROXY:
      Result := '必须通过位置字段提供的代理访问请求的资源。';
    HTTP_STATUS_REDIRECT_KEEP_VERB:
      Result := '重定向的请求保留相同的 HTTP 谓词。 HTTP/1.1 行为。';
    HTTP_STATUS_PERMANENT_REDIRECT:
      Result := '请求的资源已分配给新的永久统一资源标识符 (URI) ，且不允许更改请求方式 (METHOD) ，将来对此资源的任何引用都应使用返回的 URI 之一完成。';
    HTTP_STATUS_BAD_REQUEST:
      Result := '由于语法无效，服务器无法处理请求。';
    HTTP_STATUS_DENIED:
      Result := '请求的资源需要用户身份验证。';
    HTTP_STATUS_PAYMENT_REQ:
      Result := '未在 HTTP 协议中实现。';
    HTTP_STATUS_FORBIDDEN:
      Result := '服务器理解请求，但无法满足请求。';
    HTTP_STATUS_NOT_FOUND:
      Result := '服务器未找到与请求的 URI 匹配的任何内容。';
    HTTP_STATUS_BAD_METHOD:
      Result := '不允许使用 HTTP 谓词 。';
    HTTP_STATUS_NONE_ACCEPTABLE:
      Result := '找不到客户端可接受的响应。';
    HTTP_STATUS_PROXY_AUTH_REQ:
      Result := '需要代理身份验证。';
    HTTP_STATUS_REQUEST_TIMEOUT:
      Result := '服务器等待请求时超时。';
    HTTP_STATUS_CONFLICT:
      Result := '由于与资源的当前状态冲突，请求无法完成。 用户应重新提交详细信息。';
    HTTP_STATUS_GONE:
      Result := '请求的资源在服务器上不再可用，并且没有已知的转发地址。';
    HTTP_STATUS_LENGTH_REQUIRED:
      Result := '服务器无法接受未定义内容长度的请求。';
    HTTP_STATUS_PRECOND_FAILED:
      Result := '在服务器上测试时，一个或多个请求标头字段中给定的前提条件的计算结果为 false。';
    HTTP_STATUS_REQUEST_TOO_LARGE:
      Result := '服务器无法处理请求，因为请求实体大于服务器能够处理的实体。';
    HTTP_STATUS_URI_TOO_LONG:
      Result := '服务器无法为请求提供服务，因为请求 URI 比服务器可以解释的要长。';
    HTTP_STATUS_UNSUPPORTED_MEDIA:
      Result := '服务器无法为请求提供服务，因为请求的实体的格式不受所请求方法的资源支持。';
    HTTP_STATUS_RETRY_WITH:
      Result := '执行相应操作后，应重试该请求。';
    HTTP_STATUS_SERVER_ERROR:
      Result := '服务器遇到一个意外情况，导致它无法满足请求。';
    HTTP_STATUS_NOT_SUPPORTED:
      Result := '服务器不支持满足请求所需的功能。';
    HTTP_STATUS_BAD_GATEWAY:
      Result := '服务器在充当网关或代理时，从尝试满足请求时访问的上游服务器收到无效响应。';
    HTTP_STATUS_SERVICE_UNAVAIL:
      Result := '服务临时过载。';
    HTTP_STATUS_GATEWAY_TIMEOUT:
      Result := '请求等待网关超时。';
    HTTP_STATUS_VERSION_NOT_SUP:
      Result := '服务器不支持请求消息中使用的 HTTP 协议版本。';
    else
      Result := Format('未定义的响应码：%d！', [nHttpStatusCode]);
  end;

end;

end.
