// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xfr_proxy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XFRProxy _$XFRProxyFromJson(Map<String, dynamic> json) => XFRProxy()
  ..puid = json['puid'] as String?
  ..buid = json['buid'] as String?
  ..tokenName = json['tokenName'] as String?
  ..proxyStatus = json['proxyStatus'] as String?;

Map<String, dynamic> _$XFRProxyToJson(XFRProxy instance) => <String, dynamic>{
      if (instance.puid case final value?) 'puid': value,
      if (instance.buid case final value?) 'buid': value,
      if (instance.tokenName case final value?) 'tokenName': value,
      if (instance.proxyStatus case final value?) 'proxyStatus': value,
    };
