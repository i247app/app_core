import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:app_core/helper/kglobals.dart';
import 'package:app_core/helper/kpref_helper.dart';
import 'package:app_core/model/klat_lng.dart';
import 'package:app_core/ui/widget/dialog/klocation_permission_info_dialog.dart';
import 'package:app_core/ui/widget/open_settings_dialog.dart';
import 'package:app_core/value/kphrases.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class KLocationHelper {
  static Position? _theCachedPosition;
  static Completer<bool>? _dialogCompleter;
  static bool _isAsking = false;
  static bool _firstAsk = true;

  static Position? get cachedPosition {
    hasPermission().then((bool yes) {
      if (yes) {
        Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.bestForNavigation)
            .then((pos) => _theCachedPosition = pos);
      }
    });
    return _theCachedPosition;
  }

  static Future<bool> hasPermission() async =>
      Geolocator.checkPermission().then((lp) => [
            LocationPermission.always,
            LocationPermission.whileInUse
          ].contains(lp));

  static Future<PermissionStatus?> askForPermission() async {
    if (await hasPermission()) return PermissionStatus.granted;

    if (_dialogCompleter == null ||
        !((await _dialogCompleter?.future) ?? false)) {
      _dialogCompleter = Completer<bool>();
      bool? future;
      if (Platform.isIOS) {
        future = true;
      } else {
        future = await showDialog(
          context: kNavigatorKey.currentContext!,
          builder: (ctx) => KLocationPermissionInfoDialog(),
        );
      }
      _dialogCompleter!.complete(future ?? false);
    }
    bool dialogAcknowledged =
        await _dialogCompleter!.future.then((b) => b) ?? false;

    if (dialogAcknowledged) {
      await Permission.location.request();
      return Permission.location.status;
    }
    // return Geolocator.requestPermission()
    //     .then((_) => Permission.location.status);
    else
      return null;
  }

  static Future<KLatLng?> getKLatLng({bool askForPermissions: true}) async {
    if (_theCachedPosition == null) {
      final positionString = await KPrefHelper.get(KPrefHelper.CACHED_POSITION);
      if (positionString != null) {
        _theCachedPosition = Position.fromMap(positionString);
      }
    }
    Position? position;
    if (askForPermissions || (await hasPermission())) {
      if (askForPermissions && !(await hasPermission())) {
        final result = await askForPermission1();
        if (result != PermissionStatus.granted) return null;
      }
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    }
    _setCachedPosition(position);
    return position == null ? null : KLatLng.fromPosition(position);
  }

  static void _setCachedPosition(Position? position) {
    if (position != null) {
      KPrefHelper.put(KPrefHelper.CACHED_POSITION, position.toJson());
      _theCachedPosition = position;
    }
  }

  static Future<PermissionStatus?> askForPermission1(
      {askPermissionSetting: true}) async {
    final result = await Geolocator.checkPermission();

    if (_isAsking) return null;
    _isAsking = true;
    if (result == LocationPermission.deniedForever) {
      // Show dialog ask user enable location service in settings
      if (askPermissionSetting) {
        showDialog(
          context: kNavigatorKey.currentContext!,
          builder: (ctx) => KSettingsDialog(
            title: KPhrases.locationPermissionDialogTitle,
            body: KPhrases.locationPermissionDialogBody,
          ),
        );
      }
      _isAsking = false;
      return PermissionStatus.permanentlyDenied;
    }

    if (result == LocationPermission.denied) {
      final requestResult = await Geolocator.requestPermission();
      if (requestResult == LocationPermission.denied ||
          requestResult == LocationPermission.deniedForever) {
        if (askPermissionSetting) {
          showDialog(
            context: kNavigatorKey.currentContext!,
            builder: (ctx) => KSettingsDialog(
              title: KPhrases.locationPermissionDialogTitle,
              body: KPhrases.locationPermissionDialogBody,
            ),
          );
        }
        _isAsking = false;
        return PermissionStatus.permanentlyDenied;
      }
      // _firstAsk = false;
      _isAsking = false;
      return PermissionStatus.granted;
    }
    // _firstAsk = false;
    _isAsking = false;
    return PermissionStatus.granted;
  }

  // Calculate distance in meters between two KLatLng
  static double calculateDistance(KLatLng ll1, KLatLng ll2) {
    final lat1 = ll1.lat ?? 0;
    final lon1 = ll1.lng ?? 0;
    final lat2 = ll2.lat ?? 0;
    final lon2 = ll2.lng ?? 0;

    final p = 0.017453292519943295;
    final c = cos;
    final a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  // Calculate center point between many different points
  static KLatLng computeCentroid(Iterable<KLatLng> points) {
    double latitude = 0;
    double longitude = 0;
    int n = points.length;

    for (KLatLng point in points) {
      latitude += point.lat ?? 0;
      longitude += point.lng ?? 0;
    }

    return KLatLng.raw(latitude / n, longitude / n);
  }
}
