unit Parameters.SearchEntryPoint;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#SearchEntryPoint
  Google 搜索入口点。
}
  TSearchEntryPoint = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 可选。可嵌入网页或应用 WebView 中的 Web 内容代码段。
    renderedContent: String;
    // 可选。以 Base64 编码的 JSON，表示 <搜索字词、搜索网址> 元组的数组。使用 base64 编码的字符串。
    sdkBlob: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TSearchEntryPoint }

constructor TSearchEntryPoint.Create();
begin
  inherited Create();
  Self.renderedContent := '';
  Self.sdkBlob := '';
end;

destructor TSearchEntryPoint.Destroy();
begin
  Self.sdkBlob := '';
  Self.renderedContent := '';
  inherited Destroy();
end;

end.
