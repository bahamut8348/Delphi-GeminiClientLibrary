unit Parameters.CountMessageTokensRequestBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.MessagePrompt;

type
{
  https://ai.google.dev/api/palm#request-body_3
  countMessageTokens ÇëÇóÕýÎÄ
}
  TCountMessageTokensRequestBody = class(TParameterReality)
  private
    FPrompt: TMessagePrompt;
    procedure SetPrompt(const Value: TMessagePrompt);
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    property prompt: TMessagePrompt read FPrompt write SetPrompt;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const pPrompt: TMessagePrompt): TCountMessageTokensRequestBody; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TCountMessageTokensRequestBody }

constructor TCountMessageTokensRequestBody.Create();
begin
  inherited Create();
  Self.FPrompt := nil;
end;

class function TCountMessageTokensRequestBody.CreateWith(
  const pPrompt: TMessagePrompt): TCountMessageTokensRequestBody;
begin
  Result := TCountMessageTokensRequestBody.Create();
  Result.prompt := pPrompt;
end;

destructor TCountMessageTokensRequestBody.Destroy();
begin
  SafeFreeAndNil(Self.FPrompt);
  inherited Destroy();
end;

function TCountMessageTokensRequestBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TCountMessageTokensRequestBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'prompt') then
  begin
    TParameterReality.CopyWithJson(Self.FPrompt, TMessagePrompt, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TCountMessageTokensRequestBody.SetPrompt(const Value: TMessagePrompt);
begin
  TParameterReality.CopyWithClass(FPrompt, Value);
end;

end.