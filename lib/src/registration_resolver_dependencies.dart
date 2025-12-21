import 'dart:collection';

import 'package:widject_container/dependency_provider.dart';
import 'package:widject_container/disposable.dart';
import 'package:widject_container/src/initialization/initialization_controller.dart';
import 'package:widject_container/src/singletons.dart';

class RegistrationResolverDependencies {
  final DependencyProvider dependencyProvider;
  final Singletons singletons;
  final InitializationController initializationController;
  final HashSet<Disposable> disposables;

  RegistrationResolverDependencies(
      this.dependencyProvider, this.singletons, this.initializationController, this.disposables);
}
