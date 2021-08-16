import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final GlobalKey<NavigatorState> kNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> kScaffoldKey = GlobalKey<ScaffoldState>();
final RouteObserver<PageRoute> kRouteObserver = RouteObserver<PageRoute>();
