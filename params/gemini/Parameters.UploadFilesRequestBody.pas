unit Parameters.UploadFilesRequestBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.FileInfo;

type
{
  https://ai.google.dev/api/files#request-body
  media.upload / files.upload 的请求正文
}
  TUploadFilesRequestBody = class(TParameterReality)
  private
    { private declarations }
    FFile: TFile;
    procedure SetFile(const Value: TFile);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。要创建的文件的元数据。
    property &file: TFile read FFile write SetFile;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const pFile: TFile): TUploadFilesRequestBody; overload; inline; static;
    class function CreateWith(const szFileName, szDisplayName: String): TUploadFilesRequestBody; overload; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TUploadFilesRequestBody }

constructor TUploadFilesRequestBody.Create();
begin
  inherited Create();
  Self.FFile := nil;
end;

class function TUploadFilesRequestBody.CreateWith(
  const szFileName, szDisplayName: String): TUploadFilesRequestBody;
begin
  Result := TUploadFilesRequestBody.Create();
  Result.FFile := TFile.CreateWithName(szFileName, szDisplayName);
end;

class function TUploadFilesRequestBody.CreateWith(
  const pFile: TFile): TUploadFilesRequestBody;
begin
  Result := TUploadFilesRequestBody.Create();
  Result.&file := pFile;
end;

destructor TUploadFilesRequestBody.Destroy();
begin
  SafeFreeAndNil(Self.FFile);
  inherited Destroy();
end;

function TUploadFilesRequestBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TUploadFilesRequestBody.SetFile(const Value: TFile);
begin
  if (Value <> FFile) then
    TParameterReality.CopyWithClass(FFile, Value);
end;

function TUploadFilesRequestBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'file') then
  begin
    TParameterReality.CopyWithJson(FFile, TFile, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.