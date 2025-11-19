unit Parameters.ListFileResponseBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.FileInfo;

type
{
  https://ai.google.dev/api/files#response-body_2
  对 files.list 的响应。
}
  TListFileResponseBody = class(TParameterReality)
  private
    { private declarations }
    // File 的列表。
    FFiles: TArray<TFile>;
    // 可作为 pageToken 发送到后续 files.list 调用中的令牌。
    FNextPageToken: String;
    procedure SetFiles(const Value: TArray<TFile>);
    procedure SetNextPageToken(const Value: String);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // File 的列表。
    property files: TArray<TFile> read FFiles write SetFiles;
    // 可作为 pageToken 发送到后续 files.list 调用中的令牌。
    property nextPageToken: String read FNextPageToken write SetNextPageToken;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    function ExtractFile(const nIndex: Integer): TFile; inline;
    function ExtractFiles(): TArray<TFile>; inline;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TListFileResponseBody }

constructor TListFileResponseBody.Create();
begin
  inherited Create();
  SetLength(Self.FFiles, 0);
  Self.FNextPageToken := '';
end;

destructor TListFileResponseBody.Destroy();
begin
  Self.FNextPageToken := '';
  TParameterReality.ReleaseArray<TFile>(Self.FFiles);
  inherited Destroy();
end;

function TListFileResponseBody.ExtractFile(const nIndex: Integer): TFile;
var
  nLength: Integer;
begin
  Result := nil;
  if (nIndex < Low(Self.FFiles)) or (nIndex > High(Self.FFiles)) then
    Exit;

  nLength := Length(Self.FFiles);
  Result := Self.FFiles[nIndex];
  Self.FFiles[nIndex] := nil;
  Dec(nLength);
  if (nIndex < nLength) then
    Move(Self.FFiles[nIndex + 1], Self.FFiles[nIndex], (nLength - nIndex) * SizeOf(TFile));
  SetLength(Self.FFiles, nLength);
end;

function TListFileResponseBody.ExtractFiles(): TArray<TFile>;
begin
  Result := Self.FFiles;
  Self.FFiles := [];
end;

function TListFileResponseBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TListFileResponseBody.SetFiles(const Value: TArray<TFile>);
begin
  TParameterReality.CopyArrayWithClass<TFile>(FFiles, Value);
end;

function TListFileResponseBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'files') then
  begin
    TParameterReality.CopyArrayWithJson<TFile>(FFiles, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TListFileResponseBody.SetNextPageToken(const Value: String);
begin
  FNextPageToken := Value;
end;

end.