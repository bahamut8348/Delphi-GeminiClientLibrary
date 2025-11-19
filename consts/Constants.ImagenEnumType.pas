unit Constants.ImagenEnumType;

interface

const
  { **
    * Imagen 接口使用的language选项值
    * }
  // 自动检测。如果 Imagen 检测到受支持的语言，会将提示和（可选）反向提示翻译为英语。如果检测到不受支持的语言，Imagen 会按原样使用输入文本，这可能会导致意外输出。系统不会返回错误代码。
  IMAGEN_LANGUAGE_AUTO                           = 'auto';
  // 英语（如果省略，则其为默认值）
  IMAGEN_LANGUAGE_EN                             = 'en';
  // 中文（简体）
  IMAGEN_LANGUAGE_ZH                             = 'zh';
  // 中文（简体）
  IMAGEN_LANGUAGE_ZH_CN                          = 'zh-CN';
  // 中文（繁体）
  IMAGEN_LANGUAGE_ZH_TW                          = 'zh-TW';
  // 印地语
  IMAGEN_LANGUAGE_HI                             = 'hi';
  // 日语
  IMAGEN_LANGUAGE_JA                             = 'ja';
  // 韩语
  IMAGEN_LANGUAGE_KO                             = 'ko';
  // 葡萄牙语
  IMAGEN_LANGUAGE_PT                             = 'pt';
  // 西班牙语
  IMAGEN_LANGUAGE_ES                             = 'es';

  { **
    * 允许模型生成人物。
    * }
  // 禁止在图片中包含人物或人脸。
  IMAGEN_PERSON_GENERATION_ALLOW_NONE            = 'dont_allow';
  // 默认值，仅允许生成成人
  IMAGEN_PERSON_GENERATION_ALLOW_ADULT           = 'allow_adult';
  // 允许生成任何年龄的人。
  IMAGEN_PERSON_GENERATION_ALLOW_ALL             = 'allow_all';

  { **
    * 为安全性过滤策略添加过滤级别。
    * }
  // 最强的过滤级别，采用最严苛的屏蔽策略。
  IMAGEN_SAFETY_SETTING_BLOCK_MOST               = 'block_most'; // 已弃用的值
  IMAGEN_SAFETY_SETTING_BLOCK_LOW_AND_ABOVE      = 'block_low_and_above';
  // 屏蔽部分有问题的提示和回答。
  IMAGEN_SAFETY_SETTING_BLOCK_SOME               = 'block_some'; // 已弃用的值
  IMAGEN_SAFETY_SETTING_BLOCK_MEDIUM_AND_ABOVE   = 'block_medium_and_above';
  // 默认值
  // 减少因安全性过滤机制而被屏蔽的请求数量。Imagen 生成的不良内容的数量可能会增加。
  IMAGEN_SAFETY_SETTING_BLOCK_FEW                = 'block_few'; // 已弃用的值
  IMAGEN_SAFETY_SETTING_BLOCK_ONLY_HIGH          = 'block_only_high';
  // 屏蔽极少数有问题的提示和回答。此功能的使用是有一定限制的。
  IMAGEN_SAFETY_SETTING_BLOCK_FEWEST             = 'block_fewest'; // 之前的字段值
  IMAGEN_SAFETY_SETTING_BLOCK_NONE               = 'block_none';

  { **
    * 指定生成的图片的输出分辨率。
    * }
  IMAGEN_SAMPLE_IMAGE_SIZE_1K                    = '1K'; // 默认值
  IMAGEN_SAMPLE_IMAGE_SIZE_2K                    = '2K';

  { **
    * 分辨率提升系数。
    * }
  IMAGEN_UPSCALE_FACTOR_X2                       = 'x2';
  IMAGEN_UPSCALE_FACTOR_X4                       = 'x4';

  { **
    * 生成图片的宽高比。支持的值包括 "1:1"、"3:4"、"4:3"、"9:16" 和 "16:9"。默认值为 "1:1"。
    * 要生成的图片的宽高比。支持的宽高比：1:1、2:3、3:2、3:4、4:3、9:16、16:9、21:9。
    * }
  IMAGEN_ASPECT_RATIO_1_1                        = '1:1';
  IMAGEN_ASPECT_RATIO_2_3                        = '2:3';
  IMAGEN_ASPECT_RATIO_3_2                        = '3:2';
  IMAGEN_ASPECT_RATIO_3_4                        = '3:4';
  IMAGEN_ASPECT_RATIO_4_3                        = '4:3';
  IMAGEN_ASPECT_RATIO_9_16                       = '9:16';
  IMAGEN_ASPECT_RATIO_16_9                       = '16:9';
  IMAGEN_ASPECT_RATIO_21_9                       = '21:9';

implementation

end.
