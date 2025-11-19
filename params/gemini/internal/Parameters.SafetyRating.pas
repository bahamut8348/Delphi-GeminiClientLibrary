unit Parameters.SafetyRating;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#v1beta.SafetyRating
  内容的安全分级。
  安全评级包含内容的危害类别以及该类别中的危害概率级别。内容会根据多个危害类别进行安全分类，此处会显示内容属于危害分类的概率。
}
  TSafetyRating = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。相应评分的类别。
    //
    // 值                               | 说明
    // HARM_CATEGORY_UNSPECIFIED        | 未指定类别。
    // HARM_CATEGORY_DEROGATORY         | PaLM - 针对身份和/或受保护属性的负面或有害评论。
    // HARM_CATEGORY_TOXICITY           | PaLM - 粗鲁、无礼或亵渎性的内容。
    // HARM_CATEGORY_VIOLENCE           | PaLM - 描述描绘针对个人或团体的暴力行为的场景，或一般性血腥描述。
    // HARM_CATEGORY_SEXUAL             | PaLM - 包含对性行为或其他淫秽内容的引用。
    // HARM_CATEGORY_MEDICAL            | PaLM - 宣传未经核实的医疗建议。
    // HARM_CATEGORY_DANGEROUS          | PaLM - 宣扬、助长或鼓励有害行为的危险内容。
    // HARM_CATEGORY_HARASSMENT         | Gemini - 骚扰内容。
    // HARM_CATEGORY_HATE_SPEECH        | Gemini - 仇恨言论和内容。
    // HARM_CATEGORY_SEXUALLY_EXPLICIT  | Gemini - 露骨色情内容。
    // HARM_CATEGORY_DANGEROUS_CONTENT  | Gemini - 危险内容。
    // HARM_CATEGORY_CIVIC_INTEGRITY    | Gemini - 可能被用于损害公民诚信的内容。已弃用：请改用 enableEnhancedCivicAnswers。
    //                                  | 此项已弃用！
    category: String;
    // 必需。相应内容的有害概率。
    //
    // 值                               | 说明
    // HARM_PROBABILITY_UNSPECIFIED     | 概率未指定。
    // NEGLIGIBLE                       | 内容不安全的概率可忽略不计。
    // LOW                              | 内容不安全的概率较低。
    // MEDIUM                           | 内容不安全的可能性为中等。
    // HIGH                             | 内容不安全的概率较高。
    probability: String;
    // 此内容是否因该分级而被屏蔽？
    blocked: Boolean;
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

{ TSafetyRating }

constructor TSafetyRating.Create();
begin
  inherited Create();
  Self.category := GEMINI_HARM_CATEGORY_UNSPECIFIED;
  Self.probability := GEMINI_HARM_PROBABILITY_UNSPECIFIED;
  Self.blocked := FALSE;
end;

destructor TSafetyRating.Destroy();
begin
  Self.blocked := FALSE;
  Self.probability := '';
  Self.category := '';
  inherited Destroy();
end;

function TSafetyRating.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TSafetyRating.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'blocked') then
  begin
    if (pValue is TJSONBool) then
      Self.blocked := (pValue as TJSONBool).AsBoolean
    else if (nil <> pValue) then
      Self.blocked := not pValue.Null
    else
      Self.blocked := FALSE;

    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
