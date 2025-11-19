unit Parameters.ChunkingConfig;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.WhiteSpaceConfig;

type
{
  https://ai.google.dev/api/files#ChunkingConfig
  用于告知服务如何对文件进行分块的参数。灵感来自 google3/cloud/ai/platform/extension/lib/retrieval/config/chunker_config.proto
}
  TChunkingConfig = class(TParameterReality)
  private
    { private declarations }
    FWhiteSpaceConfig: TWhiteSpaceConfig;
    procedure SetWhiteSpaceConfig(const Value: TWhiteSpaceConfig);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    { Union type config start }
    // 要使用的分块配置。config 只能是下列其中一项：
    // 空白字符分块配置。
    property whiteSpaceConfig: TWhiteSpaceConfig read FWhiteSpaceConfig write SetWhiteSpaceConfig;
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

{ TChunkingConfig }

constructor TChunkingConfig.Create();
begin
  inherited Create();
  Self.FWhiteSpaceConfig := nil;
end;

destructor TChunkingConfig.Destroy();
begin
  SafeFreeAndNil(Self.FWhiteSpaceConfig);
  inherited Destroy();
end;

function TChunkingConfig.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TChunkingConfig.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'whiteSpaceConfig') then
  begin
    TParameterReality.CopyWithJson(Self.FWhiteSpaceConfig, TWhiteSpaceConfig, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TChunkingConfig.SetWhiteSpaceConfig(const Value: TWhiteSpaceConfig);
begin
  if (Value <> FWhiteSpaceConfig) then
    TParameterReality.CopyWithClass(FWhiteSpaceConfig, Value);
end;

end.
