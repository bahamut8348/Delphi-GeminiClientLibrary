unit Parameters.RetrievalMetadata;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#RetrievalMetadata
  与接地流程中的检索相关的元数据。
}
  TRetrievalMetadata = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 可选。一个分数，用于指示 Google 搜索中的信息有多大可能有助于回答提示。得分介于 [0, 1] 范围内，其中 0 表示可能性最低，1 表示可能性最高。仅当启用 Google 搜索接地和动态检索时，系统才会填充此得分。系统会将该值与阈值进行比较，以确定是否触发 Google 搜索。
    googleSearchDynamicRetrievalScore: Double;
  published
    { published declarations }
  end;

implementation

end.
