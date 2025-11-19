unit Parameters.Message;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.CitationSource, Parameters.CitationMetadata;

type
{
  https://ai.google.dev/api/palm#v1beta.Message
  结构化文本的基本单元。
  Message 包含 author 和 Message 的 content。
  author 用于在将消息作为文本馈送到模型时标记消息。
}
  TMessage = class(TParameterReality)
  private
    { private declarations }
    FAuthor: String;
    FContent: String;
    FCitationMetadata: TCitationMetadata;
    procedure SetCitationMetadata(const Value: TCitationMetadata);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。相应消息的作者。
    // 当此消息作为文本馈送到模型时，此属性可作为标记此消息内容的键。
    // 作者可以是任何字母数字字符串。
    property author: String read FAuthor write FAuthor;
    // 必需。结构化 Message 的文本内容。
    property content: String read FContent write FContent;
    // 仅限输出。相应 Message 中模型生成的 content 的引用信息。
    // 如果此 Message 是模型生成的输出，则此字段可能会填充 content 中包含的任何文本的提供方信息。此字段仅用于输出。
    property citationMetadata: TCitationMetadata read FCitationMetadata write SetCitationMetadata;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TMessage }

constructor TMessage.Create();
begin
  inherited Create();
  Self.FAuthor := '';
  Self.FContent := '';
  Self.FCitationMetadata := nil;
end;

destructor TMessage.Destroy();
begin
  SafeFreeAndNil(Self.FCitationMetadata);
  Self.FContent := '';
  Self.FAuthor := '';
  inherited Destroy();
end;

function TMessage.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TMessage.SetCitationMetadata(const Value: TCitationMetadata);
begin
  if (Value <> FCitationMetadata) then
    TParameterReality.CopyWithClass(FCitationMetadata, Value);
end;

function TMessage.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'citationMetadata') then
  begin
    TParameterReality.CopyWithJson(Self.FCitationMetadata, TCitationMetadata, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
