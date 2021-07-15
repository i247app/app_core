import 'package:app_core/model/host_info.dart';
import 'package:flutter/foundation.dart' as system;

abstract class AppCoreHostConfig {
  static final AppCoreHostInfo k5 = AppCoreHostInfo.raw("k5.kashin.io", 45503); // dvl3
  static final AppCoreHostInfo k4 = AppCoreHostInfo.raw("k4.kashin.io", 45503); // dvl2
  static final AppCoreHostInfo k3 = AppCoreHostInfo.raw("k3.kashin.io", 45503); // dvl
  static final AppCoreHostInfo k2 = AppCoreHostInfo.raw("k2.kashin.io", 45503); // qa
  static final AppCoreHostInfo k1 = AppCoreHostInfo.raw("k1.kashin.io", 55500); // same as prd
  static final AppCoreHostInfo kex = AppCoreHostInfo.raw("kex.kashin.io", 55500); // kex = prd

  static AppCoreHostInfo _currentHost = defaultHost;

  static AppCoreHostInfo get defaultHost => k4;

  static bool get isReleaseMode => system.kReleaseMode;

  static AppCoreHostInfo get hostInfo => isReleaseMode ? kex : _currentHost;

  static String get hostname => hostInfo.hostname;

  static int get port => hostInfo.port;

  static void setHost(AppCoreHostInfo host) => _currentHost = host;

  static bool isProductionHost(AppCoreHostInfo host) =>
      <String>[kex.hostname, k1.hostname].contains(host.hostname);
}
