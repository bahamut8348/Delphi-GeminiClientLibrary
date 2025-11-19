unit Parameters.PromptFeedback;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.SafetyRating;

type
{
  https://ai.google.dev/api/generate-content#PromptFeedback
  提示在 GenerateContentRequest.content 中指定的一组反馈元数据。
}
  TPromptFeedback = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。如果设置了此值，则提示被屏蔽，并且不返回任何候选结果。改述提示。
    //
    // 值                           | 说明
    // BLOCK_REASON_UNSPECIFIED     | 默认值。此值未使用。
    // SAFETY                       | 出于安全原因，系统屏蔽了相应提示。检查 safetyRatings 以了解是哪个安全类别屏蔽了它。
    // OTHER                        | 提示因未知原因被屏蔽。
    // BLOCKLIST                    | 提示因包含术语屏蔽名单中的术语而被屏蔽。
    // PROHIBITED_CONTENT           | 提示因包含禁止的内容而被屏蔽。
    // IMAGE_SAFETY                 | 因生成不安全的图片内容而屏蔽了候选回答。
    blockReason: String;
    // 提示的安全评级。每个类别最多只能有一个评分。
    safetyRatings: array of TSafetyRating;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType, Functions.SystemExtended;

{ TPromptFeedback }

constructor TPromptFeedback.Create();
begin
  inherited Create();
  Self.blockReason := GEMINI_BLOCK_REASON_UNSPECIFIED;
  SetLength(Self.safetyRatings, 0);
end;

destructor TPromptFeedback.Destroy();
var
  nIndex: Integer;
begin
  for nIndex := High(Self.safetyRatings) downto Low(Self.safetyRatings) do
    SafeFreeAndNil(Self.safetyRatings[nIndex]);
  SetLength(Self.safetyRatings, 0);
  Self.blockReason := '';
  inherited Destroy();
end;

function TPromptFeedback.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TPromptFeedback.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
var
  nIndex: Integer;
begin
  if SameText(sName, 'safetyRatings') then
  begin
    for nIndex := High(Self.safetyRatings) downto Low(Self.safetyRatings) do
      SafeFreeAndNil(Self.safetyRatings[nIndex]);

    if (pValue is TJSONArray) then
    begin
      SetLength(Self.safetyRatings, (pValue as TJSONArray).Count);
      for nIndex := 0 to (pValue as TJSONArray).Count - 1 do
      begin
        Self.safetyRatings[nIndex] := TSafetyRating.Create();
        Self.safetyRatings[nIndex].Parse((pValue as TJSONArray).Items[nIndex]);
      end;
    end
    else if (nil <> pValue) then
    begin
      SetLength(Self.safetyRatings, 1);
      Self.safetyRatings[0] := TSafetyRating.Create();
      Self.safetyRatings[0].Parse(pValue);
    end
    else
      SetLength(Self.safetyRatings, 0);

    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
