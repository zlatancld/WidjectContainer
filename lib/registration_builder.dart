import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/src/registration.dart';
import 'package:flutter/foundation.dart';

class RegistrationBuilder {
  final Type _concreteType;
  final List<Type> _types;
  final Lifetime _lifetime;
  final Function(DependencyProvider provider, Key? key, dynamic args)
      _instanceFactory;

  RegistrationBuilder(this._concreteType, this._lifetime, this._instanceFactory)
      : _types = [_concreteType];

  RegistrationBuilder as<T>() {
    return asType(T);
  }

  RegistrationBuilder asType(Type type) {
    if (!_types.contains(type)) {
      _types.add(type);
    }

    return this;
  }

  Registration build() => Registration(_concreteType,
      _types.toList(growable: false), _lifetime, _instanceFactory);
}
