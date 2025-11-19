unit Parameters.FileSearchStore;

interface

uses
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/file-search/file-search-stores#FileSearchStore
  FileSearchStore 是 Document 的集合。
}
  TFileSearchStore = class(TParameterReality)
  private
    { private declarations }
    FName: String;
    FDisplayName: String;
    FCreateTime: String; // (Timestamp format)
    FUpdateTime: String; // (Timestamp format)
    FActiveDocumentsCount: String;
    FPendingDocumentsCount: String;
    FFailedDocumentsCount: String;
    FSizeBytes: String;
  protected
    { protected declarations }
  public
    { public declarations }
    // 仅限输出。不可变。标识符。FileSearchStore 资源名称。这是一个 ID（不含“fileSearchStores/”前缀的名称），最多可包含 40 个字符，这些字符可以是小写字母数字字符或短划线 (-)。此属性仅供输出。唯一名称将从 displayName 派生，并附带一个 12 字符的随机后缀。示例：fileSearchStores/my-awesome-file-search-store-123a456b789c 如果未提供 displayName，系统将随机生成名称。
    property name: String read FName write FName;
    // 可选。FileSearchStore 的人类可读显示名称。显示名称的长度不得超过 512 个字符（包括空格）。示例：“语义检索器上的文档”
    property displayName: String read FDisplayName write FDisplayName;
    // 仅限输出。FileSearchStore 的创建时间戳。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property createTime: String read FCreateTime write FCreateTime; // (Timestamp format)
    // 仅限输出。上次更新 FileSearchStore 时的时间戳。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property updateTime: String read FUpdateTime write FUpdateTime; // (Timestamp format)
    // 仅限输出。FileSearchStore 中处于有效状态且可供检索的文档数量。
    property activeDocumentsCount: String read FActiveDocumentsCount write FActiveDocumentsCount;
    // 仅限输出。正在处理的 FileSearchStore 中的文档数量。
    property pendingDocumentsCount: String read FPendingDocumentsCount write FPendingDocumentsCount;
    // 仅限输出。FileSearchStore 中处理失败的文档数量。
    property failedDocumentsCount: String read FFailedDocumentsCount write FFailedDocumentsCount;
    // 仅限输出。提取到 FileSearchStore 中的原始字节的大小。这是 FileSearchStore 中所有文档的总大小。
    property sizeBytes: String read FSizeBytes write FSizeBytes;

  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const szDisplayName: String): TFileSearchStore; inline; static;
  published
    { published declarations }
  end;

implementation

{ TFileSearchStore }

constructor TFileSearchStore.Create();
begin
  inherited Create();
  Self.FName := '';
  Self.FDisplayName := '';
  Self.FCreateTime := ''; // (Timestamp format)
  Self.FUpdateTime := ''; // (Timestamp format)
  Self.FActiveDocumentsCount := '';
  Self.FPendingDocumentsCount := '';
  Self.FFailedDocumentsCount := '';
  Self.FSizeBytes := '';
end;

class function TFileSearchStore.CreateWith(
  const szDisplayName: String): TFileSearchStore;
begin
  Result := TFileSearchStore.Create();
  Result.displayName := szDisplayName;
end;

destructor TFileSearchStore.Destroy();
begin
  Self.FSizeBytes := '';
  Self.FFailedDocumentsCount := '';
  Self.FPendingDocumentsCount := '';
  Self.FActiveDocumentsCount := '';
  Self.FUpdateTime := ''; // (Timestamp format)
  Self.FCreateTime := ''; // (Timestamp format)
  Self.FDisplayName := '';
  Self.FName := '';
  inherited Destroy();
end;

end.

