unit Parameters.StringList;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/semantic-retrieval/documents#stringlist
}
  TStringList = class(TParameterReality)
  private
    { private declarations }
    FValues: TArray<String>;
    procedure SetValues(const Value: TArray<String>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // The string values of the metadata to store.
    property values: TArray<String> read FValues write SetValues;
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

{ TStringList }

constructor TStringList.Create();
begin
  inherited Create();
  SetLength(Self.FValues, 0);
end;

destructor TStringList.Destroy();
begin
  ReleaseStringArray(Self.FValues);
  inherited Destroy();
end;

function TStringList.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TStringList.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'values') then
  begin
    CopyStringArrayWithJson(Self.FValues, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TStringList.SetValues(const Value: TArray<String>);
begin
  CopyStringArrayWithArray(Self.FValues, Value);
end;

end.
