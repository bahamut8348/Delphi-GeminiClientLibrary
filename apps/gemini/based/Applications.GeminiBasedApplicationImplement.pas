unit Applications.GeminiBasedApplicationImplement;

interface

uses
  Applications.BasedApplicationStatement, Applications.BasedApplicationImplement,
  Applications.GeminiBasedApplicationStatement,
  Models.GeminiBasedModelStatement;

type
  TGeminiBasedApplication = class(TApplicationReality, IGeminiApplicationContract)
  private
    { private declarations }
    FApiKey: WideString;
    FApiBaseUrl: WideString;
    FApiVersion: WideString;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  public
    { public declarations }

    { IGeminiApplicationContract Method }
    // API KEY
    function GetApiKey(): WideString; stdcall;
    function SetApiKey(const szApiKey: WideString): HRESULT; stdcall;
    // API 接口的基础地址
    function GetApiBaseUrl(): WideString; stdcall;
    function SetApiBaseUrl(const szApiBaseUrl: WideString): HRESULT; stdcall;
    // API 版本号
    function GetApiVersion(): WideString; stdcall;
    function SetApiVersion(const szApiVersion: WideString): HRESULT; stdcall;

    function GetResourceModels(): IResourceModelsContract; stdcall;
  published
    { published declarations }
  end;

implementation

{ TGeminiBasedApplication }

constructor TGeminiBasedApplication.Create();
begin
  inherited Create();
  Self.FApiKey := '';
  Self.FApiBaseUrl := '';
  Self.FApiVersion := '';
end;

destructor TGeminiBasedApplication.Destroy();
begin
  Self.FApiVersion := '';
  Self.FApiBaseUrl := '';
  Self.FApiKey := '';
  inherited Destroy();
end;

function TGeminiBasedApplication.GetApiBaseUrl(): WideString;
begin
  Result := Self.FApiBaseUrl;
end;

function TGeminiBasedApplication.GetApiKey(): WideString;
begin
  Result := Self.FApiKey;
end;

function TGeminiBasedApplication.GetApiVersion(): WideString;
begin
  Result := Self.FApiVersion;
end;

function TGeminiBasedApplication.GetResourceModels(): IResourceModelsContract;
begin
  Result := nil;
end;

function TGeminiBasedApplication.SetApiBaseUrl(
  const szApiBaseUrl: WideString): HRESULT;
begin
  Self.FApiBaseUrl := szApiBaseUrl;
  Result := S_OK;
end;

function TGeminiBasedApplication.SetApiKey(const szApiKey: WideString): HRESULT;
begin
  Self.FApiKey := szApiKey;
  Result := S_OK;
end;

function TGeminiBasedApplication.SetApiVersion(
  const szApiVersion: WideString): HRESULT;
begin
  Self.FApiVersion := szApiVersion;
  Result := S_OK;
end;

end.

