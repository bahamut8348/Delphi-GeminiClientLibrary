unit Parameters.CachedContent;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Content, Parameters.Tool,
  Parameters.UsageMetadata, Parameters.ToolConfig;

type
{
  https://ai.google.dev/api/caching#CachedContent
  已预处理的内容，可在后续对 GenerativeService 的请求中使用。缓存的内容只能用于创建该内容时所用的模型。
}
  TCachedContent = class(TParameterReality)
  private
    { private declarations }
    // 联合字段的序号，expiration 只允许存在一种值，如果全部都赋值发送给接口会返回错误。
    FUnionProperty: (upExpireTime, upTtl, upOther);

    FContents: TArray<TContent>;
    FTools: TArray<TTool>;

    FCreateTime: String; // (Timestamp format)
    FUpdateTime: String; // (Timestamp format)
    FUsageMetadata: TUsageMetadata;

    FExpireTime: String; // (Timestamp format)
    FTtl: String;
    FName: String;
    FDisplayName: String;
    FModel: String;
    FSystemInstruction: TContent;
    FToolConfig: TToolConfig;

    procedure SetCreateTime(const Value: String);
    procedure SetDisplayName(const Value: String);
    procedure SetExpireTime(const Value: String);
    procedure SetModel(const Value: String);
    procedure SetName(const Value: String);
    procedure SetSystemInstruction(const Value: TContent);
    procedure SetToolConfig(const Value: TToolConfig);
    procedure SetTtl(const Value: String);
    procedure SetUpdateTime(const Value: String);
    procedure SetUsageMetadata(const Value: TUsageMetadata);
    procedure SetContents(const Value: TArray<TContent>);
    procedure SetTools(const Value: TArray<TTool>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。仅限输入。不可变。要缓存的内容。
    property contents: TArray<TContent> read FContents write SetContents;
    // 可选。仅限输入。不可变。模型可能用于生成下一个回答的 Tools 列表
    property tools: TArray<TTool> read FTools write SetTools;
    // 仅限输出。相应缓存条目的创建时间。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property createTime: String read FCreateTime write SetCreateTime; // (Timestamp format)
    // 仅限输出。缓存条目的上次更新时间（世界协调时间）。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property updateTime: String read FUpdateTime write SetUpdateTime; // (Timestamp format)
    // 仅限输出。有关缓存内容使用情况的元数据。
    property usageMetadata: TUsageMetadata read FUsageMetadata write SetUsageMetadata;

    { public declarations }
    { Union type expiration start }
    // 指定相应资源何时过期。 expiration 只能是下列其中一项：
    // 资源被视为过期时的时间戳（世界协调时间）。无论输入中发送的是什么内容，输出中始终都会提供此时间戳。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property expireTime: String read FExpireTime write SetExpireTime; // (Timestamp format)
    // 仅限输入。相应资源的新 TTL，仅限输入。
    // 该时长以秒为单位，最多包含九个小数位，以“s”结尾。示例："3.5s"。
    property ttl: String read FTtl write SetTtl;
    { Union type expiration end }

    { public declarations }
    // 仅限输出。标识符。引用缓存内容的资源名称。格式：cachedContents/{id}
    property name: String read FName write SetName;
    // 可选。不可变。缓存内容的用户生成的有意义的显示名称。最多 128 个 Unicode 字符。
    property displayName: String read FDisplayName write SetDisplayName;
    // 必需。不可变。用于缓存内容的 Model 的名称格式：models/{model}
    property model: String read FModel write SetModel;
    // 可选。仅限输入。不可变。开发者设置系统指令。目前仅限文本。
    property systemInstruction: TContent read FSystemInstruction write SetSystemInstruction;
    // 可选。仅限输入。不可变。工具配置。此配置适用于所有工具。
    property toolConfig: TToolConfig read FToolConfig write SetToolConfig;

  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const pContents: TArray<TContent>; const pTools: TArray<TTool>;
      { Union type expiration start } const szExpireTime: String; const szTtl: String; { Union type expiration end }
      const szDisplayName: String; const szModelName: String;
      const pSystemInstruction: TContent; const pToolConfig: TToolConfig): TCachedContent; overload; inline; static;
    class function CreateWith({ Union type expiration start }
      const szExpireTime: String; const szTtl: String
      { Union type expiration end }): TCachedContent; overload; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  System.DateUtils, System.TimeSpan,
  Functions.SystemExtended;

{ TCachedContent }

constructor TCachedContent.Create();
begin
  inherited Create();
  Self.FUnionProperty := upExpireTime;
  SetLength(Self.FContents, 0);
  SetLength(Self.FTools, 0);
  Self.FCreateTime := '';
  Self.FUpdateTime := '';
  Self.FUsageMetadata := nil;
  Self.FExpireTime := '';
  Self.FTtl := '';
  Self.FName := '';
  Self.FDisplayName := '';
  Self.FModel := '';
  Self.FSystemInstruction := nil;
  Self.FToolConfig := nil;
end;

class function TCachedContent.CreateWith(const pContents: TArray<TContent>;
  const pTools: TArray<TTool>; const szExpireTime, szTtl, szDisplayName,
  szModelName: String; const pSystemInstruction: TContent;
  const pToolConfig: TToolConfig): TCachedContent;
begin
  Result := TCachedContent.Create();
  Result.contents := pContents;
  Result.tools := pTools;
  Result.model := szModelName;
  Result.systemInstruction := pSystemInstruction;
  Result.toolConfig := pToolConfig;

  if ('' <> szExpireTime) then
    Result.expireTime := szExpireTime
  else if ('' <> szTtl) then
    Result.ttl := szTtl
  else
    Result.ttl := '0s';
end;

class function TCachedContent.CreateWith(const szExpireTime,
  szTtl: String): TCachedContent;
begin
  Result := TCachedContent.Create();
  if ('' <> szExpireTime) then
    Result.expireTime := szExpireTime
  else if ('' <> szTtl) then
    Result.ttl := szTtl
  else
    Result.ttl := '0s';
end;

destructor TCachedContent.Destroy();
begin
  SafeFreeAndNil(Self.FToolConfig);
  SafeFreeAndNil(Self.FSystemInstruction);
  Self.FModel := '';
  Self.FDisplayName := '';
  Self.FName := '';
  Self.FTtl := '';
  Self.FExpireTime := '';
  SafeFreeAndNil(Self.FUsageMetadata);
  Self.FUpdateTime := '';
  Self.FCreateTime := '';
  TParameterReality.ReleaseArray<TTool>(Self.FTools);
  TParameterReality.ReleaseArray<TContent>(Self.FContents);
  Self.FUnionProperty := upOther;
  inherited Destroy();
end;

function TCachedContent.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  if SameText(sName, 'expireTime') then
  begin
    if (upExpireTime = FUnionProperty) then
    begin
      if ('' = Self.FExpireTime) then
        pValue := TValue.From(DateTimeToUniversalString())
      else
        pValue := TValue.From(Self.FExpireTime);
    end
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'ttl') then
  begin
    if (upTtl = FUnionProperty) then
    begin
      if ('' = Self.FTtl) then
        pValue := TValue.From('0s')
      else
        pValue := TValue.From(Self.FTtl);
    end
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else
    Result := inherited GetMemberValue(sName, pValue);
end;

procedure TCachedContent.SetContents(const Value: TArray<TContent>);
begin
  TParameterReality.CopyArrayWithClass<TContent>(FContents, Value);
end;

procedure TCachedContent.SetCreateTime(const Value: String);
begin
  FCreateTime := Value;
end;

procedure TCachedContent.SetDisplayName(const Value: String);
begin
  FDisplayName := Value;
end;

procedure TCachedContent.SetExpireTime(const Value: String);
begin
  FUnionProperty := upExpireTime;
  FExpireTime := Value;
end;

function TCachedContent.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'contents') then
  begin
    TParameterReality.CopyArrayWithJson<TContent>(Self.FContents, pValue);
    EXIT(TRUE);
  end
  else if SameText(sName, 'tools') then
  begin
    TParameterReality.CopyArrayWithJson<TTool>(Self.FTools, pValue);
    EXIT(TRUE);
  end
  else if SameText(sName, 'usageMetadata') then
  begin
    TParameterReality.CopyWithJson(Self.FUsageMetadata, TUsageMetadata, pValue);
    EXIT(TRUE);
  end
  else if SameText(sName, 'systemInstruction') then
  begin
    TParameterReality.CopyWithJson(Self.FSystemInstruction, TContent, pValue);
    EXIT(TRUE);
  end
  else if SameText(sName, 'toolConfig') then
  begin
    TParameterReality.CopyWithJson(Self.FToolConfig, TToolConfig, pValue);
    EXIT(TRUE);
  end
  else if SameText(sName, 'ttl') then
  begin
    FUnionProperty := upTtl;
    FTtl := GetJsonStringValue(pValue);
    EXIT(TRUE);
  end
  else if SameText(sName, 'expireTime') then
  begin
    FUnionProperty := upExpireTime;
    FExpireTime := GetJsonStringValue(pValue);
    EXIT(TRUE);
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TCachedContent.SetModel(const Value: String);
begin
  FModel := Value;
end;

procedure TCachedContent.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TCachedContent.SetSystemInstruction(const Value: TContent);
begin
  if (Value <> FSystemInstruction) then
    TParameterReality.CopyWithClass(FSystemInstruction, Value);
end;

procedure TCachedContent.SetToolConfig(const Value: TToolConfig);
begin
  if (Value <> FToolConfig) then
    TParameterReality.CopyWithClass(FToolConfig, Value);
end;

procedure TCachedContent.SetTools(const Value: TArray<TTool>);
begin
  TParameterReality.CopyArrayWithClass<TTool>(FTools, Value);
end;

procedure TCachedContent.SetTtl(const Value: String);
begin
  FUnionProperty := upTtl;
  FTtl := Value;
end;

procedure TCachedContent.SetUpdateTime(const Value: String);
begin
  FUpdateTime := Value;
end;

procedure TCachedContent.SetUsageMetadata(const Value: TUsageMetadata);
begin
  if (Value <> FUsageMetadata) then
    TParameterReality.CopyWithClass(FUsageMetadata, Value);
end;

end.
