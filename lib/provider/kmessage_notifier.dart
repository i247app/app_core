import 'package:flutter/material.dart';

class KMessageNotifer extends ChangeNotifier {
  bool _isNoticed = false;

  bool get isNoticed => _isNoticed;

  void notify() {
    _isNoticed = true;
    notifyListeners();
  }

  void clearNotify() {
    _isNoticed = false;
    notifyListeners();
  }
}
