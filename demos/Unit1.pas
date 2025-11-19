unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,

  Models.BatchesModelImplement, Models.CachedContentsModelImplement,
  Models.EmbeddingsModelImplement, Models.FileSearchStoresModelImplement,
  Models.FilesModelImplement, Models.GenerativeModelImplement,
  Models.ModelsModelImplement,
  Applications.Gemini;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Button2: TButton;
    Label2: TLabel;
    Memo1: TMemo;
    TabSheet4: TTabSheet;
    Label3: TLabel;
    Edit2: TEdit;
    Button3: TButton;
    Label4: TLabel;
    Memo2: TMemo;
    Button4: TButton;
    Button5: TButton;
    lvModelList: TListView;
    Button6: TButton;
    Label5: TLabel;
    edtApiBaseUrl: TEdit;
    Label6: TLabel;
    edtApiVersion: TEdit;
    Label7: TLabel;
    edtApiKey: TEdit;
    cbUsedProxy: TCheckBox;
    Label8: TLabel;
    edtProxyAddress: TEdit;
    Label9: TLabel;
    edtProxyUsername: TEdit;
    Label10: TLabel;
    edtProxyPassword: TEdit;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure cbUsedProxyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
    FGemini: TGemini;
    FGenerativeModel: TGenerativeModelReality;
    FChatSession: TChatSessionReality;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Parameters.BasedParameterStatement, Parameters.BasedParameterImplement,
  Parameters.GenerateContentRequestBody, Parameters.GenerateContentResponseBody,
  Parameters.Model;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Self.Close();
end;

procedure TForm1.Button2Click(Sender: TObject);
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

procedure TForm1.Button3Click(Sender: TObject);
var
  pResponse: TGenerateContentResponseBody;
begin
  if (nil = FChatSession) then
  begin
    Application.MessageBox('请先启动会话', nil, MB_ICONERROR or MB_OK);
    Exit;
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

procedure TForm1.Button4Click(Sender: TObject);
begin
  if (nil = FGenerativeModel) then
    FGenerativeModel := FGemini.GenerativeModel('gemini-2.5-flash');
  if (nil <> FChatSession) then
    FGenerativeModel.StopChat(FChatSession);
  FChatSession := FGenerativeModel.StartChat();

  Button4.Enabled := FALSE;
  Button5.Enabled := TRUE;
  Button3.Enabled := TRUE;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if (nil <> FChatSession) then
  begin
    if (nil <> FGenerativeModel) then
      FGenerativeModel.StopChat(FChatSession)
    else
      FreeAndNil(FChatSession);
  end;

  Button4.Enabled := TRUE;
  Button5.Enabled := FALSE;
  Button3.Enabled := FALSE;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  pModel: TModelsModelReality;
  pModelList: TArray<TModel>;
  nIndex: Integer;
begin
  pModel := FGemini.ModelsModel();
  pModelList := pModel.List();
  for nIndex := Low(pModelList) to High(pModelList) do
  begin
    with lvModelList.Items.Add() do
    begin
      Caption := pModelList[nIndex].name;
      SubItems.Add(pModelList[nIndex].version);
      SubItems.Add(pModelList[nIndex].displayName);
      SubItems.Add(pModelList[nIndex].description);
    end;
  end;
  TParameterReality.ReleaseArray<TModel>(pModelList);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  FGemini.SetApiBaseUrl(edtApiBaseUrl.Text);
  FGemini.SetApiVersion(edtApiVersion.Text);
  FGemini.SetApiKey(edtApiKey.Text);

  if cbUsedProxy.Checked then
  begin
    FGemini.SetProxyAddress(edtProxyAddress.Text);
    FGemini.SetProxyUsername(edtProxyUsername.Text);
    FGemini.SetProxyPassword(edtProxyPassword.Text);
  end;
end;

procedure TForm1.cbUsedProxyClick(Sender: TObject);
begin
  edtProxyAddress.Enabled := cbUsedProxy.Checked;
  edtProxyUsername.Enabled := cbUsedProxy.Checked;
  edtProxyPassword.Enabled := cbUsedProxy.Checked;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FGemini := TGemini.Create();
  FGenerativeModel := nil;
  FChatSession := nil;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if (nil <> FChatSession) then
  begin
    if (nil <> FGenerativeModel) then
      FGenerativeModel.StopChat(FChatSession)
    else
      FreeAndNil(FChatSession);
  end;
  FreeAndNil(FGemini);
end;

end.
