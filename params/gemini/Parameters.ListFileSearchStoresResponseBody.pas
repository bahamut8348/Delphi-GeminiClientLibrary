unit Parameters.ListFileSearchStoresResponseBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.FileSearchStore;

type
{
  https://ai.google.dev/api/file-search/file-search-stores#response-body_4
  来自 fileSearchStores.list 的响应，包含分页的 FileSearchStores 列表。结果按 fileSearchStore.create_time 升序排序。
}
  TListFileSearchStoresResponseBody = class(TParameterReality)
  private
    { private declarations }
    FFileSearchStores: TArray<TFileSearchStore>;
    FNextPageToken: String;
    procedure SetFileSearchStores(const Value: TArray<TFileSearchStore>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 返回的 ragStores。
    property fileSearchStores: TArray<TFileSearchStore> read FFileSearchStores write SetFileSearchStores;
    // 可作为 pageToken 发送并用于检索下一页的令牌。如果省略此字段，则没有更多页面。
    property nextPageToken: String read FNextPageToken write FNextPageToken;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    function ExtractFileSearchStore(const nIndex: Integer): TFileSearchStore; inline;
    function ExtractFileSearchStores(): TArray<TFileSearchStore>; inline;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TListFileSearchStoresResponseBody }

constructor TListFileSearchStoresResponseBody.Create();
begin
  inherited Create();
  SetLength(Self.FFileSearchStores, 0);
  Self.FNextPageToken := '';
end;

destructor TListFileSearchStoresResponseBody.Destroy();
begin
  Self.FNextPageToken := '';
  TParameterReality.ReleaseArray<TFileSearchStore>(Self.FFileSearchStores);
  inherited Destroy();
end;

function TListFileSearchStoresResponseBody.ExtractFileSearchStore(
  const nIndex: Integer): TFileSearchStore;
var
  nLength: Integer;
begin
  Result := nil;
  if (nIndex < Low(Self.FFileSearchStores)) or (nIndex > High(Self.FFileSearchStores)) then
    Exit;

  nLength := Length(Self.FFileSearchStores);
  Result := Self.FFileSearchStores[nIndex];
  Self.FFileSearchStores[nIndex] := nil;
  Dec(nLength);
  if (nIndex < nLength) then
    Move(Self.FFileSearchStores[nIndex + 1], Self.FFileSearchStores[nIndex], (nLength - nIndex) * SizeOf(TFileSearchStore));
  SetLength(Self.FFileSearchStores, nLength);
end;

function TListFileSearchStoresResponseBody.ExtractFileSearchStores(): TArray<TFileSearchStore>;
begin
  Result := Self.FFileSearchStores;
  Self.FFileSearchStores := [];
end;

function TListFileSearchStoresResponseBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TListFileSearchStoresResponseBody.SetFileSearchStores(
  const Value: TArray<TFileSearchStore>);
begin
  TParameterReality.CopyArrayWithClass<TFileSearchStore>(FFileSearchStores, Value);
end;

function TListFileSearchStoresResponseBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'fileSearchStores') then
  begin
    TParameterReality.CopyArrayWithJson<TFileSearchStore>(FFileSearchStores, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
