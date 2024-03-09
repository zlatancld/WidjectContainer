import 'package:widject_container/src/container_builder.dart';
import 'package:widject_container/container_register.dart';
import 'package:widject_container/src/dependency_container.dart';
import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/initialization/initializer.dart';
import 'package:flutter/widgets.dart';

abstract class Scope<T extends Widget> {
  final DependencyProvider? _parentDependencyProvider;
  DependencyContainer? _dependencyContainer;

  Scope(this._parentDependencyProvider);

  Future<T> getInitializedWidget({Key? key, dynamic args}) async {
    var widget = getWidget(key: key, args: args);
    await initialize();
    return widget;
  }

  T getWidget({Key? key, dynamic args}) {
    var container = _getDependencyContainer();
    var widget = container.tryGet<T>(key: key, args: args);

    if (widget == null)
      throw Exception("Widget $T hasn't been registered in scope $runtimeType");

    return widget;
  }

  Future initialize() {
    var provider = _getDependencyContainer();
    var initializationController = provider.tryGet<Initializer>();
    return initializationController?.initialize() ?? Future.value();
  }

  DependencyContainer _getDependencyContainer() =>
      _dependencyContainer ??= _createDependencyContainer();

  DependencyContainer _createDependencyContainer() {
    var containerBuilder = ContainerBuilder();
    configure(containerBuilder);
    return containerBuilder.build(_parentDependencyProvider);
  }

  @protected
  void configure(ContainerRegister register);

  @protected
  DependencyProvider getDependencyProvider() =>
      DependencyProvider(_getDependencyContainer());
}
