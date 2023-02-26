import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/installer.dart';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/registration_builder.dart';
import 'package:widject_container/scope.dart';
import 'package:flutter/widgets.dart';

abstract class ContainerRegister {
  RegistrationBuilder add<T>(
      T Function(DependencyProvider) instanceFactory, Lifetime lifetime);
  RegistrationBuilder addWidget<T extends Widget>(
      T Function(DependencyProvider, Key? key, dynamic args) instanceFactory);
  void addScopedWidget<T extends Widget>(
      Scope<T> Function(DependencyProvider, Key? key, dynamic args)
          instanceFactory);
  install(Installer installer);
}
