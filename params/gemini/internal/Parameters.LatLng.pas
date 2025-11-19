unit Parameters.LatLng;

interface

uses
  Parameters.BasedParameterImplement;

type
{
  https://ai.google.dev/api/caching#LatLng
  表示纬度/经度对的对象。该对象以一对双精度数表示，分别代表纬度度数和经度度数。除非另有说明，否则该对象必须符合 <a href='https://en.wikipedia.org/wiki/World_Geodetic_System#1984_version'>WGS84 标准</a>。值必须介于标准化范围内。
}
  TLatLng = class(TParameterReality)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    // 纬度（以度为单位），它必须在 [-90.0, +90.0] 范围内。
    latitude: Double;
    // 经度（以度为单位）。它必须在 [-180.0, +180.0] 范围内。
    longitude: Double;

    class function CreateWith(const nLatitude, nLongitude: Double): TLatLng; inline; static;
  published
    { published declarations }
  end;

implementation

{ TLatLng }

class function TLatLng.CreateWith(const nLatitude, nLongitude: Double): TLatLng;
begin
  Result := TLatLng.Create();
  Result.latitude := nLatitude;
  Result.longitude := nLongitude;
end;

end.
