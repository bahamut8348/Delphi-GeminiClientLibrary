unit Parameters.Content;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement, Parameters.Part, Parameters.Blob, Parameters.FileData;

type
{
  https://ai.google.dev/api/caching#Content
  包含消息的多部分内容的基本结构化数据类型。
  Content 包含一个 role 字段（用于指定 Content 的提供方）和一个 parts 字段（包含多部分数据，其中包含消息轮次的内容）。
}
  TContent = class(TParameterReality)
  private
    { private declarations }
    FParts: TArray<TPart>;
    FRole: String;
    procedure SetParts(const Value: TArray<TPart>);
    procedure SetRole(const Value: String);
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 构成单条消息的有序 Parts。部分可能具有不同的 MIME 类型。
    property parts: TArray<TPart> read FParts write SetParts;
    // 可选。内容的制作方。必须是“user”或“model”。对于多轮对话，此字段很有用；否则，可以留空或不设置。
    property role: String read FRole write SetRole;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  public
    { public declarations }
    class function CreateWithPart(const pPart: TPart): TContent; overload; inline; static;
    class function CreateWithPart(const szText: String): TContent; overload; inline; static;
    class function CreateWithPart(const pInlineData: TBlob): TContent; overload; inline; static;
    class function CreateWithPart(const pFileData: TFileData): TContent; overload; inline; static;
    //class function CreateWithPart(const pUploadedFile: TUploadedFile): TContent; overload; inline; static;
    class function CreateWithPart(const pContent: TContent): TContent; overload; inline; static;

    class function CreateMultiWithParts(const pParts: TArray<TPart>): TArray<TContent>; overload; static;
    class function CreateMultiWithParts(const pTexts: TArray<String>): TArray<TContent>; overload; static;
    class function CreateMultiWithParts(const pInlineDatas: TArray<TBlob>): TArray<TContent>; overload; static;
    class function CreateMultiWithParts(const pFileDatas: TArray<TFileData>): TArray<TContent>; overload; static;
    //class function CreateMultiWithParts(const pUploadedFiles: TArray<TUploadedFile>): TArray<TContent>; overload; static;
    //class function CreateMultiWithParts(const pContents: TArray<TContent>): TArray<TContent>; overload; static;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType,
  Functions.SystemExtended;

{ TContent }

constructor TContent.Create();
begin
  inherited Create();
  SetLength(Self.FParts, 0);
  Self.FRole := '';
end;

class function TContent.CreateMultiWithParts(
  const pParts: TArray<TPart>): TArray<TContent>;
var
  nIndex: Integer;
begin
  SetLength(Result, Length(pParts));
  for nIndex := Low(pParts) to High(pParts) do
    Result[nIndex] := TContent.CreateWithPart(pParts[nIndex]);
end;

class function TContent.CreateMultiWithParts(
  const pTexts: TArray<String>): TArray<TContent>;
var
  nIndex: Integer;
begin
  SetLength(Result, Length(pTexts));
  for nIndex := Low(pTexts) to High(pTexts) do
    Result[nIndex] := TContent.CreateWithPart(pTexts[nIndex]);
end;

class function TContent.CreateMultiWithParts(
  const pFileDatas: TArray<TFileData>): TArray<TContent>;
var
  nIndex: Integer;
begin
  SetLength(Result, Length(pFileDatas));
  for nIndex := Low(pFileDatas) to High(pFileDatas) do
    Result[nIndex] := TContent.CreateWithPart(pFileDatas[nIndex]);
end;

class function TContent.CreateMultiWithParts(
  const pInlineDatas: TArray<TBlob>): TArray<TContent>;
var
  nIndex: Integer;
begin
  SetLength(Result, Length(pInlineDatas));
  for nIndex := Low(pInlineDatas) to High(pInlineDatas) do
    Result[nIndex] := TContent.CreateWithPart(pInlineDatas[nIndex]);
end;

class function TContent.CreateWithPart(const szText: String): TContent;
begin
  Result := TContent.Create();
  SetLength(Result.FParts, 1);
  Result.FParts[0] := TPart.CreateWith(szText);
  Result.role := GEMINI_ROLE_USER;
end;

class function TContent.CreateWithPart(const pPart: TPart): TContent;
begin
  Result := TContent.Create();
  SetLength(Result.FParts, 1);
  Result.FParts[0] := TPart.Create();
  Result.FParts[0].Assign(pPart);
  Result.role := GEMINI_ROLE_USER;
end;

class function TContent.CreateWithPart(const pInlineData: TBlob): TContent;
begin
  Result := TContent.Create();
  SetLength(Result.FParts, 1);
  Result.FParts[0] := TPart.CreateWith(pInlineData);
  Result.role := GEMINI_ROLE_USER;
end;

class function TContent.CreateWithPart(const pFileData: TFileData): TContent;
begin
  Result := TContent.Create();
  SetLength(Result.FParts, 1);
  Result.FParts[0] := TPart.CreateWith(pFileData);
  Result.role := GEMINI_ROLE_USER;
end;

class function TContent.CreateWithPart(const pContent: TContent): TContent;
var
  nIndex: Integer;
begin
  if (nil = pContent) then
    Exit(nil);
  Result := TContent.Create();
  SetLength(Result.FParts, Length(pContent.FParts));
  for nIndex := Low(Result.FParts) to High(Result.FParts) do
    Result.FParts[nIndex] := TPart.CreateWith(pContent.FParts[0]);
end;

destructor TContent.Destroy();
begin
  Self.FRole := '';
  TParameterReality.ReleaseArray<TPart>(Self.FParts);
  inherited Destroy();
end;

function TContent.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TContent.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
begin
  if SameText(sName, 'parts') then
  begin
    TParameterReality.CopyArrayWithJson<TPart>(Self.FParts, pValue);
    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

procedure TContent.SetParts(const Value: TArray<TPart>);
begin
  TParameterReality.CopyArrayWithClass<TPart>(Self.FParts, Value);
end;

procedure TContent.SetRole(const Value: String);
begin
  FRole := Value;
end;

end.
