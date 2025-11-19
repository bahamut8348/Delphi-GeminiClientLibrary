unit Parameters.Document;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.CustomMetadata;

type
{
  https://ai.google.dev/api/file-search/documents#Document
  Document 是 Chunk 的集合。
}
  TDocument = class(TParameterReality)
  private
    { private declarations }
    FName: String;
    FDisplayName: String;
    FCustomMetadata: TArray<TCustomMetadata>;
    FUpdateTime: String;
    FCreateTime: String;
    FState: String;
    FSizeBytes: String;
    FMimeType: String;

    procedure SetCustomMetadata(const Value: TArray<TCustomMetadata>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 不可变。标识符。Document 资源名称。ID（不含“fileSearchStores/*/documents/”前缀的名称）最多可包含 40 个字符，这些字符可以是小写字母数字字符或短划线 (-)。ID 不能以短划线开头或结尾。如果创建时的名称为空，系统会从 displayName 派生出一个唯一名称，并附加一个 12 字符的随机后缀。示例：fileSearchStores/{file_search_store_id}/documents/my-awesome-doc-123a456b789c
    property name: String read FName write FName;
    // 可选。Document 的人类可读显示名称。显示名称的长度不得超过 512 个字符（包括空格）。示例：“语义检索器文档”
    property displayName: String read FDisplayName write FDisplayName;
    // 可选。用户提供的自定义元数据，以键值对的形式存储，用于查询。一个 Document 最多可以有 20 个 CustomMetadata。
    property customMetadata: TArray<TCustomMetadata> read FCustomMetadata write SetCustomMetadata;
    // 仅限输出。上次更新 Document 时的时间戳。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property updateTime: String read FUpdateTime write FUpdateTime; // (Timestamp format)
    // 仅限输出。Document 的创建时间戳。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property createTime: String read FCreateTime write FCreateTime; // (Timestamp format)
    // 仅限输出。Document 的当前状态。
    //
    // 值                   | 说明
    // STATE_UNSPECIFIED    | 默认值。如果省略状态，则使用此值。
    // STATE_PENDING        | 部分 Document 正在处理（嵌入和向量存储）。Chunks
    // STATE_ACTIVE         | Document 的所有 Chunks 都已处理完毕，可供查询。
    // STATE_FAILED         | 部分 Document 的 Chunks 处理失败。
    property state: String read FState write FState;
    // 仅限输出。提取到文档中的原始字节的大小。
    property sizeBytes: String read FSizeBytes write FSizeBytes;
    // 仅限输出。相应文档的 MIME 类型。
    property mimeType: String read FMimeType write FMimeType;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType,
  Functions.SystemExtended;

{ TDocument }

constructor TDocument.Create();
begin
  inherited Create();
  Self.FName := '';
  Self.FDisplayName := '';
  SetLength(Self.FCustomMetadata, 0);
  Self.FUpdateTime := '';
  Self.FCreateTime := '';
  Self.FState := GEMINI_DOCUMENT_STATE_UNSPECIFIED;
  Self.FSizeBytes := '';
  Self.FMimeType := '';
end;

destructor TDocument.Destroy();
begin
  Self.FMimeType := '';
  Self.FSizeBytes := '';
  Self.FState := '';
  Self.FCreateTime := '';
  Self.FUpdateTime := '';
  TParameterReality.ReleaseArray<TCustomMetadata>(Self.FCustomMetadata);
  Self.FDisplayName := '';
  Self.FName := '';
  inherited Destroy();
end;

function TDocument.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TDocument.SetCustomMetadata(const Value: TArray<TCustomMetadata>);
begin
  TParameterReality.CopyArrayWithClass<TCustomMetadata>(FCustomMetadata, Value);
end;

function TDocument.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'customMetadata') then
  begin
    TParameterReality.CopyArrayWithJson<TCustomMetadata>(Self.FCustomMetadata, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
