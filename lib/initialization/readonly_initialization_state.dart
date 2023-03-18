import 'package:flutter/foundation.dart';

abstract class ReadonlyInitializationState extends ChangeNotifier {
  bool get isCompleted;
}
