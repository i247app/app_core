import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kpush_data.g.dart';

@JsonSerializable()
class KPushData {
  static const String PUSH_TYPE = "pushType";
  static const String APP = "app";
  static const String ID = "id";
  static const String INDEX = "index";
  static const String REF_APP = "refApp";
  static const String REF_ID = "refID";
  static const String REM = "rem";

  static const String PUSH_TYPE_NOTIFICATION = "notification";
  static const String PUSH_TYPE_DATA = "data";

  static const String APP_GIG_NOTIFY = "gig.tutor.notify";
  static const String APP_GIG_ASSIGN = "gig.gig.assign";
  static const String APP_GIG_STANDBY_ASSIGN = "gig.standby.assign";
  static const String APP_GIG_BOOK = "gig.tutor.book";
  static const String APP_GIG_GPS = "gig.tutor.gps";
  static const String APP_CHAT_NOTIFY = "chat.notify";
  static const String APP_SESSION_NOTIFY = "session.notify";
  static const String APP_PUSH_PING_NOTIFY = "push.ping.notify";
  static const String APP_P2P_CALL_NOTIFY = "p2p.call.notify";
  static const String APP_CONFETTI_NOTIFY = "confetti.notify";
  static const String APP_REM_NOTIFY = "rem.notify";
  static const String APP_PING = "ping";

  /// EXTRAS
  static const String OTHER_ID = "other_id";
  static const String CALLER_NAME = "caller_name";
  static const String UUID = "uuid";
  static const String CONFETTI_COUNT = "confettiCount";
  static const String MESSAGE = "message";

  @JsonKey(name: PUSH_TYPE)
  String? pushType;

  @JsonKey(name: APP)
  String? app;

  @JsonKey(name: ID)
  String? id;

  @JsonKey(name: INDEX)
  String? index;

  @JsonKey(name: REF_APP)
  String? refApp;

  @JsonKey(name: REF_ID)
  String? refID;

  @JsonKey(name: REM)
  String? rem;

  @JsonKey(name: OTHER_ID)
  String? otherId;

  @JsonKey(name: UUID)
  String? uuid;

  @JsonKey(name: "caller_id")
  int? callerId;

  @JsonKey(name: "call_type")
  int? callType;

  @JsonKey(name: "session_id")
  String? sessionId;

  @JsonKey(name: CALLER_NAME)
  String? callerName;

  @JsonKey(name: "call_opponents")
  String? callOpponents;

  @JsonKey(name: "user_info")
  String? userInfo;

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
