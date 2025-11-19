unit Parameters.ModalityTokenCount;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#v1beta.ModalityTokenCount
  表示单个模态的令牌计数信息。
}
  TModalityTokenCount = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 与此令牌数量关联的模态。
    //
    // 值                       | 说明
    // MODALITY_UNSPECIFIED     | 默认值。
    // TEXT                     | 表示模型应返回文本。
    // IMAGE                    | 表示模型应返回图片。
    // AUDIO                    | 表示模型应返回音频。
    modality: String;
    // 令牌数量。
    tokenCount: Integer;

    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType;

{ TModalityTokenCount }

constructor TModalityTokenCount.Create();
begin
  inherited Create();
  Self.modality := GEMINI_MODALITY_UNSPECIFIED;
  Self.tokenCount := 0;
end;

destructor TModalityTokenCount.Destroy();
begin
  Self.tokenCount := 0;
  Self.modality := '';
  inherited Destroy();
end;

end.
