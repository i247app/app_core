import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kcall_control_stream_helper.dart';
import 'package:app_core/helper/kcall_stream_helper.dart';
import 'package:app_core/helper/service/ktheme_service.dart';
import 'package:app_core/style/kpalette_group.dart';
import 'package:app_core/style/ktheme.dart';
import 'package:app_core/ui/kicon/kicon_manager.dart';
import 'package:app_core/ui/widget/kerror_view.dart';
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';

class KApp extends StatefulWidget {
  final Widget home;
  final TextStyle defaultTextStyle;
  final bool isEmbed;
  final String title;
  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<NavigatorObserver> navigatorObservers;
  final Map<dynamic, KIconProvider> iconSet;
  final KPaletteGroup paletteGroup;
  final Completer? initializer;
  final KTheme Function(KPaletteGroup, Widget)? customThemeBuilder;
  final StreamSubscription Function()? initGlobalListener;

  const KApp({
    required this.home,
    required this.defaultTextStyle,
    required this.paletteGroup,
    required this.navigatorKey,
    required this.scaffoldKey,
    required this.navigatorObservers,
    this.customThemeBuilder,
    this.initGlobalListener,
    this.isEmbed = false,
    this.title = '',
    this.iconSet = const {},
    this.initializer,
  });

  @override
  State<StatefulWidget> createState() => _KAppState();
}

class _KAppState extends State<KApp> with WidgetsBindingObserver {
  late final StreamSubscription? globalListenerSub;
  late final StreamSubscription streamCallControl;
  late final StreamSubscription streamCall;

  bool forceRebuild = false;

  ThemeMode get themeMode => KThemeService.getThemeMode();

  KVOIPCall? voipCall;
  KCallType callType = KCallType.kill;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    globalListenerSub = widget.initGlobalListener?.call();
    KRebuildHelper.notifier.addListener(rebuildListener);
    this.streamCall = KCallStreamHelper.stream.listen(callNotifListener);
    this.streamCallControl =
        KCallControlStreamHelper.stream.listen(callControlNotifListener);
  }

  void callNotifListener(KVOIPCall? call) {
    setState(() {
      voipCall = call;
    });
  }

  void callControlNotifListener(KCallType type) {
    setState(() {
      callType = type;
    });
  }

  @override
  void dispose() {
    globalListenerSub?.cancel();
    KRebuildHelper.notifier.removeListener(rebuildListener);
    WidgetsBinding.instance?.removeObserver(this);
    this.streamCall.cancel();
    this.streamCallControl.cancel();
    super.dispose();
  }

  KTheme defaultThemeBuilder(KPaletteGroup group, Widget child) =>
      KTheme(paletteGroup: group, child: child);

  void rebuildListener() => setState(() => forceRebuild = true);

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    /// HACKY BUT EFFECTIVE
    if (forceRebuild) {
      // print("# # # # REBUILDING ALL CHILDREN");
      forceRebuild = false;
      rebuildAllChildren(context);
    }

    // print("# # # # # THEME MODE - $themeMode");

    final defaultTheme =
        KStyles.themeDataBuilder(widget.paletteGroup, Brightness.light);
    final darkTheme =
        KStyles.themeDataBuilder(widget.paletteGroup, Brightness.dark);

    final innerApp = (widget.customThemeBuilder ?? defaultThemeBuilder).call(
      widget.paletteGroup,
      KIconManager(
        iconSet: widget.iconSet,
        child: KEmbedManager(
          isEmbed: widget.isEmbed,
          child: DefaultTextStyle(
            style: widget.defaultTextStyle,
            child: MaterialApp(
              title: widget.title,
              navigatorKey: widget.navigatorKey,
              debugShowCheckedModeBanner: false,
              navigatorObservers: widget.navigatorObservers,
              theme: defaultTheme,
              darkTheme: darkTheme,
              themeMode: themeMode,
              home: widget.home,
            ),
          ),
        ),
      ),
    );
    final button = FloatingActionButton(
      onPressed: () {
        KCallControlStreamHelper.broadcast(KCallType.foreground);
      },
      backgroundColor: Colors.red,
      child: const Icon(
        Icons.phone_in_talk,
        color: Colors.white,
      ),
    );

    final buttonOpenCall = DraggableWidget(
      bottomMargin: 80,
      topMargin: 80,
      intialVisibility: true,
      horizontalSpace: 20,
      shadowBorderRadius: 50,
      child: button,
      initialPosition: AnchoringPosition.bottomRight,
    );

    final rawInnerAppWithOverlay = Stack(
      fit: StackFit.expand,
      children: [
        innerApp,
        if (callType == KCallType.background) buttonOpenCall,
        KOverlayHelper.build(),
      ],
    );

    final voipWithApp = IndexedStack(
      index: callType == KCallType.foreground ? 1 : 0,
      children: [
        rawInnerAppWithOverlay,
        if (voipCall != null) voipCall!,
      ],
    );

    final innerAppWithOverlay = widget.initializer == null
        ? voipWithApp
        : FutureBuilder(
            future: widget.initializer!.future,
            builder: (_, snapshot) =>
                !snapshot.hasData ? Container() : voipWithApp,
          );

    final masterApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (_, __) {
        ErrorWidget.builder =
            (FlutterErrorDetails errorDetails) => KErrorView(errorDetails);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: widget.scaffoldKey,
          body: innerAppWithOverlay,
        );
      },
      theme: defaultTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
    );

    return masterApp;
  }
}
