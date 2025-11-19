unit Parameters.FileInfo;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Status, Parameters.VideoFileMetadata;

type
{
  https://ai.google.dev/api/files#File
  上传到 API 的文件。下一个 ID：15
}
  TFile = class(TParameterReality)
  private
    { private declarations }
    FName: String;
    FDisplayName: String;
    FMimeType: String;
    FSizeBytes: String;
    FCreateTime: String; // (Timestamp format)
    FUpdateTime: String; // (Timestamp format)
    FExpirationTime: String; // (Timestamp format)
    FSha256Hash: String;
    FUri: String;
    FDownloadUri: String;
    FState: String;
    FSource: String;
    FError: TStatus;
    FVideoMetadata: TVideoFileMetadata;

    procedure SetError(const Value: TStatus);
    procedure SetVideoMetadata(const Value: TVideoFileMetadata);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 不可变。标识符。File 资源名称。ID（不含“files/”前缀的名称）最多可包含 40 个字符，这些字符可以是小写字母数字字符或短划线 (-)。ID 不能以短划线开头或结尾。如果创建时名称为空，系统会生成一个唯一名称。示例：files/123-456
    property name: String read FName write FName;
    // 可选。File 的人类可读显示名称。显示名称的长度不得超过 512 个字符（包括空格）。示例：“欢迎图片”
    property displayName: String read FDisplayName write FDisplayName;
    // 仅限输出。文件的 MIME 类型。【详情见MimeType.pas】
    property mimeType: String read FMimeType write FMimeType;
    // 仅限输出。文件的大小（以字节为单位）。
    property sizeBytes: String read FSizeBytes write FSizeBytes;
    // 仅限输出。File 的创建时间戳。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property createTime: String read FCreateTime write FCreateTime; // (Timestamp format)
    // 仅限输出。File 上次更新的时间戳。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property updateTime: String read FUpdateTime write FUpdateTime; // (Timestamp format)
    // 仅限输出。相应 File 将被删除的时间戳。仅当 File 计划过期时设置。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    property expirationTime: String read FExpirationTime write FExpirationTime; // (Timestamp format)
    // 仅限输出。上传字节的 SHA-256 哈希值。
    // 使用 base64 编码的字符串。
    property sha256Hash: String read FSha256Hash write FSha256Hash;
    // 仅限输出。File 的 URI。
    property uri: String read FUri write FUri;
    // 仅限输出。File 的下载 URI。
    property downloadUri: String read FDownloadUri write FDownloadUri;
    // 仅限输出。文件的处理状态。
    //
    // 值                   | 说明
    // STATE_UNSPECIFIED    | 默认值。如果省略状态，则使用此值。
    // PROCESSING           | 文件正在处理中，尚无法用于推理。
    // ACTIVE               | 文件已处理完毕，可用于推理。
    // FAILED               | 文件处理失败。
    property state: String read FState write FState;
    // 文件的来源。
    //
    // 值                   | 说明
    // SOURCE_UNSPECIFIED   | 如果未指定来源，则使用此值。
    // UPLOADED             | 表示文件由用户上传。
    // GENERATED            | 表示相应文件由 Google 生成。
    // REGISTERED           | 表示相应文件是已注册的文件，即 Google Cloud Storage 文件。
    property source: String read FSource write FSource;
    // 仅限输出。文件处理失败时的错误状态。
    property error: TStatus read FError write SetError;

    { Union type metadata start }
    // 文件的元数据。metadata 只能是下列其中一项：
    // 仅限输出。视频的元数据。
    property videoMetadata: TVideoFileMetadata read FVideoMetadata write SetVideoMetadata;
    { Union type metadata end }
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWithName(const szName, szDisplayName: String): TFile; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Constants.MimeType, Functions.SystemExtended;

{ TFile }

constructor TFile.Create();
begin
  inherited Create();
  Self.FName := '';
  Self.FDisplayName := '';
  Self.FMimeType := MIMETYPE_NONE;
  Self.FSizeBytes := '';
  Self.FCreateTime := '';
  Self.FUpdateTime := '';
  Self.FExpirationTime := '';
  Self.FSha256Hash := '';
  Self.FUri := '';
  Self.FDownloadUri := '';
  Self.FState := '';
  Self.FSource := '';
  Self.FError := nil;
  Self.FVideoMetadata := nil;
end;

class function TFile.CreateWithName(const szName, szDisplayName: String): TFile;
begin
  Result := TFile.Create();
  Result.name := szName;
  Result.displayName := szDisplayName;
end;

destructor TFile.Destroy();
begin
  SafeFreeAndNil(Self.FVideoMetadata);
  SafeFreeAndNil(Self.FError);
  Self.FSource := '';
  Self.FState := '';
  Self.FDownloadUri := '';
  Self.FUri := '';
  Self.FSha256Hash := '';
  Self.FExpirationTime := '';
  Self.FUpdateTime := '';
  Self.FCreateTime := '';
  Self.FSizeBytes := '';
  Self.FMimeType := '';
  Self.FDisplayName := '';
  Self.FName := '';
  inherited Destroy();
end;

function TFile.GetMemberValue(var sName: String; out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TFile.SetError(const Value: TStatus);
begin
  if (Value <> FError) then
    TParameterReality.CopyWithClass(FError, Value);
end;

function TFile.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'error') then
  begin
    TParameterReality.CopyWithJson(FError, TStatus, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'videoMetadata') then
  begin
    TParameterReality.CopyWithJson(FVideoMetadata, TVideoFileMetadata, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TFile.SetVideoMetadata(const Value: TVideoFileMetadata);
begin
  if (Value <> FVideoMetadata) then
    TParameterReality.CopyWithClass(FVideoMetadata, Value);
end;

end.
