unit Parameters.Operation;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Status;

type
{
  https://ai.google.dev/api/batch-api#Operation
  此资源表示由网络 API 调用引发的长时间运行的操作。
}
  TOperation = class(TParameterReality)
  private
    { private declarations }
    // 联合属性序号，联合属性 result 不能全部发送，否则服务器将返回错误.
    FUnionProperty: (upError, upResponse, upOther);
    FMetadataNeedFree, FResponseNeedFree: Boolean;

    FName: String;
    FMetadata: TObject; // TDictionary<String, TValue>;
    FDone: Boolean;

    { Union type result start }
    FError: TStatus;
    FResponse: TObject;
    procedure SetError(const Value: TStatus);
    procedure SetMetadata(const Value: TObject);
    procedure SetResponse(const Value: TObject); // TDictionary<String, TValue>;
    { Union type result end }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 由服务器分配的名称，该名称仅在最初返回它的那项服务中是唯一的。如果您使用默认 HTTP 映射，则 name 应是以 operations/{unique_id} 结尾的资源名称。
    property name: String read FName write FName;
    // 与操作关联的服务专属元数据。它通常包含进度信息和常见元数据（如创建时间）。一些服务可能不会提供此类元数据。任何返回长时间运行操作的方法都应记录元数据类型（如果有的话）。
    // 此对象可以包含任意类型的字段。附加字段 "@type" 包含用于标示相应类型的 URI。示例：{ "id": 1234, "@type": "types.example.com/standard/id" }。
    property metadata: TObject read FMetadata write SetMetadata; // TDictionary<String, TValue>;
    // 如果值为 false，则表示操作仍在进行中。如果为 true，则表示操作已完成，其结果不是 error 就是 response。
    property done: Boolean read FDone write FDone;

    { Union type result start }
    // result 操作结果，可以是 error，也可以是有效的 response。如果 done == false，则既不会设置 error，也不会设置 response。如果 done == true，则只能设置 error 或 response 中的一项。部分服务可能不会提供结果。result 只能是下列其中一项：
    // 操作失败或被取消时表示有错误发生的结果。
    property error: TStatus read FError write SetError;
    // 操作的常规成功响应。如果原始方法在成功时不返回任何数据（如 Delete），则响应为 google.protobuf.Empty。如果原始方法为标准 Get/Create/Update 方法，则响应应该为资源。对于其他方法，响应类型应为 XxxResponse，其中 Xxx 是原始方法的名称。例如，如果原始方法名称为 TakeSnapshot()，则推断的响应类型为 TakeSnapshotResponse。
    // 此对象可以包含任意类型的字段。附加字段 "@type" 包含用于标示相应类型的 URI。示例：{ "id": 1234, "@type": "types.example.com/standard/id" }。
    property response: TObject read FResponse write SetResponse; // TDictionary<String, TValue>;
    { Union type result end }

    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TOperation }

constructor TOperation.Create();
begin
  inherited Create();
  Self.FUnionProperty := upError;
  Self.FMetadataNeedFree := FALSE;
  Self.FResponseNeedFree := FALSE;

  Self.FName := '';
  Self.FMetadata := nil;
  Self.FDone := FALSE;

  Self.FError := nil;
  Self.FResponse := nil;
end;

destructor TOperation.Destroy();
begin
  if (Self.FResponseNeedFree) then
    SafeFreeAndNil(Self.FResponse);
  SafeFreeAndNil(Self.FError);
  if (Self.FMetadataNeedFree) then
    SafeFreeAndNil(Self.FMetadata);

  Self.FDone := FALSE;
  Self.FName := '';

  Self.FResponseNeedFree := FALSE;
  Self.FMetadataNeedFree := FALSE;
  Self.FUnionProperty := upOther;
  inherited Destroy();
end;

function TOperation.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  if SameText(sName, 'error') then
  begin
    if (upError = FUnionProperty) then
      pValue := TValue.From(FError)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'response') then
  begin
    if (upResponse = FUnionProperty) then
      pValue := TValue.From(FResponse)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else
    Result := inherited GetMemberValue(sName, pValue);
end;

procedure TOperation.SetError(const Value: TStatus);
begin
  FUnionProperty := upError;
  if (Value <> FError) then
    TParameterReality.CopyWithClass(FError, Value);
end;

function TOperation.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'metadata') then
  begin
    TParameterReality.CloneWithJson(FMetadata, FMetadataNeedFree, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'response') then
  begin
    FUnionProperty := upResponse;
    TParameterReality.CloneWithJson(FResponse, FResponseNeedFree, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'error') then
  begin
    FUnionProperty := upError;
    TParameterReality.CopyWithJson(FError, TStatus, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TOperation.SetMetadata(const Value: TObject);
begin
  if (Value <> FMetadata) then
    TParameterReality.CloneWithClass(FMetadata, FMetadataNeedFree, Value);
end;

procedure TOperation.SetResponse(const Value: TObject);
begin
  FUnionProperty := upResponse;
  if (Value <> FResponse) then
    TParameterReality.CloneWithClass(FResponse, FResponseNeedFree, Value);
end;

end.
