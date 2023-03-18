import 'package:widject_container/container_builder.dart';
import 'package:widject_container/container_register.dart';
import 'package:widject_container/src/dependency_container.dart';
import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/initialization/initializer.dart';
import 'package:flutter/widgets.dart';

abstract class Scope<T extends Widget> {
  final DependencyProvider? _parentProvider;
  DependencyContainer? _container;

  Scope(this._parentProvider);

  Future<T> getInitializedWidget({Key? key, dynamic args}) async {
    var widget = getWidget(key: key, args: args);
    await initialize();
    return widget;
  }

  T getWidget({Key? key, dynamic args}) {
    var container = _getContainer();
    var widget = container.tryGet<T>(key: key, args: args);

    if (widget == null)
      throw Exception("Widget $T hasn't been registered in scope $runtimeType");

    return widget;
  }

  Future initialize(){
    var container = _getContainer();
    var initializationController = container.tryGet<Initializer>();
    return initializationController.initialize();
  }

  DependencyContainer _getContainer() {
    if (_container == null) {
      var containerBuilder = ContainerBuilder();
      configure(containerBuilder);
      _container = containerBuilder.build(_parentProvider);
    }

    return _container!;
  }

  @protected
  void configure(ContainerRegister register);
}
