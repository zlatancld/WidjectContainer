import 'package:widject_container/initialization/initializer.dart';
import 'package:widject_container/scope.dart';
import 'package:flutter/widgets.dart';
import 'package:widject_container/src/dependency_container.dart';
import 'package:widject_container/widget_resolver.dart';

@Deprecated("Resolve widgets using WidgetResolver instead.")
class WidgetProvider {
  final DependencyContainer _container;
  final Initializer _initializer;
  final WidgetResolver _widgetResolver;

  WidgetProvider(this._container, this._initializer, this._widgetResolver);

  Widget resolveWidget<T extends Widget>({Key? key, dynamic args}) {
    return _widgetResolver.resolve<T>(key: key, args: args);
  }

  bool canResolveWidget<T extends Widget>() =>
      _widgetResolver.canResolve<T>();

  Future<T> getInitializedRawWidget<T extends Widget>(
      {Key? key, dynamic args}) async {
    return _widgetResolver.resolveExactTypeInitialized<T>(key: key, args: args);
  }

  T getRawWidget<T extends Widget>({Key? key, dynamic args}) {
    return _widgetResolver.resolveExactType<T>(key: key, args: args);
  }

  @Deprecated(
      "Use resolveWidget for generic scoped or initialized widget, or getRawWidget for typed unscoped result.")
  T getWidget<T extends Widget>({Key? key, dynamic args}) {
    var scope = _container.tryGetByType(Scope<T>, key: key, args: args);
    if (scope != null) return scope.getWidget(key: key, args: args);

    return getRawWidget<T>(key: key, args: args);
  }

  @Deprecated(
      "Use resolveWidget for generic scoped or initialized widget, or getInitializedRawWidget for typed unscoped result.")
  Future<T> getInitializedWidget<T extends Widget>(
      {Key? key, dynamic args}) async {
    var scope = _container.tryGetByType(Scope<T>, key: key, args: args);
    if (scope != null) {
      return await scope.getInitializedWidget(key: key, args: args);
    }

    var widget = getRawWidget<T>(key: key, args: args);
    await _initializer.initialize();
    return widget;
  }
}
