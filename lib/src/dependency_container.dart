import 'package:widject_container/src/readonly_registry.dart';
import 'package:widject_container/src/registration_resolver.dart';
import 'package:widject_container/src/registration_resolver_factory.dart';
import 'package:flutter/widgets.dart';

class DependencyContainer {
  final ReadonlyRegistry _registry;
  final RegistrationResolverFactory _registrationResolverFactory;

  DependencyContainer(this._registry, this._registrationResolverFactory);

  tryGet<T>({Key? key, dynamic args}) {
    return tryGetByType(T, key: key, args: args);
  }

  tryGetByType(Type type, {Key? key, dynamic args}) {
    var registrationResolver = _tryGetResolver(type);
    if (registrationResolver == null) return null;

    return registrationResolver.solve(this, key: key, args: args);
  }

  RegistrationResolver? _tryGetResolver(Type type) {
    var registration = _registry.tryGet(type);
    if(registration == null) return null;

    return _registrationResolverFactory.create(registration);
  }

  Iterable<T> getMultiple<T>() {
    var resolvers = _registry.getCollection(T)
      .map((registration) => _registrationResolverFactory.create(registration));

    var instances = resolvers.map((resolver) => resolver.solve(this));
    return instances.cast<T>().toList(growable: false);
  }
}
