unit Constants.ContentType;

interface

const
  // https://zh.wikipedia.org/wiki/%E4%BA%92%E8%81%94%E7%BD%91%E5%AA%92%E4%BD%93%E7%B1%BB%E5%9E%8B
  // https://www.iana.org/assignments/media-types/media-types.xhtml

  { Type application 分别对于不同用途的文件： }
  // Atom feeds
  CONTENT_TYPE_APPLICATION_ATOM             = 'application/atom+xml';
  // ECMAScript/JavaScript;（相当于application/javascript但是严格的处理规则）
  CONTENT_TYPE_APPLICATION_ECMA             = 'application/ecmascript';
  // EDI ANSI ASC X12资料
  CONTENT_TYPE_APPLICATION_EDI_X12          = 'application/EDI-X12';
  // EDI EDIFACT资料
  CONTENT_TYPE_APPLICATION_EDIFACT          = 'application/EDIFACT';
  // JSON（JavaScript Object Notation）
  CONTENT_TYPE_APPLICATION_JSON             = 'application/json';
  // ECMAScript/JavaScript（相当于application/ecmascript但是宽松的处理规则）它不被IE 8或更早之前的版本所支持。
  // 虽然可以改用text/javascript，但它却被RFC 4329定义为过时。
  // 在HTML5之中，<script>标签的type的属性是可省略的，因为所有的浏览器即使在HTML5以前都一直默认使用JavaScript。
  CONTENT_TYPE_APPLICATION_JAVASCRIPT       = 'application/javascript';
  // 任意的二进制文件（通常做为通知浏览器下载文件）一般来说，这种类型标识的文件不应该与特定应用程序关联。
  // 与Apache等软件包过去的假设相反，这种类型不应该应用于未知文件。
  // 在这种情况下，服务器或应用程序不应指示内容类型，因为这可能是不正确的，而应该省略类型，以便让接收者猜测类型。
  CONTENT_TYPE_APPLICATION_OCTET_STREAM     = 'application/octet-stream';
  // application/octet-stream 用于文件下载。
  CONTENT_TYPE_MULTIPART_FORM_DATA          = 'multipart/form-data';
  // multipart/form-data 用于文件上传。
  // OGG 视频文件格式
  CONTENT_TYPE_APPLICATION_OGG              = 'application/ogg';
  // PDF
  CONTENT_TYPE_APPLICATION_PDF              = 'application/pdf';
  // PostScript
  CONTENT_TYPE_APPLICATION_POSTSCRIPT       = 'application/postscript';
  // Resource Description Framework
  CONTENT_TYPE_APPLICATION_RDF              = 'application/rdf+xml';
  // RSS feeds
  CONTENT_TYPE_APPLICATION_RSS              = 'application/rss+xml';
  // SOAP
  CONTENT_TYPE_APPLICATION_SOAP             = 'application/soap+xml';
  // Web Open Font Format（推荐使用；使用application/x-font-woff直到它变为官方标准）
  CONTENT_TYPE_APPLICATION_FONT_WOFF        = 'application/font-woff';
  CONTENT_TYPE_APPLICATION_X_FONT_WOFF      = 'application/x-font-woff';
  // XHTML
  CONTENT_TYPE_APPLICATION_XHTML            = 'application/xhtml+xml';
  // XML文件
  CONTENT_TYPE_APPLICATION_XML              = 'application/xml';
  // 文件
  CONTENT_TYPE_APPLICATION_DTD              = 'application/xml-dtd';
  // XML-binary Optimized Packaging
  CONTENT_TYPE_APPLICATION_XOP              = 'application/xop+xml';
  // ZIP压缩包
  CONTENT_TYPE_APPLICATION_ZIP              = 'application/zip';
  // GZIP
  CONTENT_TYPE_APPLICATION_GZIP             = 'application/gzip';

  { Type audio 数字音频文件： }
  // MP4 音频档案
  CONTENT_TYPE_AUDIO_MP4                    = 'audio/mp4';
  // MP3 或其他 MPEG 音频档案
  CONTENT_TYPE_AUDIO_MP3                    = 'audio/mpeg';
  // OGG 音频档案
  CONTENT_TYPE_AUDIO_OGG                    = 'audio/ogg';
  // Vorbis 音频档案
  CONTENT_TYPE_AUDIO_VORBIS                 = 'audio/vorbis';
  // RealAudio 音频档案
  CONTENT_TYPE_AUDIO_REALAUDIO              = 'audio/vnd.rn-realaudio';
  // WAV 音频档案
  CONTENT_TYPE_AUDIO_WAV                    = 'audio/vnd.wave';
  // WebM 音频档案
  CONTENT_TYPE_AUDIO_WEBM                   = 'audio/webm';
  // FLAC 音频档案
  CONTENT_TYPE_AUDIO_FLAC                   = 'audio/flac';

  { Type image 图像文件： }
  // GIF 图像文件
  CONTENT_TYPE_IMAGE_GIF                    = 'image/gif';
  // JPEG 图像文件
  CONTENT_TYPE_IMAGE_JPG                    = 'image/jpeg';
  CONTENT_TYPE_IMAGE_JPEG                   = 'image/jpeg';
  // PNG 图像文件
  CONTENT_TYPE_IMAGE_PNG                    = 'image/png';
  // WebP 图像文件
  CONTENT_TYPE_IMAGE_WEBP                   = 'image/webp';
  // SVG 向量图像文件
  CONTENT_TYPE_IMAGE_SVG                    = 'image/svg+xml';
  // TIFF 图像文件
  CONTENT_TYPE_IMAGE_TIF                    = 'image/tiff';
  CONTENT_TYPE_IMAGE_TIFF                   = 'image/tiff';
  // ICO 图片文件
  CONTENT_TYPE_IMAGE_ICO                    = 'image/icon';
  CONTENT_TYPE_IMAGE_ICON                   = 'image/icon';

  { Type message、Type model 三维计算机图形文件： }
  // example
  CONTENT_TYPE_MODEL_EXAMPLE                = 'model/example';
  // IGS 文件，IGES 文件
  CONTENT_TYPE_MODEL_IGS                    = 'model/iges';
  CONTENT_TYPE_MODEL_IGES                   = 'model/iges';
  // MSH 文件，MESH 文件
  CONTENT_TYPE_MODEL_MSH                    = 'model/mesh';
  CONTENT_TYPE_MODEL_MESH                   = 'model/mesh';
  // WRL 文件，VRML 文件
  CONTENT_TYPE_MODEL_WRL                    = 'model/vrml';
  CONTENT_TYPE_MODEL_VRML                   = 'model/vrml';
  // X3D ISO 标准，用于表示三维计算机图形、X3DB 二进制文件
  CONTENT_TYPE_MODEL_X3D_BINARY             = 'model/x3d+binary';
  // X3D ISO 标准，用于表示三维计算机图形、X3DB VRML文件
  CONTENT_TYPE_MODEL_X3D_VRML               = 'model/x3d+vrml';
  // X3D ISO 标准，用于表示三维计算机图形、X3DB XML 文件
  CONTENT_TYPE_MODEL_X3D_XML                = 'model/x3d+xml';

  { Type multipart、Type text： }
  // CSS 文件
  CONTENT_TYPE_TEXT_CSS                     = 'text/css';
  // CSV 文件
  CONTENT_TYPE_TEXT_CSV                     = 'text/csv';
  // HTML 文件
  CONTENT_TYPE_TEXT_HTML                    = 'text/html';
  // JavaScript （过时）;
  // 在 RFC 4329 中定义并舍弃，以减少使用，推荐使用 application/javascript。
  // 然而，相比于 application/javascript，在 HTML 4 和 5 中，可以使用text/javascript，且有跨浏览器的支持。
  // 因为在使用 <script> 时，对于其 "type" 属性 ，所有浏览器都会使用正确的默认值（尽管 HTML 4 的规格中明确要求），所以 HTML 5 中定义为选择性的，且没必要。
  CONTENT_TYPE_TEXT_JAVASCRIPT              = 'text/javascript';
  // 纯文字内容
  CONTENT_TYPE_TEXT_PLAIN                   = 'text/plain';
  // vCard（电子名片）
  CONTENT_TYPE_TEXT_VCARD                   = 'text/vcard';
  // XML
  CONTENT_TYPE_TEXT_XML                     = 'text/xml';

  { Type video 视频文件格式文件（可能包含数字视频与数字音频） }
  // MPEG-1 视频文件
  CONTENT_TYPE_VIDEO_MPEG                   = 'video/mpeg';
  // MP4 视频文件
  CONTENT_TYPE_VIDEO_MP4                    = 'video/mp4';
  // OGG 视频文件
  CONTENT_TYPE_VIDEO_OGG                    = 'video/ogg';
  // QuickTime 视频文件
  CONTENT_TYPE_VIDEO_QUICKTIME              = 'video/quicktime';
  // WebM 视频文件（基于Matroska基础）
  CONTENT_TYPE_VIDEO_WEBM                   = 'video/webm';
  // Matroska （多媒体封装格式）
  CONTENT_TYPE_VIDEO_MATROSKA               = 'video/x-matroska';
  // Windows Media Video 视频文件
  CONTENT_TYPE_VIDEO_WMV                    = 'video/x-ms-wmv';
  // Flash Video
  CONTENT_TYPE_VIDEO_FLV                    = 'video/x-flv';

  { charset }
  // https://www.iana.org/assignments/character-sets/character-sets.xhtml
  CONTENT_TYPE_UTF_1                        = 'charset="ISO-10646-UTF-1"';
  CONTENT_TYPE_UNICODE_7                    = 'charset="UNICODE-1-1-UTF-7"';
  CONTENT_TYPE_UTF_7                        = 'charset="UTF-7"';
  CONTENT_TYPE_UTF_8                        = 'charset="UTF-8"';
  CONTENT_TYPE_UTF_16                       = 'charset="UTF-16"';
  CONTENT_TYPE_UTF_32                       = 'charset="UTF-32"';
  CONTENT_TYPE_UTF_16BE                     = 'charset="UTF-16BE"';
  CONTENT_TYPE_UTF_16LE                     = 'charset="UTF-16LE"';
  CONTENT_TYPE_UTF_32BE                     = 'charset="UTF-32BE"';
  CONTENT_TYPE_UTF_32LE                     = 'charset="UTF-32LE"';
  CONTENT_TYPE_UCS_BASIC                    = 'charset="ISO-10646-UCS-Basic"';
  CONTENT_TYPE_UCS_2                        = 'charset="ISO-10646-UCS-2"';
  CONTENT_TYPE_UCS_4                        = 'charset="ISO-10646-UCS-4"';

implementation

end.
