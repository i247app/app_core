import 'dart:ui';

import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'host_info.g.dart';

@JsonSerializable()
class HostInfo {
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

  factory HostInfo.raw(String hostname, int port) => HostInfo()
    ..hostname = hostname
    ..port = port;

  /// Methods
  @override
  String toString() => "${this.hostname}:${this.port}";

  @override
  int get hashCode => hashValues(this.hostname, this.port);

  @override
  bool operator ==(Object other) => this.hashCode == other.hashCode;

  HostInfo copyWith({String? hostname, int? port}) => HostInfo.raw(
        hostname ?? this.hostname,
        port ?? this.port,
      );

  // JSON
  HostInfo();

  factory HostInfo.fromJson(Map<String, dynamic> json) =>
      _$HostInfoFromJson(json);

  Map<String, dynamic> toJson() => _$HostInfoToJson(this);
}
