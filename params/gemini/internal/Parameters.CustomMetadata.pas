unit Parameters.CustomMetadata;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.StringList;

type
  TCustomMetadata = class(TParameterReality)
  private
    { private declarations }
    FKey: String;
    FStringValue: String;
    FStringListValue: TStringList;
    FNumericValue: Double;
    procedure SetStringListValue(const Value: TStringList);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // The key of the metadata to store.
    property key: String read FKey write FKey;
    // The string value of the metadata to store.
    property stringValue: String read FStringValue write FStringValue;
    // The StringList value of the metadata to store.
    property stringListValue: TStringList read FStringListValue write SetStringListValue;
    // The numeric value of the metadata to store.
    property numericValue: Double read FNumericValue write FNumericValue;
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

{ TCustomMetadata }

constructor TCustomMetadata.Create();
begin
  inherited Create();
  Self.FKey := '';
  Self.FStringValue := '';
  Self.FStringListValue := nil;
  Self.FNumericValue := 0;
end;

destructor TCustomMetadata.Destroy();
begin
  Self.FNumericValue := 0;
  SafeFreeAndNil(Self.FStringListValue);
  Self.FStringValue := '';
  Self.FKey := '';
  inherited Destroy();
end;

function TCustomMetadata.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TCustomMetadata.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'stringListValue') then
  begin
    TParameterReality.CopyWithJson(Self.FStringListValue, TStringList, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TCustomMetadata.SetStringListValue(const Value: TStringList);
begin
  TParameterReality.CopyWithClass(Self.FStringListValue, Value);
end;

end.

