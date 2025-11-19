unit Parameters.ThinkingConfig;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#ThinkingConfig
  思考功能的配置。
}
  TThinkingConfig = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 指示是否在回答中包含想法。如果为 true，则仅在有想法时返回想法。
    includeThoughts: Boolean;
    // 模型应生成的想法 token 的数量。
    thinkingBudget: Integer;
  published
    { published declarations }
  end;

implementation

end.
