import 'package:app_core/app_core.dart';
import 'package:app_core/model/kaddress.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kgig_address.g.dart';

@JsonSerializable()
class KGigAddress extends KAddress {
  static const String GIG_ID = "gigID";
  static const String LOCATION_TYPE = "locationType";
  static const String LOCATION_NUMBER = "locationNumber";

  @JsonKey(name: GIG_ID)
  String? gigID;

  @JsonKey(name: LOCATION_TYPE)
  String? locationType;

  @JsonKey(name: LOCATION_NUMBER)
  String? locationNumber;

  // JSON
  KGigAddress();

  factory KGigAddress.fromKAddress(KAddress address) {
    return KGigAddress()
      ..addressID = address.addressID
      ..puid = address.puid
      ..placeID = address.placeID
      ..addressType = address.addressType
      ..addressLine1 = address.addressLine1
      ..addressLine2 = address.addressLine2
      ..fullAddressLine = address.fullAddressLine
      ..name = address.name
      ..ward = address.ward
      ..district = address.district
      ..city = address.city
      ..state = address.state
      ..zipCode = address.zipCode
      ..countryCode = address.countryCode
      ..latLng = address.latLng
      ..addressStatus = address.addressStatus;
  }

  factory KGigAddress.fromJson(Map<String, dynamic> json) =>
      _$KGigAddressFromJson(json);

  Map<String, dynamic> toJson() => _$KGigAddressToJson(this);
}
