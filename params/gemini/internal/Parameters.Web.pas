unit Parameters.Web;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#Web
  来自网络的块。
}
  TWeb = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 块的 URI 引用。
    uri: String;
    // 块的标题。
    title: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

{ TWeb }

constructor TWeb.Create();
begin
  inherited Create();
  Self.uri := '';
  Self.title := '';
end;

destructor TWeb.Destroy();
begin
  Self.title := '';
  Self.uri := '';
  inherited Destroy();
end;

end.
