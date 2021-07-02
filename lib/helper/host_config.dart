import 'package:app_core/model/host_info.dart';
import 'package:flutter/foundation.dart' as system;

abstract class HostConfig {
  static final HostInfo k5 = HostInfo.raw("k5.kashin.io", 45503); // dvl3
  static final HostInfo k4 = HostInfo.raw("k4.kashin.io", 45503); // dvl2
  static final HostInfo k3 = HostInfo.raw("k3.kashin.io", 45503); // dvl
  static final HostInfo k2 = HostInfo.raw("k2.kashin.io", 45503); // qa
  static final HostInfo k1 = HostInfo.raw("k1.kashin.io", 55500); // same as prd
  static final HostInfo kex = HostInfo.raw("kex.kashin.io", 55500); // kex = prd

  static HostInfo _currentHost = defaultHost;

  static HostInfo get defaultHost => k4;

  static bool get isReleaseMode => system.kReleaseMode;

  static HostInfo get hostInfo => isReleaseMode ? kex : _currentHost;

  static String get hostname => hostInfo.hostname;

  static int get port => hostInfo.port;

  static void setHost(HostInfo host) => _currentHost = host;

  static bool isProductionHost(HostInfo host) =>
      <String>[kex.hostname, k1.hostname].contains(host.hostname);
}
