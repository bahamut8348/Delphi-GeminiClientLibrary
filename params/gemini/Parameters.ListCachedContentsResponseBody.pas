unit Parameters.ListCachedContentsResponseBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.CachedContent;

type
{
  https://ai.google.dev/api/caching#response-body_1
  包含 CachedContents 列表的响应。
}
  TListCachedContentsResponseBody = class(TParameterReality)
  private
    { private declarations }
    FCachedContents: TArray<TCachedContent>;
    FNextPageToken: String;
    procedure SetCachedContents(const Value: TArray<TCachedContent>);
    procedure SetNextPageToken(const Value: String);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 缓存内容列表。
    property cachedContents: TArray<TCachedContent> read FCachedContents write SetCachedContents;
    // 可作为 pageToken 发送并用于检索下一页的令牌。如果省略此字段，则不存在后续页面。
    property nextPageToken: String read FNextPageToken write SetNextPageToken;

    constructor Create(); override;
    destructor Destroy(); override;

    function ExtractCachedContent(const nIndex: Integer): TCachedContent; inline;
    function ExtractCachedContents(): TArray<TCachedContent>; inline;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TListCachedContentsResponseBody }

constructor TListCachedContentsResponseBody.Create();
begin
  inherited Create();
  SetLength(Self.FCachedContents, 0);
  Self.FNextPageToken := '';
end;

destructor TListCachedContentsResponseBody.Destroy();
begin
  Self.FNextPageToken := '';
  TParameterReality.ReleaseArray<TCachedContent>(Self.FCachedContents);
  inherited Destroy();
end;

function TListCachedContentsResponseBody.ExtractCachedContent(
  const nIndex: Integer): TCachedContent;
var
  nLength: Integer;
begin
  Result := nil;
  if (nIndex < Low(Self.FCachedContents)) or (nIndex > High(Self.FCachedContents)) then
    Exit;

  nLength := Length(Self.FCachedContents);
  Result := Self.FCachedContents[nIndex];
  Self.FCachedContents[nIndex] := nil;
  Dec(nLength);
  if (nIndex < nLength) then
    Move(Self.FCachedContents[nIndex + 1], Self.FCachedContents[nIndex], (nLength - nIndex) * SizeOf(TCachedContent));
  SetLength(Self.FCachedContents, nLength);
end;

function TListCachedContentsResponseBody.ExtractCachedContents(): TArray<TCachedContent>;
begin
  Result := Self.FCachedContents;
  Self.FCachedContents := [];
end;

function TListCachedContentsResponseBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TListCachedContentsResponseBody.SetCachedContents(
  const Value: TArray<TCachedContent>);
begin
  TParameterReality.CopyArrayWithClass<TCachedContent>(FCachedContents, Value);
end;

function TListCachedContentsResponseBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'cachedContents') then
  begin
    TParameterReality.CopyArrayWithJson<TCachedContent>(FCachedContents, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TListCachedContentsResponseBody.SetNextPageToken(const Value: String);
begin
  FNextPageToken := Value;
end;

end.