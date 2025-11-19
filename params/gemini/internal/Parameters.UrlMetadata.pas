unit Parameters.UrlMetadata;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#UrlMetadata
  单个网址检索的上下文。
}
  TUrlMetadata = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 由工具检索到的网址。
    retrievedUrl: String;
    // 网址检索的状态。
    //
    // 值                                 | 说明
    // URL_RETRIEVAL_STATUS_UNSPECIFIED   | 默认值。此值未使用。
    // URL_RETRIEVAL_STATUS_SUCCESS       | 网址检索成功。
    // URL_RETRIEVAL_STATUS_ERROR         | 由于出错，网址检索失败。
    // URL_RETRIEVAL_STATUS_PAYWALL       | 由于内容受付费墙保护，网址检索失败。
    // URL_RETRIEVAL_STATUS_UNSAFE        | 由于内容不安全，网址检索失败。
    urlRetrievalStatus: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType;

{ TUrlMetadata }

constructor TUrlMetadata.Create();
begin
  inherited Create();
  Self.retrievedUrl := '';
  Self.urlRetrievalStatus := GEMINI_URL_RETRIEVAL_STATUS_UNSPECIFIED;
end;

destructor TUrlMetadata.Destroy();
begin
  Self.urlRetrievalStatus := '';
  Self.retrievedUrl := '';
  inherited Destroy();
end;

end.
