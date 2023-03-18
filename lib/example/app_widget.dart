import 'package:flutter/material.dart';
import 'package:widject_container/example/message_provider.dart';
import 'package:widject_container/example/screen_widget.dart';
import 'package:widject_container/widget_provider.dart';

class AppWidget extends StatelessWidget {
  final MessageProvider _messageProvider;
  final WidgetProvider _widgetProvider;

  const AppWidget(this._messageProvider, this._widgetProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WidjectContainer Demo',
        home: Scaffold(
            body: TextButton(
                onPressed: () => _openChildWidget(context),
                child: Text(_messageProvider.getMessage()))));
  }

  _openChildWidget(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _widgetProvider.getWidget<ScreenWidget>()));
  }
}
