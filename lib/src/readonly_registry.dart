import 'package:widject_container/src/registration_resolver.dart';

abstract class ReadonlyRegistry {
  RegistrationResolver? tryGet(Type type);
  Iterable<RegistrationResolver> getCollection(Type type);
}
