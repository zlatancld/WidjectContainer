import 'package:widject_container/dependency_container.dart';
import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/initialization/initialization_controller.dart';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/registration.dart';
import 'package:widject_container/singletons.dart';
import 'package:flutter/foundation.dart';

class RegistrationResolver{
  final Registration _registration;
  final Singletons _singletons;
  final InitializationController _initializationController;

  RegistrationResolver(this._registration, this._singletons, this._initializationController);

  solve(DependencyContainer requester, {Key? key, dynamic args}){
    var provider = DependencyProvider(requester);

    switch(_registration.lifetime)
    {
      case Lifetime.singleton:
      case Lifetime.scoped:
        return _solveSingleton(_registration, provider, key, args);

      case Lifetime.transient:
        return _solveTransient(_registration, provider, key, args);
    }
  }

  _solveSingleton(Registration registration, DependencyProvider provider, Key? key, dynamic args){
    var instance = _singletons.getOrAdd(registration, provider, key, args);
    _initializationController.register(instance);
    return instance;
  }

  _solveTransient(Registration registration, DependencyProvider provider, Key? key, dynamic args){
    var instance = registration.instanceFactory(provider, key, args);
    _initializationController.register(instance);
    return instance;
  }
}