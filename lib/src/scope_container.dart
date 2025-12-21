import 'package:widject_container/container_builder.dart';
import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/installer.dart';
import 'package:widject_container/src/dependency_container.dart';

class ScopeContainer {
  DependencyContainer? _container;
  bool _disposed = false;

  bool get isInitialized => _container != null;

  DependencyContainer _getContainer() {
    if (_disposed) {
      throw Exception("Container has been disposed");
    }

    return _container!;
  }

  DependencyProvider getDependencyProvider() =>
      DependencyProvider(_getContainer());

  void initialize(Installer installer, DependencyProvider? parentProvider) {
    _container = _createContainer(installer, parentProvider);
  }

  DependencyContainer _createContainer(
      Installer installer, DependencyProvider? parentProvider) {
    if (_disposed) {
      throw Exception("Container has been disposed");
    }

    var containerBuilder = ContainerBuilder();
    containerBuilder.install(installer);
    return containerBuilder.build(parentProvider);
  }

  void dispose() {
    _container?.dispose();
    _container = null;
    _disposed = true;
  }
}
