import 'package:widject_container/initialization/initializer.dart';
import 'package:widject_container/src/dependency_container.dart';
import 'package:widject_container/scope.dart';
import 'package:flutter/widgets.dart';

class WidgetProvider {
  final DependencyContainer _container;
  final Initializer _initializer;

  WidgetProvider(this._container, this._initializer);

  T getWidget<T extends Widget>({Key? key, dynamic args}) {
    var scope = _tryGetScope<T>(key, args);
    if (scope != null) return scope.getWidget(key: key, args: args);

    return _getWidget<T>(key: key, args: args);
  }

  Scope<T>? _tryGetScope<T extends Widget>(Key? key, dynamic args) {
    return _container.tryGetByType(Scope<T>, key: key, args: args);
  }

  T _getWidget<T extends Widget>({Key? key, dynamic args}) {
    var widget = _container.tryGetByType(T, key: key, args: args);
    if (widget == null)
      throw Exception(
          "Widget $T hasn't been registered and can't be resolved.");

    return widget;
  }

  Future<T> getInitializedWidget<T extends Widget>(
      {Key? key, dynamic args}) async {
    var scope = _tryGetScope<T>(key, args);
    if (scope != null)
      return await scope.getInitializedWidget(key: key, args: args);

    var widget = _getWidget<T>(key: key, args: args);
    await _initializer.initialize();
    return widget;
  }
}
