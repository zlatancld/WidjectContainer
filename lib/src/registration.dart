import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/lifetime.dart';
import 'package:flutter/foundation.dart';

class Registration {
  final Type concreteType;
  final List<Type> _types;
  final Lifetime lifetime;
  final Function(DependencyProvider provider, Key? key, dynamic args)
      instanceFactory;

  Registration(this.concreteType, this._types, this.lifetime, this.instanceFactory);

  Iterable<Type> get types => _types;
}
