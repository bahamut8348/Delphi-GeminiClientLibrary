unit Parameters.EmbedContentBatchOutput;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.InlinedEmbedContentResponses;

type
{
  https://ai.google.dev/api/embeddings#EmbedContentBatchOutput
  批量请求的输出。此值在 AsyncBatchEmbedContentResponse 或 EmbedContentBatch.output 字段中返回。
}
  TEmbedContentBatchOutput = class(TParameterReality)
  private
    { private declarations }
    // 联合字段的序号，output 只允许存在一种值，如果全部都赋值发送给接口会返回错误。
    FUnionProperty: (upResponsesFile, upInlinedResponses, upOther);

    FResponsesFile: String;
    FInlinedResponses: TInlinedEmbedContentResponses;

    procedure SetResponsesFile(const Value: String);
    procedure SetInlinedResponses(const Value: TInlinedEmbedContentResponses);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    { Union type output start }
    // 批量请求的输出。 output 只能是下列其中一项：

    // 仅限输出。包含回答内容的文件对应的文件 ID。该文件将是一个 JSONL 文件，每行包含一个回答。响应将是采用 JSON 格式的 EmbedContentResponse 消息。响应将按输入请求的顺序写入。
    property responsesFile: String read FResponsesFile write SetResponsesFile;
    // 仅限输出。对批处理请求的响应。当批处理是使用内嵌请求构建时返回。响应的顺序与输入请求的顺序相同。
    property inlinedResponses: TInlinedEmbedContentResponses read FInlinedResponses write SetInlinedResponses;
    { Union type output end }
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

{ TEmbedContentBatchOutput }

constructor TEmbedContentBatchOutput.Create();
begin
  inherited Create();
  Self.FUnionProperty := upResponsesFile;
  Self.FResponsesFile := '';
  Self.FInlinedResponses := nil;
end;

destructor TEmbedContentBatchOutput.Destroy();
begin
  SafeFreeAndNil(Self.FInlinedResponses);
  Self.FResponsesFile := '';
  Self.FUnionProperty := upOther;
  inherited Destroy();
end;

function TEmbedContentBatchOutput.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  if SameText(sName, 'responsesFile') then
  begin
    if (upResponsesFile = FUnionProperty) then
      pValue := TValue.From(Self.FResponsesFile)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'inlinedResponses') then
  begin
    if (upInlinedResponses = FUnionProperty) then
      pValue := TValue.From(Self.FInlinedResponses)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else
    Result := inherited GetMemberValue(sName, pValue);
end;

procedure TEmbedContentBatchOutput.SetInlinedResponses(
  const Value: TInlinedEmbedContentResponses);
begin
  FUnionProperty := upInlinedResponses;
  if (Value <> FInlinedResponses) then
    TParameterReality.CopyWithClass(FInlinedResponses, Value);
end;

function TEmbedContentBatchOutput.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'inlinedResponses') then
  begin
    FUnionProperty := upInlinedResponses;
    TParameterReality.CopyWithJson(Self.FInlinedResponses, TInlinedEmbedContentResponses, pValue);
    Result := TRUE;
  end
  else if SameText(sname, 'responsesFile') then
  begin
    FUnionProperty := upResponsesFile;
    FResponsesFile := GetJsonStringValue(pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TEmbedContentBatchOutput.SetResponsesFile(const Value: String);
begin
  FUnionProperty := upResponsesFile;
  FResponsesFile := Value;
end;

end.
