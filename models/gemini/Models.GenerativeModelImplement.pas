unit Models.GenerativeModelImplement;

interface

uses
  System.SysUtils, System.Classes,
  System.Generics.Defaults, System.Generics.Collections,
  System.Rtti, System.JSON, System.TypInfo, System.ObjAuto,
  Models.GeminiBasedModelStatement, Models.GeminiBasedModelImplement,
  Parameters.BasedParameterImplement,
  Parameters.Tool, Parameters.ToolConfig, Parameters.SafetySetting,
  Parameters.GenerationConfig, Parameters.Blob, Parameters.FileData,
  Parameters.Part, Parameters.Content,
  Parameters.GenerateContentRequestBody, Parameters.GenerateContentResponseBody,
  Parameters.MessagePrompt, Parameters.CountMessageTokensRequestBody, Parameters.CountMessageTokensResponseBody;

type
  TGenerativeModelReality = class;

  TChatSessionReality = class(TObject)
  private
    { private declarations }
    FOwner: TGenerativeModelReality;
    FHistory: TArray<TContent>;

    function GenerateContentWithContent(const pContents: TArray<TContent>): TGenerateContentResponseBody;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(const pOwner: TGenerativeModelReality; const pHistory: TArray<TContent> = []);
    destructor Destroy(); override;

    function SendMessage(const szText: String): TGenerateContentResponseBody; overload;
    function SendMessage(const pPart: TPart): TGenerateContentResponseBody; overload;
    function SendMessage(const pInlineData: TBlob): TGenerateContentResponseBody; overload;
    function SendMessage(const pFileData: TFileData): TGenerateContentResponseBody; overload;
    //function SendMessage(const pUploadedFile: TUploadedFile): TGenerateContentResponseBody; overload;
    function SendMessage(const pTexts: TArray<String>): TGenerateContentResponseBody; overload;
    function SendMessage(const pParts: TArray<TPart>): TGenerateContentResponseBody; overload;
    function SendMessage(const pInlineDatas: TArray<TBlob>): TGenerateContentResponseBody; overload;
    function SendMessage(const pFileDatas: TArray<TFileData>): TGenerateContentResponseBody; overload;
    //function SendMessage(const pUploadedFiles: TArray<TUploadedFile>): TGenerateContentResponseBody; overload;

    function StartChat(const pHistory: TArray<TContent>): TChatSessionReality;
    function StopChat(var pChatSession: TChatSessionReality): Boolean;
  //published
    { published declarations }
  end;

{
  https://ai.google.dev/api/models
  https://ai.google.dev/api/generate-content
  包含基础接口与生成文字内容
}
  TGenerativeModelReality = class(TGeminiModelReality)
  private
    FGenerateContentRequestBody: TGenerateContentRequestBody;
  private
    { private declarations }
    function GenerateContentWith(
      const pGenerateContentRequestBody: TGenerateContentRequestBody;
      const szMethodName: String): TGenerateContentResponseBody;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  public
    { public declarations }
    procedure SetTools(const pTools: TArray<TTool>);
    procedure SetToolConfig(const pToolConfig: TToolConfig);
    procedure SetSafetySettings(const pSafetySettings: TArray<TSafetySetting>);
    procedure SetSystemInstruction(const pSystemInstruction: TContent);
    procedure SetGenerationConfig(const pGenerationConfig: TGenerationConfig);
    procedure SetCachedContent(const szCachedContent: String);

    // start/stop chat session
	  function StartChat(const pHistory: TArray<TContent> = []): TChatSessionReality;
    function StopChat(var pChatSession: TChatSessionReality): Boolean;

    // https://ai.google.dev/api/generate-content#v1beta.models.generateContent
    // POST /v1beta/{model=models/*}:generateContent
    // Generates a model response given an input GenerateContentRequest.
    function GenerateContentWithContent(const pContents: TArray<TContent>): TGenerateContentResponseBody;

    function GenerateContent(const szText: String): TGenerateContentResponseBody; overload;
    function GenerateContent(const pPart: TPart): TGenerateContentResponseBody; overload;
    function GenerateContent(const pInlineData: TBlob): TGenerateContentResponseBody; overload;
    function GenerateContent(const pFileData: TFileData): TGenerateContentResponseBody; overload;
    //function GenerateContent(const pUploadedFile: TUploadedFile): TGenerateContentResponseBody; overload;
    function GenerateContent(const pTexts: TArray<String>): TGenerateContentResponseBody; overload;
    function GenerateContent(const pParts: TArray<TPart>): TGenerateContentResponseBody; overload;
    function GenerateContent(const pInlineDatas: TArray<TBlob>): TGenerateContentResponseBody; overload;
    function GenerateContent(const pFileDatas: TArray<TFileData>): TGenerateContentResponseBody; overload;
    //function GenerateContent(const pUploadedFiles: TArray<TUploadedFile>): TGenerateContentResponseBody; overload;

    // https://ai.google.dev/api/generate-content#v1beta.models.streamGenerateContent
    // POST /v1beta/{model=models/*}:streamGenerateContent
    // Generates a <a href="https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream">streamed response</a> from the model given an input GenerateContentRequest.
    function StreamGenerateContentWithContent(const pContents: TArray<TContent>): TGenerateContentResponseBody;

    function StreamGenerateContent(const szText: String): TGenerateContentResponseBody; overload;
    function StreamGenerateContent(const pPart: TPart): TGenerateContentResponseBody; overload;
    function StreamGenerateContent(const pInlineData: TBlob): TGenerateContentResponseBody; overload;
    function StreamGenerateContent(const pFileData: TFileData): TGenerateContentResponseBody; overload;
    //function StreamGenerateContent(const pUploadedFile: TUploadedFile): TGenerateContentResponseBody; overload;
    function StreamGenerateContent(const pTexts: TArray<String>): TGenerateContentResponseBody; overload;
    function StreamGenerateContent(const pParts: TArray<TPart>): TGenerateContentResponseBody; overload;
    function StreamGenerateContent(const pInlineDatas: TArray<TBlob>): TGenerateContentResponseBody; overload;
    function StreamGenerateContent(const pFileDatas: TArray<TFileData>): TGenerateContentResponseBody; overload;
    //function StreamGenerateContent(const pUploadedFiles: TArray<TUploadedFile>): TGenerateContentResponseBody; overload;
  published
    { published declarations }
  end;


implementation

uses
  System.AnsiStrings,
  Functions.StringsUtils, Functions.SystemExtended,
  Constants.RequestMethod, Constants.ContentType, Constants.GeminiEnumType;

{ TChatSessionReality }

constructor TChatSessionReality.Create(const pOwner: TGenerativeModelReality;
  const pHistory: TArray<TContent>);
begin
  inherited Create();

  Self.FOwner := pOwner;
  SetLength(Self.FHistory, 0);
  TParameterReality.CopyArrayWithClass<TContent>(Self.FHistory, pHistory);
end;

destructor TChatSessionReality.Destroy();
begin
  TParameterReality.ReleaseArray<TContent>(Self.FHistory);
  Self.FOwner := nil;
  inherited Destroy();
end;

function TChatSessionReality.GenerateContentWithContent(
  const pContents: TArray<TContent>): TGenerateContentResponseBody;
var
  nIndex: Integer;
  pContent: TContent;
begin
  Self.FHistory := Self.FHistory + pContents;
  Result := Self.FOwner.GenerateContentWithContent(Self.FHistory);
  if (nil <> Result) then
  begin
    for nIndex := Low(Result.candidates) to High(Result.candidates) do
    begin
      pContent := TContent.CreateWithPart(Result.candidates[nIndex].content);
      pContent.role := GEMINI_ROLE_MODEL;
      Self.FHistory := Self.FHistory + [pContent];
    end;
  end;
end;

function TChatSessionReality.SendMessage(
  const pInlineData: TBlob): TGenerateContentResponseBody;
var
  pContent: TContent;
begin
  pContent := TContent.CreateWithPart(pInlineData);
  Result := Self.GenerateContentWithContent([pContent]);
end;

function TChatSessionReality.SendMessage(
  const pPart: TPart): TGenerateContentResponseBody;
var
  pContent: TContent;
begin
  pContent := TContent.CreateWithPart(pPart);
  Result := Self.GenerateContentWithContent([pContent]);
end;

function TChatSessionReality.SendMessage(
  const szText: String): TGenerateContentResponseBody;
var
  pContent: TContent;
begin
  pContent := TContent.CreateWithPart(szText);
  Result := Self.GenerateContentWithContent([pContent]);
end;

function TChatSessionReality.SendMessage(
  const pFileData: TFileData): TGenerateContentResponseBody;
var
  pContent: TContent;
begin
  pContent := TContent.CreateWithPart(pFileData);
  Result := Self.GenerateContentWithContent([pContent]);
end;

function TChatSessionReality.SendMessage(
  const pTexts: TArray<String>): TGenerateContentResponseBody;
var
  pContents: TArray<TContent>;
begin
  pContents := TContent.CreateMultiWithParts(pTexts);
  Result := Self.GenerateContentWithContent(pContents);
end;

function TChatSessionReality.SendMessage(
  const pParts: TArray<TPart>): TGenerateContentResponseBody;
var
  pContents: TArray<TContent>;
begin
  pContents := TContent.CreateMultiWithParts(pParts);
  Result := Self.GenerateContentWithContent(pContents);
end;

function TChatSessionReality.SendMessage(
  const pInlineDatas: TArray<TBlob>): TGenerateContentResponseBody;
var
  pContents: TArray<TContent>;
begin
  pContents := TContent.CreateMultiWithParts(pInlineDatas);
  Result := Self.GenerateContentWithContent(pContents);
end;

function TChatSessionReality.SendMessage(
  const pFileDatas: TArray<TFileData>): TGenerateContentResponseBody;
var
  pContents: TArray<TContent>;
begin
  pContents := TContent.CreateMultiWithParts(pFileDatas);
  Result := Self.GenerateContentWithContent(pContents);
end;

function TChatSessionReality.StartChat(
  const pHistory: TArray<TContent>): TChatSessionReality;
begin
  Result := TChatSessionReality.Create(Self.FOwner, pHistory);
end;

function TChatSessionReality.StopChat(
  var pChatSession: TChatSessionReality): Boolean;
begin
  if (nil = pChatSession) then
    Exit(FALSE)
  else
  begin
    FreeAndNil(pChatSession);
    Exit(TRUE);
  end;
end;

{ TGenerativeModelReality }

function TGenerativeModelReality.GenerateContent(
  const pFileData: TFileData): TGenerateContentResponseBody;
var
  pContent: TContent;
begin
  pContent := TContent.CreateWithPart(pFileData);
  Result := Self.GenerateContentWithContent([pContent]);
  SafeFreeAndNil(pContent);
end;

function TGenerativeModelReality.GenerateContent(
  const pInlineData: TBlob): TGenerateContentResponseBody;
var
  pContent: TContent;
begin
  pContent := TContent.CreateWithPart(pInlineData);
  Result := Self.GenerateContentWithContent([pContent]);
  SafeFreeAndNil(pContent);
end;

function TGenerativeModelReality.GenerateContent(
  const pPart: TPart): TGenerateContentResponseBody;
var
  pContent: TContent;
begin
  pContent := TContent.CreateWithPart(pPart);
  Result := Self.GenerateContentWithContent([pContent]);
  SafeFreeAndNil(pContent);
end;

function TGenerativeModelReality.GenerateContent(
  const szText: String): TGenerateContentResponseBody;
var
  pContent: TContent;
begin
  pContent := TContent.CreateWithPart(szText);
  Result := Self.GenerateContentWithContent([pContent]);
  SafeFreeAndNil(pContent);
end;

constructor TGenerativeModelReality.Create();
begin
  inherited Create();
  Self.SetModelPath('models');
  Self.FGenerateContentRequestBody := TGenerateContentRequestBody.Create();
end;

destructor TGenerativeModelReality.Destroy();
begin
  SafeFreeAndNil(Self.FGenerateContentRequestBody);
  inherited Destroy();
end;

function TGenerativeModelReality.GenerateContent(
  const pFileDatas: TArray<TFileData>): TGenerateContentResponseBody;
var
  pContents: TArray<TContent>;
begin
  pContents := TContent.CreateMultiWithParts(pFileDatas);
  Result := Self.GenerateContentWithContent(pContents);
  TParameterReality.ReleaseArray<TContent>(pContents);
end;

function TGenerativeModelReality.GenerateContent(
  const pInlineDatas: TArray<TBlob>): TGenerateContentResponseBody;
var
  pContents: TArray<TContent>;
begin
  pContents := TContent.CreateMultiWithParts(pInlineDatas);
  Result := Self.GenerateContentWithContent(pContents);
  TParameterReality.ReleaseArray<TContent>(pContents);
end;

function TGenerativeModelReality.GenerateContent(
  const pTexts: TArray<String>): TGenerateContentResponseBody;
var
  pContents: TArray<TContent>;
begin
  pContents := TContent.CreateMultiWithParts(pTexts);
  Result := Self.GenerateContentWithContent(pContents);
  TParameterReality.ReleaseArray<TContent>(pContents);
end;

function TGenerativeModelReality.GenerateContent(
  const pParts: TArray<TPart>): TGenerateContentResponseBody;
var
  pContents: TArray<TContent>;
begin
  pContents := TContent.CreateMultiWithParts(pParts);
  Result := Self.GenerateContentWithContent(pContents);
  TParameterReality.ReleaseArray<TContent>(pContents);
end;

function TGenerativeModelReality.GenerateContentWith(
  const pGenerateContentRequestBody: TGenerateContentRequestBody;
  const szMethodName: String): TGenerateContentResponseBody;
var
  szRequestContent: AnsiString;
begin
  Result := nil;

  szRequestContent := Self.SendRequest(
    REQUESTMETHOD_HTTP_POST, // 请求方式
    pGenerateContentRequestBody, // 请求数据
    Self.GetPostRequestHeader(), // 自定义请求头
    Self.GetModelName(), // 模块名
    szMethodName // 方法名
  );

  if (S_OK = Self.GetLastErrorCode()) then
  begin
    Result := TGenerateContentResponseBody.Create();
    if not Result.Parse(StringValueS(szRequestContent)) then
    begin
      SafeFreeAndNil(Result);
      SetLastErrorCode(S_FALSE);
      SetLastErrorInfo(Format('invalid data format: '#13#10'%s'#13#10, [szRequestContent]));
    end;
  end;

  szRequestContent := '';
end;

function TGenerativeModelReality.GenerateContentWithContent(
  const pContents: TArray<TContent>): TGenerateContentResponseBody;
begin
  Self.FGenerateContentRequestBody.contents := pContents;
  Result := Self.GenerateContentWith(Self.FGenerateContentRequestBody, 'generateContent');
  Self.FGenerateContentRequestBody.contents := [];
end;

procedure TGenerativeModelReality.SetCachedContent(
  const szCachedContent: String);
begin
  if (nil <> FGenerateContentRequestBody) then
    FGenerateContentRequestBody.cachedContent := szCachedContent;
end;

procedure TGenerativeModelReality.SetGenerationConfig(
  const pGenerationConfig: TGenerationConfig);
begin
  if (nil <> FGenerateContentRequestBody) then
    FGenerateContentRequestBody.generationConfig := pGenerationConfig;
end;

procedure TGenerativeModelReality.SetSafetySettings(
  const pSafetySettings: TArray<TSafetySetting>);
begin
  if (nil <> FGenerateContentRequestBody) then
    FGenerateContentRequestBody.safetySettings := pSafetySettings;
end;

procedure TGenerativeModelReality.SetSystemInstruction(
  const pSystemInstruction: TContent);
begin
  if (nil <> FGenerateContentRequestBody) then
    FGenerateContentRequestBody.systemInstruction := pSystemInstruction;
end;

procedure TGenerativeModelReality.SetToolConfig(const pToolConfig: TToolConfig);
begin
  if (nil <> FGenerateContentRequestBody) then
    FGenerateContentRequestBody.toolConfig := pToolConfig;
end;

procedure TGenerativeModelReality.SetTools(const pTools: TArray<TTool>);
begin
  if (nil <> FGenerateContentRequestBody) then
    FGenerateContentRequestBody.tools := pTools;
end;

function TGenerativeModelReality.StreamGenerateContent(
  const pInlineData: TBlob): TGenerateContentResponseBody;
var
  pContent: TContent;
begin
  pContent := TContent.CreateWithPart(pInlineData);
  Result := Self.StreamGenerateContentWithContent([pContent]);
  SafeFreeAndNil(pContent);
end;

function TGenerativeModelReality.StreamGenerateContent(
  const pFileData: TFileData): TGenerateContentResponseBody;
var
  pContent: TContent;
begin
  pContent := TContent.CreateWithPart(pFileData);
  Result := Self.StreamGenerateContentWithContent([pContent]);
  SafeFreeAndNil(pContent);
end;

function TGenerativeModelReality.StreamGenerateContent(
  const pPart: TPart): TGenerateContentResponseBody;
var
  pContent: TContent;
begin
  pContent := TContent.CreateWithPart(pPart);
  Result := Self.StreamGenerateContentWithContent([pContent]);
  SafeFreeAndNil(pContent);
end;

function TGenerativeModelReality.StreamGenerateContent(
  const szText: String): TGenerateContentResponseBody;
var
  pContent: TContent;
begin
  pContent := TContent.CreateWithPart(szText);
  Result := Self.StreamGenerateContentWithContent([pContent]);
  SafeFreeAndNil(pContent);
end;

function TGenerativeModelReality.StartChat(
  const pHistory: TArray<TContent>): TChatSessionReality;
begin
  Result := TChatSessionReality.Create(Self, pHistory);
end;

function TGenerativeModelReality.StopChat(
  var pChatSession: TChatSessionReality): Boolean;
begin
  if (nil = pChatSession) then
    Exit(FALSE)
  else
  begin
    FreeAndNil(pChatSession);
    Exit(TRUE);
  end;
end;

function TGenerativeModelReality.StreamGenerateContent(
  const pFileDatas: TArray<TFileData>): TGenerateContentResponseBody;
var
  pContents: TArray<TContent>;
begin
  pContents := TContent.CreateMultiWithParts(pFileDatas);
  Result := Self.StreamGenerateContentWithContent(pContents);
  TParameterReality.ReleaseArray<TContent>(pContents);
end;

function TGenerativeModelReality.StreamGenerateContent(
  const pInlineDatas: TArray<TBlob>): TGenerateContentResponseBody;
var
  pContents: TArray<TContent>;
begin
  pContents := TContent.CreateMultiWithParts(pInlineDatas);
  Result := Self.StreamGenerateContentWithContent(pContents);
  TParameterReality.ReleaseArray<TContent>(pContents);
end;

function TGenerativeModelReality.StreamGenerateContent(
  const pParts: TArray<TPart>): TGenerateContentResponseBody;
var
  pContents: TArray<TContent>;
begin
  pContents := TContent.CreateMultiWithParts(pParts);
  Result := Self.StreamGenerateContentWithContent(pContents);
  TParameterReality.ReleaseArray<TContent>(pContents);
end;

function TGenerativeModelReality.StreamGenerateContent(
  const pTexts: TArray<String>): TGenerateContentResponseBody;
var
  pContents: TArray<TContent>;
begin
  pContents := TContent.CreateMultiWithParts(pTexts);
  Result := Self.StreamGenerateContentWithContent(pContents);
  TParameterReality.ReleaseArray<TContent>(pContents);
end;

function TGenerativeModelReality.StreamGenerateContentWithContent(
  const pContents: TArray<TContent>): TGenerateContentResponseBody;
begin
  Self.FGenerateContentRequestBody.contents := pContents;
  Result := Self.GenerateContentWith(Self.FGenerateContentRequestBody, 'streamGenerateContent');
  Self.FGenerateContentRequestBody.contents := [];
end;

end.
