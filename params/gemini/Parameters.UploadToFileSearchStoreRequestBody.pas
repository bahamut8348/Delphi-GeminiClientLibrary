unit Parameters.UploadToFileSearchStoreRequestBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.CustomMetadata, Parameters.ChunkingConfig;

type
// 上传 URI，用于媒体上传请求：
// POST https://generativelanguage.googleapis.com/upload/v1beta/{fileSearchStoreName=fileSearchStores/*}:uploadToFileSearchStore
// 元数据 URI，用于仅涉及元数据的请求：
// POST https://generativelanguage.googleapis.com/v1beta/{fileSearchStoreName=fileSearchStores/*}:uploadToFileSearchStore
{
  https://ai.google.dev/api/file-search/file-search-stores#request-body
  media.uploadToFileSearchStore 的请求正文
}
  TUploadToFileSearchStoreRequestBody = class(TParameterReality)
  private
    { private declarations }
    FDisplayName: String;
    FCustomMetadata: TArray<TCustomMetadata>;
    FChunkingConfig: TChunkingConfig;
    FMimeType: String;
    procedure SetCustomMetadata(const Value: TArray<TCustomMetadata>);
    procedure SetChunkingConfig(const Value: TChunkingConfig);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。所创建文档的显示名称。
    property displayName: String read FDisplayName write FDisplayName;
    // 要与数据相关联的自定义元数据。
    property customMetadata: TArray<TCustomMetadata> read FCustomMetadata write SetCustomMetadata;
    // 可选。用于告知服务如何对数据进行分块的配置。如果未提供，服务将使用默认参数。
    property chunkingConfig: TChunkingConfig read FChunkingConfig write SetChunkingConfig;
    // 可选。数据的 MIME 类型。如果未提供，系统会根据上传的内容进行推断。
    property mimeType: String read FMimeType write FMimeType;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const szDisplayName: String; const pCustomMetadata: TArray<TCustomMetadata>;
      const pChunkingConfig: TChunkingConfig; const szMimeType: String): TUploadToFileSearchStoreRequestBody;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TUploadToFileSearchStoreRequestBody }

constructor TUploadToFileSearchStoreRequestBody.Create();
begin
  inherited Create();
  Self.FDisplayName := '';
  SetLength(Self.FCustomMetadata, 0);
  Self.FChunkingConfig := nil;
  Self.FMimeType := '';
end;

class function TUploadToFileSearchStoreRequestBody.CreateWith(
  const szDisplayName: String; const pCustomMetadata: TArray<TCustomMetadata>;
  const pChunkingConfig: TChunkingConfig;
  const szMimeType: String): TUploadToFileSearchStoreRequestBody;
begin
  Result := TUploadToFileSearchStoreRequestBody.Create();
  Result.displayName := szDisplayName;
  Result.customMetadata := pCustomMetadata;
  Result.chunkingConfig := pChunkingConfig;
  Result.mimeType := szMimeType;
end;

destructor TUploadToFileSearchStoreRequestBody.Destroy();
begin
  Self.FMimeType := '';
  SafeFreeAndNil(Self.FChunkingConfig);
  TParameterReality.ReleaseArray<TCustomMetadata>(Self.FCustomMetadata);
  Self.FDisplayName := '';
  inherited Destroy();
end;

function TUploadToFileSearchStoreRequestBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TUploadToFileSearchStoreRequestBody.SetChunkingConfig(
  const Value: TChunkingConfig);
begin
  if (Value <> FChunkingConfig) then
    TParameterReality.CopyWithClass(FChunkingConfig, Value);
end;

procedure TUploadToFileSearchStoreRequestBody.SetCustomMetadata(
  const Value: TArray<TCustomMetadata>);
begin
  TParameterReality.CopyArrayWithClass<TCustomMetadata>(FCustomMetadata, Value);
end;

function TUploadToFileSearchStoreRequestBody.SetMemberValue(const sName: String;
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
