unit Parameters.VideoMetadata;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#VideoMetadata
  元数据用于描述输入视频内容。
}
  TVideoMetadata = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 可选。视频的起始偏移量。该时长以秒为单位，最多包含九个小数位，以“s”结尾。示例："3.5s"。
    startOffset: String;
    // 可选。视频的结束偏移量。该时长以秒为单位，最多包含九个小数位，以“s”结尾。示例："3.5s"。
    endOffset: String;
    // 可选。发送给模型的视频的帧速率。如果未指定，则默认值为 1.0。fps 范围为 (0.0, 24.0]。
    fps: Double;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TVideoMetadata }

constructor TVideoMetadata.Create();
begin
  inherited Create();
  startOffset := '';
  endOffset := '';
  fps := 0;
end;

destructor TVideoMetadata.Destroy();
begin
  fps := 0;
  endOffset := '';
  startOffset := '';
  inherited Destroy();
end;

end.
