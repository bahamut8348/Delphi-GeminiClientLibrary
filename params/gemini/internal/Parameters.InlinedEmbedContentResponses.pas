unit Parameters.InlinedEmbedContentResponses;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.InlinedEmbedContentResponse;

type
{
  https://ai.google.dev/api/embeddings#InlinedEmbedContentResponses
  对批处理请求的响应。
}
  TInlinedEmbedContentResponses = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 仅限输出。对批处理请求的响应。
    inlinedResponses: array of TInlinedEmbedContentResponse;
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

{ TInlinedEmbedContentResponses }

constructor TInlinedEmbedContentResponses.Create();
begin
  inherited Create();
  SetLength(Self.inlinedResponses, 0);
end;

destructor TInlinedEmbedContentResponses.Destroy();
var
  nIndex: Integer;
begin
  for nIndex := High(Self.inlinedResponses) downto Low(Self.inlinedResponses) do
    SafeFreeAndNil(Self.inlinedResponses[nIndex]);
  SetLength(Self.inlinedResponses, 0);
  inherited Destroy();
end;

function TInlinedEmbedContentResponses.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TInlinedEmbedContentResponses.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
var
  nIndex: Integer;
begin
  if SameText(sName, 'inlinedResponses') then
  begin
    for nIndex := High(Self.inlinedResponses) downto Low(Self.inlinedResponses) do
      SafeFreeAndNil(Self.inlinedResponses[nIndex]);

    if (pValue is TJSONArray) then
    begin
      SetLength(Self.inlinedResponses, (pValue as TJSONArray).Count);
      for nIndex := Low(Self.inlinedResponses) to High(Self.inlinedResponses) do
      begin
        Self.inlinedResponses[nIndex] := TInlinedEmbedContentResponse.Create();
        Self.inlinedResponses[nIndex].Parse((pValue as TJSONArray).Items[nIndex]);
      end;
    end
    else if (nil <> pValue) then
    begin
      SetLength(Self.inlinedResponses, 1);
      Self.inlinedResponses[0] := TInlinedEmbedContentResponse.Create();
      Self.inlinedResponses[0].Parse(pValue);
    end
    else
      SetLength(Self.inlinedResponses, 0);

    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
