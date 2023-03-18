import 'package:widject_container/container_register.dart';
import 'package:widject_container/example/app_widget.dart';
import 'package:widject_container/example/hello_world_provider.dart';
import 'package:widject_container/example/message_provider.dart';
import 'package:widject_container/example/screen_scope.dart';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/scope.dart';

class AppScope extends Scope<AppWidget> {
  AppScope() : super(null);

  @override
  void configure(ContainerRegister register) {
    register
        .add((p) => HelloWorldProvider(), Lifetime.transient)
        .as<MessageProvider>();
    register.addWidget((p, key, args) => AppWidget(p.get(), p.get(), key: key));
    register.addScopedWidget((p, key, args) => ScreenScope(p));
  }
}
