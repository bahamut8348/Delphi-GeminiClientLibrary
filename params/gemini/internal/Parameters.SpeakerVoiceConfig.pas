unit Parameters.SpeakerVoiceConfig;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.VoiceConfig;

type
{
  https://ai.google.dev/api/generate-content#SpeakerVoiceConfig
  多音箱设置中单个音箱的配置。
}
  TSpeakerVoiceConfig = class(TParameterReality)
  private
    { private declarations }
    FSpeaker: String;
    FVoiceConfig: TVoiceConfig;
    procedure SetVoiceConfig(const Value: TVoiceConfig);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。要使用的扬声器的名称。应与提示中的内容相同。
    property speaker: String read FSpeaker write FSpeaker;
    // 必需。要使用的语音的配置。
    property voiceConfig: TVoiceConfig read FVoiceConfig write SetVoiceConfig;
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

{ TSpeakerVoiceConfig }

constructor TSpeakerVoiceConfig.Create();
begin
  inherited Create();
  FSpeaker := '';
  FVoiceConfig := nil;
end;

destructor TSpeakerVoiceConfig.Destroy();
begin
  SafeFreeAndNil(FVoiceConfig);
  FSpeaker := '';
  inherited Destroy();
end;

function TSpeakerVoiceConfig.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TSpeakerVoiceConfig.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'voiceConfig') then
  begin
    TParameterReality.CopyWithJson(Self.FVoiceConfig, TVoiceConfig, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TSpeakerVoiceConfig.SetVoiceConfig(const Value: TVoiceConfig);
begin
  if (Value <> FVoiceConfig) then
    TParameterReality.CopyWithClass(FVoiceConfig, Value);
end;

end.
