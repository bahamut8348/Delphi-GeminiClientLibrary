unit Parameters.FileData;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#FileData
  基于 URI 的数据。
}
  TFileData = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 可选。来源数据的 IANA 标准 MIME 类型。
    mimeType: String;
    // 必需。URI。
    fileUri: String;
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

{ TFileData }

constructor TFileData.Create();
begin
  inherited Create();
  Self.mimeType := MIMETYPE_NONE;
  Self.fileUri := '';
end;

destructor TFileData.Destroy();
begin
  Self.fileUri := '';
  Self.mimeType := '';
  inherited Destroy();
end;

end.
