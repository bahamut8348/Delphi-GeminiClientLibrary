unit Parameters.PredictResponseBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/models#response-body_2
  [PredictionService.Predict] 的响应消息。
}
  TPredictResponseBody = class(TParameterReality)
  private
    { private declarations }
    FPredictionsNeedFree: Boolean;
    FPredictions: TArray<TObject>;
    procedure SetPredictions(const Value: TArray<TObject>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 预测调用的输出。
    property predictions: TArray<TObject> read FPredictions write SetPredictions;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    function ExtractPrediction(const nIndex: Integer): TObject; inline;
    function ExtractPredictions(): TArray<TObject>; inline;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TPredictResponseBody }

constructor TPredictResponseBody.Create();
begin
  inherited Create();
  FPredictionsNeedFree := FALSE;
  SetLength(Self.FPredictions, 0);
end;

destructor TPredictResponseBody.Destroy();
begin
  TParameterReality.ReleaseArray<TObject>(Self.FPredictions, Self.FPredictionsNeedFree);
  SetLength(Self.FPredictions, 0);
  Self.FPredictionsNeedFree := FALSE;
  inherited Destroy();
end;

function TPredictResponseBody.ExtractPrediction(const nIndex: Integer): TObject;
var
  nLength: Integer;
begin
  Result := nil;
  if (nIndex < Low(FPredictions)) or (nIndex > High(FPredictions)) then
    Exit;

  nLength := Length(FPredictions);
  Result := FPredictions[nIndex];
  FPredictions[nIndex] := nil;
  Dec(nLength);
  if (nIndex < nLength) then
    Move(FPredictions[nIndex + 1], FPredictions[nIndex], (nLength - nIndex) * SizeOf(TObject));
  SetLength(FPredictions, nLength);
end;

function TPredictResponseBody.ExtractPredictions(): TArray<TObject>;
begin
  Result := FPredictions;
  FPredictions := [];
  FPredictionsNeedFree := FALSE;
end;

function TPredictResponseBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TPredictResponseBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'predictions') then
  begin
    TParameterReality.CloneArrayWithJson(FPredictions, FPredictionsNeedFree, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TPredictResponseBody.SetPredictions(const Value: TArray<TObject>);
begin
  TParameterReality.CloneArrayWithClass(FPredictions, FPredictionsNeedFree, Value);
end;

end.