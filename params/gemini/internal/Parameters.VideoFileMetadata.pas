unit Parameters.VideoFileMetadata;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/files#VideoFileMetadata
  视频 File 的元数据。
}
  TVideoFileMetadata = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 视频时长。该时长以秒为单位，最多包含九个小数位，以“s”结尾。示例："3.5s"。
    videoDuration: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TVideoFileMetadata }

constructor TVideoFileMetadata.Create();
begin
  inherited Create();
  videoDuration := '';
end;

destructor TVideoFileMetadata.Destroy();
begin
  videoDuration := '';
  inherited Destroy();
end;

end.
