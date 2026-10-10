// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webrtc_conference_action_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebRTCConferenceActionResponse _$WebRTCConferenceActionResponseFromJson(
        Map<String, dynamic> json) =>
    WebRTCConferenceActionResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..webRTCConferences = (json['webRTCConferences'] as List<dynamic>?)
          ?.map((e) => KWebRTCConference.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$WebRTCConferenceActionResponseToJson(
    WebRTCConferenceActionResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('webRTCConferences',
      instance.webRTCConferences?.map((e) => e.toJson()).toList());
  return val;
}
