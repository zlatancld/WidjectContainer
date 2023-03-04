import 'package:widject_container/src/registration.dart';

abstract class ReadonlyRegistry {
  Registration? tryGet(Type type);
  Iterable<Registration>? tryGetCollection(Type type);
}
