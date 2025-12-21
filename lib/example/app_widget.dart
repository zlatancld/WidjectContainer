import 'package:flutter/material.dart';
import 'package:widject_container/example/home_screen_widget.dart';
import 'package:widject_container/widget_resolver.dart';

class AppWidget extends StatelessWidget {
  final WidgetResolver _widgetResolver;

  const AppWidget(this._widgetResolver, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WidjectContainer Demo',
        home: Scaffold(
            body: _widgetResolver.resolve<HomeScreenWidget>()));
  }
}
