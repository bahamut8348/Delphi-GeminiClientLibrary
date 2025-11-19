unit Parameters.GoogleMaps;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#GoogleMaps
  可为用户查询提供地理空间背景信息的 GoogleMaps 工具。
}
  TGoogleMaps = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 可选。是否在回答的 GroundingMetadata 中返回 widget 上下文令牌。开发者可以使用 widget 上下文令牌来渲染 Google 地图 widget，其中包含与模型在回答中提及的地点相关的地理空间上下文。
    enableWidget: Boolean;
  published
    { published declarations }
  end;

implementation

end.
