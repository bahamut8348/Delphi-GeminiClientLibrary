unit Parameters.WhiteSpaceConfig;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/files#WhiteSpaceConfig
  空白分隔分块算法的配置 [以空格分隔]。
}
  TWhiteSpaceConfig = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 每个块的令牌数量上限。对于此分块算法，词法单元定义为字词。注意：我们将词元定义为由空格分隔的字词，而不是分词器的输出。截至 2025 年 4 月 17 日，最新 Gemini 嵌入模型的上下文窗口目前为 8,192 个词元。我们假设平均每个字词包含 5 个字符。因此，我们将上限设置为 2**9，即 512 个字或 2560 个 token（假设最坏情况下每个 token 包含一个字符）。这是一个保守的估计值，旨在防止上下文窗口溢出。
    maxTokensPerChunk: Integer;
    // 两个相邻分块之间的重叠词元数量上限。
	  maxOverlapTokens: Integer;
  published
    { published declarations }
  end;

implementation

end.
