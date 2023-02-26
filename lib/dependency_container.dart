import 'package:widject_container/lifetime.dart';
import 'package:widject_container/readonly_registry.dart';
import 'package:widject_container/registration_resolver.dart';
import 'package:widject_container/registration_resolver_factory.dart';
import 'package:flutter/widgets.dart';

class DependencyContainer {
  final ReadonlyRegistry _registry;
  final RegistrationResolverFactory _registrationResolverFactory;
  final DependencyContainer? _parent;

  DependencyContainer(
      this._registry, this._registrationResolverFactory, this._parent);

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
    var resolver = registration != null
        ? _registrationResolverFactory.create(registration)
        : null;

    if (resolver != null && registration!.lifetime != Lifetime.singleton) {
      return resolver;
    }

    var parentResolver = _parent?._tryGetResolver(type);
    if (parentResolver != null) return parentResolver;

    return resolver;
  }

  Iterable<T> getMultiple<T>() {
    var resolvers = _getMultipleResolvers<T>();
    var instances = resolvers.map((resolver) => resolver.solve(this)).toSet();

    return instances.cast<T>();
  }

  Iterable<RegistrationResolver> _getMultipleResolvers<T>() {
    var registrations = _registry.tryGetCollection(T) ?? [];
    var resolvers = registrations
        .map(
            (registration) => _registrationResolverFactory.create(registration))
        .toList();

    var parentResolvers = _parent?._getMultipleResolvers<T>();
    if (parentResolvers != null) {
      resolvers.addAll(parentResolvers);
    }

    return resolvers;
  }
}
