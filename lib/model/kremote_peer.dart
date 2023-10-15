import 'package:json_annotation/json_annotation.dart';
import 'package:peerdart/peerdart.dart';

part 'kremote_peer.g.dart';

@JsonSerializable()
class KRemotePeer {
  static const String STATUS_PENDING = "pending";
  static const String STATUS_CONNECTED = "connected";
  static const String ROLE_CALLER = "CALLER";
  static const String ROLE_LISTENER = "LISTENER";

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? peerID;

  @JsonKey(includeFromJson: false, includeToJson: false)
  DataConnection? dataConnection;

  @JsonKey(includeFromJson: false, includeToJson: false)
  MediaConnection? mediaConnection;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? status = STATUS_PENDING;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? role;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int retryCount = 0;

  // JSON
  KRemotePeer();

  factory KRemotePeer.fromJson(Map<String, dynamic> json) =>
      _$KRemotePeerFromJson(json);

  Map<String, dynamic> toJson() => _$KRemotePeerToJson(this);
}
