unit Parameters.Tool;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.FunctionDeclaration,
  Parameters.GoogleSearchRetrieval, Parameters.CodeExecution,
  Parameters.GoogleSearch, Parameters.ComputerUse, Parameters.UrlContext,
  Parameters.FileSearch, Parameters.GoogleMaps;

type
{
  https://ai.google.dev/api/caching#Tool
  模型可能用于生成回答的工具详细信息。
  Tool 是一段代码，可让系统与外部系统进行交互，以在模型知识和范围之外执行操作或一组操作。
  下一个 ID：13
}
  TTool = class(TParameterReality)
  private
    { private declarations }

    FGoogleSearchRetrieval: TGoogleSearchRetrieval;
    FCodeExecution: TCodeExecution;
    FGoogleSearch: TGoogleSearch;
    FComputerUse: TComputerUse;
    FUrlContext: TUrlContext;
    FFileSearch: TFileSearch;
    FGoogleMaps: TGoogleMaps;

    procedure SetCodeExecution(const Value: TCodeExecution);
    procedure SetComputerUse(const Value: TComputerUse);
    procedure SetFileSearch(const Value: TFileSearch);
    procedure SetGoogleMaps(const Value: TGoogleMaps);
    procedure SetGoogleSearch(const Value: TGoogleSearch);
    procedure SetGoogleSearchRetrieval(const Value: TGoogleSearchRetrieval);
    procedure SetUrlContext(const Value: TUrlContext);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 可选。可供模型用于函数调用的 FunctionDeclarations 列表。
    // 模型或系统未执行该函数。而是可以将定义的函数作为 FunctionCall 返回到客户端以供执行。模型可能会通过在响应中填充 FunctionCall 来决定调用这些函数中的一部分。下一个对话轮次可能包含 FunctionResponse，其中包含 Content.role“function”生成上下文，用于下一个模型轮次。
    functionDeclarations: TArray<TFunctionDeclaration>;
    // 可选。由 Google 搜索提供支持的检索工具。
    property googleSearchRetrieval: TGoogleSearchRetrieval read FGoogleSearchRetrieval write SetGoogleSearchRetrieval;
    // 可选。使模型能够在生成过程中执行代码。
    property codeExecution: TCodeExecution read FCodeExecution write SetCodeExecution;
    // 可选。GoogleSearch 工具类型。支持在模型中使用 Google 搜索的工具。由 Google 提供支持。
    property googleSearch: TGoogleSearch read FGoogleSearch write SetGoogleSearch;
    // 可选。支持模型直接与计算机交互的工具。如果启用，系统会自动填充特定于计算机用途的函数声明。
    property computerUse: TComputerUse read FComputerUse write SetComputerUse;
    // 可选。用于支持网址上下文检索的工具。
    property urlContext: TUrlContext read FUrlContext write SetUrlContext;
    // 可选。FileSearch 工具类型。用于从语义检索语料库中检索知识的工具。
    property fileSearch: TFileSearch read FFileSearch write SetFileSearch;
    // 可选。一种工具，可让模型根据与用户查询相关的地理空间上下文生成回答。
    property googleMaps: TGoogleMaps read FGoogleMaps write SetGoogleMaps;
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

{ TTool }

constructor TTool.Create();
begin
  inherited Create();
  SetLength(Self.functionDeclarations, 0);
  Self.FGoogleSearchRetrieval := nil;
  Self.FCodeExecution := nil;
  Self.FGoogleSearch := nil;
  Self.FComputerUse := nil;
  Self.FUrlContext := nil;
  Self.FFileSearch := nil;
  Self.FGoogleMaps := nil;
end;

destructor TTool.Destroy();
begin
  SafeFreeAndNil(Self.FGoogleMaps);
  SafeFreeAndNil(Self.FFileSearch);
  SafeFreeAndNil(Self.FUrlContext);
  SafeFreeAndNil(Self.FComputerUse);
  SafeFreeAndNil(Self.FGoogleSearch);
  SafeFreeAndNil(Self.FCodeExecution);
  SafeFreeAndNil(Self.FGoogleSearchRetrieval);
  TParameterReality.ReleaseArray<TFunctionDeclaration>(Self.functionDeclarations);
  inherited Destroy();
end;

function TTool.GetMemberValue(var sName: String; out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

procedure TTool.SetCodeExecution(const Value: TCodeExecution);
begin
  if (Value <> FCodeExecution) then
    TParameterReality.CopyWithClass(FCodeExecution, Value);
end;

procedure TTool.SetComputerUse(const Value: TComputerUse);
begin
  if (Value <> FComputerUse) then
    TParameterReality.CopyWithClass(FComputerUse, Value);
end;

procedure TTool.SetFileSearch(const Value: TFileSearch);
begin
  if (Value <> FFileSearch) then
    TParameterReality.CopyWithClass(FFileSearch, Value);
end;

procedure TTool.SetGoogleMaps(const Value: TGoogleMaps);
begin
  if (Value <> FGoogleMaps) then
    TParameterReality.CopyWithClass(FGoogleMaps, Value);
end;

procedure TTool.SetGoogleSearch(const Value: TGoogleSearch);
begin
  if (Value <> FGoogleSearch) then
    TParameterReality.CopyWithClass(FGoogleSearch, Value);
end;

procedure TTool.SetGoogleSearchRetrieval(const Value: TGoogleSearchRetrieval);
begin
  if (Value <> FGoogleSearchRetrieval) then
    TParameterReality.CopyWithClass(FGoogleSearchRetrieval, Value);
end;

function TTool.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'functionDeclarations') then
  begin
    TParameterReality.CopyArrayWithJson<TFunctionDeclaration>(Self.functionDeclarations, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'googleSearchRetrieval') then
  begin
    TParameterReality.CopyWithJson(FGoogleSearchRetrieval, TGoogleSearchRetrieval, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'codeExecution') then
  begin
    TParameterReality.CopyWithJson(FCodeExecution, TCodeExecution, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'googleSearch') then
  begin
    TParameterReality.CopyWithJson(FGoogleSearch, TGoogleSearch, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'computerUse') then
  begin
    TParameterReality.CopyWithJson(FComputerUse, TComputerUse, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'urlContext') then
  begin
    TParameterReality.CopyWithJson(FUrlContext, TUrlContext, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'fileSearch') then
  begin
    TParameterReality.CopyWithJson(FFileSearch, TFileSearch, pValue);
    Result := TRUE;
  end
  else if SameText(sName, 'googleMaps') then
  begin
    TParameterReality.CopyWithJson(FGoogleMaps, TGoogleMaps, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TTool.SetUrlContext(const Value: TUrlContext);
begin
  if (Value <> FUrlContext) then
    TParameterReality.CopyWithClass(FUrlContext, Value);
end;

end.
