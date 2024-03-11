import 'package:widject_container/initialization/initializable.dart';
import 'package:widject_container/initialization/initialization_group.dart';
import 'package:widject_container/initialization/initializer.dart';
import 'package:widject_container/src/initialization/initializable_reference.dart';
import 'package:widject_container/src/initialization/initialization_progress.dart';
import 'package:widject_container/src/initialization/initialization_state.dart';

class InitializationController implements Initializer {
  final Map<int, InitializableReference> _registeredInstances = {};
  final InitializationController? _parent;
  final InitializationState _state;

  InitializationController(this._parent, this._state);

  void register(dynamic instance) {
    var hashCode = identityHashCode(instance);
    if (instance is! Initializable || !_canBeInitialized(hashCode)) return;

    _registeredInstances[hashCode] =
        InitializableReference(hashCode, InitializationProgress.none, instance);
    _state.setCompleted(false);
  }

  bool _canBeInitialized(int instanceHashCode) {
    return !_registeredInstances.containsKey(instanceHashCode) &&
        _parent?._canBeInitialized(instanceHashCode) != false;
  }

  @override
  Future initialize() async {
    if (!_hasInstancesToInitialize()) return;

    if (_parent != null) await _parent!.initialize();

    while (_toInitializeInstances.isNotEmpty) {
      var initializableReference = _getRegisteredForGroup(InitializationGroup.early) ??
          _getRegisteredForGroup(InitializationGroup.normal) ??
          _getRegisteredForGroup(InitializationGroup.late)!;

      initializableReference.progress = InitializationProgress.inProgress;
      await initializableReference.instance!.initialize();
      initializableReference.instance = null;
      initializableReference.progress = InitializationProgress.completed;
    }

    _state.setCompleted(true);
  }

  bool _hasInstancesToInitialize() {
    if (_toInitializeInstances.isNotEmpty) return true;

    if (_parent == null) return false;
    return _parent!._hasInstancesToInitialize();
  }

  Iterable<InitializableReference> get _toInitializeInstances =>
      _registeredInstances.entries
          .where((mapEntry) => mapEntry.value.progress == InitializationProgress.none)
          .map((mapEntry) => mapEntry.value);

  InitializableReference? _getRegisteredForGroup(InitializationGroup group) {
    for (var initializable in _toInitializeInstances) {
      if (initializable.instance!.group == group) return initializable;
    }

    return null;
  }
}
