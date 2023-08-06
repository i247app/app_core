import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/helper/khero_helper.dart';

part 'khero.g.dart';

@JsonSerializable()
class KHero {
  static const String ID = "id";
  static const String PUID = "puid";
  static const String HERO_ID = "heroID";

  static const String EGG_DATE = "eggDate";
  static const String HATCH_DATE = "hatchDate";
  static const String EGG_DURATION = "eggDuration";
  static const String EGG_IMAGE = "eggImage";
  static const String EGG_URL = "eggURL";

  static const String HERO_NAME = "heroName";
  static const String HERO_BIO = "heroBio";
  static const String HERO_IMAGE = "heroImage";
  static const String HERO_URL = "heroURL";

  static const String EVOLUTION = "evolution";

  static const String POWER = "power";
  static const String ENERGY = "energy";

  static const String BUA = "bua";
  static const String BAO = "bao";
  static const String KEO = "keo";

  static const String OWN_DATE = "ownDate";
  static const String HERO_STATUS = "heroStatus";

  @JsonKey(name: ID)
  String? id;

  @JsonKey(name: PUID)
  String? puid;

  @JsonKey(name: HERO_ID)
  String? heroID;

  @JsonKey(name: EGG_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? eggDate;

  @JsonKey(name: HATCH_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? hatchDate;

  @JsonKey(name: EGG_DURATION, fromJson: zzz_str2Dur, toJson: zzz_dur2Str)
  Duration? eggDuration;

  @JsonKey(name: EGG_IMAGE)
  String? eggImage;

  @JsonKey(name: EGG_URL)
  String? eggImageURL;

  @JsonKey(name: HERO_NAME)
  String? name;

  @JsonKey(name: HERO_BIO)
  String? bio;

  @JsonKey(name: HERO_IMAGE)
  String? heroImage;

  @JsonKey(name: HERO_URL)
  String? imageURL;

  @JsonKey(name: OWN_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? ownDate;

  @JsonKey(name: EVOLUTION)
  String? evolution;

  @JsonKey(name: POWER)
  String? power;

  @JsonKey(name: ENERGY)
  String? energy;

  @JsonKey(name: BUA)
  String? bua;

  @JsonKey(name: BAO)
  String? bao;

  @JsonKey(name: KEO)
  String? keo;

  @JsonKey(name: HERO_STATUS)
  String? heroStatus;

  /// Methods

  @JsonKey(ignore: true)
  bool get isEgg => KHeroHelper.isEgg(this);

  // JSON
  KHero();

  factory KHero.fromJson(Map<String, dynamic> json) => _$KHeroFromJson(json);

  Map<String, dynamic> toJson() => _$KHeroToJson(this);
}
