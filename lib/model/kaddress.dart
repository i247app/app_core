import 'package:app_core/app_core.dart';
import 'package:app_core/value/kphrases.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kaddress.g.dart';

@JsonSerializable()
class KAddress {
  static const String TYPE_HOME = "HOME";
  static const String KEY = "address";
  static const String ADDRESS_ID = "addressID";
  static const String PUID = "puid";
  static const String ADDRESS_TYPE = "addressType";
  static const String ADDRESS_LINE1 = "addressLine1";
  static const String ADDRESS_LINE2 = "addressLine2";
  static const String DISTRICT = "district";
  static const String CITY = "city";
  static const String STATE = "state";
  static const String ZIP_CODE = "zipCode";
  static const String COUNTRY_CODE = "countryCode";
  static const String LAT_LNG = "latLng";
  static const String ADDRESS_STATUS = "addressStatus";
  static const String FULL_ADDRESS_LINE = "fullAddressLine";
  static const String NAME = "name";
  static const String WARD = "ward";
  static const String PLACE_ID = "placeID";

  @JsonKey(name: ADDRESS_ID)
  String? addressID;

  @JsonKey(name: PUID)
  String? puid;

  @JsonKey(name: PLACE_ID)
  String? placeID;

  @JsonKey(name: ADDRESS_TYPE)
  String? addressType;

  @JsonKey(name: ADDRESS_LINE1)
  String? addressLine1;

  @JsonKey(name: ADDRESS_LINE2)
  String? addressLine2;

  @JsonKey(name: FULL_ADDRESS_LINE)
  String? fullAddressLine;

  @JsonKey(name: NAME)
  String? name;

  @JsonKey(name: WARD)
  String? ward;

  @JsonKey(name: DISTRICT)
  String? district;

  @JsonKey(name: CITY)
  String? city;

  @JsonKey(name: STATE)
  String? state;

  @JsonKey(name: ZIP_CODE)
  String? zipCode;

  @JsonKey(name: COUNTRY_CODE)
  String? countryCode;

  @JsonKey(name: ADDRESS_STATUS)
  String? addressStatus;

  @JsonKey(name: LAT_LNG)
  KLatLng? latLng;

  String? get prettryDistrict {
    // Check if district not contains one of item in KUtil.ignoreAddressWords list then add Quận before it
    if (district != null && district!.isNotEmpty) {
      if (KUtil.ignoreAddressWords.any((word) => district!.contains(word))) {
        return district;
      } else {
        return "${KPhrases.district} $district";
      }
    }
    return district;
  }

  String? get prettryWard {
    // Check if district not contains one of item in KUtil.ignoreAddressWords list then add Quận before it
    if (ward != null && ward!.isNotEmpty) {
      if (KUtil.ignoreAddressWords.any((word) => ward!.contains(word))) {
        return ward;
      } else {
        return "${KPhrases.ward} $ward";
      }
    }
    return ward;
  }

  /// Methods
  @JsonKey(ignore: true)
  String get area {
    final address = [
      prettryWard,
      prettryDistrict,
      city,
    ].where((e) => e != null).join(", ");
    return address;
  }

  String get prettyAddress {
    final area = this.area;
    if (area.contains(this.addressLine1 ?? "")) {
      return area;
    } else {
      return "${this.addressLine1}, $area";
    }
  }

  // JSON
  KAddress();

  factory KAddress.fromJson(Map<String, dynamic> json) =>
      _$KAddressFromJson(json);

  factory KAddress.fromKUser(KUser user) {
    return KAddress()
      ..addressLine1 = user.address1
      ..addressLine2 = user.address2
      ..fullAddressLine = user.fullAddress
      ..ward = user.ward
      ..district = user.district
      ..city = user.city
      ..state = user.state
      ..zipCode = user.zip
      ..countryCode = user.countryCode
      ..latLng = user.currentLatLng;
  }

  Map<String, dynamic> toJson() => _$KAddressToJson(this);
}
