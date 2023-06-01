import 'package:flutter/material.dart';
import 'package:app_post/firebase_analytics.dart';

class AnalyticsProvider extends InheritedWidget {
  const AnalyticsProvider({
    Key? key,
    required Widget child,
    required this.handlers,
  }) : super(key: key, child: child);

  final List<AnalyticsHandler> handlers;

  static AnalyticsProvider of(BuildContext context) {
    final AnalyticsProvider? result =
    context.dependOnInheritedWidgetOfExactType<AnalyticsProvider>();
    assert(result != null, 'No AnalyticsProvider found in context');
    return result!;
  }

  Future<void> logEvent(String name, Map<String, dynamic> parameters) async  {
    for (final handler in handlers) {
      await handler.logEvent(name, parameters);
    }
  }

  Future<void> setUserProperty(String name, String value) async  {
    for (final handler in handlers) {
      await handler.setUserProperty(name, value);
    }
  }



  @override
  bool updateShouldNotify(AnalyticsProvider old) {
    return true;
  }
}
