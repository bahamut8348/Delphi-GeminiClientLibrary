unit Models.FilesModelImplement;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Defaults, System.Generics.Collections,
  System.Rtti, System.JSON, System.TypInfo, System.ObjAuto,
  Models.BasedModelImplement, Models.GeminiBasedModelImplement,
  Parameters.FileInfo, Parameters.FileData, Parameters.ListFileResponseBody,
  Parameters.UploadFilesRequestBody, Parameters.UploadFilesResponseBody;

type
{
  https://ai.google.dev/api/files
}
  TFilesModelReality = class(TGeminiModelReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  public
    { public declarations }
    // https://ai.google.dev/api/files#v1beta.files.delete
    // DELETE /v1beta/{name=files/*}
    // Deletes the File.
    function Delete(const szFileName: String): Boolean;
    // https://ai.google.dev/api/files#v1beta.files.get
    // GET /v1beta/{name=files/*}
    // Gets the metadata for the given File.
    function Get(const szFileName: String): TFile;
    // https://ai.google.dev/api/files#v1beta.files.list
    // GET /v1beta/files
    // Lists the metadata for Files owned by the requesting project.
    function List(const nPageSize: Integer = 0; const szPageToken: String = '';
      const bAutoExpansion: Boolean = TRUE): TArray<TFile>;
    // https://ai.google.dev/api/files#v1beta.media.upload
    // POST /v1beta/files
    // POST /upload/v1beta/files
    // Creates a File.
    function Upload(const szLocaleName, szResourceName, szDisplayName: String): TFile;
  published
    { published declarations }
  end;

implementation

uses
  Constants.HttpStatusCode, Constants.ProtocolType, Constants.RequestMethod,
  Functions.StringsUtils, Functions.SystemExtended;

{ TFilesModelReality }

constructor TFilesModelReality.Create();
begin
  inherited Create();
  Self.SetModelPath('files');
end;

function TFilesModelReality.Delete(const szFileName: String): Boolean;
var
  szRequestAddress: AnsiString;
begin
  Result := FALSE;

  szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
    Self.GetModelRequestAddress(szFileName),
    Self.GetApiKey()])); // GEMINI_API_KEY

  Self.SendRequest(
    REQUESTMETHOD_HTTP_DELETE, // 请求方式
    szRequestAddress); // 请求地址

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TRUE;
  end;

  szRequestAddress := '';
end;

destructor TFilesModelReality.Destroy();
begin
  inherited Destroy();
end;

function TFilesModelReality.Get(const szFileName: String): TFile;
var
  szRequestAddress, szRequestContent: AnsiString;
begin
  Result := nil;

  szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
    Self.GetModelRequestAddress(szFileName),
    Self.GetApiKey()])); // GEMINI_API_KEY

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_GET, // 请求方式
    szRequestAddress // 请求地址
  );

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TFile.Create();
    if not Result.Parse(StringValueS(szRequestContent)) then
    begin
      SafeFreeAndNil(Result);
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
  end;

  szRequestContent := '';
  szRequestAddress := '';
end;

function TFilesModelReality.List(const nPageSize: Integer;
  const szPageToken: String; const bAutoExpansion: Boolean): TArray<TFile>;
var
  szAddress, szRequestAddress, szToken: String;
  szRequestContent: AnsiString;
  pResponseBody: TListFileResponseBody;
begin
  // 拼接请求地址
  if (0 = nPageSize) then
    szAddress := Format('%s?key=%s', [
      Self.GetModelRequestAddress(), // 请求地址
      Self.GetApiKey()]) // GEMINI_API_KEY
  else
    szAddress := Format('%s?key=%s&pageSize=%d', [
      Self.GetModelRequestAddress(), // 请求地址
      Self.GetApiKey(), // GEMINI_API_KEY
      nPageSize]);

  Result := []; //
  pResponseBody := TListFileResponseBody.Create(); // 响应对象
  szToken := Trim(szPageToken); // token
  repeat
    szRequestAddress := Format('%s&pageToken=%s', [szAddress, szToken]);
    szRequestContent := Self.SendRequest(
      REQUESTMETHOD_HTTP_GET, // 请求方式
      AnsiStringValue(szRequestAddress) // 请求地址
    );

    // 请求失败，退出循环
    if (S_OK <> Self.GetLastErrorCode()) then
      Break;

    pResponseBody.nextPageToken := '';
    if not pResponseBody.Parse(StringValueS(szRequestContent)) then
    begin
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
      Break;
    end;

    szToken := pResponseBody.nextPageToken;
    Result := Result + pResponseBody.ExtractFiles();
  until (not bAutoExpansion) or ('' = szToken);

  szToken := '';
  szAddress := '';
  szRequestContent := '';
  szRequestAddress := '';
  SafeFreeAndNil(pResponseBody);
end;

function TFilesModelReality.Upload(const szLocaleName, szResourceName, szDisplayName: String): TFile;
var
  szRequestContent, szRequestAddress: AnsiString;
  pRequestBody: TUploadFilesRequestBody;
  pResponseBody: TUploadFilesResponseBody;
begin
  Result := nil;

  // 请求参数
  pRequestBody := TUploadFilesRequestBody.CreateWith(szResourceName, szDisplayName);

  // 地址
  szRequestAddress := AnsiStringValue(Format('%s?key=%s', [
    Self.GetModelRequestAddress(),
    Self.GetApiKey()])); // GEMINI_API_KEY

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_POST, // 请求方式
    szRequestAddress, // 请求地址
    pRequestBody, // 请求参数
    [], // 请求头
    szLocaleName // 本地文件名
  );

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    pResponseBody := TUploadFilesResponseBody.Create();
    if pResponseBody.Parse(StringValueS(szRequestContent)) then
      Result := pResponseBody.ExtractFile()
    else
    begin
      Self.SetLastErrorCode(S_FALSE);
      Self.SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
    SafeFreeAndNil(pResponseBody);
  end;

  SafeFreeAndNil(pRequestBody);
  szRequestContent := '';
  szRequestAddress := '';
end;

end.

