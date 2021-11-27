// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bxfr_transfer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BXFRTransferResponse _$BXFRTransferResponseFromJson(
        Map<String, dynamic> json) =>
    BXFRTransferResponse()
      ..kstatus = zzz_parseInt(json['kstatus'] as String?)
      ..kmessage = json['kmessage'] as String?
      ..ktoken = json['ktoken'] as String?
      ..puid = json['puid'] as String?;

Map<String, dynamic> _$BXFRTransferResponseToJson(
    BXFRTransferResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('kstatus', zzz_itoa(instance.kstatus));
  writeNotNull('kmessage', instance.kmessage);
  writeNotNull('ktoken', instance.ktoken);
  writeNotNull('puid', instance.puid);
  return val;
}
