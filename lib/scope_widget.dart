import 'package:flutter/material.dart';
import 'package:widject_container/container_provider.dart';
import 'package:widject_container/container_register.dart';
import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/initialization/initializer.dart';
import 'package:widject_container/deferred_future_widget.dart';
import 'package:widject_container/installer.dart';
import 'package:widject_container/src/debug_log.dart';
import 'package:widject_container/src/scope_container.dart';
import 'package:widject_container/widget_provider.dart';

abstract class ScopeWidget<T extends Widget> extends StatefulWidget
    implements Installer {
  final bool _immediateChild;
  final bool initializeContainer;
  final void Function(ContainerRegister)? installer;
  final DependencyProvider? parentDependencyProvider;
  final T? child;
  final T Function(BuildContext context, DependencyProvider provider)?
      childBuilder;

  static Widget Function(Future<Widget>)? customDeferredWidgetFactory;

  @protected
  final dynamic args;

  const ScopeWidget.createImmediate(
      {super.key,
      this.args,
      this.installer,
      this.parentDependencyProvider,
      this.child,
      this.childBuilder,
      this.initializeContainer = true})
      : _immediateChild = true;

  const ScopeWidget.createDeferred(
      {super.key,
      this.args,
      this.installer,
      this.parentDependencyProvider,
      this.child,
      this.childBuilder})
      : initializeContainer = true,
        _immediateChild = false;

  @override
  State<StatefulWidget> createState() => _State<T>();

  @override
  void install(ContainerRegister register) {
    assert(installer != null,
        "Installer must be provided, or install method must be overridden.");
    installer!(register);
  }

  Widget _createWidget(BuildContext context, DependencyProvider provider) {
    var child = _getChildWidget(context, provider);

    if (_immediateChild) {
      _handleContainerInitialization(provider);
      return child;
    }

    return _buildDeferredChildWidget(context, child, provider);
  }

  Widget _getChildWidget(BuildContext context, DependencyProvider provider) {
    if (child != null) return child!;
    if (childBuilder != null) return childBuilder!(context, provider);

    return provider.get<WidgetProvider>().getRawWidget<T>(args: args);
  }

  Widget _buildDeferredChildWidget(
      BuildContext context, Widget child, DependencyProvider provider) {
    var futureChild = _buildFutureChild(context, child, provider);
    var builder = customDeferredWidgetFactory ??
        (Future<Widget> arg) => DeferredFutureWidget(arg);
    return builder(futureChild);
  }

  Future<Widget> _buildFutureChild(
      BuildContext context, Widget child, DependencyProvider provider) async {
    await _handleContainerInitialization(provider);
    return child;
  }

  Future _handleContainerInitialization(DependencyProvider provider) {
    if (!initializeContainer) return Future.value();

    var initializer = provider.get<Initializer>();
    return initializer.initialize();
  }
}

class _State<T extends Widget> extends State<ScopeWidget<T>> {
  final ScopeContainer _scopeContainer = ScopeContainer();
  final String _stateId = DateTime.now().toIso8601String();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_scopeContainer.isInitialized) return;

    _scopeContainer.initialize(widget, _resolveParentProvider());
  }

  DependencyProvider? _resolveParentProvider() {
    if (widget.parentDependencyProvider != null) {
      return widget.parentDependencyProvider;
    }

    var parentProvider = ContainerProvider.maybeOf(context);
    if (parentProvider == null) return null;

    return parentProvider;
  }

  @override
  void initState() {
    debugLog("🟢 INIT State $T ($_stateId)");
    super.initState();
  }

  DependencyProvider _getDependencyProvider() =>
      _scopeContainer.getDependencyProvider();

  @override
  Widget build(BuildContext context) {
    debugLog("⚡ BUILD State $T ($_stateId)");
    var dependencyProvider = _getDependencyProvider();
    return ContainerProvider(
        container: dependencyProvider,
        child: widget._createWidget(context, dependencyProvider));
  }

  @override
  void dispose() {
    debugLog("🔴 DISPOSE State $T ($_stateId)");
    _scopeContainer.dispose();
    super.dispose();
  }
}
