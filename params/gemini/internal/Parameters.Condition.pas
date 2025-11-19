unit Parameters.Condition;

interface

uses
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement;

type
  TCondition = class(TParameterReality)
  private
    { private declarations }
    FOperation: String;
    FStringValue: String;
    FNumericValue: Double;
  protected
    { protected declarations }
  public
    { public declarations }
    // Operator applied to the given key-value pair to trigger the condition.
    //
    // OPERATOR_UNSPECIFIED = 'OPERATOR_UNSPECIFIED';
    // LESS = 'LESS';
    // LESS_EQUAL = 'LESS_EQUAL';
    // EQUAL = 'EQUAL';
    // GREATER_EQUAL = 'GREATER_EQUAL';
    // GREATER = 'GREATER';
    // NOT_EQUAL = 'NOT_EQUAL';
    // INCLUDES = 'INCLUDES';
    // EXCLUDES = 'EXCLUDES';
    property operation: String read FOperation write FOperation;
    // The string value to filter the metadata on.
    property stringValue: String read FStringValue write FStringValue;
    // The numeric value to filter the metadata on.
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
  Constants.GeminiEnumType;

{ TCondition }

constructor TCondition.Create();
begin
  inherited Create();
  Self.FOperation := GEMINI_CONDITION_OPERATOR_UNSPECIFIED;
  Self.FStringValue := '';
  Self.FNumericValue := 0;
end;

destructor TCondition.Destroy();
begin
  Self.FNumericValue := 0;
  Self.FStringValue := '';
  Self.FOperation := '';
  inherited Destroy();
end;

end.
