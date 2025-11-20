# 简介
该项目使用 delphi 与 gemini 对接，实现了【缓存】、【文件】、【搜索】、【内容生成】接口中的方法，其中除【内容生成】外均未测试。

# 依赖
项目中引入了若干外部项目以补全项目所必需的功能，您需要全部获取下列项目才能正常使用本项目：

- [curl](https://github.com/curl/curl.git) 用于处理 http 协议报文收发，您可以通过实现 IHttpworkContract 【在 tools/Tools.HttpworkStatement.pas 中】 并替换 function GetHttpworkInstance(): IHttpworkContract; 【在 tools/Tools.HttpworkImplement.pas 中】 中的相关代码实现对 http 相关功能模块的替换，这样您就可以完全去除本项目对所有外部项目的依赖。
- [curl4delphi](https://github.com/Mercury13/curl4delphi.git) 用于引用 delphi 中 curl 的相关定义。该项目通过动态库（dll）的方式实现对 curl 的调用，您可以通过编译 curl 源码的方式获得 libcurl 的相关dll，或者直接使用我已编译过的 libcurl.dll 与 libcurl-x64.dll ，您可以在 thirds 目录下找到它们。
- [brotli](https://github.com/google/brotli.git) 用于解压经过 br 算法压缩过的 http 页面数据
- [mORMotBP](https://github.com/eugeneilyin/mORMotBP.git) 引入了该项目中 tools 目录下 brotli 相关单元，通过对 obj 文件嵌入实现对 brotli 相关功能的调用。您可以自行编译 brotli 项目获得最新的 obj 文件（需要使用bcb），也可以直接使用该项目提供的相关文件。
- [DelphiZLib](https://github.com/BrentSherwood/DelphiZLib.git) 用于解压经过 gzip 算法压缩过的 http 页面数据。

# 例子
### Basic text generation
```pas
var
  pResponse: TGenerateContentResponseBody;
begin
  FGenerativeModel := FGemini.GenerativeModel('gemini-2.5-flash');
  pResponse := FGenerativeModel.GenerateContent(Edit1.Text);
  if (nil <> pResponse) then
  begin
    Memo1.Text := pResponse.ToString();
    FreeAndNil(pResponse);
  end
  else
    Memo1.Text := FGenerativeModel.GetLastErrorInfo();
end;
```

### Chat Session (Multi-Turn Conversations)
```pas
var
  pResponse: TGenerateContentResponseBody;
begin
  if (nil = FChatSession) then
  begin
    if (nil = FGenerativeModel) then
      FGenerativeModel := FGemini.GenerativeModel('gemini-2.5-flash');
    if (nil <> FChatSession) then
      FGenerativeModel.StopChat(FChatSession);
    FChatSession := FGenerativeModel.StartChat();
  end;

  pResponse := FChatSession.SendMessage(Edit2.Text);
  if (nil <> pResponse) then
  begin
    Memo2.Text := pResponse.ToString();
    FreeAndNil(pResponse);
  end
  else
    Memo2.Text := FGenerativeModel.GetLastErrorInfo();
end;
```
![截图1](https://github.com/bahamut8348/Delphi-GeminiClientLibrary/blob/main/demos/1.png)
![截图2](https://github.com/bahamut8348/Delphi-GeminiClientLibrary/blob/main/demos/2.png)

### 注：
所有 model 的方法返回的对象都需要手动释放，而 model 本身通过 app 对象进行管理，无需手动释放。

项目原本计划用 interface 隔离所有相关 param 与 model 降低对特定模块的耦合并实现生存期自动托管，以避免因对象未释放导致的内存泄露。但由于 gemini 模型以及相关参数改动太频繁，所以在中途弃用了这个方案。目前实现了 interface 隔离的只有 param、app、model 等根类以及封装 curl 相关功能的部分，除此之外的其他部分都是通过实体类实现数据的传递及功能调用。


更多请查阅 demos 目录下的测试程序。
