unit Parameters.ImportFileRequestBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.CustomMetadata, Parameters.ChunkingConfig;

type
{
  https://ai.google.dev/api/file-search/file-search-stores#request-body_5
  fileSearchStores.importFile 的请求正文
}
  TImportFileRequestBody = class(TParameterReality)
  private
    { private declarations }
    FFileName: String;
    FCustomMetadata: TArray<TCustomMetadata>;
    FChunkingConfig: TChunkingConfig;
    procedure SetChunkingConfig(const Value: TChunkingConfig);
    procedure SetCustomMetadata(const Value: TArray<TCustomMetadata>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。要导入的 File 的名称。示例：files/abc-123
    property fileName: String read FFileName write FFileName;
    // 要与文件关联的自定义元数据。
    property customMetadata: TArray<TCustomMetadata> read FCustomMetadata write SetCustomMetadata;
    // 可选。用于告知服务如何将文件分块的配置。如果未提供，服务将使用默认参数。
    property chunkingConfig: TChunkingConfig read FChunkingConfig write SetChunkingConfig;


    class function CreateWith(const szFileName: String; const pCustomMetadata: TArray<TCustomMetadata>;
      const pChunkingConfig: TChunkingConfig): TImportFileRequestBody; inline; static;
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

{ TImportFileRequestBody }

constructor TImportFileRequestBody.Create();
begin
  inherited Create();
  Self.FFileName := '';
  SetLength(Self.FCustomMetadata, 0);
  Self.FChunkingConfig := nil;
end;

class function TImportFileRequestBody.CreateWith(const szFileName: String;
  const pCustomMetadata: TArray<TCustomMetadata>;
  const pChunkingConfig: TChunkingConfig): TImportFileRequestBody;
begin
  Result := TImportFileRequestBody.Create();
  Result.fileName := szFileName;
  Result.customMetadata := pCustomMetadata;
  Result.chunkingConfig := pChunkingConfig;
end;

destructor TImportFileRequestBody.Destroy();
begin
  SafeFreeAndNil(Self.FChunkingConfig);
  TParameterReality.ReleaseArray<TCustomMetadata>(Self.FCustomMetadata);
  Self.FFileName := '';
  inherited Destroy();
end;

function TImportFileRequestBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TImportFileRequestBody.SetChunkingConfig(
  const Value: TChunkingConfig);
begin
  FChunkingConfig := Value;
end;

procedure TImportFileRequestBody.SetCustomMetadata(
  const Value: TArray<TCustomMetadata>);
begin
  FCustomMetadata := Value;
end;

function TImportFileRequestBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'customMetadata') then
  begin
    TParameterReality.CopyArrayWithJson<TCustomMetadata>(Self.FCustomMetadata, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'chunkingConfig') then
  begin
    TParameterReality.CopyWithJson(Self.FChunkingConfig, TChunkingConfig, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
