// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kwebrtc_conference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KWebRTCConference _$KWebRTCConferenceFromJson(Map<String, dynamic> json) =>
    KWebRTCConference()
      ..kdomain = json['domain'] as String?
      ..kreportFlag = json['reportFlag'] as String?
      ..knote = json['note'] as String?
      ..kstatusCode = json['statusCode'] as String?
      ..kcreateID = json['createID'] as String?
      ..kcreateDate = zzz_str2Date(json['createDate'] as String?)
      ..kmodifyID = json['modifyID'] as String?
      ..kmodifyDate = zzz_str2Date(json['modifyDate'] as String?)
      ..kisValid = json['isValid'] as String?
      ..kaction = json['kaction'] as String?
      ..kattribute = json['kattribute'] as String?
      ..kvalue = json['kvalue'] as String?
      ..ktags = json['ktags'] as String?
      ..kfts = json['kfts'] as String?
      ..kranking = json['kranking'] as String?
      ..krange = json['krange'] as String?
      ..statuses =
          (json['statuses'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..korderBy = json['korderBy'] as String?
      ..klimit = json['klimit'] as String?
      ..koffset = json['koffset'] as String?
      ..kstatus = json['kstatus'] as String?
      ..kmessage = json['kmessage'] as String?
      ..kcount = json['kcount'] as String?
      ..kname = json['kname'] as String?
      ..conferenceID = json['conferenceID'] as String?
      ..conferenceKey = json['conferenceKey'] as String?
      ..puid = json['puid'] as String?
      ..title = json['title'] as String?
      ..org = json['org'] as int?
      ..startDate = zzz_str2Date(json['startDate'] as String?)
      ..endDate = zzz_str2Date(json['endDate'] as String?)
      ..refID = json['refID'] as String?
      ..refApp = json['refApp'] as String?
      ..latLng = json['latLng'] as String?
      ..status = json['status'] as String?
      ..conferenceCode = json['conferenceCode'] as String?
      ..conferencePass = json['conferencePass'] as String?
      ..webRTCMembers = (json['webRTCMembers'] as List<dynamic>?)
          ?.map((e) => KWebRTCMember.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KWebRTCConferenceToJson(KWebRTCConference instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('domain', instance.kdomain);
  writeNotNull('reportFlag', instance.kreportFlag);
  writeNotNull('note', instance.knote);
  writeNotNull('statusCode', instance.kstatusCode);
  writeNotNull('createID', instance.kcreateID);
  writeNotNull('createDate', zzz_date2Str(instance.kcreateDate));
  writeNotNull('modifyID', instance.kmodifyID);
  writeNotNull('modifyDate', zzz_date2Str(instance.kmodifyDate));
  writeNotNull('isValid', instance.kisValid);
  writeNotNull('kaction', instance.kaction);
  writeNotNull('kattribute', instance.kattribute);
  writeNotNull('kvalue', instance.kvalue);
  writeNotNull('ktags', instance.ktags);
  writeNotNull('kfts', instance.kfts);
  writeNotNull('kranking', instance.kranking);
  writeNotNull('krange', instance.krange);
  writeNotNull('statuses', instance.statuses);
  writeNotNull('korderBy', instance.korderBy);
  writeNotNull('klimit', instance.klimit);
  writeNotNull('koffset', instance.koffset);
  writeNotNull('kstatus', instance.kstatus);
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('kcount', instance.kcount);
  writeNotNull('kname', instance.kname);
  writeNotNull('conferenceID', instance.conferenceID);
  writeNotNull('conferenceKey', instance.conferenceKey);
  writeNotNull('puid', instance.puid);
  writeNotNull('title', instance.title);
  writeNotNull('org', instance.org);
  writeNotNull('startDate', zzz_date2Str(instance.startDate));
  writeNotNull('endDate', zzz_date2Str(instance.endDate));
  writeNotNull('refID', instance.refID);
  writeNotNull('refApp', instance.refApp);
  writeNotNull('latLng', instance.latLng);
  writeNotNull('status', instance.status);
  writeNotNull('conferenceCode', instance.conferenceCode);
  writeNotNull('conferencePass', instance.conferencePass);
  writeNotNull(
      'webRTCMembers', instance.webRTCMembers?.map((e) => e.toJson()).toList());
  return val;
}
