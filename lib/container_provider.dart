import 'package:flutter/widgets.dart';
import 'package:widject_container/dependency_provider.dart';

class ContainerProvider extends InheritedWidget {
  final DependencyProvider container;

  const ContainerProvider({
    super.key,
    required this.container,
    required super.child,
  });

  static DependencyProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ContainerProvider>();
    if (provider == null) {
      throw FlutterError(
        'ContainerProvider.of() called with a context that does not contain a ContainerProvider.\n'
            'No "WidgetScope" ancestor could be found starting from the context that was passed.',
      );
    }
    return provider.container;
  }

  static DependencyProvider? maybeOf(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ContainerProvider>();
    return provider?.container;
  }

  @override
  bool updateShouldNotify(ContainerProvider oldWidget) {
    return container != oldWidget.container;
  }
}