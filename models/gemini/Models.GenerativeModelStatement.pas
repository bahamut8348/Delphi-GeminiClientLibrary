unit Models.GenerativeModelStatement;

interface

uses
  Parameters.BasedParameterStatement, Models.GeminiBasedModelStatement;

type
  IChatSessionContract = interface(IUnknown)
    ['{D0051C8E-C6B6-497B-BA53-6CBB373B4B47}']
    {
      @todo 发送消息
      @param string|Blob|array<string|Blob>|Content ...$Parts
      @return GenerateContentResponseParameter
    }
    function SendMessage(): IParameterContract; stdcall;
  end;

{
  https://ai.google.dev/api/models
  https://ai.google.dev/api/generate-content
  包含基础接口与生成文字内容
}
  IGenerativeModelContract = interface(IGeminiModelContract)
    ['{4FDB5434-0BBE-4FEB-AA29-6EF749644B40}']
    // https://ai.google.dev/api/generate-content#v1beta.models.generateContent
    // POST /v1beta/{model=models/*}:generateContent
    // Generates a model response given an input GenerateContentRequest.
    function GenerateContent(): IParameterContract; stdcall;

    // https://ai.google.dev/api/generate-content#v1beta.models.streamGenerateContent
    // POST /v1beta/{model=models/*}:streamGenerateContent
    // Generates a <a href="https://ai.google.dev/gemini-api/docs/text-generation?lang=python#generate-a-text-stream">streamed response</a> from the model given an input GenerateContentRequest.
    function StreamGenerateContent(): IParameterContract; stdcall;

    // https://ai.google.dev/api/models#v1beta.models.get
    // GET /v1beta/{name=models/*}
    // Gets information about a specific Model such as its version number, token limits, <a href="https://ai.google.dev/gemini-api/docs/models/generative-models#model-parameters">parameters</a> and other metadata.
    function get(): IParameterContract; stdcall;

    // https://ai.google.dev/api/models#v1beta.models.list
    // GET /v1beta/models
    // Lists the <a href="https://ai.google.dev/gemini-api/docs/models/gemini">Models</a> available through the Gemini API.
    function list(): IParameterContract; stdcall;

    // https://ai.google.dev/api/models#v1beta.models.predict
    // POST /v1beta/{model=models/*}:predict
    // Performs a prediction request.
    function predict(): IParameterContract; stdcall;

    // https://ai.google.dev/api/models#v1beta.models.predictLongRunning
    // POST /v1beta/{model=models/*}:predictLongRunning
    // Same as Predict but returns an LRO.
    function predictLongRunning(): IParameterContract; stdcall;

    // https://ai.google.dev/api/palm#v1beta.models.countMessageTokens
    // POST /v1beta/{model=models/*}:countMessageTokens
    // Runs a model's tokenizer on a string and returns the token count.
    function countMessageTokens(): IParameterContract; stdcall;

    // https://ai.google.dev/api/palm#v1beta.models.countTextTokens
    // POST /v1beta/{model=models/*}:countTextTokens
    // Runs a model's tokenizer on a text and returns the token count.
    function countTextTokens(): IParameterContract; stdcall;

    // https://ai.google.dev/api/tokens#v1beta.models.countTokens
    // POST /v1beta/{model=models/*}:countTokens
    // Runs a model's tokenizer on input Content and returns the token count.
    function countTokens(): IParameterContract; stdcall;

    // start chat session
	  function StartChat(): IChatSessionContract; stdcall;
    function StopChat(pChatSession: IChatSessionContract): HRESULT; stdcall;
  end;

implementation

end.
