unit Parameters.MessagePrompt;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Example, Parameters.Message;

type
{
  https://ai.google.dev/api/palm#messageprompt
  作为提示传递给模型的所有结构化输入文本。
  MessagePrompt 包含一组结构化字段，用于提供对话的上下文；包含用户输入/模型输出消息对的示例，用于引导模型以不同方式回答；还包含对话历史记录或消息列表，用于表示用户与模型之间交替进行的对话回合。
}
  TMessagePrompt = class(TParameterReality)
  private
    { private declarations }
    FContext: String;
    FExamples: TArray<TExample>;
    FMessages: TArray<TMessage>;
    procedure SetExamples(const Value: TArray<TExample>);
    procedure SetMessages(const Value: TArray<TMessage>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。应该先将文本提供给模型以打下响应的基础。
    // 如果此 context 不为空，则会先将此 context 提供给模型，然后再提供 examples 和 messages。使用 context 时，请务必在每个请求中提供该令牌，以保持连续性。
    // 此字段可以是您向模型发出的提示的说明，有助于提供上下文并引导回答。示例：“将该短语从英语翻译成法语。”或“给定一个陈述，将情感归类为快乐、悲伤或中性。”
    // 如果总输入大小超过模型的 inputTokenLimit，并且输入请求被截断，则此字段中包含的任何内容都将优先于消息历史记录。
    property context: String read FContext write FContext;
    // 可选。模型应生成的示例。
    // 这包括用户输入和模型应模拟的回答。
    // 这些 examples 的处理方式与对话消息相同，但它们优先于 messages 中的历史记录：如果总输入大小超过模型的 inputTokenLimit，输入将被截断。商品将从 messages 中下架，时间为 examples 之前。
    property examples: TArray<TExample> read FExamples write SetExamples;
    // 必需。按时间顺序排序的近期对话记录的快照。
    // 轮流由两位作者撰写。
    // 如果总输入大小超过模型的 inputTokenLimit，输入将被截断：系统会从 messages 中舍弃最旧的项目。
    property messages: TArray<TMessage> read FMessages write SetMessages;

  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TMessagePrompt }

constructor TMessagePrompt.Create();
begin
  inherited Create();
  Self.FContext := '';
  SetLength(Self.FExamples, 0);
  SetLength(Self.FMessages, 0);
end;

destructor TMessagePrompt.Destroy();
begin
  TParameterReality.ReleaseArray<TMessage>(Self.FMessages);
  TParameterReality.ReleaseArray<TExample>(Self.FExamples);
  inherited Destroy();
end;

function TMessagePrompt.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TMessagePrompt.SetExamples(const Value: TArray<TExample>);
begin
  TParameterReality.CopyArrayWithClass<TExample>(FExamples, Value);
end;

function TMessagePrompt.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'examples') then
  begin
    TParameterReality.CopyArrayWithJson<TExample>(Self.FExamples, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'messages') then
  begin
    TParameterReality.CopyArrayWithJson<TMessage>(Self.FMessages, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TMessagePrompt.SetMessages(const Value: TArray<TMessage>);
begin
  TParameterReality.CopyArrayWithClass<TMessage>(FMessages, Value);
end;

end.