import 'package:widject_container/initialization/initializable.dart';
import 'package:widject_container/initialization/initialization_group.dart';
import 'package:widject_container/initialization/initializer.dart';
import 'package:widject_container/src/initialization/initialization_progress.dart';
import 'package:widject_container/src/initialization/initialization_state.dart';

class InitializationController implements Initializer {
  final Map<Initializable, InitializationProgress> _registeredInstances = {};
  final InitializationController? _parent;
  final InitializationState _state;

  InitializationController(this._parent, this._state);

  void register(dynamic instance) {
    if (instance is! Initializable || !_canBeInitialized(instance)) return;

    _registeredInstances[instance] = InitializationProgress.none;
    _state.setCompleted(false);
  }

  bool _canBeInitialized(Initializable initializable) {
    return !_registeredInstances.containsKey(initializable) &&
        _parent?._canBeInitialized(initializable) != false;
  }

  @override
  Future initialize() async {
    if (!_hasInstancesToInitialize()) return;

    if (_parent != null) await _parent!.initialize();

    while (_toInitializeInstances.isNotEmpty) {
      var initializable = _getRegisteredForGroup(InitializationGroup.early) ??
          _getRegisteredForGroup(InitializationGroup.normal) ??
          _getRegisteredForGroup(InitializationGroup.late)!;

      _registeredInstances[initializable] = InitializationProgress.inProgress;
      await initializable.initialize();
      _registeredInstances[initializable] = InitializationProgress.completed;
    }

    _state.setCompleted(true);
  }

  bool _hasInstancesToInitialize() {
    if (_toInitializeInstances.isNotEmpty) return true;

    if (_parent == null) return false;
    return _parent!._hasInstancesToInitialize();
  }

  Iterable<Initializable> get _toInitializeInstances => _registeredInstances
      .entries
      .where((mapEntry) => mapEntry.value == InitializationProgress.none)
      .map((mapEntry) => mapEntry.key);

  Initializable? _getRegisteredForGroup(InitializationGroup group) {
    for (var initializable in _toInitializeInstances) {
      if (initializable.group == group) return initializable;
    }

    return null;
  }
}
