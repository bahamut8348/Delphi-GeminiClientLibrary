unit Parameters.ComputerUse;

interface

uses
  System.SysUtils,
  System.Generics.Defaults, System.Generics.Collections, System.Rtti, System.JSON,
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#ComputerUse
  “电脑使用情况”工具类型。
}
  TComputerUse = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetMemberValue(var sName: String; out pValue: TValue): Boolean; override;
    function SetMemberValue(const sName: String; const pValue: TJsonValue): Boolean; override;
  public
    { public declarations }
    // 必需。正在运行的环境。
    //
    // 值                         | 说明
    // ENVIRONMENT_UNSPECIFIED    | 默认为浏览器。
    // ENVIRONMENT_BROWSER        | 在网络浏览器中运行。
    environment: String;
    // 可选。默认情况下，预定义函数包含在最终的模型调用中。您可以明确排除某些功能，使其不被自动纳入。这可用于以下两个目的：1. 使用更受限 / 不同的行动空间。2. 改进预定义函数的定义 / 说明。
    excludedPredefinedFunctions: array of String;
  public
    { public declarations }
    constructor Create(); override;
    destructor Destroy(); override;
  published
    { published declarations }
  end;

implementation

uses
  Constants.GeminiEnumType, Functions.SystemExtended;

{ TComputerUse }

constructor TComputerUse.Create();
begin
  inherited Create();
  Self.environment := GEMINI_ENVIRONMENT_UNSPECIFIED;
  SetLength(Self.excludedPredefinedFunctions, 0);
end;

destructor TComputerUse.Destroy();
var
  nIndex: Integer;
begin
  for nIndex := High(Self.excludedPredefinedFunctions) downto Low(Self.excludedPredefinedFunctions) do
    Self.excludedPredefinedFunctions[nIndex] := '';
  SetLength(Self.excludedPredefinedFunctions, 0);
  Self.environment := '';
  inherited Destroy();
end;

function TComputerUse.GetMemberValue(var sName: String;
  out pValue: TValue): Boolean;
begin
  Result := inherited GetMemberValue(sName, pValue);
end;

function TComputerUse.SetMemberValue(const sName: String;
  const pValue: TJsonValue): Boolean;
var
  nIndex: Integer;
begin
  if SameText(sName, 'excludedPredefinedFunctions') then
  begin
    for nIndex := High(Self.excludedPredefinedFunctions) downto Low(Self.excludedPredefinedFunctions) do
    begin
      Self.excludedPredefinedFunctions[nIndex] := '';
    end;

    if (pValue is TJSONArray) then
    begin
      SetLength(Self.excludedPredefinedFunctions, (pValue as TJSONArray).Count);
      for nIndex := 0 to (pValue as TJSONArray).Count - 1 do
      begin
        Self.excludedPredefinedFunctions[nIndex] := (pValue as TJSONArray).Items[nIndex].Value;
      end;
    end
    else if (nil <> pValue) then
    begin
      SetLength(Self.excludedPredefinedFunctions, 1);
      Self.excludedPredefinedFunctions[0] := pValue.Value;
    end
    else
      SetLength(Self.excludedPredefinedFunctions, 0);

    Result := TRUE;
  end
  else
    Result := inherited SetMemberValue(sName, pValue);
end;

end.
