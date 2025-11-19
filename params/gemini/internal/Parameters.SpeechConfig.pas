unit Parameters.SpeechConfig;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.VoiceConfig, Parameters.MultiSpeakerVoiceConfig;

type
{
  https://ai.google.dev/api/generate-content#SpeechConfig
  语音生成配置。
}
  TSpeechConfig = class(TParameterReality)
  private
    { private declarations }
    FVoiceConfig: TVoiceConfig;
    FMultiSpeakerVoiceConfig: TMultiSpeakerVoiceConfig;
    FLanguageCode: String;
    procedure SetMultiSpeakerVoiceConfig(const Value: TMultiSpeakerVoiceConfig);
    procedure SetVoiceConfig(const Value: TVoiceConfig);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 单语音输出时的配置。
    property voiceConfig: TVoiceConfig read FVoiceConfig write SetVoiceConfig;
    // 可选。多音箱设置的配置。它与 voiceConfig 字段互斥。
    property multiSpeakerVoiceConfig: TMultiSpeakerVoiceConfig read FMultiSpeakerVoiceConfig write SetMultiSpeakerVoiceConfig;
    // 可选。用于语音合成的语言代码（采用 BCP 47 格式，例如“en-US”）。
    // 有效值包括：de-DE、en-AU、en-GB、en-IN、en-US、es-US、fr-FR、hi-IN、pt-BR、ar-XA、es-ES、fr-CA、id-ID、it-IT、ja-JP、tr-TR、vi-VN、bn-IN、gu-IN、kn-IN、ml-IN、mr-IN、ta-IN、te-IN、nl-NL、ko-KR、cmn-CN、pl-PL、ru-RU 和 th-TH。
    property languageCode: String read FLanguageCode write FLanguageCode;

    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType, Functions.SystemExtended;

{ TSpeechConfig }

constructor TSpeechConfig.Create();
begin
  inherited Create();
  FVoiceConfig := nil;
  FMultiSpeakerVoiceConfig := nil;
  FLanguageCode := GEMINI_LANGUAGE_CODE_EN_US;
end;

destructor TSpeechConfig.Destroy();
begin
  FLanguageCode := '';
  SafeFreeAndNil(FMultiSpeakerVoiceConfig);
  SafeFreeAndNil(FVoiceConfig);
  inherited Destroy();
end;

function TSpeechConfig.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TSpeechConfig.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'voiceConfig') then
  begin
    TParameterReality.CopyWithJson(Self.FVoiceConfig, TVoiceConfig, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'multiSpeakerVoiceConfig') then
  begin
    TParameterReality.CopyWithJson(Self.FMultiSpeakerVoiceConfig, TMultiSpeakerVoiceConfig, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TSpeechConfig.SetMultiSpeakerVoiceConfig(
  const Value: TMultiSpeakerVoiceConfig);
begin
  if (Value <> FMultiSpeakerVoiceConfig) then
    TParameterReality.CopyWithClass(FMultiSpeakerVoiceConfig, Value);
end;

procedure TSpeechConfig.SetVoiceConfig(const Value: TVoiceConfig);
begin
  if (Value <> FVoiceConfig) then
    TParameterReality.CopyWithClass(FVoiceConfig, Value);
end;

end.
