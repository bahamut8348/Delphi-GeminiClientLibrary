unit Parameters.UsageMetadataCaching;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#UsageMetadata
  有关缓存内容使用情况的元数据。
}
  TUsageMetadataCaching = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 缓存内容消耗的 token 总数。
    totalTokenCount: Integer;
  published
    { published declarations }
  end;

implementation

end.
