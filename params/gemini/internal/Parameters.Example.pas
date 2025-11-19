unit Parameters.Example;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Message;

type
{
  https://ai.google.dev/api/palm#Example
  用于指示模型的输入/输出示例。
  它展示了模型应如何回答或设置回答的格式。
}
  TExample = class(TParameterReality)
  private
    FInput: TMessage;
    FOutput: TMessage;
    procedure SetInput(const Value: TMessage);
    procedure SetOutput(const Value: TMessage);
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。用户输入 Message 的示例。
    property input: TMessage read FInput write SetInput;
    // 必需。模型在获得输入后应输出的内容示例。
    property output: TMessage read FOutput write SetOutput;
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

{ TExample }

constructor TExample.Create();
begin
  inherited Create();
  Self.FInput := nil;
  Self.FOutput := nil;
end;

destructor TExample.Destroy();
begin
  SafeFreeAndNil(Self.FOutput);
  SafeFreeAndNil(Self.FInput);
  inherited Destroy();
end;

function TExample.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TExample.SetInput(const Value: TMessage);
begin
  TParameterReality.CopyWithClass(FInput, Value);
end;

function TExample.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'input') then
  begin
    TParameterReality.CopyWithJson(Self.FInput, TMessage, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'output') then
  begin
    TParameterReality.CopyWithJson(Self.FOutput, TMessage, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TExample.SetOutput(const Value: TMessage);
begin
  TParameterReality.CopyWithClass(FOutput, Value);
end;

end.
