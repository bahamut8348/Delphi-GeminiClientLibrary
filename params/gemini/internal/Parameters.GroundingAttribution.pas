unit Parameters.GroundingAttribution;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement,
  Parameters.AttributionSourceId, Parameters.Content;

type
{
  https://ai.google.dev/api/generate-content#GroundingAttribution
  对促成回答的来源的提供方信息。
}
  TGroundingAttribution = class(TParameterReality)
  private
    { private declarations }
    FSourceId: TAttributionSourceId;
    FContent: TContent;

    procedure SetContent(const Value: TContent);
    procedure SetSourceId(const Value: TAttributionSourceId);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 仅限输出。促成相应归因的来源的标识符。
    property sourceId: TAttributionSourceId read FSourceId write SetSourceId;
    // 构成此提供方信息的接地源内容。
    property content: TContent read FContent write SetContent;

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

{ TGroundingAttribution }

constructor TGroundingAttribution.Create();
begin
  inherited Create();
  Self.FSourceId := nil;
  Self.FContent := nil;
end;

destructor TGroundingAttribution.Destroy();
begin
  SafeFreeAndNil(Self.FContent);
  SafeFreeAndNil(Self.FSourceId);
  inherited Destroy();
end;

function TGroundingAttribution.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TGroundingAttribution.SetContent(const Value: TContent);
begin
  if (Value <> FContent) then
    TParameterReality.CopyWithClass(FContent, Value);
end;

function TGroundingAttribution.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'sourceId') then
  begin
    TParameterReality.CopyWithJson(FSourceId, TAttributionSourceId, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'content') then
  begin
    TParameterReality.CopyWithJson(FContent, TContent, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TGroundingAttribution.SetSourceId(const Value: TAttributionSourceId);
begin
  if (Value <> FSourceId) then
    TParameterReality.CopyWithClass(FSourceId, Value);
end;

end.
