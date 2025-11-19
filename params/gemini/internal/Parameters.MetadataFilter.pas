unit Parameters.MetadataFilter;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.Condition;

type
  TMetadataFilter = class(TParameterReality)
  private
    { private declarations }
    FKey: String;
    FConditions: TArray<TCondition>;
    procedure SetConditions(const Value: TArray<TCondition>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // The key of the metadata to filter on.
    property key: String read FKey write FKey;
    property conditions: TArray<TCondition> read FConditions write SetConditions;
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

{ TMetadataFilter }

constructor TMetadataFilter.Create();
begin
  inherited Create();
  Self.FKey := '';
  SetLength(Self.FConditions, 0);
end;

destructor TMetadataFilter.Destroy();
begin
  TParameterReality.ReleaseArray<TCondition>(Self.FConditions);
  Self.FKey := '';
  inherited Destroy();
end;

function TMetadataFilter.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TMetadataFilter.SetConditions(const Value: TArray<TCondition>);
begin
  TParameterReality.CopyArrayWithClass<TCondition>(FConditions, Value);
end;

function TMetadataFilter.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'conditions') then
  begin
    TParameterReality.CopyArrayWithJson<TCondition>(Self.FConditions, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.

