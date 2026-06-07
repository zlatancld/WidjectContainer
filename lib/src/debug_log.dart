import 'package:flutter/foundation.dart';
import 'package:widject_container/widject_settings.dart';

void debugLog(String message) {
  if (!kDebugMode || !WidjectSettings.enableDebugLogs) return;
  // ignore: avoid_print
  print(message);
}
