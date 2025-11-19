unit Constants.RequestMethod;

interface

const
  {**
   * 基本请求类型
   *}
  REQUESTMETHOD_TCP                    = 'TCP';
  REQUESTMETHOD_UDP                    = 'UDP';

  {**
   * HTTP请求类型
   *}
  // HTTP1.0中定义了三种请求的方法：GET、POST、HEAD方法；
  REQUESTMETHOD_HTTP_GET               = 'GET';
  REQUESTMETHOD_HTTP_POST              = 'POST';
  REQUESTMETHOD_HTTP_HEAD              = 'HEAD';

  // HTTP1.1中新增了六种请求方法：OPTIONS、PUT、PATCH、DELETE、TRACE和CONNECT方法。
  REQUESTMETHOD_HTTP_OPTIONS           = 'OPTIONS';
  REQUESTMETHOD_HTTP_PUT               = 'PUT';
  REQUESTMETHOD_HTTP_PATCH             = 'PATCH';
  REQUESTMETHOD_HTTP_DELETE            = 'DELETE';
  REQUESTMETHOD_HTTP_TRACE             = 'TRACE';
  REQUESTMETHOD_HTTP_CONNECT           = 'CONNECT';

  // websocket
  REQUESTMETHOD_WEBSOCKET              = 'WEBSOCKET';
  // ftp
  REQUESTMETHOD_FTP                    = 'FTP';

  {**
   * 实时视频传输协议
   *
   * https://cloud.tencent.com/developer/article/2453136
   *}
  // 1. RTMP（Real Time Messaging Protocol）
  // 简介：RTMP是由Adobe公司开发的实时消息传输协议，主要用于流媒体数据的传输。它基于TCP传输，具有低延迟、高可靠性的特点。
  // 特点：RTMP支持多种视频编码格式，如H.264、MPEG-4等，且兼容性好，可以与多种客户端和服务器软件无缝对接。
  //
  // REQUESTMETHOD_RTMP                = 'RTMP';
  // 2. RTSP（Real Time Streaming Protocol）
  // 简介：RTSP是一种网络流媒体协议，用于控制流媒体数据的传输和播放。它基于TCP/UDP传输，通过定义一系列命令和请求，实现对流媒体服务器的远程控制。
  // 特点：RTSP协议本身不传输媒体数据，而是通过控制连接建立命令和控制，媒体数据通过其他协议（如RTP）传输。它提供了丰富的控制选项，方便用户操作，且可以穿越NAT和防火墙。
  //
  // REQUESTMETHOD_RTSP                = 'RTSP';
  // 3. RTP（Real-time Transport Protocol）
  // 简介：RTP是一个实时传输媒体数据的协议，通常与RTSP一起使用。它负责在网络上传输音视频数据。
  // 特点：RTP通过UDP或TCP传输媒体数据，提供时间戳和序列号等机制以保证实时性。它支持多种视频编码格式，且具有良好的扩展性和兼容性。
  // 应用场景：常与RTSP一起用于音视频流传输，确保媒体数据能够准确、高效地传输到目标终端并进行解码播放。
  // REQUESTMETHOD_RTP                 = 'RTP';
  // 4. HLS（HTTP Live Streaming）
  // 简介：HLS是基于HTTP的流媒体传输协议，由苹果公司提出并广泛应用。
  // 特点：HLS使用切片（chunk）的方式传输媒体数据，即将媒体文件切分成小的TS（Transport Stream）文件，通过HTTP协议传输。它支持自适应比特率，可以根据网络状况选择最佳的媒体质量。
  // 应用场景：常用于移动设备和Web浏览器等环境，提供流畅的视频播放体验。
  REQUESTMETHOD_HLS                    = 'HLS';
  // 5. MPEG-DASH（Dynamic Adaptive Streaming over HTTP）
  // 简介：MPEG-DASH（Dynamic Adaptive Streaming over HTTP）是一种基于HTTP的自适应流媒体传输协议，由MPEG（运动图像专家组）和ISO（国际标准化组织）共同制定并推广。该协议以其高兼容性、灵活性和动态自适应流传输的能力，在多个领域有着广泛的应用场景。
  // 特点：DASH将媒体文件切分成小的分段，通过HTTP传输。客户端通过MPD（Media Presentation Description）文件获取媒体信息，并根据网络条件选择最佳的媒体分段和质量。
  REQUESTMETHOD_MPEG_DASH              = 'MPEG-DASH';

  {**
   * https://baijiahao.baidu.com/s?id=1840236604738170265&wfr=spider&for=pc
   *}
  // RTP（Real-time Transport Protocol）
  // 基本概念：
  // RTP是一种基于UDP的传输协议，专为实时数据传输设计，由IETF在RFC 3550中定义。其核心功能是提供时间戳、序列号和负载类型标识，确保音视频数据的时序同步和丢包检测。RTP本身不保证服务质量（QoS），但通过RTCP实现监控和反馈。
  // 技术特点：
  // ● 时间戳机制：标记数据包的生成时间，解决网络抖动导致的播放不同步问题。
  // ● 序列号：检测丢包和乱序，支持接收端重组数据。
  // ● 负载类型标识：动态适应不同编码格式（如H.264、AAC）。
  // ● 多路复用：通过SSRC（同步源标识符）区分同一会话中的不同流。
  // 应用场景
  // ● 视频会议：如Zoom、WebRTC底层使用RTP传输音视频流。
  // ● IP电话：VoIP系统依赖RTP实现实时语音通信。
  // ● 直播推流：与RTCP配合优化传输质量。
  REQUESTMETHOD_RTP                    = 'RTP';
  // RTCP（Real-time Transport Control Protocol）
  // 角色与功能
  // RTCP是RTP的伴生协议，负责传输控制信息，而非媒体数据。主要功能包括：
  // ● QoS监控：通过发送接收报告（RR）和发送报告（SR），反馈丢包率、延迟等指标。
  // ● 同步协调：同步多媒体的音画同步（如唇音同步）。
  // ● 参与者管理：在多方会话中标识成员状态。
  // 报文类型
  // ● SR（Sender Report）：发送端统计信息（如发送字节数、时间戳）。
  // ● RR（Receiver Report）：接收端反馈网络状况。
  // ● SDES（Source Description）：参与者描述信息（如用户名）。
  // ● BYE：会话终止通知。
  // 实际应用
  // 在直播场景中，RTCP帮助服务器动态调整码率。例如，当接收端反馈高丢包率时，发送端可降低分辨率以适配网络状况。
  REQUESTMETHOD_RCTP                   = 'RCTP';
  // RTSP（Real-time Streaming Protocol）
  // 协议定位
  // RTSP是一种应用层协议（RFC 2326），用于控制媒体服务器的播放、暂停等操作，类似“网络遥控器”。其特点是：
  // ● 无传输功能：依赖RTP/RTCP或TCP传输数据。
  // ● 状态性协议：通过会话ID管理连接生命周期。
  // 交互流程
  // 1. OPTIONS：查询服务器支持的方法。
  // 2. DESCRIBE：获取媒体描述（如SDP文件）。
  // 3. SETUP：建立传输通道（指定RTP端口）。
  // 4. PLAY/PAUSE/TEARDOWN：控制播放状态。
  // 典型场景
  // ● 安防监控：通过RTSP调取摄像头实时流。
  // ● IPTV：支持点播与直播的交互控制。
  REQUESTMETHOD_RTSP                   = 'RTSP';
  // RTMP（Real-time Messaging Protocol）
  // 协议演进
  // RTMP由Adobe开发，最初用于Flash播放器与服务器通信。尽管Flash已淘汰，但RTMP因低延迟特性仍广泛用于直播推流。
  // 核心特性
  // ● 基于TCP：确保可靠性，但延迟高于RTP/UDP。
  // ● 分块传输（Chunking）：将数据拆分为小块，适应不同带宽。
  // ● 多路复用：在一个连接上传输音视频、元数据和控制命令。
  // 工作流程
  // ● 握手阶段：客户端与服务器交换C0-C2数据包。
  // ● 连接阶段：建立NetConnection。
  // ● 流创建：通过NetStream传输媒体数据。
  // 现代应用
  // ● 直播推流：OBS等工具通过RTMP将流推送到CDN（如腾讯云、阿里云）。
  // ● 兼容性适配：通过转协议（如RTMP转HLS）适配移动端。
  REQUESTMETHOD_RTMP                   = 'RTMP';

implementation

end.
