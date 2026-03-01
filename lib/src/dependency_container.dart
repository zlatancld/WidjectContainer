import 'dart:collection';

import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/disposable.dart';
import 'package:widject_container/src/initialization/initialization_controller.dart';
import 'package:widject_container/src/readonly_registry.dart';
import 'package:flutter/widgets.dart';
import 'package:widject_container/src/registration_resolver_dependencies.dart';
import 'package:widject_container/src/singletons.dart';

class DependencyContainer {
  final ReadonlyRegistry _registry;
  late RegistrationResolverDependencies registrationResolverDependencies;

  DependencyContainer(
      this._registry,
      Singletons singletons,
      InitializationController initializationController,
      HashSet<Disposable> disposables) {
    registrationResolverDependencies = RegistrationResolverDependencies(
        DependencyProvider(this),
        singletons,
        initializationController,
        disposables);
  }

  tryGet<T>({Key? key, dynamic args}) {
    return tryGetByType(T, key: key, args: args);
  }

  tryGetByType(Type type, {Key? key, dynamic args}) {
    var registrationResolver = _registry.tryGet(type);
    if (registrationResolver == null) return null;

    return registrationResolver.solve(registrationResolverDependencies,
        key: key, args: args);
  }

  bool canResolveByType(Type type) {
    var registrationResolver = _registry.tryGet(type);
    return registrationResolver != null;
  }

  Iterable<T> getMultiple<T>() {
    var resolvers = _registry.getCollection(T);
    var instances = resolvers
        .map((resolver) => resolver.solve(registrationResolverDependencies));
    return instances.cast<T>().toList(growable: false);
  }

  void dispose() {
    registrationResolverDependencies.singletons.dispose();
    for (var disposable in registrationResolverDependencies.disposables) {
      disposable.dispose();
    }
    registrationResolverDependencies.disposables.clear();

    _registry.dispose();
  }
}
