unit Constants.MimeType;

interface

const

  {**
   * The IANA standard MIME type of the source data.
   *
   * https://ai.google.dev/api/rest/v1beta/Content#blob
   *}
  MIMETYPE_NONE                        = '';
  // Images
  MIMETYPE_IMAGE_PNG                   = 'image/png';
  MIMETYPE_IMAGE_JPEG                  = 'image/jpeg';
  MIMETYPE_IMAGE_HEIC                  = 'image/heic';
  MIMETYPE_IMAGE_HEIF                  = 'image/heif';
  MIMETYPE_IMAGE_WEBP                  = 'image/webp';

  // Audio
  MIMETYPE_AUDIO_WAV                   = 'audio/wav';
  MIMETYPE_AUDIO_MP3                   = 'audio/mp3';
  MIMETYPE_AUDIO_AIFF                  = 'audio/aiff';
  MIMETYPE_AUDIO_AAC                   = 'audio/aac';
  MIMETYPE_AUDIO_OGG                   = 'audio/ogg';
  MIMETYPE_AUDIO_FLAC                  = 'audio/flac';
  MIMETYPE_AUDIO_L16_PCM_RATE_24000    = 'audio/L16;codec=pcm;rate=24000';

  // Video
  MIMETYPE_VIDEO_MP4                   = 'video/mp4';
  MIMETYPE_VIDEO_MPEG                  = 'video/mpeg';
  MIMETYPE_VIDEO_MOV                   = 'video/mov';
  MIMETYPE_VIDEO_AVI                   = 'video/avi';
  MIMETYPE_VIDEO_FLV                   = 'video/x-flv';
  MIMETYPE_VIDEO_MPG                   = 'video/mpg';
  MIMETYPE_VIDEO_WEBM                  = 'video/webm';
  MIMETYPE_VIDEO_WMV                   = 'video/wmv';
  MIMETYPE_VIDEO_3GPP                  = 'video/3gpp';

  // Plain text
  MIMETYPE_TEXT_PLAIN                  = 'text/plain';
  MIMETYPE_TEXT_HTML                   = 'text/html';
  MIMETYPE_TEXT_CSS                    = 'text/css';
  MIMETYPE_TEXT_JAVASCRIPT             = 'text/javascript';
  MIMETYPE_APPLICATION_X_JAVASCRIPT    = 'application/x-javascript';
  MIMETYPE_TEXT_X_TYPESCRIPT           = 'text/x-typescript';
  MIMETYPE_APPLICATION_X_TYPESCRIPT    = 'application/x-typescript';
  MIMETYPE_TEXT_CSV                    = 'text/csv';
  MIMETYPE_TEXT_MARKDOWN               = 'text/markdown';
  MIMETYPE_TEXT_X_PYTHON               = 'text/x-python';
  MIMETYPE_APPLICATION_X_PYTHON_CODE   = 'application/x-python-code';
  MIMETYPE_APPLICATION_JSON            = 'application/json';
  MIMETYPE_TEXT_XML                    = 'text/xml';
  MIMETYPE_APPLICATION_RTF             = 'application/rtf';
  MIMETYPE_TEXT_RTF                    = 'text/rtf';

  // Pdf
  MIMETYPE_APPLICATION_PDF             = 'application/pdf';

implementation

end.
