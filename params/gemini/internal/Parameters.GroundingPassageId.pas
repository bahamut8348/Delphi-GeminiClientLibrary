unit Parameters.GroundingPassageId;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#GroundingPassageId
  GroundingPassage 中某个部分的标识符。
}
  TGroundingPassageId = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 仅限输出。与 GenerateAnswerRequest 的 GroundingPassage.id 匹配的段落的 ID。
    passageId: String;
    // 仅限输出。GenerateAnswerRequest 的 GroundingPassage.content 中相应部分的索引。
    partIndex: Integer;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;


implementation

{ TGroundingPassageId }

constructor TGroundingPassageId.Create();
begin
  inherited Create();
  Self.passageId := '';
  Self.partIndex := 0;
end;

destructor TGroundingPassageId.Destroy();
begin
  Self.partIndex := 0;
  Self.passageId := '';
  inherited Destroy();
end;

end.
