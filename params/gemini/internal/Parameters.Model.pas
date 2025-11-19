unit Parameters.Model;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/models#Model
  有关生成式语言模型的信息。
}
  TModel = class(TParameterReality)
  private
    { private declarations }
    FName: String;
    FBaseModelId: String;
    FVersion: String;
    FDisplayName: String;
    FDescription: String;
    FInputTokenLimit: Integer;
    FOutputTokenLimit: Integer;
    FSupportedGenerationMethods: TArray<String>;
    FThinking: Boolean;
    FTemperature: Double;
    FMaxTemperature: Double;
    FTopP: Double;
    FTopK: Integer;
    procedure SetSupportedGenerationMethods(const Value: TArray<String>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。Model 的资源名称。如需了解所有允许的值，请参阅模型变体。
    // 格式：models/{model}，采用 {model} 命名规范：
    // "{baseModelId}-{version}"
    // 示例：
    // models/gemini-1.5-flash-001
    property name: String read FName write FName;
    // 必需。基础模型的名称，将其传递给生成请求。
    // 示例：
    // gemini-1.5-flash
    property baseModelId: String read FBaseModelId write FBaseModelId;
    // 必需。模型的版本号。
    // 表示主要版本（1.0 或 1.5）
    property version: String read FVersion write FVersion;
    // 模型的直观易懂的名称。例如“Gemini 1.5 Flash”。
    // 名称不得超过 128 个字符，可以包含任何 UTF-8 字符。
    property displayName: String read FDisplayName write FDisplayName;
    // 模型的简短说明。
    property description: String read FDescription write FDescription;
    // 相应模型允许的输入令牌数量上限。
    property inputTokenLimit: Integer read FInputTokenLimit write FInputTokenLimit;
    // 相应模型可输出的词元数量上限。
    property outputTokenLimit: Integer read FOutputTokenLimit write FOutputTokenLimit;
    // 模型支持的生成方法。
    // 相应的 API 方法名称定义为 Pascal 大小写字符串，例如 generateMessage 和 generateContent。
    property supportedGenerationMethods: TArray<String> read FSupportedGenerationMethods write SetSupportedGenerationMethods;
    // 模型是否支持思考。
    property thinking: Boolean read FThinking write FThinking;
    // 控制输出的随机性。
    // 值可介于 [0.0,maxTemperature] 之间（含边界值）。值越高，生成的回答就越多样化；而值越接近 0.0，模型生成的回答通常就越不令人意外。此值用于指定后端在调用模型时使用的默认值。
    property temperature: Double read FTemperature write FTemperature;
    // 此模型可使用的最高温度。
    property maxTemperature: Double read FMaxTemperature write FMaxTemperature;
    // 对于核采样。核采样会考虑概率总和至少为 topP 的最小 token 集。此值用于指定后端在调用模型时使用的默认值。
    property topP: Double read FTopP write FTopP;
    // 适用于 Top-k 采样。Top-k 抽样会考虑 topK 个最有可能的 token。此值用于指定后端在调用模型时使用的默认值。如果为空，则表示模型不使用 Top-K 抽样，并且不允许将 topK 用作生成参数。
    property topK: Integer read FTopK write FTopK;
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

{ TModel }

constructor TModel.Create();
begin
  inherited Create();
  Self.FName := '';
  Self.FBaseModelId := '';
  Self.FVersion := '';
  Self.FDisplayName := '';
  Self.FDescription := '';
  Self.FInputTokenLimit := 0;
  Self.FOutputTokenLimit := 0;
  SetLength(Self.FSupportedGenerationMethods, 0);
  Self.FThinking := FALSE;
  Self.FTemperature := 0;
  Self.FMaxTemperature := 0;
  Self.FTopP := 0;
  Self.FTopK := 0;
end;

destructor TModel.Destroy();
begin
  Self.FTopK := 0;
  Self.FTopP := 0;
  Self.FMaxTemperature := 0;
  Self.FTemperature := 0;
  Self.FThinking := FALSE;
  ReleaseStringArray( Self.FSupportedGenerationMethods );
  Self.FOutputTokenLimit := 0;
  Self.FInputTokenLimit := 0;
  Self.FDescription := '';
  Self.FDisplayName := '';
  Self.FVersion := '';
  Self.FBaseModelId := '';
  Self.FName := '';
  inherited Destroy();
end;

function TModel.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TModel.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'supportedGenerationMethods') then
  begin
    CopyStringArrayWithJson(Self.FSupportedGenerationMethods, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TModel.SetSupportedGenerationMethods(const Value: TArray<String>);
begin
  CopyStringArrayWithArray(FSupportedGenerationMethods, Value);
end;

end.
