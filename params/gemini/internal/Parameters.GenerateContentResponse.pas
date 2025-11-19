unit Parameters.GenerateContentResponse;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Candidate,
  Parameters.PromptFeedback, Parameters.UsageMetadata;

type
{
  https://ai.google.dev/api/generate-content#generatecontentresponse
  支持多个候选回答的模型的回答。
  系统会针对 GenerateContentResponse.prompt_feedback 中的每个提示和 finishReason 及 safetyRatings 中的每个候选答案报告安全等级和内容过滤情况。该 API： - 要么返回所有请求的候选内容，要么不返回任何候选内容 - 仅当提示存在问题时（检查 promptFeedback），才不返回任何候选内容 - 在 finishReason 和 safetyRatings 中报告有关每个候选内容的反馈。
}
  TGenerateContentResponse = class(TParameterReality)
  private
    { private declarations }
    FCandidates: TArray<TCandidate>;
    FPromptFeedback: TPromptFeedback;
    FUsageMetadata: TUsageMetadata;
    FModelVersion: String;
    FResponseId: String;
    procedure SetPromptFeedback(const Value: TPromptFeedback);
    procedure SetUsageMetadata(const Value: TUsageMetadata);
    procedure SetCandidates(const Value: TArray<TCandidate>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 模型给出的候选回答。
    property candidates: TArray<TCandidate> read FCandidates write SetCandidates;
    // 返回与内容过滤器相关的提示反馈。
    property promptFeedback: TPromptFeedback read FPromptFeedback write SetPromptFeedback;
    // 仅限输出。有关生成请求的 token 使用情况的元数据。
    property usageMetadata: TUsageMetadata read FUsageMetadata write SetUsageMetadata;
    // 仅限输出。用于生成回答的模型版本。
    property modelVersion: String read FModelVersion write FModelVersion;
    // 仅限输出。responseId 用于标识每个响应。
    property responseId: String read FResponseId write FResponseId;

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

{ TGenerateContentResponse }

constructor TGenerateContentResponse.Create();
begin
  inherited Create();
  SetLength(Self.FCandidates, 0);
  Self.FPromptFeedback := nil;
  Self.FUsageMetadata := nil;
  Self.FModelVersion := '';
  Self.FResponseId := '';
end;

destructor TGenerateContentResponse.Destroy();
begin
  Self.FResponseId := '';
  Self.FModelVersion := '';
  SafeFreeAndNil(Self.FUsageMetadata);
  SafeFreeAndNil(Self.FPromptFeedback);
  TParameterReality.ReleaseArray<TCandidate>(Self.FCandidates);
  inherited Destroy();
end;

function TGenerateContentResponse.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TGenerateContentResponse.SetCandidates(
  const Value: TArray<TCandidate>);
begin
  TParameterReality.CopyArrayWithClass<TCandidate>(FCandidates, Value);
end;

function TGenerateContentResponse.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'candidates') then
  begin
    TParameterReality.CopyArrayWithJson<TCandidate>(Self.FCandidates, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'promptFeedback') then
  begin
    TParameterReality.CopyWithJson(FPromptFeedback, TPromptFeedback, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'usageMetadata') then
  begin
    TParameterReality.CopyWithJson(FUsageMetadata, TUsageMetadata, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TGenerateContentResponse.SetPromptFeedback(
  const Value: TPromptFeedback);
begin
  if (Value <> FPromptFeedback) then
    TParameterReality.CopyWithClass(FPromptFeedback, Value);
end;

procedure TGenerateContentResponse.SetUsageMetadata(
  const Value: TUsageMetadata);
begin
  if (Value <> FUsageMetadata) then
    TParameterReality.CopyWithClass(FUsageMetadata, Value);
end;

end.
