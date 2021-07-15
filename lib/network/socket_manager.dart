import 'dart:io';

import 'package:app_core/helper/host_config.dart';
import 'package:app_core/model/host_info.dart';

class AppCoreSocketResource {
  static int count = 0;

  final int socketID = count++;
  final SecureSocket socket;
  final Stream<List<int>> stream;

  AppCoreHostInfo get hostInfo => AppCoreHostInfo.raw(
        this.socket.address.host,
        this.socket.remotePort,
      );

  AppCoreSocketResource(this.socket, this.stream);

  Future close() => this.socket.close();

  factory AppCoreSocketResource.fromSocket(SecureSocket socket) =>
      AppCoreSocketResource(socket, socket.asBroadcastStream());
}

abstract class SocketManager {
  static Map<AppCoreHostInfo, List<AppCoreSocketResource>> _sockets = {};

  static Future<AppCoreSocketResource> getSocket([AppCoreHostInfo? hostInfo]) async {
    hostInfo ??= AppCoreHostConfig.hostInfo;

    // Create map entry if needed
    if (!_sockets.containsKey(hostInfo)) _sockets[hostInfo] = [];

    // Check if sockets are empty
    if (_sockets[hostInfo] != null && _sockets[hostInfo]!.isEmpty) {
      // print("% % % % % SocketManager.getSocket CREATING NEW SOCKET");
      _sockets[hostInfo]!.add(await _createSocket(hostInfo));
    }
    return _sockets[hostInfo]!.removeLast();
  }

  static void releaseSocket(AppCoreSocketResource socket) {
    socket.close();
    // _sockets[socket.hostInfo]!.add(socket);
  }

  static Future<AppCoreSocketResource> _createSocket(AppCoreHostInfo hostInfo) async {
    // print("creating socket for $hostInfo");
    return SecureSocket.connect(
      hostInfo.hostname,
      hostInfo.port,
      onBadCertificate: (_) => true,
    ).then((ss) => AppCoreSocketResource.fromSocket(ss));
  }
}
