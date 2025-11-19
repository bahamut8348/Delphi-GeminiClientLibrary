unit Parameters.MultiSpeakerVoiceConfig;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.SpeakerVoiceConfig;

type
{
  https://ai.google.dev/api/generate-content#MultiSpeakerVoiceConfig
  多音箱设置的配置。
}
  TMultiSpeakerVoiceConfig = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。所有已启用的音箱语音。
    speakerVoiceConfigs: array of TSpeakerVoiceConfig;

    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TMultiSpeakerVoiceConfig }

constructor TMultiSpeakerVoiceConfig.Create();
begin
  inherited Create();
  SetLength(Self.speakerVoiceConfigs, 0);
end;

destructor TMultiSpeakerVoiceConfig.Destroy();
var
  nIndex: Integer;
begin
  for nIndex := High(Self.speakerVoiceConfigs) downto Low(Self.speakerVoiceConfigs) do
    SafeFreeAndNil(Self.speakerVoiceConfigs[nIndex]);
  SetLength(Self.speakerVoiceConfigs, 0);
  inherited Destroy();
end;

function TMultiSpeakerVoiceConfig.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TMultiSpeakerVoiceConfig.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
var
  nIndex: Integer;
begin
  if SameText(sName, 'speakerVoiceConfigs') then
  begin
    for nIndex := High(Self.speakerVoiceConfigs) downto Low(Self.speakerVoiceConfigs) do
      SafeFreeAndNil(Self.speakerVoiceConfigs[nIndex]);

    if (pValue is TJSONArray) then
    begin
      SetLength(Self.speakerVoiceConfigs, (pValue as TJSONArray).Count);
      for nIndex := Low(Self.speakerVoiceConfigs) to High(Self.speakerVoiceConfigs) do
      begin
        Self.speakerVoiceConfigs[nIndex] := TSpeakerVoiceConfig.Create();
        Self.speakerVoiceConfigs[nIndex].Parse((pValue as TJSONArray).Items[nIndex]);
      end;
    end
    else if (nil <> pValue) then
    begin
      SetLength(Self.speakerVoiceConfigs, 1);
      Self.speakerVoiceConfigs[0] := TSpeakerVoiceConfig.Create();
      Self.speakerVoiceConfigs[0].Parse(pValue);
    end
    else
      SetLength(Self.speakerVoiceConfigs, 0);

    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
