import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/registration.dart';
import 'package:flutter/foundation.dart';

class RegistrationBuilder {
  final List<Type> _types;
  final Lifetime _lifetime;
  final Function(DependencyProvider provider, Key? key, dynamic args)
      _instanceFactory;

  RegistrationBuilder(Type defaultType, this._lifetime, this._instanceFactory)
      : _types = [defaultType];

  RegistrationBuilder as<T>() {
    return asType(T);
  }

  RegistrationBuilder asType(Type type) {
    if (!_types.contains(type)) {
      _types.add(type);
    }

    return this;
  }

  Registration build() =>
      Registration(_types.toList(growable: false), _lifetime, _instanceFactory);
}
