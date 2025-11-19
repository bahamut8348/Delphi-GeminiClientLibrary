unit Tools.HttpworkImplement;

interface

uses
  Tools.HttpworkStatement;

function GetHttpworkInstance(): IHttpworkContract;

implementation

uses
  Functions.SystemExtended,
  Tools.HttpworkImplementWithCURL;

var
  pHttpworkInstance: IHttpworkContract = nil;

function GetHttpworkInstance(): IHttpworkContract;
begin
  if (nil = pHttpworkInstance) then
    pHttpworkInstance := THttpworkRealityWithCURL.Create() as IHttpworkContract;
  Result := pHttpworkInstance;
end;

initialization
  pHttpworkInstance := THttpworkRealityWithCURL.Create() as IHttpworkContract;
finalization
  pHttpworkInstance := nil;
end.
