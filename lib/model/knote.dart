import 'package:app_core/model/kobject.dart';
import 'package:app_core/model/kuser.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app_core/model/response/base_response.dart';

part 'knote.g.dart';

@JsonSerializable()
class KNote extends KObject {
  static const String CONTENT_TYPE_TEXT = "text";
  static const String CONTENT_TYPE_IMAGE = "image";
  static const String ACTION_ADD = "add";
  static const String ACTION_LIST = "list";
  static const String ACTION_MODIFY = "modify";
  static const String ACTION_REMOVE = "remove";

  static const String ID = "id";
  static const String NOTE_ID = "noteID";
  static const String ACTION = "action";

  static const String PUID = "puid";
  static const String REF_APP = "refApp";
  static const String USER = "user";
  static const String REF_ID = "refID";
  static const String MESSAGE = "message";
  static const String MESSAGE_DATE = "messageDate";
  static const String MESSAGE_TYPE = "messageType";
  static const String NOTE_STATUS = "noteStatus";

  static const String IMG_DATA = "imageData";

  @JsonKey(name: ID)
  String? id;

  @JsonKey(name: NOTE_ID)
  String? noteID;

  @JsonKey(name: ACTION)
  String? action;

  @JsonKey(name: PUID)
  String? puid;

  @JsonKey(name: REF_APP)
  String? refApp;

  @JsonKey(name: REF_ID)
  String? refID;

  @JsonKey(name: MESSAGE_DATE, fromJson: zzz_str2Date, toJson: zzz_date2Str)
  DateTime? messageDate;

  @JsonKey(name: MESSAGE_TYPE)
  String? messageType;

  @JsonKey(name: MESSAGE)
  String? message;

  @JsonKey(name: NOTE_STATUS)
  String? noteStatus;

  @JsonKey(name: IMG_DATA)
  String? imgData;

  @JsonKey(name: USER)
  KUser? user;

  // JSON
  KNote();

  factory KNote.fromJson(Map<String, dynamic> json) => _$KNoteFromJson(json);

  Map<String, dynamic> toJson() => _$KNoteToJson(this);
}
