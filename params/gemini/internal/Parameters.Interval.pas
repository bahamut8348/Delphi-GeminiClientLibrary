unit Parameters.Interval;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#Interval
  表示时间间隔，编码为开始时间戳（含）和结束时间戳（不含）。
  开始时间必须早于或等于结束时间。如果开始时间与结束时间相同，则时间间隔为空（不匹配任何时间）。如果未指定开始时间和结束时间，则该时间段会匹配任何时间。
}
  TInterval = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 可选。时间间隔的开始时间（含）。
    // 如果指定，则与此时间间隔匹配的时间戳必须等于或晚于开始时间。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"
    startTime: String; // (Timestamp format)
    // 可选。时间间隔的结束时间（不含）。
    // 如果指定，则与此时间间隔匹配的时间戳必须早于结束时间。
    // 采用 RFC 3339 标准，生成的输出将始终进行 Z 规范化（即转换为 UTC 零时区格式并在末尾附加 Z），并使用 0、3、6 或 9 个小数位。不带“Z”的偏差时间也是可以接受的。示例："2014-10-02T15:01:23Z"、"2014-10-02T15:01:23.045123456Z" 或 "2014-10-02T15:01:23+05:30"。
    endTime: String; // (Timestamp format)

    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TInterval }

constructor TInterval.Create();
begin
  inherited Create();
  Self.startTime := '';
  Self.endTime := '';
end;

destructor TInterval.Destroy();
begin
  Self.endTime := '';
  Self.startTime := '';
  inherited Destroy();
end;

end.
