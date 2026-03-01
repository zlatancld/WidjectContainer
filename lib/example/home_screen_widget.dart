import 'package:flutter/material.dart';
import 'package:widject_container/example/message_provider.dart';
import 'package:widject_container/example/other_screen_widget.dart';
import 'package:widject_container/widget_resolver.dart';

class HomeScreenWidget extends StatelessWidget {
  final MessageProvider _messageProvider;
  final WidgetResolver _widgetResolver;

  const HomeScreenWidget(this._messageProvider, this._widgetResolver,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)),
              onPressed: () => _openChildWidget(context),
              child: Text(_messageProvider.getMessage()))),
    );
  }

  _openChildWidget(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                _widgetResolver.resolve<OtherScreenWidget>()));
  }
}
