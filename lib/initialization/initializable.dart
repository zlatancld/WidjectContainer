import 'package:widject_container/initialization/initialization_group.dart';

abstract class Initializable{
  InitializationGroup get group;
  Future initialize();
}