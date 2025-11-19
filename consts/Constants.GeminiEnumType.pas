unit Constants.GeminiEnumType;

interface

const
  { **
    * https://ai.google.dev/api/caching#Language
    * GEMINI_LANGUAGE
    * 语言
    * 生成代码支持的编程语言。
    * }
  // 未指定语言。请勿使用此值。
  GEMINI_LANGUAGE_UNSPECIFIED                    = 'LANGUAGE_UNSPECIFIED';
  // Python >= 3.10，且提供 numpy 和 simpy。
  GEMINI_LANGUAGE_PYTHON                         = 'PYTHON';

  { **
    * https://ai.google.dev/api/caching#Outcome
    * GEMINI_OUTCOME
    * 结果
    * 代码执行的可能结果的枚举。
    * }
  // 未指定状态。请勿使用此值。
  GEMINI_OUTCOME_UNSPECIFIED                     = 'OUTCOME_UNSPECIFIED';
  // 代码已成功执行完毕。
  GEMINI_OUTCOME_OK                              = 'OUTCOME_OK';
  // 代码执行已完成，但失败了。stderr 应包含原因。
  GEMINI_OUTCOME_FAILED                          = 'OUTCOME_FAILED';
  // 代码执行运行时间过长，已被取消。可能存在部分输出，也可能不存在。
  GEMINI_OUTCOME_DEADLINE_EXCEEDED               = 'OUTCOME_DEADLINE_EXCEEDED';

  { **
    * https://ai.google.dev/api/caching#Scheduling
    * GEMINI_SCHEDULING
    * 时间安排
    * 指定在对话中如何安排响应。
    * }
  // 此值未使用。
  GEMINI_SCHEDULING_UNSPECIFIED                  = 'SCHEDULING_UNSPECIFIED';
  // 仅将结果添加到对话上下文，不中断或触发生成。
  GEMINI_SCHEDULING_SILENT                       = 'SILENT';
  // 将结果添加到对话上下文，并提示生成输出，而不会中断正在进行的生成。
  GEMINI_SCHEDULING_WHEN_IDLE                    = 'WHEN_IDLE';
  // 将结果添加到对话上下文，中断正在进行的生成操作，并提示生成输出。
  GEMINI_SCHEDULING_INTERRUPT                    = 'INTERRUPT';

  { **
    * https://ai.google.dev/api/caching#Type
    * GEMINI_TYPE
    * 类型
    * 类型包含 OpenAPI 数据类型列表，如 https://spec.openapis.org/oas/v3.0.3#data-types 中所定义
    * }
  // 未指定，不应使用。
  GEMINI_TYPE_UNSPECIFIED                        = 'TYPE_UNSPECIFIED';
  // 字符串类型。
  GEMINI_TYPE_STRING                             = 'STRING';
  // 号码类型。
  GEMINI_TYPE_NUMBER                             = 'NUMBER';
  // 整数类型。
  GEMINI_TYPE_INTEGER                            = 'INTEGER';
  // 布尔值类型。
  GEMINI_TYPE_BOOLEAN                            = 'BOOLEAN';
  // 数组类型。
  GEMINI_TYPE_ARRAY                              = 'ARRAY';
  // 对象类型。
  GEMINI_TYPE_OBJECT                             = 'OBJECT';
  // Null 类型。
  GEMINI_TYPE_NULL                               = 'NULL';

  { **
    * https://ai.google.dev/api/caching#Behavior
    * GEMINI_BEHAVIOR
    * 行为
    * 定义函数行为。默认为 BLOCKING。
    * }
  // 此值未使用。
  GEMINI_BEHAVIOR_UNSPECIFIED                    = 'UNSPECIFIED';
  // 如果设置，系统将等待接收函数响应，然后再继续对话。
  GEMINI_BEHAVIOR_BLOCKING                       = 'BLOCKING';
  // 如果设置，系统将不会等待接收函数响应。相反，它会尝试在函数响应可用时处理这些响应，同时保持用户与模型之间的对话。
  GEMINI_BEHAVIOR_NON_BLOCKING                   = 'NON_BLOCKING';

  { **
    * https://ai.google.dev/api/caching#Mode
    * GEMINI_MODE
    * 模式
    * 要在动态检索中使用的预测器的模式。
    * }
  // 始终触发检索。
  GEMINI_MODE_UNSPECIFIED                        = 'MODE_UNSPECIFIED';
  // 仅在系统认为必要时运行检索。
  GEMINI_MODE_DYNAMIC                            = 'MODE_DYNAMIC';

  { **
    * https://ai.google.dev/api/caching#Mode_1
    * GEMINI_MODE
    * 模式
    * 通过定义执行模式来定义函数调用的执行行为。
    * }
  // 未指定函数调用模式。请勿使用此值。
  // GEMINI_MODE_UNSPECIFIED                       = 'MODE_UNSPECIFIED';
  // 默认模型行为，模型决定预测函数调用或自然语言回答。
  GEMINI_MODE_AUTO                               = 'AUTO';
  // 模型会受到限制，始终仅预测函数调用。如果设置了“allowedFunctionNames”，预测的函数调用将仅限于“allowedFunctionNames”中的任何一个；否则，预测的函数调用将是所提供的“functionDeclarations”中的任何一个。
  GEMINI_MODE_ANY                                = 'ANY';
  // 模型不会预测任何函数调用。模型行为与不传递任何函数声明时相同。
  GEMINI_MODE_NONE                               = 'NONE';
  // 模型决定预测函数调用或自然语言回答，但会通过受限解码来验证函数调用。如果设置了“allowedFunctionNames”，预测的函数调用将仅限于“allowedFunctionNames”中的任何一个；否则，预测的函数调用将是所提供的“functionDeclarations”中的任何一个。
  GEMINI_MODE_VALIDATED                          = 'VALIDATED';

  { **
    * https://ai.google.dev/api/generate-content#v1beta.HarmCategory
    * GEMINI_HARMCATEGORY
    * 评分的类别。
    * 这些类别涵盖了开发者可能希望调整的各种类型的危害。
    * }
  // 未指定类别。
  GEMINI_HARM_CATEGORY_UNSPECIFIED               = 'HARM_CATEGORY_UNSPECIFIED';
  // PaLM - 针对身份和/或受保护属性的负面或有害评论。
  GEMINI_HARM_CATEGORY_DEROGATORY                = 'HARM_CATEGORY_DEROGATORY';
  // PaLM - 粗鲁、无礼或亵渎性的内容。
  GEMINI_HARM_CATEGORY_TOXICITY                  = 'HARM_CATEGORY_TOXICITY';
  // PaLM - 描述描绘针对个人或团体的暴力行为的场景，或一般性血腥描述。
  GEMINI_HARM_CATEGORY_VIOLENCE                  = 'HARM_CATEGORY_VIOLENCE';
  // PaLM - 包含对性行为或其他淫秽内容的引用。
  GEMINI_HARM_CATEGORY_SEXUAL                    = 'HARM_CATEGORY_SEXUAL';
  // PaLM - 宣传未经核实的医疗建议。
  GEMINI_HARM_CATEGORY_MEDICAL                   = 'HARM_CATEGORY_MEDICAL';
  // PaLM - 宣扬、助长或鼓励有害行为的危险内容。
  GEMINI_HARM_CATEGORY_DANGEROUS                 = 'HARM_CATEGORY_DANGEROUS';
  // Gemini - 骚扰内容。
  GEMINI_HARM_CATEGORY_HARASSMENT                = 'HARM_CATEGORY_HARASSMENT';
  // Gemini - 仇恨言论和内容。
  GEMINI_HARM_CATEGORY_HATE_SPEECH               = 'HARM_CATEGORY_HATE_SPEECH';
  // Gemini - 露骨色情内容。
  GEMINI_HARM_CATEGORY_SEXUALLY_EXPLICIT         = 'HARM_CATEGORY_SEXUALLY_EXPLICIT';
  // Gemini - 危险内容。
  GEMINI_HARM_CATEGORY_DANGEROUS_CONTENT         = 'HARM_CATEGORY_DANGEROUS_CONTENT';
  // Gemini - 可能被用于损害公民诚信的内容。已弃用：请改用 enableEnhancedCivicAnswers。【??此项已弃用！】
  GEMINI_HARM_CATEGORY_CIVIC_INTEGRITY           = 'HARM_CATEGORY_CIVIC_INTEGRITY';

  { **
    * https://ai.google.dev/api/generate-content#HarmProbability
    * GEMINI_HARM_PROBABILITY
    * HarmProbability
    * 内容有害的概率。
    * 分类系统会给出内容不安全的概率。这并不表示内容造成的伤害程度。
    * }
  // 概率未指定。
  GEMINI_HARM_PROBABILITY_UNSPECIFIED            = 'HARM_PROBABILITY_UNSPECIFIED';
  // 内容不安全的概率可忽略不计。
  GEMINI_HARM_PROBABILITY_NEGLIGIBLE             = 'NEGLIGIBLE';
  // 内容不安全的概率较低。
  GEMINI_HARM_PROBABILITY_LOW                    = 'LOW';
  // 内容不安全的可能性为中等。
  GEMINI_HARM_PROBABILITY_MEDIUM                 = 'MEDIUM';
  // 内容不安全的概率较高。
  GEMINI_HARM_PROBABILITY_HIGH                   = 'HIGH';

  { **
    * https://ai.google.dev/api/generate-content#HarmBlockThreshold
    * GEMINI_HARM_BLOCK
    * HarmBlockThreshold
    * 在达到或超过指定有害概率时进行屏蔽。
    * }
  // 未指定阈值。
  GEMINI_HARM_BLOCK_THRESHOLD_UNSPECIFIED        = 'HARM_BLOCK_THRESHOLD_UNSPECIFIED';
  // 内容中包含“可忽略”的性暗示内容将获准投放广告。
  GEMINI_HARM_BLOCK_LOW_AND_ABOVE                = 'BLOCK_LOW_AND_ABOVE';
  // 系统会允许发布风险为“可忽略”和“低”的内容。
  GEMINI_HARM_BLOCK_MEDIUM_AND_ABOVE             = 'BLOCK_MEDIUM_AND_ABOVE';
  // 内容风险为“可忽略”“低”和“中”时，将允许发布。
  GEMINI_HARM_BLOCK_HIGH                         = 'BLOCK_ONLY_HIGH';
  // 允许所有内容。
  GEMINI_HARM_BLOCK_NONE                         = 'BLOCK_NONE';
  // 关闭安全过滤条件。
  GEMINI_HARM_BLOCK_OFF                          = 'OFF';

  { **
    * https://ai.google.dev/api/generate-content#Modality
    * GEMINI_MODALITY
    * 模态
    * 支持的响应模态。
    * }
  // 默认值。
  GEMINI_MODALITY_UNSPECIFIED                    = 'MODALITY_UNSPECIFIED';
  // 表示模型应返回文本。
  GEMINI_MODALITY_TEXT                           = 'TEXT';
  // 表示模型应返回图片。
  GEMINI_MODALITY_IMAGE                          = 'IMAGE';
  // 表示模型应返回音频。
  GEMINI_MODALITY_AUDIO                          = 'AUDIO';

  { **
    * https://ai.google.dev/api/generate-content#MediaResolution
    * GEMINI_MEDIA_RESOLUTION
    * MediaResolution
    * 输入媒体的媒体分辨率。
    * }
  // 媒体分辨率尚未设置。
  GEMINI_MEDIA_RESOLUTION_UNSPECIFIED            = 'MEDIA_RESOLUTION_UNSPECIFIED';
  // 媒体分辨率设置为低（64 个 token）。
  GEMINI_MEDIA_RESOLUTION_LOW                    = 'MEDIA_RESOLUTION_LOW';
  // 媒体分辨率设置为中等（256 个 token）。
  GEMINI_MEDIA_RESOLUTION_MEDIUM                 = 'MEDIA_RESOLUTION_MEDIUM';
  // 媒体分辨率设置为高（缩放重构，使用 256 个 token）。
  GEMINI_MEDIA_RESOLUTION_HIGH                   = 'MEDIA_RESOLUTION_HIGH';

  { **
    * https://ai.google.dev/api/generate-content#UrlRetrievalStatus
    * GEMINI_URL_RETRIEVAL_STATUS
    * UrlRetrievalStatus
    * 网址检索的状态。
    * }
  // 默认值。此值未使用。
  GEMINI_URL_RETRIEVAL_STATUS_UNSPECIFIED        = 'URL_RETRIEVAL_STATUS_UNSPECIFIED';
  // 网址检索成功。
  GEMINI_URL_RETRIEVAL_STATUS_SUCCESS            = 'URL_RETRIEVAL_STATUS_SUCCESS';
  // 由于出错，网址检索失败。
  GEMINI_URL_RETRIEVAL_STATUS_ERROR              = 'URL_RETRIEVAL_STATUS_ERROR';
  // 由于内容受付费墙保护，网址检索失败。
  GEMINI_URL_RETRIEVAL_STATUS_PAYWALL            = 'URL_RETRIEVAL_STATUS_PAYWALL';
  // 由于内容不安全，网址检索失败。
  GEMINI_URL_RETRIEVAL_STATUS_UNSAFE             = 'URL_RETRIEVAL_STATUS_UNSAFE';

  { **
    * https://ai.google.dev/api/generate-content#BlockReason
    * GEMINI_BLOCK_REASON
    * BlockReason
    * 指定屏蔽提示的原因。
    * }
  // 默认值。此值未使用。
  GEMINI_BLOCK_REASON_UNSPECIFIED                = 'BLOCK_REASON_UNSPECIFIED';
  // 出于安全原因，系统屏蔽了相应提示。检查 safetyRatings 以了解是哪个安全类别屏蔽了它。
  GEMINI_BLOCK_REASON_SAFETY                     = 'SAFETY';
  // 提示因未知原因被屏蔽。
  GEMINI_BLOCK_REASON_OTHER                      = 'OTHER';
  // 提示因包含术语屏蔽名单中的术语而被屏蔽。
  GEMINI_BLOCK_REASON_BLOCKLIST                  = 'BLOCKLIST';
  // 提示因包含禁止的内容而被屏蔽。
  GEMINI_BLOCK_REASON_PROHIBITED_CONTENT         = 'PROHIBITED_CONTENT';
  // 因生成不安全的图片内容而屏蔽了候选回答。
  GEMINI_BLOCK_REASON_IMAGE_SAFETY               = 'IMAGE_SAFETY';

  // 角色：用户
  GEMINI_ROLE_USER                               = 'user';
  // 角色：系统
  GEMINI_ROLE_MODEL                              = 'model';

  { **
    * https://ai.google.dev/api/generate-content#SpeechConfig
    * 语言代码（采用 BCP 47 格式，例如“en-US”）
    * }
  GEMINI_LANGUAGE_CODE_DE_DE                     = 'de-DE';
  GEMINI_LANGUAGE_CODE_EN_AU                     = 'en-AU';
  GEMINI_LANGUAGE_CODE_EN_GB                     = 'en-GB';
  GEMINI_LANGUAGE_CODE_EN_IN                     = 'en-IN';
  GEMINI_LANGUAGE_CODE_EN_US                     = 'en-US';
  GEMINI_LANGUAGE_CODE_ES_US                     = 'es-US';
  GEMINI_LANGUAGE_CODE_FR_FR                     = 'fr-FR';
  GEMINI_LANGUAGE_CODE_HI_IN                     = 'hi-IN';
  GEMINI_LANGUAGE_CODE_PT_BR                     = 'pt-BR';
  GEMINI_LANGUAGE_CODE_AR_XA                     = 'ar-XA';
  GEMINI_LANGUAGE_CODE_ES_ES                     = 'es-ES';
  GEMINI_LANGUAGE_CODE_FR_CA                     = 'fr-CA';
  GEMINI_LANGUAGE_CODE_ID_ID                     = 'id-ID';
  GEMINI_LANGUAGE_CODE_IT_IT                     = 'it-IT';
  GEMINI_LANGUAGE_CODE_JA_JP                     = 'ja-JP';
  GEMINI_LANGUAGE_CODE_TR_TR                     = 'tr-TR';
  GEMINI_LANGUAGE_CODE_VI_VN                     = 'vi-VN';
  GEMINI_LANGUAGE_CODE_BN_IN                     = 'bn-IN';
  GEMINI_LANGUAGE_CODE_GU_IN                     = 'gu-IN';
  GEMINI_LANGUAGE_CODE_KN_IN                     = 'kn-IN';
  GEMINI_LANGUAGE_CODE_ML_IN                     = 'ml-IN';
  GEMINI_LANGUAGE_CODE_MR_IN                     = 'mr-IN';
  GEMINI_LANGUAGE_CODE_TA_IN                     = 'ta-IN';
  GEMINI_LANGUAGE_CODE_TE_IN                     = 'te-IN';
  GEMINI_LANGUAGE_CODE_NL_NL                     = 'nl-NL';
  GEMINI_LANGUAGE_CODE_KO_KR                     = 'ko-KR';
  GEMINI_LANGUAGE_CODE_CMN_CN                    = 'cmn-CN';
  GEMINI_LANGUAGE_CODE_PL_PL                     = 'pl-PL';
  GEMINI_LANGUAGE_CODE_RU_RU                     = 'ru-RU';
  GEMINI_LANGUAGE_CODE_TH_TH                     = 'th-TH';

  { **
    * https://ai.google.dev/api/files#State
    * 文件生命周期的状态。
    * }
  // 默认值。如果省略状态，则使用此值。
  GEMINI_FILE_STATE_UNSPECIFIED                  = 'STATE_UNSPECIFIED';
  // 文件正在处理中，尚无法用于推理。
  GEMINI_FILE_STATE_PROCESSING                   = 'PROCESSING';
  // 文件已处理完毕，可用于推理。
  GEMINI_FILE_STATE_ACTIVE                       = 'ACTIVE';
  // 文件处理失败。
  GEMINI_FILE_STATE_FAILED                       = 'FAILED';

  { **
    * https://ai.google.dev/api/files#Source
    * 文件来源
    * }
  // 如果未指定来源，则使用此值。
  GEMINI_FILE_SOURCE_UNSPECIFIED                 = 'SOURCE_UNSPECIFIED';
  // 表示文件由用户上传。
  GEMINI_FILE_SOURCE_UPLOADED                    = 'UPLOADED';
  // 表示相应文件由 Google 生成。
  GEMINI_FILE_SOURCE_GENERATED                   = 'GENERATED';
  // 表示相应文件是已注册的文件，即 Google Cloud Storage 文件。
  GEMINI_FILE_SOURCE_REGISTERED                  = 'REGISTERED';

  { **
    * https://ai.google.dev/api/file-search/documents#State
    * Document 生命周期中的状态。
    * }
  // 默认值。如果省略状态，则使用此值。
  GEMINI_DOCUMENT_STATE_UNSPECIFIED              = 'STATE_UNSPECIFIED';
  // 部分 Document 正在处理（嵌入和向量存储）。Chunks
  GEMINI_DOCUMENT_STATE_PENDING                  = 'STATE_PENDING';
  // Document 的所有 Chunks 都已处理完毕，可供查询。
  GEMINI_DOCUMENT_STATE_ACTIVE                   = 'STATE_ACTIVE';
  // 部分 Document 的 Chunks 处理失败。
  GEMINI_DOCUMENT_STATE_FAILED                   = 'STATE_FAILED';

  { **
    * https://ai.google.dev/api/batch-api#batchstate
    * 批次的状态。
    * }
  // 未指定批处理状态。
  GEMINI_BATCH_STATE_UNSPECIFIED                 = 'BATCH_STATE_UNSPECIFIED';
  // 服务正在准备运行批处理。
  GEMINI_BATCH_STATE_PENDING                     = 'BATCH_STATE_PENDING';
  // 批次正在进行中。
  GEMINI_BATCH_STATE_RUNNING                     = 'BATCH_STATE_RUNNING';
  // 相应批次已成功完成。
  GEMINI_BATCH_STATE_SUCCEEDED                   = 'BATCH_STATE_SUCCEEDED';
  // 批次失败。
  GEMINI_BATCH_STATE_FAILED                      = 'BATCH_STATE_FAILED';
  // 批次已取消。
  GEMINI_BATCH_STATE_CANCELLED                   = 'BATCH_STATE_CANCELLED';
  // 相应批次已过期。
  GEMINI_BATCH_STATE_EXPIRED                     = 'BATCH_STATE_EXPIRED';


  //
  GEMINI_CHUNK_STATE_UNSPECIFIED                 = 'STATE_UNSPECIFIED';
  GEMINI_CHUNK_STATE_PENDING_PROCESSING          = 'STATE_PENDING_PROCESSING';
  GEMINI_CHUNK_STATE_ACTIVE                      = 'STATE_ACTIVE';
  GEMINI_CHUNK_STATE_FAILED                      = 'STATE_FAILED';


  { **
    * https://ai.google.dev/api/embeddings#tasktype
    * 将使用嵌入的任务类型。
    * }
  // 未设置值，将默认为其他枚举值之一。
  GEMINI_TASK_TYPE_UNSPECIFIED                   = 'TASK_TYPE_UNSPECIFIED';
  // 在搜索/检索设置中指定给定文本是查询。
  GEMINI_TASK_TYPE_RETRIEVAL_QUERY               = 'RETRIEVAL_QUERY';
  // 指定给定文本是正在搜索的语料库中的文档。
  GEMINI_TASK_TYPE_RETRIEVAL_DOCUMENT            = 'RETRIEVAL_DOCUMENT';
  // 指定给定文本用于 STS。
  GEMINI_TASK_TYPE_SEMANTIC_SIMILARITY           = 'SEMANTIC_SIMILARITY';
  // 指定将对给定的文本进行分类。
  GEMINI_TASK_TYPE_CLASSIFICATION                = 'CLASSIFICATION';
  // 指定嵌入用于聚类。
  GEMINI_TASK_TYPE_CLUSTERING                    = 'CLUSTERING';
  // 指定给定文本用于问答。
  GEMINI_TASK_TYPE_QUESTION_ANSWERING            = 'QUESTION_ANSWERING';
  // 指定给定文本将用于事实核查。
  GEMINI_TASK_TYPE_FACT_VERIFICATION             = 'FACT_VERIFICATION';
  // 指定给定文本将用于代码检索。
  GEMINI_TASK_TYPE_CODE_RETRIEVAL_QUERY          = 'CODE_RETRIEVAL_QUERY';


  {**
    * https://ai.google.dev/api/generate-content#FinishReason
    * 定义模型停止生成词元的原因。
    *}
  // 默认值。此值未使用。
  GEMINI_FINISH_REASON_FINISH_REASON_UNSPECIFIED = 'FINISH_REASON_UNSPECIFIED';
  // 模型的自然停止点或提供的停止序列。
  GEMINI_FINISH_REASON_STOP                      = 'STOP';
  // 已达到请求中指定的 token 数量上限。
  GEMINI_FINISH_REASON_MAX_TOKENS                = 'MAX_TOKENS';
  // 出于安全原因，系统标记了候选回答内容。
  GEMINI_FINISH_REASON_SAFETY                    = 'SAFETY';
  // 回答候选内容因背诵原因而被标记。
  GEMINI_FINISH_REASON_RECITATION                = 'RECITATION';
  // 系统标记了候选回答内容，原因是其中使用了不支持的语言。
  GEMINI_FINISH_REASON_LANGUAGE                  = 'LANGUAGE';
  // 原因未知。
  GEMINI_FINISH_REASON_OTHER                     = 'OTHER';
  // 由于内容包含禁用词，因此 token 生成操作已停止。
  GEMINI_FINISH_REASON_BLOCKLIST                 = 'BLOCKLIST';
  // 由于可能包含禁止的内容，因此 token 生成操作已停止。
  GEMINI_FINISH_REASON_PROHIBITED_CONTENT        = 'PROHIBITED_CONTENT';
  // 由于内容可能包含敏感的个人身份信息 (SPII)，因此 token 生成操作已停止。
  GEMINI_FINISH_REASON_SPII                      = 'SPII';
  // 模型生成的函数调用无效。
  GEMINI_FINISH_REASON_MALFORMED_FUNCTION_CALL   = 'MALFORMED_FUNCTION_CALL';
  // 由于生成的图片包含违规内容，因此 token 生成已停止。
  GEMINI_FINISH_REASON_IMAGE_SAFETY              = 'IMAGE_SAFETY';
  // 图片生成已停止，因为生成的图片包含其他禁止的内容。
  GEMINI_FINISH_REASON_IMAGE_PROHIBITED_CONTENT  = 'IMAGE_PROHIBITED_CONTENT';
  // 由于其他杂项问题，图片生成已停止。
  GEMINI_FINISH_REASON_IMAGE_OTHER               = 'IMAGE_OTHER';
  // 模型本应生成图片，但却未生成任何图片。
  GEMINI_FINISH_REASON_NO_IMAGE                  = 'NO_IMAGE';
  // 由于存在重复内容，图片生成操作已停止。
  GEMINI_FINISH_REASON_IMAGE_RECITATION          = 'IMAGE_RECITATION';
  // 模型生成了工具调用，但请求中未启用任何工具。
  GEMINI_FINISH_REASON_UNEXPECTED_TOOL_CALL      = 'UNEXPECTED_TOOL_CALL';
  // 模型连续调用了过多的工具，因此系统退出了执行。
  GEMINI_FINISH_REASON_TOO_MANY_TOOL_CALLS       = 'TOO_MANY_TOOL_CALLS';



{**
 * https://ai.google.dev/api/caching#Environment
 * 表示正在运行的环境，例如 Web 浏览器。
 *}
  // 默认为浏览器。
  GEMINI_ENVIRONMENT_UNSPECIFIED                 = 'ENVIRONMENT_UNSPECIFIED';
  // 在网络浏览器中运行。
  GEMINI_ENVIRONMENT_BROWSER                     = 'ENVIRONMENT_BROWSER';

{
}
  GEMINI_CONDITION_OPERATOR_UNSPECIFIED          = 'OPERATOR_UNSPECIFIED';
  GEMINI_CONDITION_OPERATOR_LESS                 = 'LESS';
  GEMINI_CONDITION_OPERATOR_LESS_EQUAL           = 'LESS_EQUAL';
  GEMINI_CONDITION_OPERATOR_EQUAL                = 'EQUAL';
  GEMINI_CONDITION_OPERATOR_GREATER_EQUAL        = 'GREATER_EQUAL';
  GEMINI_CONDITION_OPERATOR_GREATER              = 'GREATER';
  GEMINI_CONDITION_OPERATOR_NOT_EQUAL            = 'NOT_EQUAL';
  GEMINI_CONDITION_OPERATOR_INCLUDES             = 'INCLUDES';
  GEMINI_CONDITION_OPERATOR_EXCLUDES             = 'EXCLUDES';

implementation

end.
