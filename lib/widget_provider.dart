import 'package:widject_container/src/dependency_container.dart';
import 'package:widject_container/scope.dart';
import 'package:flutter/widgets.dart';

class WidgetProvider {
  final DependencyContainer _container;

  WidgetProvider(this._container);

  T getWidget<T extends Widget>({Key? key, dynamic args}) {
    var scope = _tryGetScope<T>();
    if (scope != null) return scope.getWidget(key: key, args: args);

    return _getWidget<T>(key: key, args: args);
  }

  Scope<T>? _tryGetScope<T extends Widget>() {
    return _container.tryGetByType(Scope<T>);
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
    var scope = _tryGetScope<T>();
    if (scope != null)
      return await scope.getInitializedWidget(key: key, args: args);

    return _getWidget<T>(key: key, args: args);
  }
}
