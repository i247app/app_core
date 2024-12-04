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
      ..org = (json['org'] as num?)?.toInt()
      ..startDate = zzz_str2Date(json['startDate'] as String?)
      ..endDate = zzz_str2Date(json['endDate'] as String?)
      ..refID = json['refID'] as String?
      ..refApp = json['refApp'] as String?
      ..latLng = json['latLng'] as String?
      ..status = json['status'] as String?
      ..conferenceCode = json['conferenceCode'] as String?
      ..conferencePass = json['conferencePass'] as String?
      ..conferenceSlug = json['conferenceSlug'] as String?
      ..webRTCMembers = (json['webRTCMembers'] as List<dynamic>?)
          ?.map((e) => KWebRTCMember.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$KWebRTCConferenceToJson(KWebRTCConference instance) =>
    <String, dynamic>{
      if (instance.kdomain case final value?) 'domain': value,
      if (instance.kreportFlag case final value?) 'reportFlag': value,
      if (instance.knote case final value?) 'note': value,
      if (instance.kstatusCode case final value?) 'statusCode': value,
      if (instance.kcreateID case final value?) 'createID': value,
      if (zzz_date2Str(instance.kcreateDate) case final value?)
        'createDate': value,
      if (instance.kmodifyID case final value?) 'modifyID': value,
      if (zzz_date2Str(instance.kmodifyDate) case final value?)
        'modifyDate': value,
      if (instance.kisValid case final value?) 'isValid': value,
      if (instance.kaction case final value?) 'kaction': value,
      if (instance.kattribute case final value?) 'kattribute': value,
      if (instance.kvalue case final value?) 'kvalue': value,
      if (instance.ktags case final value?) 'ktags': value,
      if (instance.kfts case final value?) 'kfts': value,
      if (instance.kranking case final value?) 'kranking': value,
      if (instance.krange case final value?) 'krange': value,
      if (instance.statuses case final value?) 'statuses': value,
      if (instance.korderBy case final value?) 'korderBy': value,
      if (instance.klimit case final value?) 'klimit': value,
      if (instance.koffset case final value?) 'koffset': value,
      if (instance.kstatus case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.kcount case final value?) 'kcount': value,
      if (instance.kname case final value?) 'kname': value,
      if (instance.conferenceID case final value?) 'conferenceID': value,
      if (instance.conferenceKey case final value?) 'conferenceKey': value,
      if (instance.puid case final value?) 'puid': value,
      if (instance.title case final value?) 'title': value,
      if (instance.org case final value?) 'org': value,
      if (zzz_date2Str(instance.startDate) case final value?)
        'startDate': value,
      if (zzz_date2Str(instance.endDate) case final value?) 'endDate': value,
      if (instance.refID case final value?) 'refID': value,
      if (instance.refApp case final value?) 'refApp': value,
      if (instance.latLng case final value?) 'latLng': value,
      if (instance.status case final value?) 'status': value,
      if (instance.conferenceCode case final value?) 'conferenceCode': value,
      if (instance.conferencePass case final value?) 'conferencePass': value,
      if (instance.conferenceSlug case final value?) 'conferenceSlug': value,
      if (instance.webRTCMembers?.map((e) => e.toJson()).toList()
          case final value?)
        'webRTCMembers': value,
    };
