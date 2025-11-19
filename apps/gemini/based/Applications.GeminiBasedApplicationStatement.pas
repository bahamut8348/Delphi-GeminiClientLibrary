unit Applications.GeminiBasedApplicationStatement;

interface

uses
  Applications.BasedApplicationStatement,
  Models.GeminiBasedModelStatement;

type
  IGeminiApplicationContract = interface(IApplicationContract)
    ['{57588A78-4A94-491B-A965-3F004C3FF413}']
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
  end;

implementation

end.

