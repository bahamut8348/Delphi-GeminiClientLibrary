unit Parameters.VoiceConfig;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.PrebuiltVoiceConfig;

type
{
  https://ai.google.dev/api/generate-content#VoiceConfig
  要使用的语音的配置。
}
  TVoiceConfig = class(TParameterReality)
  private
    { private declarations }
    FPrebuiltVoiceConfig: TPrebuiltVoiceConfig;
    procedure SetPrebuiltVoiceConfig(const Value: TPrebuiltVoiceConfig);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    { Union type voice_config start }
    // 音箱要使用的配置。voice_config 只能是下列其中一项：
    // 要使用的预构建语音的配置。
    property prebuiltVoiceConfig: TPrebuiltVoiceConfig read FPrebuiltVoiceConfig write SetPrebuiltVoiceConfig;
    { Union type voice_config end }
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

{ TVoiceConfig }

constructor TVoiceConfig.Create();
begin
  inherited Create();
  Self.FPrebuiltVoiceConfig := nil;
end;

destructor TVoiceConfig.Destroy();
begin
  SafeFreeAndNil(Self.FPrebuiltVoiceConfig);
  inherited Destroy();
end;

function TVoiceConfig.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TVoiceConfig.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'prebuiltVoiceConfig') then
  begin
    TParameterReality.CopyWithJson(FPrebuiltVoiceConfig, TPrebuiltVoiceConfig, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TVoiceConfig.SetPrebuiltVoiceConfig(
  const Value: TPrebuiltVoiceConfig);
begin
  if (Value <> FPrebuiltVoiceConfig) then
    TParameterReality.CopyWithClass(FPrebuiltVoiceConfig, Value);
end;

end.
