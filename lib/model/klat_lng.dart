import 'package:app_core/helper/string_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AppCoreKLatLng {
  static const String LAT = "lat";
  static const String LNG = "lng";

  @JsonKey(name: LAT, fromJson: double.parse, toJson: AppCoreStringHelper.dtoa)
  double? lat;

  @JsonKey(name: LNG, fromJson: double.parse, toJson: AppCoreStringHelper.dtoa)
  double? lng;

  /// FROM
  factory AppCoreKLatLng.fromPosition(Position pos) =>
      AppCoreKLatLng.raw(pos.latitude, pos.longitude);

  factory AppCoreKLatLng.fromLocation(Location loc) => AppCoreKLatLng.raw(loc.lat, loc.lng);

  factory AppCoreKLatLng.fromGoogleLatLng(LatLng loc) =>
      AppCoreKLatLng.raw(loc.latitude, loc.longitude);

  /// TO
  LatLng toGoogleLatLng() => LatLng(this.lat ?? 0, this.lng ?? 0);

  Location toLocation() => Location(lng: this.lng ?? 0, lat: this.lat ?? 0);

  @override
  String toString() => "${(lat ?? 0).toStringAsFixed(2)},${(lng ?? 0).toStringAsFixed(2)}";

  // JSON
  AppCoreKLatLng();

  AppCoreKLatLng.raw(this.lat, this.lng);
}
