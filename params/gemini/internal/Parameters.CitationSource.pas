unit Parameters.CitationSource;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#CitationSource
  对特定回答的部分内容所引用来源的引用。
}
  TCitationSource = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 可选。归因于相应来源的回答部分的起始位置。索引表示段的起始位置（以字节为单位）。
    startIndex: Integer;
    // 可选。归因区段的结束时间（不含）。
    endIndex: Integer;
    // 可选。被归因于部分文本的来源的 URI。
    uri: String;
    // 可选。被归因于细分的 GitHub 项目的许可。代码引用需要许可信息。
    license: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TCitationSource }

constructor TCitationSource.Create();
begin
  inherited Create();
  Self.startIndex := 0;
  Self.endIndex := 0;
  Self.uri := '';
  Self.license := '';
end;

destructor TCitationSource.Destroy();
begin
  Self.license := '';
  Self.uri := '';
  Self.endIndex := 0;
  Self.startIndex := 0;
  inherited Destroy();
end;

end.
