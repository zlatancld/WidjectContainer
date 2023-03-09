import 'package:widject_container/src/readonly_registry.dart';
import 'package:flutter/widgets.dart';

class DependencyContainer {
  final ReadonlyRegistry _registry;

  DependencyContainer(this._registry);

  tryGet<T>({Key? key, dynamic args}) {
    return tryGetByType(T, key: key, args: args);
  }

  tryGetByType(Type type, {Key? key, dynamic args}) {
    var registrationResolver = _registry.tryGet(type);
    if (registrationResolver == null) return null;

    return registrationResolver.solve(this, key: key, args: args);
  }

  Iterable<T> getMultiple<T>() {
    var resolvers = _registry.getCollection(T);
    var instances = resolvers.map((resolver) => resolver.solve(this));
    return instances.cast<T>().toList(growable: false);
  }
}
