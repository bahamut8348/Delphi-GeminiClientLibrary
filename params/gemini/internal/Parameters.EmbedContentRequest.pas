unit Parameters.EmbedContentRequest;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Content;

type
{
  https://ai.google.dev/api/batch-api#EmbedContentRequest
  包含要嵌入的模型的 Content 的请求。
}
  TEmbedContentRequest = class(TParameterReality)
  private
    { private declarations }
    FModel: String;
    FContent: TContent;
    FTaskType: String;
    FTitle: String;
    FOutputDimensionality: Integer;
    procedure SetContent(const Value: TContent);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。模型的资源名称。用作模型使用的 ID。此名称应与 ListModels 方法返回的某个模型名称相匹配。格式：models/{model}
    property model: String read FModel write FModel;
    // 必需。要嵌入的内容。系统只会统计 parts.text 字段。
    property content: TContent read FContent write SetContent;
    // 可选。嵌入将用于的可选任务类型。不支持较早的型号 (models/embedding-001)。
    //
    // 值                         | 说明
    // TASK_TYPE_UNSPECIFIED      | 未设置的值，默认情况下将为其他枚举值之一。
    // RETRIEVAL_QUERY            | 在搜索/检索设置中指定给定文本是查询。
    // RETRIEVAL_DOCUMENT         | 指定给定文本是正在搜索的语料库中的文档。
    // SEMANTIC_SIMILARITY        | 指定给定文本用于 STS。
    // CLASSIFICATION             | 指定将对给定的文本进行分类。
    // CLUSTERING                 | 指定嵌入用于聚类。
    // QUESTION_ANSWERING         | 指定给定文本用于问答。
    // FACT_VERIFICATION          | 指定给定文本将用于事实核查。
    // CODE_RETRIEVAL_QUERY       | 指定给定文本将用于代码检索。
    property taskType: String read FTaskType write FTaskType;
    // 可选。文本的可选标题。仅在 TaskType 为 RETRIEVAL_DOCUMENT 时适用。
    // 注意：为 RETRIEVAL_DOCUMENT 指定 title 可提供质量更高的嵌入以用于检索。
    property title: String read FTitle write FTitle;
    // 可选。输出嵌入的可选降维。如果设置，则会从末尾截断输出嵌入中的过大值。仅受 2024 年以来的较新型号支持。如果使用较早的模型 (models/embedding-001)，则无法设置此值。
    property outputDimensionality: Integer read FOutputDimensionality write FOutputDimensionality;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType, Functions.SystemExtended;

{ TEmbedContentRequest }

constructor TEmbedContentRequest.Create();
begin
  inherited Create();
  Self.FModel := '';
  Self.FContent := nil;
  Self.FTaskType := GEMINI_TASK_TYPE_UNSPECIFIED;
  Self.FTitle := '';
  Self.FOutputDimensionality := 0;
end;

destructor TEmbedContentRequest.Destroy();
begin
  Self.FOutputDimensionality := 0;
  Self.FTitle := '';
  Self.FTaskType := '';
  SafeFreeAndNil(Self.FContent);
  Self.FModel := '';
  inherited Destroy();
end;

function TEmbedContentRequest.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TEmbedContentRequest.SetContent(const Value: TContent);
begin
  if (Value <> FContent) then
    TParameterReality.CopyWithClass(FContent, Value);
end;

function TEmbedContentRequest.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'content') then
  begin
    TParameterReality.CopyWithJson(FContent, TContent, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
