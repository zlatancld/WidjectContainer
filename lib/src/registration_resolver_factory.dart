import 'package:widject_container/src/initialization/initialization_controller.dart';
import 'package:widject_container/src/registration.dart';
import 'package:widject_container/src/registration_resolver.dart';
import 'package:widject_container/src/singletons.dart';

class RegistrationResolverFactory {
  final Singletons _singletons;
  final InitializationController _initializationController;

  RegistrationResolverFactory(this._singletons, this._initializationController);

  RegistrationResolver create(Registration registration) {
    return RegistrationResolver(
        registration, _singletons, _initializationController);
  }
}
