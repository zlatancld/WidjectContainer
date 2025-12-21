import 'dart:developer';

import 'package:widject_container/disposable.dart';
import 'package:widject_container/example/message_provider.dart';

class OtherScreenMessageProvider implements MessageProvider, Disposable {
  @override
  String getMessage() {
    return "This is another screen.";
  }

  @override
  void dispose() {
    log("OtherScreenMessageProvider has been disposed");
  }
}
