import 'package:widject_container/container_register.dart';
import 'package:widject_container/example/screen_widget.dart';
import 'package:widject_container/scope.dart';

class ScreenScope extends Scope<ScreenWidget> {
  ScreenScope(super.parentProvider);

  @override
  void configure(ContainerRegister register) {
    register.addWidget((p, key, args) => ScreenWidget());
  }
}
