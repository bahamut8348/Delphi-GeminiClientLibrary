unit Parameters.CodeExecution;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#CodeExecution
  此类型没有字段。
  一种工具，用于执行模型生成的代码，并自动将结果返回给模型。
  另请参阅 ExecutableCode 和 CodeExecutionResult，它们仅在使用此工具时生成。
}
  TCodeExecution = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  published
    { published declarations }
  end;

implementation

end.
