import 'package:widject_container/container_register.dart';
import 'package:widject_container/example/home_screen_widget.dart';
import 'package:widject_container/example/message_provider.dart';
import 'package:widject_container/example/other_screen_scope.dart';
import 'package:widject_container/example/tap_message_provider.dart';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/scope_widget.dart';

class HomeScope extends ScopeWidget<HomeScreenWidget> {
  const HomeScope({super.args, super.key}) : super.createDeferred();

  @override
  install(ContainerRegister register) {
    register.addWidget((p, key, args) => HomeScreenWidget(p.get(), p.get()));
    register
        .add((p) => TapMessageProvider(), Lifetime.transient)
        .as<MessageProvider>();
    register.addScopeForWidget(
        (p, key, args) => OtherScreenScope(key: key, args: args));
  }
}
