unit Parameters.UrlContextMetadata;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.UrlMetadata;

type
{
  https://ai.google.dev/api/generate-content#UrlContextMetadata
  与网址上下文检索工具相关的元数据。
}
  TUrlContextMetadata = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 网址上下文列表。
    urlMetadata: array of TUrlMetadata;
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

{ TUrlContextMetadata }

constructor TUrlContextMetadata.Create();
begin
  inherited Create();
  SetLength(Self.urlMetadata, 0);
end;

destructor TUrlContextMetadata.Destroy();
var
  nIndex: Integer;
begin
  for nIndex := High(Self.urlMetadata) downto Low(Self.urlMetadata) do
    SafeFreeAndNil(Self.urlMetadata[nIndex]);
  SetLength(Self.urlMetadata, 0);
  inherited Destroy();
end;

function TUrlContextMetadata.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TUrlContextMetadata.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
var
  nIndex: Integer;
begin
  if SameText(sName, 'urlMetadata') then
  begin
    for nIndex := High(Self.urlMetadata) downto Low(Self.urlMetadata) do
      SafeFreeAndNil(Self.urlMetadata[nIndex]);

    if (pValue is TJSONArray) then
    begin
      SetLength(Self.urlMetadata, (pValue as TJSONArray).Count);
      for nIndex := Low(Self.urlMetadata) to High(Self.urlMetadata) do
      begin
        Self.urlMetadata[nIndex] := TUrlMetadata.Create();
        Self.urlMetadata[nIndex].Parse((pValue as TJSONArray).Items[nIndex]);
      end;
    end
    else if (nil <> pValue) then
    begin
      SetLength(Self.urlMetadata, 1);
      Self.urlMetadata[0] := TUrlMetadata.Create();
      Self.urlMetadata[0].Parse(pValue);
    end
    else
      SetLength(Self.urlMetadata, 0);

    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
