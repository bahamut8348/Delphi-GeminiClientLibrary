unit Parameters.CountTokensRequestBody;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Content,
  Parameters.GenerateContentRequest;

type
{
  https://ai.google.dev/api/tokens#request-body
  对输入 Content 运行模型的分词器，并返回词元数量。如需详细了解令牌，请参阅令牌指南。
}
  TCountTokensRequestBody = class(TParameterReality)
  private
    { private declarations }
    FContents: TArray<TContent>;
    FGenerateContentRequest: TGenerateContentRequest;
    procedure SetGenerateContentRequest(const Value: TGenerateContentRequest);
    procedure SetContents(const Value: TArray<TContent>);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。作为提示提供给模型的输入。如果设置了 generateContentRequest，则系统会忽略此字段。
    property contents: TArray<TContent> read FContents write SetContents;
    // 可选。提供给 Model 的整体输入。这包括提示以及其他模型引导信息，例如系统指令和/或用于函数调用的函数声明。Model、Content 和 generateContentRequest 互斥。您可以发送 Model + Content 或 generateContentRequest，但不能同时发送这两者。
    property generateContentRequest: TGenerateContentRequest read FGenerateContentRequest write SetGenerateContentRequest;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;

    class function CreateWith(const pContents: TArray<TContent> = [];
      const pGenerateContentRequest: TGenerateContentRequest = nil): TCountTokensRequestBody; inline; static;
  published
    { published declarations }
  end;

implementation

uses
  Functions.SystemExtended;

{ TCountTokensRequestBody }

constructor TCountTokensRequestBody.Create();
begin
  inherited Create();
  SetLength(Self.FContents, 0);
  Self.FGenerateContentRequest := nil;
end;

class function TCountTokensRequestBody.CreateWith(
  const pContents: TArray<TContent>;
  const pGenerateContentRequest: TGenerateContentRequest): TCountTokensRequestBody;
begin
  Result := TCountTokensRequestBody.Create();
  Result.contents := pContents;
  Result.generateContentRequest := pGenerateContentRequest;
end;

destructor TCountTokensRequestBody.Destroy();
begin
  TParameterReality.ReleaseArray<TContent>(Self.FContents);
  SafeFreeAndNil(Self.FGenerateContentRequest);
  inherited Destroy();
end;

function TCountTokensRequestBody.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TCountTokensRequestBody.SetContents(const Value: TArray<TContent>);
begin
  TParameterReality.CopyArrayWithClass<TContent>(FContents, Value);
end;

procedure TCountTokensRequestBody.SetGenerateContentRequest(
  const Value: TGenerateContentRequest);
begin
  if (Value <> FGenerateContentRequest) then
    TParameterReality.CopyWithClass(FGenerateContentRequest, Value);
end;

function TCountTokensRequestBody.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'contents') then
  begin
    TParameterReality.CopyArrayWithJson<TContent>(Self.FContents, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'generateContentRequest') then
  begin
    TParameterReality.CopyWithJson(Self.FGenerateContentRequest, TGenerateContentRequest, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.