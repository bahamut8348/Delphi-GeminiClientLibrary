unit Parameters.CountTextTokensRequestBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.TextPrompt;

type
{
  https://ai.google.dev/api/palm#request-body_1
  models.countTextTokens 的请求正文
}
  TCountTextTokensRequestBody = class(TParameterReality)
  private
    FPrompt: TTextPrompt;
    procedure SetPrompt(const Value: TTextPrompt);
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。以提示形式提供给模型的自由格式输入文本。
    property prompt: TTextPrompt read FPrompt write SetPrompt;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const pTextPrompt: TTextPrompt): TCountTextTokensRequestBody; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TCountTextTokensRequestBody }

constructor TCountTextTokensRequestBody.Create();
begin
  inherited Create();
  Self.FPrompt := nil;
end;

class function TCountTextTokensRequestBody.CreateWith(
  const pTextPrompt: TTextPrompt): TCountTextTokensRequestBody;
begin
  Result := TCountTextTokensRequestBody.Create();
  Result.prompt := pTextPrompt;
end;

destructor TCountTextTokensRequestBody.Destroy();
begin
  SafeFreeAndNil(Self.FPrompt);
  inherited Destroy();
end;

function TCountTextTokensRequestBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TCountTextTokensRequestBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'prompt') then
  begin
    TParameterReality.CopyWithJson(Self.FPrompt, TTextPrompt, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TCountTextTokensRequestBody.SetPrompt(const Value: TTextPrompt);
begin
  TParameterReality.CopyWithClass(FPrompt, Value);
end;

end.
