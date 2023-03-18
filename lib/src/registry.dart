import 'dart:collection';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/src/readonly_registry.dart';
import 'package:widject_container/src/registration.dart';
import 'package:widject_container/src/registration_resolver.dart';
import 'package:widject_container/src/registration_resolver_factory.dart';

class Registry implements ReadonlyRegistry {
  final Registry? _parent;
  final HashMap<Type, RegistrationResolver> _registrations;
  final HashMap<Type, List<RegistrationResolver>> _collectionRegistrations;
  final RegistrationResolverFactory _resolverFactory;

  Registry(
      Iterable<Registration> registrations, this._parent, this._resolverFactory)
      : _registrations = HashMap(),
        _collectionRegistrations = HashMap() {
    for (var registration in registrations) {
      add(registration);
    }
  }

  void add(Registration registration) {
    var registrationResolver = _getRegistrationResolver(registration);
    for (var type in registration.types) {
      _add(registrationResolver, type);
    }
  }

  RegistrationResolver _getRegistrationResolver(Registration registration) {
    if (registration.lifetime == Lifetime.singleton) {
      var singletonConcreteType = registration.concreteType;
      var parentRegistration = _parent?.tryGet(singletonConcreteType);

      if (parentRegistration != null &&
          parentRegistration.lifetime == Lifetime.singleton) {
        return parentRegistration;
      }
    }

    return _resolverFactory.create(registration);
  }

  void _add(RegistrationResolver registration, Type type) {
    var collection = _collectionRegistrations[type];
    if (collection != null) {
      collection.add(registration);
      return;
    }

    var existingRegistration = _registrations[type];
    if (existingRegistration != null) {
      _registrations.remove(type);
      _collectionRegistrations[type] = [existingRegistration, registration];
      return;
    }

    _registrations[type] = registration;
  }

  @override
  RegistrationResolver? tryGet(Type type) {
    var registration = _registrations[type];

    if (registration != null) return registration;

    return _parent?.tryGet(type);
  }

  @override
  Iterable<RegistrationResolver> getCollection(Type type) {
    var collection = _getLocalCollection(type).toSet();

    if (_parent != null) {
      var parentLocalCollection = _parent!._getLocalCollection(type);
      collection.addAll(parentLocalCollection);
    }

    return collection;
  }

  Iterable<RegistrationResolver> _getLocalCollection(Type type) {
    var collection = _collectionRegistrations[type];
    if (collection != null) return collection;

    var singleRegistration = tryGet(type);
    if (singleRegistration != null) return [singleRegistration];

    return Iterable<RegistrationResolver>.empty();
  }
}
