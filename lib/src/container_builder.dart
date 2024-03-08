import 'package:widject_container/container_register.dart';
import 'package:widject_container/initialization/initializable.dart';
import 'package:widject_container/initialization/readonly_initialization_state.dart';
import 'package:widject_container/src/dependency_container.dart';
import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/initialization/initializer.dart';
import 'package:widject_container/src/initialization/initialization_controller.dart';
import 'package:widject_container/installer.dart';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/registration_builder.dart';
import 'package:widject_container/src/initialization/initialization_state.dart';
import 'package:widject_container/src/registration_resolver_dependencies.dart';
import 'package:widject_container/src/registration_resolver_factory.dart';
import 'package:widject_container/src/registry.dart';
import 'package:widject_container/scope.dart';
import 'package:widject_container/src/singletons.dart';
import 'package:widject_container/widget_provider.dart';
import 'package:flutter/widgets.dart';

class ContainerBuilder implements ContainerRegister {
  final List<RegistrationBuilder> _builders;

  ContainerBuilder()
      : _builders = List<RegistrationBuilder>.empty(growable: true);

  @override
  RegistrationBuilder add<T>(
      T Function(DependencyProvider p) instanceFactory, Lifetime lifetime) {
    return _add<T>(
        (provider, key, args) => instanceFactory(provider), lifetime);
  }

  RegistrationBuilder _add<T>(
      T Function(DependencyProvider, Key?, dynamic) instanceFactory,
      Lifetime lifetime) {
    var builder = RegistrationBuilder(T, lifetime, instanceFactory);
    _builders.add(builder);
    return builder;
  }

  @override
  RegistrationBuilder addWidget<T extends Widget>(
      T Function(DependencyProvider p, Key? key, dynamic args)
          instanceFactory) {
    return _add<T>(instanceFactory, Lifetime.transient);
  }

  @override
  void addScopedWidget<T extends Widget>(
      Scope<T> Function(DependencyProvider p, Key? key, dynamic args)
          instanceFactory) {
    var builder = RegistrationBuilder(
        _getScopeType<T>(), Lifetime.transient, instanceFactory);
    _builders.add(builder);
  }

  Type _getScopeType<T extends Widget>() {
    return Scope<T>;
  }

  @override
  install(Installer installer) {
    installer.install(this);
  }

  DependencyContainer build(DependencyProvider? parentProvider) {
    _addWidgetProvider();

    var singletons = _createSingletons();
    var initializationController =
        _createInitializationController(parentProvider);
    var registry =
        _createRegistry(parentProvider, singletons, initializationController);
    var container =
        DependencyContainer(registry, singletons, initializationController);

    _addPostRegistry(container, registry);
    _preWarmSingletonInitializables(
        registry, container, singletons, initializationController);

    return container;
  }

  InitializationController _createInitializationController(
      DependencyProvider? parentProvider) {
    var parentController = parentProvider?.get<InitializationController>();

    var state = InitializationState();
    var controller = InitializationController(parentController, state);
    add<Initializer>((_) => controller, Lifetime.transient);
    add<ReadonlyInitializationState>((_) => state, Lifetime.transient);
    add<InitializationController>((_) => controller, Lifetime.transient);

    return controller;
  }

  Registry _createRegistry(
      DependencyProvider? parentProvider,
      Singletons singletons,
      InitializationController initializationController) {
    var registrations = _builders.map((builder) => builder.build());
    var parentRegistry = parentProvider?.get<Registry>();
    var resolverFactory =
        RegistrationResolverFactory(singletons, initializationController);

    var registry = Registry(registrations, parentRegistry, resolverFactory);
    _addPostRegistry(registry, registry);

    return registry;
  }

  Singletons _createSingletons() {
    var singletons = Singletons();
    add<Singletons>((p) => singletons, Lifetime.transient);
    return singletons;
  }

  void _addWidgetProvider() {
    add<WidgetProvider>(
        (p) => WidgetProvider(
            p.get<DependencyContainer>(), p.get<InitializationController>()),
        Lifetime.transient);
  }

  _addPostRegistry<T>(T instance, Registry registry) {
    var builder =
        RegistrationBuilder(T, Lifetime.transient, (_, __, ___) => instance);
    var registration = builder.build();
    registry.add(registration);
  }

  void _preWarmSingletonInitializables(
      Registry registry,
      DependencyContainer container,
      Singletons singletons,
      InitializationController initializationController) {
    var nonTransientRegistrations = registry
        .getCollection(Initializable)
        .where((element) => element.lifetime == Lifetime.singleton);

    var resolverDependencies = RegistrationResolverDependencies(
        DependencyProvider(container), singletons, initializationController);
    for (var registration in nonTransientRegistrations) {
      registration.solve(resolverDependencies);
    }
  }
}
