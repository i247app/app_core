import 'package:app_core/app_core.dart';
import 'package:app_core/model/store.dart';
import 'package:json_annotation/json_annotation.dart';

part 'business.g.dart';

@JsonSerializable()
class Business {
  static const String DELIVERY_OPT = "deliveryOpt";
  static const String PICKUP_OPT = "pickupOpt";
  static const String TABLE_OPT = "tableOpt";

  @JsonKey(name: "puid")
  String? puid;

  @JsonKey(name: "kuid")
  String? kuid;

  @JsonKey(name: "buid")
  String? buid;

  @JsonKey(name: "tokenName")
  String? tokenName;

  @JsonKey(name: "businessName")
  String? bnm;

  @JsonKey(name: "fone") // businessPhone
  String? fone;

  @JsonKey(name: "foneCode")
  String? foneCode;

  @JsonKey(name: "addressLine1")
  String? addressLine1;

  @JsonKey(name: "city")
  String? city;

  @JsonKey(name: "countryCode")
  String? countryCode;

  @JsonKey(name: "url")
  String? url;

  @JsonKey(name: "shortDesc")
  String? description;

  @JsonKey(name: "lat")
  String? lat;

  @JsonKey(name: "lng")
  String? lng;

  @JsonKey(name: "imageURL")
  String? imageURL;

  @JsonKey(name: "imageData")
  String? imageData;

  @JsonKey(name: "catCode")
  String? categoryCode;

  @JsonKey(name: "stores")
  List<Store>? stores;

  @JsonKey(name: "latLng")
  KLatLng? latLng;

  @JsonKey(name: DELIVERY_OPT)
  String? deliveryOpt;

  @JsonKey(name: PICKUP_OPT)
  String? pickupOpt;

  @JsonKey(name: TABLE_OPT)
  String? tableOpt;

  /// Methods
  @JsonKey(ignore: true)
  String get prettyFone =>
      KUtil.prettyFone(foneCode: this.foneCode ?? "", number: this.fone ?? "");

  // JSON
  Business();

  factory Business.fromJson(Map<String, dynamic> json) =>
      _$BusinessFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessToJson(this);
}
