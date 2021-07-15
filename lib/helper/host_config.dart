import 'package:app_core/model/host_info.dart';
import 'package:flutter/foundation.dart' as system;

abstract class KHostConfig {
  static final KHostInfo k5 = KHostInfo.raw("k5.kashin.io", 45503); // dvl3
  static final KHostInfo k4 = KHostInfo.raw("k4.kashin.io", 45503); // dvl2
  static final KHostInfo k3 = KHostInfo.raw("k3.kashin.io", 45503); // dvl
  static final KHostInfo k2 = KHostInfo.raw("k2.kashin.io", 45503); // qa
  static final KHostInfo k1 = KHostInfo.raw("k1.kashin.io", 55500); // same as prd
  static final KHostInfo kex = KHostInfo.raw("kex.kashin.io", 55500); // kex = prd

  static KHostInfo _currentHost = defaultHost;

  static KHostInfo get defaultHost => k4;

  static bool get isReleaseMode => system.kReleaseMode;

  static KHostInfo get hostInfo => isReleaseMode ? kex : _currentHost;

  static String get hostname => hostInfo.hostname;

  static int get port => hostInfo.port;

  static void setHost(KHostInfo host) => _currentHost = host;

  static bool isProductionHost(KHostInfo host) =>
      <String>[kex.hostname, k1.hostname].contains(host.hostname);
}
