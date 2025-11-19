unit Parameters.DynamicRetrievalConfig;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#DynamicRetrievalConfig
  介绍了用于自定义动态检索的选项。
}
  TDynamicRetrievalConfig = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 要在动态检索中使用的预测器的模式。
    //
    // 值                 | 说明
    // MODE_UNSPECIFIED   | 始终触发检索。
    // MODE_DYNAMIC       | 仅在系统认为必要时运行检索。
    mode: String;
    // 动态检索中要使用的阈值。如果未设置，则使用系统默认值。
    dynamicThreshold: Double;
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

{ TDynamicRetrievalConfig }

constructor TDynamicRetrievalConfig.Create();
begin
  inherited Create();
  Self.mode := GEMINI_MODE_DYNAMIC;
  Self.dynamicThreshold := 0;
end;

destructor TDynamicRetrievalConfig.Destroy();
begin
  Self.dynamicThreshold := 0;
  Self.mode := '';
  inherited Destroy();
end;

end.
