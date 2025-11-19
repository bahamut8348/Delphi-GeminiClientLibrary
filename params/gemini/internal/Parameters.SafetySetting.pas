unit Parameters.SafetySetting;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#v1beta.SafetySetting
  安全设置，会影响安全屏蔽行为。
  为某个类别传递安全设置会更改内容被屏蔽的允许概率。
}
  TSafetySetting = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 必需。相应设置的类别。
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
    // 必需。控制屏蔽有害内容的概率阈值。
    //
    // 值                               | 说明
    // HARM_BLOCK_THRESHOLD_UNSPECIFIED | 阈值未指定。
    // BLOCK_LOW_AND_ABOVE              | 具有“可忽略”风险的内容将允许发布。
    // BLOCK_MEDIUM_AND_ABOVE           | 内容风险为“可忽略”和“低”时，将允许投放广告。
    // BLOCK_ONLY_HIGH                  | 内容风险为“可忽略”“低”和“中”时，将允许发布。
    // BLOCK_NONE                       | 允许所有内容。
    // OFF                              | 关闭安全过滤条件。
    threshold: String;
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

{ TSafetySetting }

constructor TSafetySetting.Create();
begin
  inherited Create();
  Self.category := GEMINI_HARM_CATEGORY_UNSPECIFIED;
  Self.threshold := GEMINI_HARM_BLOCK_THRESHOLD_UNSPECIFIED;
end;

destructor TSafetySetting.Destroy();
begin
  Self.threshold := '';
  Self.category := '';
  inherited Destroy();
end;

end.
