import 'package:widject_container/initialization/initialization_controller.dart';
import 'package:widject_container/registration.dart';
import 'package:widject_container/registration_resolver.dart';
import 'package:widject_container/singletons.dart';

class RegistrationResolverFactory {
  final Singletons _singletons;
  final InitializationController _initializationController;

  RegistrationResolverFactory(this._singletons, this._initializationController);

  RegistrationResolver create(Registration registration) {
    return RegistrationResolver(
        registration, _singletons, _initializationController);
  }
}
