import 'package:Salmodiamo/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

class MyRouterDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  final _pages = <Page>[];

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;
    popRoute();
    return true;
  }

  @override
  Future<bool> popRoute() async {
    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();
      return Future.value(true);
    }
    return _confirmAppExit();
  }

  Future<bool> _confirmAppExit() {
    return Future.value(true);
    /*return showDialog<bool>(
        context: navigatorKey.currentContext,
        builder: (context) {
          return AlertDialog(
            title: const Text('Esci'),
            content: const Text('Vuoi davvero uscire dall\'app?'),
            actions: [
              TextButton(
                child: const Text('Annulla'),
                onPressed: () => Navigator.pop(context, true),
              ),
              TextButton(
                child: const Text('Conferma'),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          );
        });*/
  }

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) async {}

  MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child = SalmodiamoMain();
    switch (routeSettings.name) {
      case '/':
        child = SalmodiamoMain();
        break;
      case '/playtone':
        child = Playtone(routeSettings.arguments as String);
        break;
      case '/tonescore':
        child = ToneScore(routeSettings.arguments as String);
        break;
    }
    return MaterialPage(
      child: child,
      key: ValueKey(routeSettings.name),
      name: routeSettings.name,
      arguments: routeSettings.arguments,
    );
  }

  void pushPage({required String name, dynamic arguments}) {
    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    notifyListeners();
  }
}
