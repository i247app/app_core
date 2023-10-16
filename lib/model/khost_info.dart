import 'package:app_core/app_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'khost_info.g.dart';

@JsonSerializable()
class KHostInfo {
  static const String HOSTNAME = "hostname";
  static const String PORT = "port";

  @JsonKey(name: HOSTNAME)
  late final String hostname;

  @JsonKey(name: PORT, fromJson: int.parse, toJson: zzz_itoa)
  late final int port;

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
  int get hashCode => Object.hash(this.hostname, this.port);

  @override
  bool operator ==(Object other) => this.hashCode == other.hashCode;

  KHostInfo copyWith({String? hostname, int? port}) => KHostInfo.raw(
        hostname ?? this.hostname,
        port ?? this.port,
      );

  // JSON
  KHostInfo();

  factory KHostInfo.fromJson(Map<String, dynamic> json) =>
      _$KHostInfoFromJson(json);

  Map<String, dynamic> toJson() => _$KHostInfoToJson(this);
}
