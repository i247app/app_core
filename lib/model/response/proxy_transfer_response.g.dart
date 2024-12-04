// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_transfer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProxyTransferResponse _$ProxyTransferResponseFromJson(
        Map<String, dynamic> json) =>
    ProxyTransferResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..puid = json['puid'] as String?;

Map<String, dynamic> _$ProxyTransferResponseToJson(
        ProxyTransferResponse instance) =>
    <String, dynamic>{
      if (zzz_itoa(instance.kstatus) case final value?) 'kstatus': value,
      if (instance.kmessage case final value?) 'kmessage': value,
      if (instance.ktoken case final value?) 'ktoken': value,
      if (instance.puid case final value?) 'puid': value,
    };
