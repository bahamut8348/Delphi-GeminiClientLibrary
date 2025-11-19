unit Parameters.GoogleSearch;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Interval;

type
{
  https://ai.google.dev/api/caching#GoogleSearch
  GoogleSearch 工具类型。支持在模型中使用 Google 搜索的工具。由 Google 提供支持。
}
  TGoogleSearch = class(TParameterReality)
  private
    { private declarations }
    FTimeRangeFilter: TInterval;
    procedure SetTimeRangeFilter(const Value: TInterval);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。将搜索结果过滤为特定时间范围。如果客户设置了开始时间，则必须设置结束时间（反之亦然）。
    property timeRangeFilter: TInterval read FTimeRangeFilter write SetTimeRangeFilter;

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

{ TGoogleSearch }

constructor TGoogleSearch.Create();
begin
  inherited Create();
  Self.FTimeRangeFilter := nil;
end;

destructor TGoogleSearch.Destroy();
begin
  SafeFreeAndNil(Self.FTimeRangeFilter);
  inherited Destroy();
end;

function TGoogleSearch.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TGoogleSearch.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'timeRangeFilter') then
  begin
    TParameterReality.CopyWithJson(FTimeRangeFilter, TInterval, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TGoogleSearch.SetTimeRangeFilter(const Value: TInterval);
begin
  if (Value <> FTimeRangeFilter) then
    TParameterReality.CopyWithClass(FTimeRangeFilter, Value);
end;

end.
