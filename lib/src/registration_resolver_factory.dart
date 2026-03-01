import 'dart:collection';

import 'package:widject_container/disposable.dart';
import 'package:widject_container/src/dependency_container.dart';
import 'package:widject_container/src/initialization/initialization_controller.dart';
import 'package:widject_container/src/readonly_registry.dart';
import 'package:widject_container/src/registration.dart';
import 'package:widject_container/src/registration_resolver.dart';
import 'package:widject_container/src/singletons.dart';

class RegistrationResolverFactory {
  final Singletons _singletons;
  final InitializationController _initializationController;
  final HashSet<Disposable> _disposables;

  RegistrationResolverFactory(
      this._singletons, this._initializationController, this._disposables);

  RegistrationResolver create(
      Registration registration, ReadonlyRegistry registry) {
    var container = DependencyContainer(
        registry, _singletons, _initializationController, _disposables);
    return RegistrationResolver(
        registration, container.registrationResolverDependencies);
  }
}
