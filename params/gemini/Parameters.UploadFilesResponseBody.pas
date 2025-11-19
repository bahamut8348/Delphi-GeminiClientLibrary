unit Parameters.UploadFilesResponseBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.FileInfo;

type
{
  https://ai.google.dev/api/files#response-body
  对 media.upload 的响应。
}
  TUploadFilesResponseBody = class(TParameterReality)
  private
    FFile: TFile;
    procedure SetFile(const Value: TFile);
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 所创建文件的元数据。
    property &file: TFile read FFile write SetFile;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    function ExtractFile(): TFile;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TUploadFilesResponseBody }

constructor TUploadFilesResponseBody.Create();
begin
  inherited Create();
  Self.FFile := nil;
end;

destructor TUploadFilesResponseBody.Destroy();
begin
  SafeFreeAndNil(Self.FFile);
  inherited Destroy();
end;

function TUploadFilesResponseBody.ExtractFile(): TFile;
begin
  Result := FFile;
  FFile := nil;
end;

function TUploadFilesResponseBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TUploadFilesResponseBody.SetFile(const Value: TFile);
begin
  if (Value <> FFile) then
    TParameterReality.CopyWithClass(FFile, Value);
end;

function TUploadFilesResponseBody.SetMemberValue(const sName: String;
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