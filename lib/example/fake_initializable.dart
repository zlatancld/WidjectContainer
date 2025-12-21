import 'package:widject_container/initialization/initializable.dart';
import 'package:widject_container/initialization/initialization_group.dart';

class FakeInitializable implements Initializable {
  @override
  InitializationGroup get group => InitializationGroup.normal;

  @override
  Future initialize() => Future.delayed(const Duration(seconds: 3));
}
