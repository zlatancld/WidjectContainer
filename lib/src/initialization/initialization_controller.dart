import 'dart:collection';

import 'package:widject_container/initialization/initializable.dart';
import 'package:widject_container/initialization/initialization_group.dart';
import 'package:widject_container/initialization/initializer.dart';

class InitializationController implements Initializer {
  final HashSet<Initializable> _registeredInstances;
  final HashSet<Initializable> _initializedInstances;
  final InitializationController? _parent;

  Future? _currentInitialization;

  InitializationController(this._parent)
      : _registeredInstances = HashSet(),
        _initializedInstances = HashSet();

  void register(dynamic instance) {
    if (instance is! Initializable || !_canBeInitialized(instance)) return;
    _registeredInstances.add(instance);
  }

  bool _canBeInitialized(Initializable initializable) {
    return !_initializedInstances.contains(initializable) &&
        !_registeredInstances.contains(initializable) &&
        _parent?._canBeInitialized(initializable) != false;
  }

  @override
  Future initialize() async {
    _currentInitialization ??= _initializeInternal();
    await _currentInitialization!;
    _currentInitialization = null;
  }

  Future _initializeInternal() async {
    while (_registeredInstances.isNotEmpty) {
      var initializable = _getRegisteredForGroup(InitializationGroup.early) ??
          _getRegisteredForGroup(InitializationGroup.normal) ??
          _getRegisteredForGroup(InitializationGroup.late)!;

      await initializable.initialize();
      _registeredInstances.remove(initializable);
      _initializedInstances.add(initializable);
    }
  }

  Initializable? _getRegisteredForGroup(InitializationGroup group) {
    for (var initializable in _registeredInstances) {
      if (initializable.group == group) return initializable;
    }

    return null;
  }
}
