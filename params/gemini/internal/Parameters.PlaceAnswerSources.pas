unit Parameters.PlaceAnswerSources;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.ReviewSnippet;

type
{
  https://ai.google.dev/api/generate-content#PlaceAnswerSources
  提供有关 Google 地图中特定地点的特征的答案的来源集合。每个 PlaceAnswerSources 消息都对应 Google 地图中的特定地点。Google 地图工具使用这些来源来回答有关地点特征的问题（例如：“Bar Foo 是否提供 Wi-Fi”或“Foo Bar 是否适合轮椅使用者？”）。目前，我们仅支持将评价摘要作为来源。
}
  TPlaceAnswerSources = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 用于生成有关 Google 地图中指定地点的特征的回答的评价摘要。
    reviewSnippets: array of TReviewSnippet;
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

{ TPlaceAnswerSources }

constructor TPlaceAnswerSources.Create();
begin
  inherited Create();
  SetLength(Self.reviewSnippets, 0);
end;

destructor TPlaceAnswerSources.Destroy();
var
  nIndex: Integer;
begin
  for nIndex := High(Self.reviewSnippets) downto Low(Self.reviewSnippets) do
    SafeFreeAndNil(Self.reviewSnippets[nIndex]);
  SetLength(Self.reviewSnippets, 0);
  inherited Destroy();
end;

function TPlaceAnswerSources.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TPlaceAnswerSources.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
var
  nIndex: Integer;
begin
  if SameText(sName, 'reviewSnippets') then
  begin
    for nIndex := High(Self.reviewSnippets) downto Low(Self.reviewSnippets) do
      SafeFreeAndNil(Self.reviewSnippets[nIndex]);

    if (pValue is TJSONArray) then
    begin
      SetLength(Self.reviewSnippets, (pValue as TJSONArray).Count);
      for nIndex := Low(Self.reviewSnippets) to High(Self.reviewSnippets) do
      begin
        Self.reviewSnippets[nIndex] := TReviewSnippet.Create();
        Self.reviewSnippets[nIndex].Parse((pValue as TJSONArray).Items[nIndex]);
      end;
    end
    else if (nil <> pValue) then
    begin
      SetLength(Self.reviewSnippets, 1);
      Self.reviewSnippets[0] := TReviewSnippet.Create();
      Self.reviewSnippets[0].Parse(pValue);
    end
    else
      SetLength(Self.reviewSnippets, 0);

    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
