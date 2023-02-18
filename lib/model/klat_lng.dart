import 'package:app_core/helper/kstring_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:json_annotation/json_annotation.dart';

part 'klat_lng.g.dart';

@JsonSerializable()
class KLatLng {
  static const String LAT = "lat";
  static const String LNG = "lng";

  @JsonKey(name: LAT, fromJson: double.parse, toJson: KStringHelper.dtoa)
  double? lat;

  @JsonKey(name: LNG, fromJson: double.parse, toJson: KStringHelper.dtoa)
  double? lng;

  /// FROM
  factory KLatLng.fromPosition(Position pos) =>
      KLatLng.raw(pos.latitude, pos.longitude);

  factory KLatLng.fromGoogleLatLng(LatLng loc) =>
      KLatLng.raw(loc.latitude, loc.longitude);

  factory KLatLng.fromLocation(Location loc) => KLatLng.raw(loc.lat, loc.lng);

  /// TO
  LatLng toGoogleLatLng() => LatLng(this.lat ?? 0, this.lng ?? 0);

  Location toLocation() => Location(lat: this.lat ?? 0, lng: this.lng ?? 0);

  @override
  String toString() => "${this.lat},${this.lng}";

  @override
  int get hashCode => Object.hash(this.lat, this.lng);

  @override
  bool operator ==(Object other) => this.hashCode == other.hashCode;

  KLatLng add(double lat, double lng) =>
      KLatLng.raw((this.lat ?? 0) + lat, (this.lng ?? 0) + lng);

  /// Methods
  KLatLng.raw(this.lat, this.lng);

  // JSON
  KLatLng();

  factory KLatLng.fromJson(Map<String, dynamic> json) =>
      _$KLatLngFromJson(json);

  Map<String, dynamic> toJson() => _$KLatLngToJson(this);
}
