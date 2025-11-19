unit Parameters.InputEmbedContentConfig;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.InlinedEmbedContentRequests;

type
{
  https://ai.google.dev/api/embeddings#InputEmbedContentConfig
  配置批量请求的输入。
}
  TInputEmbedContentConfig = class(TParameterReality)
  private
    { private declarations }
    // 联合属性序号，联合属性 source 不能全部发送，否则服务器将返回错误.
    FUnionProperty: (upFileName, upRequests, upOther);

    { Union type source start }
    FFileName: String;
    FRequests: TInlinedEmbedContentRequests;
    { Union type source end }

    procedure SetFileName(const Value: String);
    procedure SetRequests(const Value: TInlinedEmbedContentRequests);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    { Union type source start }
    // 必需。输入的来源。source 只能是下列其中一项：
    // 包含输入请求的 File 的名称。
    property fileName: String read FFileName write SetFileName;
    // 批次中要处理的请求。
    property requests: TInlinedEmbedContentRequests read FRequests write SetRequests;
    { Union type source end }
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const szFileName: String): TInputEmbedContentConfig; overload; inline; static;
    class function CreateWith(const pRequests: TInlinedEmbedContentRequests): TInputEmbedContentConfig; overload; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TInputEmbedContentConfig }

constructor TInputEmbedContentConfig.Create();
begin
  inherited Create();
  FUnionProperty := upFileName;
  Self.FFileName := '';
  Self.FRequests := nil;
end;

class function TInputEmbedContentConfig.CreateWith(
  const pRequests: TInlinedEmbedContentRequests): TInputEmbedContentConfig;
begin
  Result := TInputEmbedContentConfig.Create();
  Result.requests := pRequests;
end;

class function TInputEmbedContentConfig.CreateWith(
  const szFileName: String): TInputEmbedContentConfig;
begin
  Result := TInputEmbedContentConfig.Create();
  Result.fileName := szFileName;
end;

destructor TInputEmbedContentConfig.Destroy();
begin
  SafeFreeAndNil(Self.FRequests);
  Self.FFileName := '';
  FUnionProperty := upOther;
  inherited Destroy();
end;

function TInputEmbedContentConfig.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  if SameText(sName, 'fileName') then
  begin
    if (upFileName = FUnionProperty) then
      pValue := TValue.From(FFileName)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else if SameText(sName, 'requests') then
  begin
    if (upRequests = FUnionProperty) then
      pValue := TValue.From(FRequests)
    else
      pValue := TValue.Empty;

    Result := TRUE;
  end
  else
    Result := inherited GetMemberValue(sName, pValue);
end;

procedure TInputEmbedContentConfig.SetFileName(const Value: String);
begin
  FUnionProperty := upFileName;
  FFileName := Value;
end;

function TInputEmbedContentConfig.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'fileName') then
  begin
    FUnionProperty := upFileName;
    FFileName := GetJsonStringValue(pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'requests') then
  begin
    FUnionProperty := upRequests;
    TParameterReality.CopyWithJson(FRequests, TInlinedEmbedContentRequests, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TInputEmbedContentConfig.SetRequests(
  const Value: TInlinedEmbedContentRequests);
begin
  FUnionProperty := upRequests;
  if (Value <> FRequests) then
    TParameterReality.CopyWithClass(FRequests, Value);
end;

end.
