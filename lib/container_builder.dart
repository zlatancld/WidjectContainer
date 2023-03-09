import 'package:widject_container/container_register.dart';
import 'package:widject_container/initialization/initializable.dart';
import 'package:widject_container/src/dependency_container.dart';
import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/initialization/initializer.dart';
import 'package:widject_container/src/initialization/initialization_controller.dart';
import 'package:widject_container/installer.dart';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/registration_builder.dart';
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
      T Function(DependencyProvider) instanceFactory, Lifetime lifetime) {
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
      T Function(DependencyProvider, Key? key, dynamic args) instanceFactory) {
    return _add<T>(instanceFactory, Lifetime.transient);
  }

  @override
  void addScopedWidget<T extends Widget>(
      Scope<T> Function(DependencyProvider, Key? key, dynamic args)
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

    var registry = _createRegistry(parentProvider);
    var container = DependencyContainer(registry);

    _addPostBuild(_PrivateProvider<DependencyContainer>(container), registry);
    _preWarmNonTransientInitializables(registry, container);

    return container;
  }

  InitializationController _createInitializationController(
      DependencyProvider? parentProvider) {
    var parentController = parentProvider
        ?.get<_PrivateProvider<InitializationController>>()
        .instance;

    var controller = InitializationController(parentController);
    add<Initializer>((p) => controller, Lifetime.transient);
    add<_PrivateProvider<InitializationController>>(
            (p) => _PrivateProvider<InitializationController>(controller),
        Lifetime.transient);

    return controller;
  }

  Registry _createRegistry(DependencyProvider? parentProvider) {
    var registrations = _builders.map((builder) => builder.build());
    var parentRegistry =
        parentProvider?.get<_PrivateProvider<Registry>>().instance;
    var singletons = Singletons();
    var initializationController = _createInitializationController(
        parentProvider);
    var registrationResolverFactory = RegistrationResolverFactory(singletons,
        initializationController);

    var registry = Registry(registrations, parentRegistry,
        registrationResolverFactory);
    add<_PrivateProvider<Registry>>((p) => _PrivateProvider<Registry>(registry),
        Lifetime.transient);

    return registry;
  }

  void _addWidgetProvider() {
    add<WidgetProvider>((p) => WidgetProvider(
            p.get<_PrivateProvider<DependencyContainer>>().instance),
        Lifetime.transient);
  }

  _addPostBuild<T>(T instance, Registry registry) {
    var builder =
        RegistrationBuilder(T, Lifetime.transient, (_, __, ___) => instance);
    var registration = builder.build();
    registry.add(registration);
  }

  void _preWarmNonTransientInitializables(Registry registry,
      DependencyContainer container){
    var nonTransientRegistrations = registry.getCollection(Initializable)
        .where((element) => element.lifetime != Lifetime.transient);

    for(var registration in nonTransientRegistrations){
      registration.solve(container);
    }
  }
}

class _PrivateProvider<T> {
  final T instance;

  _PrivateProvider(this.instance);
}
