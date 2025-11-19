unit Parameters.RetrievedContext;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#RetrievedContext
  文件搜索工具检索到的上下文中的块。
}
  TRetrievedContext = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 可选。语义检索文档的 URI 引用。
    uri: String;
    // 可选。文档的标题。
    title: String;
    // 可选。块的文本。
    text: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TRetrievedContext }

constructor TRetrievedContext.Create();
begin
  inherited Create();
  Self.uri := '';
  Self.title := '';
  Self.text := '';
end;

destructor TRetrievedContext.Destroy();
begin
  Self.text := '';
  Self.title := '';
  Self.uri := '';
  inherited Destroy();
end;

end.
