unit Parameters.ExecutableCode;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#ExecutableCode
  模型生成的旨在执行的代码，以及返回给模型的结果。
  仅在使用 CodeExecution 工具时生成，其中代码将自动执行，并且还会生成相应的 CodeExecutionResult。
}
  TExecutableCode = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 必需。code 的编程语言。
    //
    // 值                     | 说明
    // LANGUAGE_UNSPECIFIED   | 未指定语言。请勿使用此值。
    // PYTHON                 | Python >= 3.10，且提供 numpy 和 simpy。
    language: String;
    // 必需。要执行的代码。
    code: String;
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

{ TExecutableCode }

constructor TExecutableCode.Create();
begin
  inherited Create();
  Self.language := GEMINI_LANGUAGE_UNSPECIFIED;
  Self.code := '';
end;

destructor TExecutableCode.Destroy();
begin
  Self.code := '';
  Self.language := '';
  inherited Destroy();
end;

end.
