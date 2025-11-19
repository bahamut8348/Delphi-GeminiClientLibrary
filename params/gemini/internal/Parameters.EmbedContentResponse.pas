unit Parameters.EmbedContentResponse;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.ContentEmbedding;

type
{
  https://ai.google.dev/api/embeddings#embedcontentresponse
  对 EmbedContentRequest 的响应。
}
  TEmbedContentResponse = class(TParameterReality)
  private
    { private declarations }
    FEmbedding: TContentEmbedding;
    procedure SetEmbedding(const Value: TContentEmbedding);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 仅限输出。根据输入内容生成的嵌入。
    property embedding: TContentEmbedding read FEmbedding write SetEmbedding;
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

{ TEmbedContentResponse }

constructor TEmbedContentResponse.Create();
begin
  inherited Create();
  Self.FEmbedding := nil;
end;

destructor TEmbedContentResponse.Destroy();
begin
  SafeFreeAndNil(Self.FEmbedding);
  inherited Destroy();
end;

function TEmbedContentResponse.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TEmbedContentResponse.SetEmbedding(const Value: TContentEmbedding);
begin
  if (Value <> FEmbedding) then
    TParameterReality.CopyWithClass(FEmbedding, Value);
end;

function TEmbedContentResponse.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'embedding') then
  begin
    TParameterReality.CopyWithJson(FEmbedding, TContentEmbedding, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
