import 'package:widject_container/src/dependency_container.dart';

class DependencyProvider {
  final DependencyContainer _container;

  DependencyProvider(this._container);

  T get<T>() {
    var result = _container.tryGetByType(T);
    if (result == null)
      throw Exception("Type $T hasn't been registered and can't be provided.");

    return result;
  }

  Iterable<T> getMultiple<T>() {
    return _container.getMultiple<T>();
  }
}
