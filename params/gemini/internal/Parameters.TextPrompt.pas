unit Parameters.TextPrompt;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/palm#textprompt
  作为提示提供给模型的文本。
  模型将使用此 TextPrompt 生成文本补全。
}
  TTextPrompt = class(TParameterReality)
  private
    FText: String;
    procedure SetText(const Value: String);
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 必需。提示文本。
    property text: String read FText write SetText;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TTextPrompt }

constructor TTextPrompt.Create();
begin
  inherited Create();
  FText := '';
end;

destructor TTextPrompt.Destroy();
begin
  FText := '';
  inherited Destroy();
end;

procedure TTextPrompt.SetText(const Value: String);
begin
  FText := Value;
end;

end.

