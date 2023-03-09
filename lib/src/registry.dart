import 'dart:collection';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/src/readonly_registry.dart';
import 'package:widject_container/src/registration.dart';

class Registry implements ReadonlyRegistry {
  final Registry? _parent;
  final HashMap<Type, Registration> _registrations;
  final HashMap<Type, List<Registration>> _collectionRegistrations;

  Registry(Iterable<Registration> registrations, this._parent)
      : _registrations = HashMap(),
        _collectionRegistrations = HashMap() {
    for (var registration in registrations) {
      add(registration);
    }
  }

  void add(Registration registration) {
    var concreteRegistration = _getConcreteRegistration(registration);
    for (var type in registration.types) {
      _add(concreteRegistration, type);
    }
  }

  Registration _getConcreteRegistration(Registration registration){
    if(registration.lifetime == Lifetime.singleton){
      var singletonConcreteType = registration.concreteType;
      var parentRegistration = _parent?.tryGet(singletonConcreteType);

      if(parentRegistration != null
          && parentRegistration.lifetime == Lifetime.singleton){
        return parentRegistration;
      }
    }

    return registration;
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

    if(registration != null) return registration;

    return _parent?.tryGet(type);
  }

  @override
  Iterable<Registration> getCollection(Type type) {
    var collection = _getLocalCollection(type).toSet();

    if(_parent != null){
      var parentLocalCollection = _parent!._getLocalCollection(type);
      collection.addAll(parentLocalCollection);
    }

    return collection;
  }

  Iterable<Registration> _getLocalCollection(Type type){
    var collection = _collectionRegistrations[type];
    if(collection != null) return collection;

    var singleRegistration = tryGet(type);
    if(singleRegistration != null) return [singleRegistration];

    return Iterable<Registration>.empty();
  }
}
