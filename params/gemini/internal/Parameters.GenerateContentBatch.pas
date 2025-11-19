unit Parameters.GenerateContentBatch;

interface

uses
  System.SysUtils, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.BatchStats,
  Parameters.InputConfig, Parameters.GenerateContentBatchOutput;

type
{
  https://ai.google.dev/api/batch-api#generatecontentbatch
  表示一批 GenerateContent 请求的资源。
}
  TGenerateContentBatch = class(TParameterReality)
  private
    { private declarations }
    FModel: String;
    FName: String;
    FDisplayName: String;
    FInputConfig: TInputConfig;
    FOutput: TGenerateContentBatchOutput;
    FCreateTime: String; // (Timestamp format)
    FEndTime: String; // (Timestamp format)
    FUpdateTime: String; // (Timestamp format)
    FBatchStats: TBatchStats;
    FState: String;
    FPriority: String;

    procedure SetBatchStats(const Value: TBatchStats);
    procedure SetInputConfig(const Value: TInputConfig);
    procedure SetOutput(const Value: TGenerateContentBatchOutput);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。用于生成补全的 Model 的名称。
    // 格式：models/{model}。
    property model: String read FModel write FModel;
    // 仅限输出。标识符。批次的资源名称。
    // 格式：batches/{batchId}。
    property name: String read FName write FName;
    // 必需。相应批次的用户定义名称。
    property displayName: String read FDisplayName write FDisplayName;
    // 必需。执行批处理的实例的输入配置。
    property inputConfig: TInputConfig read FInputConfig write SetInputConfig;
    // 仅限输出。批量请求的输出。
    property output: TGenerateContentBatchOutput read FOutput write SetOutput;
    // 仅限输出。批次的创建时间。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property createTime: String read FCreateTime write FCreateTime; // (Timestamp format)
    // 仅限输出。批处理完成的时间。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property endTime: String read FEndTime write FEndTime; // (Timestamp format)
    // 仅限输出。批次上次更新的时间。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property updateTime: String read FUpdateTime write FUpdateTime; // (Timestamp format)
    // 仅限输出。有关批次的统计信息。
    property batchStats: TBatchStats read FBatchStats write SetBatchStats;
    // 仅限输出。批次的状态。
    //
    // 值                           | 说明
    // BATCH_STATE_UNSPECIFIED      | 未指定批处理状态。
    // BATCH_STATE_PENDING          | 服务正在准备运行批处理。
    // BATCH_STATE_RUNNING          | 批次正在进行中。
    // BATCH_STATE_SUCCEEDED        | 相应批次已成功完成。
    // BATCH_STATE_FAILED           | 批次失败。
    // BATCH_STATE_CANCELLED        | 批次已取消。
    // BATCH_STATE_EXPIRED          | 相应批次已过期。
    property state: String read FState write FState;
    // 可选。批次的优先级。优先级值较高的批次将先于优先级值较低的批次进行处理。允许使用负值。默认值为 0。
    property priority: String read FPriority write FPriority;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const szModelName, szDisplayName: String;
      const pInputConfig: TInputconfig; const szPriority: String): TGenerateContentBatch; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType, Functions.SystemExtended;

{ TGenerateContentBatch }

constructor TGenerateContentBatch.Create();
begin
  inherited Create();
  Self.FModel := '';
  Self.FName := '';
  Self.FDisplayName := '';
  Self.FInputConfig := nil;
  Self.FOutput := nil;
  Self.FCreateTime := '';
  Self.FEndTime := '';
  Self.FUpdateTime := '';
  Self.FBatchStats := nil;
  Self.FState := GEMINI_BATCH_STATE_UNSPECIFIED;
  Self.FPriority := '';
end;

class function TGenerateContentBatch.CreateWith(const szModelName,
  szDisplayName: String; const pInputConfig: TInputconfig;
  const szPriority: String): TGenerateContentBatch;
begin
  Result := TGenerateContentBatch.Create();
  Result.model := szModelName;
  Result.displayName := szDisplayName;
  Result.inputConfig := pInputConfig;
  Result.priority := szPriority;
end;

destructor TGenerateContentBatch.Destroy();
begin
  Self.FPriority := '';
  Self.FState := '';
  SafeFreeAndNil(Self.FBatchStats);
  Self.FUpdateTime := '';
  Self.FEndTime := '';
  Self.FCreateTime := '';
  SafeFreeAndNil(Self.FOutput);
  SafeFreeAndNil(Self.FInputConfig);
  Self.FDisplayName := '';
  Self.FName := '';
  Self.FModel := '';
  inherited Destroy();
end;

function TGenerateContentBatch.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TGenerateContentBatch.SetBatchStats(const Value: TBatchStats);
begin
  if (Value <> FBatchStats) then
    TParameterReality.CopyWithClass(FBatchStats, Value);
end;

procedure TGenerateContentBatch.SetInputConfig(const Value: TInputConfig);
begin
  if (Value <> FInputConfig) then
    TParameterReality.CopyWithClass(FInputConfig, Value);
end;

function TGenerateContentBatch.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'inputConfig') then
  begin
    TParameterReality.CopyWithJson(FInputConfig, TInputConfig, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'output') then
  begin
    TParameterReality.CopyWithJson(FOutput, TGenerateContentBatchOutput, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'batchStats') then
  begin
    TParameterReality.CopyWithJson(FBatchStats, TBatchStats, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TGenerateContentBatch.SetOutput(
  const Value: TGenerateContentBatchOutput);
begin
  if (Value <> FOutput) then
    TParameterReality.CopyWithClass(FOutput, Value);
end;

end.
