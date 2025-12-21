import 'package:widject_container/container_register.dart';
import 'package:widject_container/example/app_widget.dart';
import 'package:widject_container/example/fake_initializable.dart';
import 'package:widject_container/example/home_scope.dart';
import 'package:widject_container/initialization/initializable.dart';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/scope_widget.dart';

class AppScope extends ScopeWidget<AppWidget> {
  const AppScope({super.key}) : super.createImmediate();

  @override
  void install(ContainerRegister register) {
    register.addWidget((p, key, args) => AppWidget(p.get(), key: key));
    register
        .add((p) => FakeInitializable(), Lifetime.singleton)
        .as<Initializable>();
    register
        .addScopeForWidget((p, key, args) => HomeScope(key: key, args: args));
  }
}
