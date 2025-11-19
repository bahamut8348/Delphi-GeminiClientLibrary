unit Parameters.BatchGenerateContentRequestBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.InputConfig,
  Parameters.GenerateContentBatchOutput, Parameters.BatchStats;

type
{
  https://ai.google.dev/api/batch-api#request-body
  将一批 models.generateContent 个请求加入队列以进行批处理。
}
  TBatchGenerateContentRequestBody = class(TParameterReality)
  private
    { private declarations }
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
    procedure SetCreateTime(const Value: String);
    procedure SetDisplayName(const Value: String);
    procedure SetEndTime(const Value: String);
    procedure SetInputConfig(const Value: TInputConfig);
    procedure SetName(const Value: String);
    procedure SetOutput(const Value: TGenerateContentBatchOutput);
    procedure SetPriority(const Value: String);
    procedure SetState(const Value: String);
    procedure SetUpdateTime(const Value: String);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    { 该参数所有字段名前面都有一个前缀【batch.】，但由于名字中间的点号【.】不符合标识符规范，所以属性一律只截取了点号【.】后面的部分。 }

    // batch.name 仅限输出。标识符。批次的资源名称。
    // 格式：batches/{batchId}。
    property name: String read FName write SetName;
    // batch.displayName 必需。相应批次的用户定义名称。
    property displayName: String read FDisplayName write SetDisplayName;
    // batch.inputConfig 必需。执行批处理的实例的输入配置。
    property inputConfig: TInputConfig read FInputConfig write SetInputConfig;
    // batch.output 仅限输出。批量请求的输出。
    property output: TGenerateContentBatchOutput read FOutput write SetOutput;
    // batch.createTime 仅限输出。批次的创建时间。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property createTime: String read FCreateTime write SetCreateTime; // (Timestamp format)
    // batch.endTime 仅限输出。批处理完成的时间。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property endTime: String read FEndTime write SetEndTime; // (Timestamp format)
    // batch.updateTime 仅限输出。批次上次更新的时间。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property updateTime: String read FUpdateTime write SetUpdateTime; // (Timestamp format)
    // batch.batchStats 仅限输出。有关批次的统计信息。
    property batchStats: TBatchStats read FBatchStats write SetBatchStats;
    // batch.state 仅限输出。批次的状态。
    //
    // 值                         | 说明
    // BATCH_STATE_UNSPECIFIED    | 未指定批处理状态。
    // BATCH_STATE_PENDING        | 服务正在准备运行批处理。
    // BATCH_STATE_RUNNING        | 批次正在进行中。
    // BATCH_STATE_SUCCEEDED      | 相应批次已成功完成。
    // BATCH_STATE_FAILED         | 批次失败。
    // BATCH_STATE_CANCELLED      | 批次已取消。
    // BATCH_STATE_EXPIRED        | 相应批次已过期。
    property state: String read FState write SetState;
    // batch.priority 可选。批次的优先级。优先级值较高的批次将先于优先级值较低的批次进行处理。允许使用负值。默认值为 0。
    property priority: String read FPriority write SetPriority;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const szDisplayName: String; const pInputConfig: TInputConfig;
      const szPriority: String = '0'): TBatchGenerateContentRequestBody; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType,
  Functions.StringsUtils,
  Functions.SystemExtended;

{ TBatchGenerateContentRequestBody }

constructor TBatchGenerateContentRequestBody.Create();
begin
  inherited Create();
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

class function TBatchGenerateContentRequestBody.CreateWith(
  const szDisplayName: String; const pInputConfig: TInputConfig;
  const szPriority: String): TBatchGenerateContentRequestBody;
begin
  Result := TBatchGenerateContentRequestBody.Create();
  Result.displayName := szDisplayName;
  Result.inputConfig := pInputConfig;
  Result.priority := szPriority;
end;

destructor TBatchGenerateContentRequestBody.Destroy();
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
  inherited Destroy();
end;

function TBatchGenerateContentRequestBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  // 在调用 ToJson 方法前调用 GetMemberValue 的时候要在属性的名字前面重新把前缀【batch.】加回去。
  if SameText(sName, 'name') then
  begin
    sName := 'batch.' + sName;
    if ('' = FName) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(FName);

    Result := TRUE;
  end
  else if SameText(sName, 'displayName') then
  begin
    sName := 'batch.' + sName;
    if ('' = FDisplayName) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(FDisplayName);

    Result := TRUE;
  end
  else if SameText(sName, 'inputConfig') then
  begin
    sName := 'batch.' + sName;
    if (nil = FInputConfig) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(FInputConfig);

    Result := TRUE;
  end
  else if SameText(sName, 'output') then
  begin
    sName := 'batch.' + sName;
    if (nil = FOutput) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(FOutput);

    Result := TRUE;
  end
  else if SameText(sName, 'createTime') then
  begin
    sName := 'batch.' + sName;
    if ('' = FCreateTime) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(FCreateTime);

    Result := TRUE;
  end
  else if SameText(sName, 'endTime') then
  begin
    sName := 'batch.' + sName;
    if ('' = FEndTime) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(FEndTime);

    Result := TRUE;
  end
  else if SameText(sName, 'updateTime') then
  begin
    sName := 'batch.' + sName;
    if ('' = FUpdateTime) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(FUpdateTime);

    Result := TRUE;
  end
  else if SameText(sName, 'batchStats') then
  begin
    sName := 'batch.' + sName;
    if (nil = FBatchStats) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(FBatchStats);

    Result := TRUE;
  end
  else if SameText(sName, 'state') then
  begin
    sName := 'batch.' + sName;
    if ('' = FState) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(FState);

    Result := TRUE;
  end
  else if SameText(sName, 'priority') then
  begin
    sName := 'batch.' + sName;
    if ('' = FPriority) then
      pValue := TValue.Empty
    else
      pValue := TValue.From(FPriority);

    Result := TRUE;
  end
  else
    Result := inherited GetMemberValue(sName, pValue);
end;

procedure TBatchGenerateContentRequestBody.SetBatchStats(
  const Value: TBatchStats);
begin
  if (Value <> FBatchStats) then
    TParameterReality.CopyWithClass(FBatchStats, Value);
end;

procedure TBatchGenerateContentRequestBody.SetCreateTime(const Value: String);
begin
  FCreateTime := Value;
end;

procedure TBatchGenerateContentRequestBody.SetDisplayName(const Value: String);
begin
  FDisplayName := Value;
end;

procedure TBatchGenerateContentRequestBody.SetEndTime(const Value: String);
begin
  FEndTime := Value;
end;

procedure TBatchGenerateContentRequestBody.SetInputConfig(
  const Value: TInputConfig);
begin
  if (Value <> FInputConfig) then
    TParameterReality.CopyWithClass(FInputConfig, Value);
end;

function TBatchGenerateContentRequestBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  // 在调用 Parse 方法解析 json 之后调用 SetMemberValue 的时候要去除属性名的前缀【batch.】。
  if SameText(sName, 'batch.name') then
  begin
    FName := GetJsonStringValue(pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'batch.displayName') then
  begin
    FDisplayName := GetJsonStringValue(pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'batch.inputConfig') then
  begin
    TParameterReality.CopyWithJson(FInputConfig, TInputConfig, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'batch.output') then
  begin
    TParameterReality.CopyWithJson(FOutput, TGenerateContentBatchOutput, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'batch.createTime') then
  begin
    FCreateTime := GetJsonStringValue(pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'batch.endTime') then
  begin
    FEndTime := GetJsonStringValue(pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'batch.updateTime') then
  begin
    FUpdateTime := GetJsonStringValue(pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'batch.batchStats') then
  begin
    TParameterReality.CopyWithJson(FBatchStats, TBatchStats, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'batch.state') then
  begin
    FState := GetJsonStringValue(pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'batch.priority') then
  begin
    FPriority := GetJsonStringValue(pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TBatchGenerateContentRequestBody.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TBatchGenerateContentRequestBody.SetOutput(
  const Value: TGenerateContentBatchOutput);
begin
  if (Value <> FOutput) then
    TParameterReality.CopyWithClass(FOutput, Value);
end;

procedure TBatchGenerateContentRequestBody.SetPriority(const Value: String);
begin
  FPriority := Value;
end;

procedure TBatchGenerateContentRequestBody.SetState(const Value: String);
begin
  FState := Value;
end;

procedure TBatchGenerateContentRequestBody.SetUpdateTime(const Value: String);
begin
  FUpdateTime := Value;
end;

end.