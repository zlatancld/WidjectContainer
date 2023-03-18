import 'package:widject_container/initialization/readonly_initialization_state.dart';

class InitializationState extends ReadonlyInitializationState {
  bool _isCompleted = false;

  @override
  bool get isCompleted => _isCompleted == true;

  void setCompleted(bool isCompleted) {
    var notify = _isCompleted != isCompleted;
    _isCompleted = isCompleted;

    if (notify) {
      notifyListeners();
    }
  }
}
