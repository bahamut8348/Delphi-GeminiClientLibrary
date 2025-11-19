unit Parameters.ContentEmbedding;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/embeddings#contentembedding
  表示嵌入的浮点数列表。
}
  TContentEmbedding = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 嵌入值。
    values: array of Double;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TContentEmbedding }

constructor TContentEmbedding.Create();
begin
  inherited Create();
  SetLength(Self.values, 0);
end;

destructor TContentEmbedding.Destroy();
begin
  SetLength(Self.values, 0);
  inherited Destroy();
end;

function TContentEmbedding.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TContentEmbedding.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
var
  nIndex: Integer;
begin
  if SameText(sName, 'values') then
  begin
    if (pValue is TJSONArray) then
    begin
      SetLength(Self.values, (pValue as TJSONArray).Count);
      for nIndex := Low(Self.values) to High(Self.values) do
      begin
        Self.values[nIndex] := StrToFloat((pValue as TJSONArray).Items[nIndex].Value);
      end;
    end
    else if (nil <> pValue) then
    begin
      SetLength(Self.values, 1);
      Self.values[0] := StrToFloat(pValue.Value);
    end
    else
      SetLength(Self.values, 0);

    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
