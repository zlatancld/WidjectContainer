import 'package:widject_container/lifetime.dart';
import 'package:widject_container/src/registration.dart';
import 'package:flutter/foundation.dart';
import 'package:widject_container/src/registration_resolver_dependencies.dart';

class RegistrationResolver {
  final Registration _registration;
  final RegistrationResolverDependencies _registrationDeclarationDependencies;

  RegistrationResolver(
      this._registration, this._registrationDeclarationDependencies);

  solve(RegistrationResolverDependencies requesterDependencies,
      {Key? key, dynamic args}) {
    switch (_registration.lifetime) {
      case Lifetime.singleton:
        return _solveSingleton(_registration, _registrationDeclarationDependencies, key, args);
      case Lifetime.scoped:
        return _solveSingleton(_registration, requesterDependencies, key, args);
      case Lifetime.transient:
        return _solveTransient(_registration, requesterDependencies, key, args);
    }
  }

  _solveSingleton(Registration registration, RegistrationResolverDependencies dependencies, Key? key, dynamic args) {
    var instance = dependencies.singletons.getOrAdd(registration, dependencies.dependencyProvider, key, args);
    dependencies.initializationController.register(instance);
    return instance;
  }

  _solveTransient(Registration registration, RegistrationResolverDependencies dependencies, Key? key, dynamic args) {
    var instance = registration.instanceFactory(dependencies.dependencyProvider, key, args);
    dependencies.initializationController.register(instance);
    return instance;
  }

  Lifetime get lifetime => _registration.lifetime;
}
