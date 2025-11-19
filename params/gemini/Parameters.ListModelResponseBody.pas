unit Parameters.ListModelResponseBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Model;

type
{
  https://ai.google.dev/api/models#response-body_1
  来自 ListModel 的响应，包含分页的 Model 列表。
}
  TListModelResponseBody = class(TParameterReality)
  private
    { private declarations }
    FModels: TArray<TModel>;
    FNextPageToken: String;
    procedure SetModels(const Value: TArray<TModel>);
    procedure SetNextPageToken(const Value: String);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 返回的模型。
    property models: TArray<TModel> read FModels write SetModels;
    // 可作为 pageToken 发送并用于检索下一页的令牌。如果省略此字段，则没有更多页面。
    property nextPageToken: String read FNextPageToken write SetNextPageToken;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    function ExtractModel(const nIndex: Integer): TModel; inline;
    function ExtractModels(): TArray<TModel>; inline;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TListModelResponseBody }

constructor TListModelResponseBody.Create();
begin
  inherited Create();
  SetLength(Self.FModels, 0);
  Self.FNextPageToken := '';
end;

destructor TListModelResponseBody.Destroy();
begin
  Self.FNextPageToken := '';
  TParameterReality.ReleaseArray<TModel>(Self.FModels);
  inherited Destroy();
end;

function TListModelResponseBody.ExtractModel(const nIndex: Integer): TModel;
var
  nLength: Integer;
begin
  Result := nil;
  if (nIndex < Low(Self.FModels)) or (nIndex > High(Self.FModels)) then
    Exit;

  nLength := Length(Self.FModels);
  Result := Self.FModels[nIndex];
  Self.FModels[nIndex] := nil;
  Dec(nLength);
  if (nIndex < nLength) then
    Move(Self.FModels[nIndex + 1], Self.FModels[nIndex], (nLength - nIndex) * SizeOf(TModel));
  SetLength(Self.FModels, nLength);
end;

function TListModelResponseBody.ExtractModels(): TArray<TModel>;
begin
  Result := Self.FModels;
  Self.FModels := [];
end;

function TListModelResponseBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TListModelResponseBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'models') then
  begin
    TParameterReality.CopyArrayWithJson<TModel>(FModels, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TListModelResponseBody.SetModels(const Value: TArray<TModel>);
begin
  TParameterReality.CopyArrayWithClass<TModel>(FModels, Value);
end;

procedure TListModelResponseBody.SetNextPageToken(const Value: String);
begin
  FNextPageToken := Value;
end;

end.