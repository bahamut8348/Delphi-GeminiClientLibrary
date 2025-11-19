unit Parameters.EmbedContentRequestBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Content, Parameters.Part;

type
{
  https://ai.google.dev/api/embeddings#request-body
  models.embedContent 请求正文
}
  TEmbedContentRequestBody = class(TParameterReality)
  private
    FTitle: String;
    FTaskType: String;
    FOutputDimensionality: Integer;
    FContent: TContent;
    procedure SetContent(const Value: TContent);
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
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

    class function CreateWith(const pContent: TContent): TEmbedContentRequestBody; overload; inline;
    class function CreateWith(const szText: String): TEmbedContentRequestBody; overload; inline;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType,
  Functions.SystemExtended;

{ TEmbedContentRequestBody }

constructor TEmbedContentRequestBody.Create();
begin
  inherited Create();
  FTitle := '';
  FTaskType := GEMINI_TASK_TYPE_UNSPECIFIED;
  FOutputDimensionality := 0;
  FContent := nil;
end;

class function TEmbedContentRequestBody.CreateWith(
  const szText: String): TEmbedContentRequestBody;
begin
  Result := TEmbedContentRequestBody.Create();
  Result.FContent := TContent.CreateWithPart(szText);
end;

class function TEmbedContentRequestBody.CreateWith(
  const pContent: TContent): TEmbedContentRequestBody;
begin
  Result := TEmbedContentRequestBody.Create();
  Result.content := pContent;
end;

destructor TEmbedContentRequestBody.Destroy();
begin
  SafeFreeAndNil(FContent);
  FOutputDimensionality := 0;
  FTaskType := '';
  FTitle := '';
  inherited Destroy();
end;

function TEmbedContentRequestBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TEmbedContentRequestBody.SetContent(const Value: TContent);
begin
  if (Value <> FContent) then
    TParameterReality.CopyWithClass(FContent, Value);
end;

function TEmbedContentRequestBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'content') then
  begin
    TParameterReality.CopyWithJson(Self.FContent, TContent, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.

