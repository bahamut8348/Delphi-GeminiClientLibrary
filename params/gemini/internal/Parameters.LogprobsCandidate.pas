unit Parameters.LogprobsCandidate;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  //https://ai.google.dev/api/generate-content#Candidate
  logprobs 令牌和得分的候选对象。
}
  TLogprobsCandidate = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 候选人的令牌字符串值。
    token: String;
    // 候选人的令牌 ID 值。
    tokenId: Integer;
    // 候选词元的对数概率。
	  logProbability: Double;

    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TLogprobsCandidate }

constructor TLogprobsCandidate.Create();
begin
  inherited Create();
  Self.token := '';
  Self.tokenId := 0;
  Self.logProbability := 0;
end;

destructor TLogprobsCandidate.Destroy();
begin
  Self.logProbability := 0;
  Self.tokenId := 0;
  Self.token := '';
  inherited Destroy();
end;

end.
