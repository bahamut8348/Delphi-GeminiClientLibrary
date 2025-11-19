unit Parameters.Segment;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#Segment
  内容片段。
}
  TSegment = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 仅限输出。Part 对象在其父 Content 对象中的索引。
    partIndex: Integer;
    // 仅限输出。指定 Part 中的起始索引（以字节为单位）。从 Part 开始的偏移量（含），从零开始。
    startIndex: Integer;
    // 仅限输出。指定部分的结束索引（以字节为单位）。从相应部分的开头开始的偏移量（不含边界值），从零开始。
    endIndex: Integer;
    // 仅限输出。响应中与相应片段对应的文本。
    text: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TSegment }

constructor TSegment.Create();
begin
  inherited Create();
  Self.partIndex := 0;
  Self.startIndex := 0;
  Self.endIndex := 0;
  Self.text := '';
end;

destructor TSegment.Destroy();
begin
  Self.text := '';
  Self.endIndex := 0;
  Self.startIndex := 0;
  Self.partIndex := 0;
  inherited Destroy();
end;

end.
