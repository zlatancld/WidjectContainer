import 'dart:collection';

import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/registration.dart';
import 'package:flutter/foundation.dart';

class Singletons {
  final HashMap<Registration, dynamic> _instances;

  Singletons() : _instances = HashMap();

  getOrAdd(Registration registration, DependencyProvider dependencyProvider,
      Key? key, dynamic args) {
    var instance = _instances[registration];
    instance ??= _addInstance(registration, dependencyProvider, key, args);
    return instance;
  }

  _addInstance(Registration registration, DependencyProvider dependencyProvider,
      Key? key, dynamic args) {
    var instance = registration.instanceFactory(dependencyProvider, key, args);
    _instances[registration] = instance;
    return instance;
  }
}
