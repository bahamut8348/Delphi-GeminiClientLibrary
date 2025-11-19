unit Parameters.CitationMetadata;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.CitationSource;

type
{
  https://ai.google.dev/api/generate-content#citationmetadata
  一段内容的一组来源提供方信息。
}
  TCitationMetadata = class(TParameterReality)
  private
    { private declarations }
    FCitationSources: TArray<TCitationSource>;
    procedure SetCitationSources(const Value: TArray<TCitationSource>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 特定回答的来源引用。
    property citationSources: TArray<TCitationSource> read FCitationSources write SetCitationSources;
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

{ TCitationMetadata }

constructor TCitationMetadata.Create();
begin
  inherited Create();
  SetLength(Self.FCitationSources, 0);
end;

destructor TCitationMetadata.Destroy();
begin
  TParameterReality.ReleaseArray<TCitationSource>(Self.FCitationSources);
  inherited Destroy();
end;

function TCitationMetadata.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TCitationMetadata.SetCitationSources(
  const Value: TArray<TCitationSource>);
begin
  TParameterReality.CopyArrayWithClass<TCitationSource>(FCitationSources, Value);
end;

function TCitationMetadata.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'citationSources') then
  begin
    TParameterReality.CopyArrayWithJson<TCitationSource>(Self.FCitationSources, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
