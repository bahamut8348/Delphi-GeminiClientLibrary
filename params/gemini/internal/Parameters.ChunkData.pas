unit Parameters.ChunkData;

interface

uses
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement;

type
  TChunkData = class(TParameterReality)
  private
    FStringValue: String;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // The Chunk content as a string. The maximum number of tokens per chunk is 2043.
    property stringValue: String read FStringValue write FStringValue;
  published
    { published declarations }
  end;

implementation

end.
