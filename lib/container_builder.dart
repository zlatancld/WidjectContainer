import 'package:widject_container/container_register.dart';
import 'package:widject_container/dependency_container.dart';
import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/initialization/initializer.dart';
import 'package:widject_container/initialization/initialization_controller.dart';
import 'package:widject_container/installer.dart';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/registration_builder.dart';
import 'package:widject_container/registration_resolver_factory.dart';
import 'package:widject_container/registry.dart';
import 'package:widject_container/scope.dart';
import 'package:widject_container/singletons.dart';
import 'package:widject_container/widget_provider.dart';
import 'package:flutter/widgets.dart';

class ContainerBuilder implements ContainerRegister{
  final List<RegistrationBuilder> _builders;

  ContainerBuilder() : _builders = List<RegistrationBuilder>.empty(growable: true);

  @override
  RegistrationBuilder add<T>(T Function(DependencyProvider) instanceFactory, Lifetime lifetime){
    return _add<T>((provider, key, args) => instanceFactory(provider), lifetime);
  }

  RegistrationBuilder _add<T>(T Function(DependencyProvider, Key?, dynamic) instanceFactory, Lifetime lifetime){
    var builder = RegistrationBuilder(T, lifetime, instanceFactory);
    _builders.add(builder);
    return builder;
  }

  @override
  RegistrationBuilder addWidget<T extends Widget>(T Function(DependencyProvider, Key? key, dynamic args) instanceFactory){
    return _add<T>(instanceFactory, Lifetime.transient);
  }

  @override
  void addScopedWidget<T extends Widget>(Scope<T> Function(DependencyProvider, Key? key, dynamic args) instanceFactory) {
    var builder = RegistrationBuilder(_getScopeType<T>(), Lifetime.transient, instanceFactory);
    _builders.add(builder);
  }

  Type _getScopeType<T extends Widget>(){
    return Scope<T>;
  }

  @override
  install(Installer installer) {
    installer.install(this);
  }

  DependencyContainer build(DependencyProvider? parentProvider){
    var initializationController = _createInitializationController(parentProvider);
    _addDefaults(initializationController);

    var registrations = _builders.map((builder) => builder.build());
    var registry = Registry(registrations);
    var singletons = Singletons();
    var registrationResolverFactory = RegistrationResolverFactory(singletons, initializationController);
    var parentContainer = parentProvider?.get<_PrivateProvider<DependencyContainer>>().instance;

    var container = DependencyContainer(registry, registrationResolverFactory, parentContainer);
    _addPostBuild(_PrivateProvider<DependencyContainer>(container), registry);

    return container;
  }

  InitializationController _createInitializationController(DependencyProvider? parentProvider){
    var parentController = parentProvider?.get<_PrivateProvider<InitializationController>>().instance;
    return InitializationController(parentController);
  }

  void _addDefaults(InitializationController initializationController){
    add<Initializer>((p) => initializationController, Lifetime.transient);
    add<_PrivateProvider<InitializationController>>(
      (p) => _PrivateProvider<InitializationController>(initializationController), Lifetime.transient);
    add<WidgetProvider>((p) => WidgetProvider(p.get<_PrivateProvider<DependencyContainer>>().instance), Lifetime.transient);
  }

  _addPostBuild<T>(T instance, Registry registry) {
    var builder = RegistrationBuilder(T, Lifetime.transient, (_, __, ___) => instance);
    var registration = builder.build();
    registry.add(registration);
  }
}

class _PrivateProvider<T>{
  final T instance;

  _PrivateProvider(this.instance);
}