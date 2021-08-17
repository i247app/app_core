import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:app_core/ui/widget/kflash_confetti_overlay.dart';
import 'package:app_core/ui/widget/kflash_emoji_overlay.dart';

abstract class KOverlayHelper {
  static final List<Widget> _defaults = [
    IgnorePointer(child: KFlashConfettiOverlay()),
    IgnorePointer(child: KFlashEmojiOverlay()),
  ];
  static final Map<int, Widget> _overlays = {};

  static int _overlayCounter = 0;

  static List<Widget> get overlays => [
        ..._defaults,
        ..._overlays.values.toList(),
      ];

  /// Add overlay
  static int addOverlay(Widget widget) {
    final id = _overlayCounter++;
    _overlays[id] = widget;
    _OverlayView.reload();
    print("OverlayHelper.addOverlay ID $id");
    return id;
  }

  /// Remove overlay
  static bool removeOverlay(int id) {
    final didExist = _overlays.containsKey(id);
    _overlays.remove(id);
    _OverlayView.reload();
    print("OverlayHelper.removeOverlay ID $id");
    return didExist;
  }

  /// Returns the OverlayHelper widget
  static _OverlayView build() => _OverlayView();
}

class _OverlayView extends StatefulWidget {
  static final StreamController<bool> _streamController =
      StreamController.broadcast();

  static Stream<bool> get stream =>
      _streamController.stream.asBroadcastStream();

  static void reload() => _streamController.add(true);

  @override
  __OverlayViewState createState() => __OverlayViewState();
}

class __OverlayViewState extends State<_OverlayView> {
  StreamSubscription? streamSub;

  List<Widget> overlays = [];

  @override
  void initState() {
    super.initState();
    this.overlays = KOverlayHelper.overlays;
    this.streamSub = _OverlayView.stream
        .listen((_) => setState(() => this.overlays = KOverlayHelper.overlays));
  }

  @override
  void dispose() {
    this.streamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(children: this.overlays);

    return body;
  }
}
