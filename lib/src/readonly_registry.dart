import 'package:widject_container/disposable.dart';
import 'package:widject_container/src/registration_resolver.dart';

abstract class ReadonlyRegistry implements Disposable{
  RegistrationResolver? tryGet(Type type);
  Iterable<RegistrationResolver> getCollection(Type type);
}
