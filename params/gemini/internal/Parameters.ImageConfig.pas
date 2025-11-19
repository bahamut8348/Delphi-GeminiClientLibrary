unit Parameters.ImageConfig;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/generate-content#ImageConfig
  图片生成功能的配置。
}
  TImageConfig = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 可选。要生成的图片的宽高比。支持的宽高比：1:1、2:3、3:2、3:4、4:3、9:16、16:9、21:9。
    // 如果未指定，模型将根据提供的任何参考图片选择默认宽高比。
    aspectRatio: String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;


implementation

uses
  Constants.ImagenEnumType;

{ TImageConfig }

constructor TImageConfig.Create();
begin
  inherited Create();
  Self.aspectRatio := IMAGEN_ASPECT_RATIO_1_1;
end;

destructor TImageConfig.Destroy();
begin
  Self.aspectRatio := '';
  inherited Destroy();
end;

end.
