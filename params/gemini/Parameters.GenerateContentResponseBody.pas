unit Parameters.GenerateContentResponseBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Candidate,
  Parameters.PromptFeedback, Parameters.UsageMetadata;

type
{
  https://ai.google.dev/api/generate-content#v1beta.GenerateContentResponse
  支持多个候选回答的模型的回答。
  系统会在 GenerateContentResponse.prompt_feedback 中针对每个提示报告安全等级和内容过滤情况，并在 finishReason 和 safetyRatings 中针对每个候选答案报告安全等级和内容过滤情况。该 API： - 要么返回所有请求的候选结果，要么不返回任何结果 - 仅当提示存在问题时（检查 promptFeedback），才不返回任何候选结果 - 在 finishReason 和 safetyRatings 中报告有关每个候选结果的反馈。
}
  TGenerateContentResponseBody = class(TParameterReality)
  private
    { private declarations }
    FCandidates: TArray<TCandidate>;
    FPromptFeedback: TPromptFeedback;
    FUsageMetadata: TUsageMetadata;
    FModelVersion: String;
    FResponseId: String;

    procedure SetCandidates(const Value: TArray<TCandidate>);
    procedure SetModelVersion(const Value: String);
    procedure SetPromptFeedback(const Value: TPromptFeedback);
    procedure SetResponseId(const Value: String);
    procedure SetUsageMetadata(const Value: TUsageMetadata);
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
    property modelVersion: String read FModelVersion write SetModelVersion;
    // 仅限输出。responseId 用于标识每个响应。
    property responseId: String read FResponseId write SetResponseId;
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

{ TGenerateContentResponseBody }

constructor TGenerateContentResponseBody.Create();
begin
  inherited Create();
  SetLength(Self.FCandidates, 0);
  Self.FPromptFeedback := nil;
  Self.FUsageMetadata := nil;
  Self.FModelVersion := '';
  Self.FResponseId := '';
end;

destructor TGenerateContentResponseBody.Destroy();
begin
  Self.FResponseId := '';
  Self.FModelVersion := '';
  SafeFreeAndNil(Self.FUsageMetadata);
  SafeFreeAndNil(Self.FPromptFeedback);
  TParameterReality.ReleaseArray<TCandidate>(Self.FCandidates);
  inherited Destroy();
end;

function TGenerateContentResponseBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TGenerateContentResponseBody.SetCandidates(
  const Value: TArray<TCandidate>);
begin
  TParameterReality.CopyArrayWithClass<TCandidate>(FCandidates, Value);
end;

function TGenerateContentResponseBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'candidates') then
  begin
    TParameterReality.CopyArrayWithJson<TCandidate>(FCandidates, pValue);
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

procedure TGenerateContentResponseBody.SetModelVersion(const Value: String);
begin
  FModelVersion := Value;
end;

procedure TGenerateContentResponseBody.SetPromptFeedback(
  const Value: TPromptFeedback);
begin
  if (Value <> FPromptFeedback) then
    TParameterReality.CopyWithClass(FPromptFeedback, Value);
end;

procedure TGenerateContentResponseBody.SetResponseId(const Value: String);
begin
  FResponseId := Value;
end;

procedure TGenerateContentResponseBody.SetUsageMetadata(
  const Value: TUsageMetadata);
begin
  if (Value <> FUsageMetadata) then
    TParameterReality.CopyWithClass(FUsageMetadata, Value);
end;

end.