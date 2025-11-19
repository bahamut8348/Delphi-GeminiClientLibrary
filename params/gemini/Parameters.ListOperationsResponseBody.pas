unit Parameters.ListOperationsResponseBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Operation;

type
{
  https://ai.google.dev/api/batch-api#response-body_3
  来自 ListOperationsResponse 的响应，包含分页的 Operation 列表。
}
  TListOperationsResponseBody = class(TParameterReality)
  private
    { private declarations }
    FUnreachableNeedFree: Boolean;

    FOperations: TArray<TOperation>;
    FNextPageToken: String;
    FUnreachable: TObject;
    procedure SetNextPageToken(const Value: String);
    procedure SetOperations(const Value: TArray<TOperation>);
    procedure SetUnreachable(const Value: TObject);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 返回的 Operation 列表
    property operations: TArray<TOperation> read FOperations write SetOperations;
    // 可作为 pageToken 发送并用于检索下一页的令牌。如果省略此字段，则没有更多页面。
    property nextPageToken: String read FNextPageToken write SetNextPageToken;
    // ??
    property unreachable: TObject read FUnreachable write SetUnreachable;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    function ExtractOperation(const nIndex: Integer): TOperation; inline;
    function ExtractOperations(): TArray<TOperation>; inline;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TListOperationsResponseBody }

constructor TListOperationsResponseBody.Create();
begin
  inherited Create();
  Self.FUnreachableNeedFree := FALSE;
  SetLength(Self.FOperations, 0);
  Self.FNextPageToken := '';
  Self.FUnreachable := nil;
end;

destructor TListOperationsResponseBody.Destroy();
begin
  if (Self.FUnreachableNeedFree) then
    SafeFreeAndNil(FUnreachable);
  TParameterReality.ReleaseArray<TOperation>(Self.FOperations);
  Self.FNextPageToken := '';
  SetLength(Self.FOperations, 0);
  Self.FUnreachableNeedFree := FALSE;
  inherited Destroy();
end;

function TListOperationsResponseBody.ExtractOperation(
  const nIndex: Integer): TOperation;
var
  nLength: Integer;
begin
  Result := nil;
  if (nIndex < Low(Self.FOperations)) or (nIndex > High(Self.FOperations)) then
    Exit;

  nLength := Length(Self.FOperations);
  Result := Self.FOperations[nIndex];
  Self.FOperations[nIndex] := nil;
  Dec(nLength);
  if (nIndex < nLength) then
    Move(Self.FOperations[nIndex + 1], Self.FOperations[nIndex], (nLength - nIndex) * SizeOf(TOperation));
  SetLength(Self.FOperations, nLength);
end;

function TListOperationsResponseBody.ExtractOperations(): TArray<TOperation>;
begin
  Result := Self.FOperations;
  Self.FOperations := [];
end;

function TListOperationsResponseBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TListOperationsResponseBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'operations') then
  begin
    TParameterReality.CopyArrayWithJson<TOperation>(Self.FOperations, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'unreachable') then
  begin
    TParameterReality.CloneWithJson(Self.FUnreachable, Self.FUnreachableNeedFree, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TListOperationsResponseBody.SetNextPageToken(const Value: String);
begin
  FNextPageToken := Value;
end;

procedure TListOperationsResponseBody.SetOperations(
  const Value: TArray<TOperation>);
begin
  TParameterReality.CopyArrayWithClass<TOperation>(FOperations, Value);
end;

procedure TListOperationsResponseBody.SetUnreachable(const Value: TObject);
begin
  if (Value <> FUnreachable) then
    TParameterReality.CloneWithClass(FUnreachable, FUnreachableNeedFree, Value);
end;

end.