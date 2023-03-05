import 'package:widject_container/src/registration.dart';

abstract class ReadonlyRegistry {
  Registration? tryGet(Type type);
  Iterable<Registration> getCollection(Type type);
}
