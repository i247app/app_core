import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kpush_data.g.dart';

@JsonSerializable()
class KPushData {
  static const String PUSH_TYPE = "pushType";
  static const String APP = "app";
  static const String ID = "id";
  static const String REF_APP = "refApp";
  static const String REF_ID = "refID";

  static const String PUSH_TYPE_NOTIFICATION = "notification";
  static const String PUSH_TYPE_DATA = "data";

  static const String APP_GIG_NOTIFY = "gig.tutor.notify";
  static const String APP_GIG_ASSIGN = "gig.tutor.assign";
  static const String APP_GIG_BOOK = "gig.tutor.book";
  static const String APP_GIG_GPS = "gig.tutor.gps";
  static const String APP_CHAT_NOTIFY = "chat.notify";
  static const String APP_SESSION_NOTIFY = "session.notify";
  static const String APP_PUSH_PING_NOTIFY = "push.ping.notify";
  static const String APP_P2P_CALL_NOTIFY = "p2p.call.notify";
  static const String APP_CONFETTI_NOTIFY = "confetti.notify";
  static const String REM_NOTIFY = "rem.notify";

  /// EXTRAS
  static const String OTHER_ID = "other_id";
  static const String CALLER_NAME = "callName";
  static const String UUID = "uuid";
  static const String CONFETTI_COUNT = "confettiCount";
  static const String MESSAGE = "message";

  @JsonKey(name: PUSH_TYPE)
  String? pushType;

  @JsonKey(name: APP)
  String? app;

  @JsonKey(name: ID)
  String? id;

  @JsonKey(name: REF_APP)
  String? refApp;

  @JsonKey(name: REF_ID)
  String? refID;

  @JsonKey(name: OTHER_ID)
  String? otherId;

  @JsonKey(name: CALLER_NAME)
  String? callerName;

  @JsonKey(name: UUID)
  String? uuid;

  @JsonKey(name: CONFETTI_COUNT, toJson: zzz_itoa, fromJson: zzz_atoi)
  int? confettiCount;

  @JsonKey(name: MESSAGE)
  String? message;

  // JSON
  KPushData();

  factory KPushData.fromJson(Map<String, dynamic> json) =>
      _$KPushDataFromJson(json);

  Map<String, dynamic> toJson() => _$KPushDataToJson(this);
}
