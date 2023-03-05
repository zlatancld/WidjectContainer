import 'dart:collection';
import 'package:widject_container/src/readonly_registry.dart';
import 'package:widject_container/src/registration.dart';

class Registry implements ReadonlyRegistry {
  final HashMap<Type, Registration> _registrations;
  final HashMap<Type, List<Registration>> _collectionRegistrations;

  Registry(Iterable<Registration> registrations)
      : _registrations = HashMap(),
        _collectionRegistrations = HashMap() {
    for (var registration in registrations) {
      add(registration);
    }
  }

  void add(Registration registration) {
    for (var type in registration.types) {
      _add(registration, type);
    }
  }

  void _add(Registration registration, Type type) {
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
  Registration? tryGet(Type type) {
    var registration = _registrations[type];
    return registration;
  }

  @override
  Iterable<Registration> getCollection(Type type) {
    var collection = _collectionRegistrations[type];
    if(collection != null) return collection;

    var singleRegistration = tryGet(type);
    if(singleRegistration != null) return [singleRegistration];

    return [];
  }
}
