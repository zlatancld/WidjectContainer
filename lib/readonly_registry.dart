import 'package:widject_container/registration.dart';

abstract class ReadonlyRegistry {
  Registration? tryGet(Type type);
  Iterable<Registration>? tryGetCollection(Type type);
}
