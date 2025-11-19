unit Parameters.CountTextTokensResponseBody;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/palm#response-body_1
  来自 models.countTextTokens 的回答。
  它会返回 prompt 的模型 tokenCount。
}
  TCountTextTokensResponseBody = class(TParameterReality)
  private
    FTokenCount: Integer;
    { private declarations }
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
