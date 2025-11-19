unit Parameters.CountMessageTokensResponseBody;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/palm#response-body_3
  来自 models.countMessageTokens 的回答。
  它会返回 prompt 的模型 tokenCount。
}
  TCountMessageTokensResponseBody = class(TParameterReality)
  private
    { private declarations }
    FTokenCount: Integer;
  protected
    { protected declarations }
  public
    { public declarations }
    // model 将 prompt 分词为的词元数。
    // 始终为非负数。
    property tokenCount: Integer read FTokenCount write FTokenCount;
  published
    { published declarations }
  end;

implementation

end.
