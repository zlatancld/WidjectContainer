import 'package:widject_container/disposable.dart';
import 'package:widject_container/initialization/readonly_initialization_state.dart';

class InitializationState extends ReadonlyInitializationState implements Disposable {
  bool _isCompleted = false;
  bool _isDisposed = false;

  @override
  bool get isCompleted => _isCompleted == true;

  void setCompleted(bool isCompleted) {
    if (_isDisposed) return;

    var notify = _isCompleted != isCompleted;
    _isCompleted = isCompleted;

    if (notify) {
      Future.microtask(() {
        if (_isDisposed) return;
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    if (_isDisposed) return;

    _isDisposed = true;
    super.dispose();
  }
}
