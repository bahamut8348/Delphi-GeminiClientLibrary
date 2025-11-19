unit Parameters.ReviewSnippet;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#ReviewSnippet
  封装了用户评价的一段内容，其中回答了有关 Google 地图中特定地点的特征的问题。
}
  TReviewSnippet = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 评价摘要的 ID。
    reviewId: String;
    // 与 Google 地图上的用户评价对应的链接。
    googleMapsUri: String;
    // 评价的标题。
    title: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TReviewSnippet }

constructor TReviewSnippet.Create();
begin
  inherited Create();
  Self.reviewId := '';
  Self.googleMapsUri := '';
  Self.title := '';
end;

destructor TReviewSnippet.Destroy();
begin
  Self.title := '';
  Self.googleMapsUri := '';
  Self.reviewId := '';
  inherited Destroy();
end;

end.
