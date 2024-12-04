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
        WebRTCConferenceActionResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.webRTCConferences?.map((e) => e.toJson()).toList()
          case final value?)
        'webRTCConferences': value,
    };
