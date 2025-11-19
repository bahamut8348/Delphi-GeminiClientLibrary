unit Parameters.SemanticRetrieverChunk;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#SemanticRetrieverChunk
  通过 SemanticRetrieverConfig 使用 GenerateAnswerRequest 中指定的语义检索器检索到的 Chunk 的标识符。
}
  TSemanticRetrieverChunk = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 仅限输出。与请求的 SemanticRetrieverConfig.source 匹配的来源的名称。示例：corpora/123 或 corpora/123/documents/abc
    source: String;
    // 仅限输出。包含归因文本的 Chunk 的名称。示例：corpora/123/documents/abc/chunks/xyz
    chunk: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;


implementation

{ TSemanticRetrieverChunk }

constructor TSemanticRetrieverChunk.Create();
begin
  inherited Create();
  Self.source := '';
  Self.chunk := '';
end;

destructor TSemanticRetrieverChunk.Destroy();
begin
  Self.chunk := '';
  Self.source := '';
  inherited Destroy();
end;

end.
