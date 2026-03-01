import 'package:widject_container/initialization/initializer.dart';
import 'package:widject_container/deferred_future_widget.dart';
import 'package:widject_container/scope_widget.dart';
import 'package:widject_container/src/dependency_container.dart';
import 'package:flutter/widgets.dart';

class WidgetResolver {
  final DependencyContainer _container;
  final Initializer _initializer;

  WidgetResolver(this._container, this._initializer);

  static Widget Function(Future<Widget>)? customDeferredWidgetFactory;

  Widget resolve<T extends Widget>({Key? key, dynamic args}) {
    var scopedWidget =
        _container.tryGetByType(ScopeWidget<T>, key: key, args: args);
    if (scopedWidget != null) return scopedWidget;

    return _resolveDeferred(
        resolveExactTypeInitialized<T>(key: key, args: args));
  }

  bool canResolve<T extends Widget>() =>
      _container.canResolveByType(ScopeWidget<T>) ||
      _container.canResolveByType(T);

  Widget _resolveDeferred(Future<Widget> futureWidget) {
    return customDeferredWidgetFactory?.call(futureWidget) ??
        DeferredFutureWidget(futureWidget);
  }

  Future<T> resolveExactTypeInitialized<T extends Widget>(
      {Key? key, dynamic args}) async {
    var widget = resolveExactType<T>(key: key, args: args);
    await _initializer.initialize();
    return widget;
  }

  T resolveExactType<T extends Widget>({Key? key, dynamic args}) {
    var widget = _container.tryGetByType(T, key: key, args: args);
    if (widget == null) {
      throw Exception(
          "Widget $T hasn't been registered and can't be resolved.");
    }

    return widget;
  }
}
