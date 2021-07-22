import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class KFCMHelper {
  static Completer<FirebaseMessaging>? _fcmCompleter;

  static Future<FirebaseMessaging> get _fcmFuture async {
    if (_fcmCompleter == null) {
      _fcmCompleter = Completer<FirebaseMessaging>();
      Firebase.initializeApp().whenComplete(
          () => _fcmCompleter!.complete(FirebaseMessaging.instance));
    }
    return _fcmCompleter!.future;
  }

  /// Get the token, prioritize refreshed tokens over what .getToken returns
  static Future<String?> getPushToken() async {
    final fcm = await _fcmFuture;
    return await fcm.getToken();
  }
}
