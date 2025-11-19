unit Parameters.PrebuiltVoiceConfig;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#PrebuiltVoiceConfig
  预构建扬声器的配置。
}
  TPrebuiltVoiceConfig = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 要使用的预设语音的名称。
    voiceName: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TPrebuiltVoiceConfig }

constructor TPrebuiltVoiceConfig.Create();
begin
  inherited Create();
  Self.voiceName := '';
end;

destructor TPrebuiltVoiceConfig.Destroy();
begin
  Self.voiceName := '';
  inherited Destroy();
end;

end.
