import 'package:widject_container/initialization/initializable.dart';
import 'package:widject_container/src/initialization/initialization_progress.dart';

class InitializableReference {
  final int instanceHash;
  InitializationProgress progress;
  Initializable? instance;

  InitializableReference(
      this.instanceHash, this.progress, Initializable instance)
      : instance = instance;
}
