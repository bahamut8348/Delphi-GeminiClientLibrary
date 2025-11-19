unit Parameters.Status;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/files#status
  https://ai.google.dev/api/files#v1beta.Status
  Status 类型定义了适用于不同编程环境（包括 REST API 和 RPC API）的逻辑错误模型。此类型供 gRPC 使用。每条 Status 消息包含三部分数据：错误代码、错误消息和错误详细信息。
  如需详细了解该错误模型及其使用方法，请参阅 API 设计指南。
}
  TStatus = class(TParameterReality)
  private
    { private declarations }
    FDetailsNeedFree: Boolean;

    FCode: Integer;
    FMessage: String;
    FDetails: TArray<TObject>;
    procedure SetDetails(const Value: TArray<TObject>); // TDictionary<String, TValue>;
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 状态代码，应为 google.rpc.Code 的枚举值。
    property code: Integer read FCode write FCode;
    // 面向开发者的错误消息（应采用英语）。任何向用户显示的错误消息都应进行本地化并通过 google.rpc.Status.details 字段发送，或者由客户端进行本地化。
    property &message: String read FMessage write FMessage;
    // 包含错误详细信息的消息列表。有一组通用的消息类型可供 API 使用。
    // 可以包含任意类型字段的对象。附加字段 "@type" 包含用于标示相应类型的 URI。示例：{ "id": 1234, "@type": "types.example.com/standard/id" }。
    property details: TArray<TObject> read FDetails write SetDetails; // TDictionary<String, TValue>;
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

{ TStatus }

constructor TStatus.Create();
begin
  inherited Create();
  Self.FDetailsNeedFree := FALSE;
  Self.FCode := 0;
  Self.FMessage := '';
  SetLength(Self.FDetails, 0);
end;

destructor TStatus.Destroy();
begin
  TParameterReality.ReleaseArray<TObject>(Self.FDetails, FDetailsNeedFree);
  Self.FMessage := '';
  Self.FCode := 0;
  inherited Destroy();
end;

function TStatus.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TStatus.SetDetails(const Value: TArray<TObject>);
begin
  TParameterReality.CloneArrayWithClass(FDetails, FDetailsNeedFree, Value);
end;

function TStatus.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'details') then
  begin
    TParameterReality.CloneArrayWithJson(Self.FDetails, Self.FDetailsNeedFree, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
