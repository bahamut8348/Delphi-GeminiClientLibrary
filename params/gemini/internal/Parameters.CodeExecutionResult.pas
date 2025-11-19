unit Parameters.CodeExecutionResult;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#CodeExecutionResult
  执行 ExecutableCode 的结果。仅在使用 CodeExecution 时生成，并且始终跟在包含 ExecutableCode 的 part 之后。
}
  TCodeExecutionResult = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 必需。代码执行结果。
    //
    // 值                         | 说明
    // OUTCOME_UNSPECIFIED        | 未指定状态。请勿使用此值。
    // OUTCOME_OK                 | 代码已成功执行完毕。
    // OUTCOME_FAILED             | 代码执行已完成，但失败了。stderr 应包含原因。
    // OUTCOME_DEADLINE_EXCEEDED  | 代码执行运行时间过长，已被取消。可能存在部分输出，也可能不存在。
    outcome: String;
    // 可选。如果代码执行成功，则包含 stdout；否则包含 stderr 或其他说明。
    output: String;
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

{ TCodeExecutionResult }

constructor TCodeExecutionResult.Create();
begin
  inherited Create();
  Self.outcome := GEMINI_OUTCOME_UNSPECIFIED;
  Self.output := '';
end;

destructor TCodeExecutionResult.Destroy();
begin
  Self.output := '';
  Self.outcome := '';
  inherited Destroy();
end;

end.
