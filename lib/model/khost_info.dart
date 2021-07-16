import 'dart:ui';

import 'package:app_core/model/response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

class KHostInfo {
  static const String HOSTNAME = "hostname";
  static const String PORT = "port";

  @JsonKey(name: HOSTNAME)
  late String hostname;

  @JsonKey(name: PORT, fromJson: int.parse, toJson: zzz_itoa)
  late int port;

  @JsonKey(ignore: true)
  String get nickname {
    try {
      return this.hostname.split(".").first;
    } catch (e) {
      return this.hostname;
    }
  }

  factory KHostInfo.raw(String hostname, int port) => KHostInfo()
    ..hostname = hostname
    ..port = port;

  /// Methods
  @override
  String toString() => "${this.hostname}:${this.port}";

  @override
  int get hashCode => hashValues(this.hostname, this.port);

  @override
  bool operator ==(Object other) => this.hashCode == other.hashCode;

  KHostInfo copyWith({String? hostname, int? port}) => KHostInfo.raw(
        hostname ?? this.hostname,
        port ?? this.port,
      );

  // JSON
  KHostInfo();
}
