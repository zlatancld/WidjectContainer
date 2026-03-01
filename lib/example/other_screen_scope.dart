import 'package:widject_container/container_register.dart';
import 'package:widject_container/example/message_provider.dart';
import 'package:widject_container/example/other_screen_message_provider.dart';
import 'package:widject_container/example/other_screen_widget.dart';
import 'package:widject_container/lifetime.dart';
import 'package:widject_container/scope_widget.dart';

class OtherScreenScope extends ScopeWidget<OtherScreenWidget> {
  const OtherScreenScope({super.args, super.key}) : super.createDeferred();

  @override
  void install(ContainerRegister register) {
    register.addWidget((p, key, args) => OtherScreenWidget(p.get(), key: key));
    register
        .add((p) => OtherScreenMessageProvider(), Lifetime.transient)
        .as<MessageProvider>();
  }
}
