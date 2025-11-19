unit Parameters.Blob;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#Blob
  原始媒体字节。
  不应以原始字节形式发送文本，而应使用“text”字段。
}
  TBlob = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 来源数据的 IANA 标准 MIME 类型。示例：- image/png- image/jpeg 如果提供的 MIME 类型不受支持，系统会返回错误。如需查看支持的类型的完整列表，请参阅支持的文件格式。
    mimeType: String;
    // 媒体格式的原始字节。使用 base64 编码的字符串。
    data: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Constants.MimeType;

{ TBlob }

constructor TBlob.Create();
begin
  inherited Create();
  Self.mimeType := MIMETYPE_NONE;
  Self.data := '';
end;

destructor TBlob.Destroy();
begin
  Self.data := '';
  Self.mimeType := '';
  inherited Destroy();
end;

end.
