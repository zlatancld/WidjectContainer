import 'package:flutter/material.dart';

import 'message_provider.dart';

class OtherScreenWidget extends StatelessWidget {
  final MessageProvider _messageProvider;

  const OtherScreenWidget(this._messageProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(_messageProvider.getMessage())));
  }
}
