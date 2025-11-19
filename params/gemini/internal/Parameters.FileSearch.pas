unit Parameters.FileSearch;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#FileSearch
  一种从语义检索语料库中检索知识的 FileSearch 工具。使用 ImportFile API 将文件导入到语义检索语料库。
}
  TFileSearch = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。要从中检索的 fileSearchStore 的名称。示例：fileSearchStores/my-file-search-store-123
    fileSearchStoreNames: array of String;
    // 可选。要应用于语义检索文档和块的元数据过滤条件。
    metadataFilter: String;
    // 可选。要检索的语义检索块的数量。
    topK: Integer;
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

{ TFileSearch }

constructor TFileSearch.Create();
begin
  inherited Create();
  SetLength(Self.fileSearchStoreNames, 0);
  Self.metadataFilter := '';
  Self.topK := 0;
end;

destructor TFileSearch.Destroy();
var
  nIndex: Integer;
begin
  for nIndex := High(Self.fileSearchStoreNames) downto Low(Self.fileSearchStoreNames) do
    Self.fileSearchStoreNames[nIndex] := '';

  Self.topK := 0;
  Self.metadataFilter := '';
  SetLength(Self.fileSearchStoreNames, 0);
  inherited Destroy();
end;

function TFileSearch.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TFileSearch.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
var
  nIndex: Integer;
begin
  if SameText(sName, 'fileSearchStoreNames') then
  begin
    for nIndex := High(Self.fileSearchStoreNames) downto Low(Self.fileSearchStoreNames) do
      Self.fileSearchStoreNames[nIndex] := '';

    if (pValue is TJSONArray) then
    begin
      SetLength(Self.fileSearchStoreNames, (pValue as TJSONArray).Count);
      for nIndex := Low(Self.fileSearchStoreNames) to High(Self.fileSearchStoreNames) do
        Self.fileSearchStoreNames[nIndex] := (pValue as TJSONArray).Value;
    end
    else if (nil <> pValue) then
    begin
      SetLength(Self.fileSearchStoreNames, 1);
      Self.fileSearchStoreNames[0] := pValue.Value;
    end
    else
      SetLength(Self.fileSearchStoreNames, 0);

    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
