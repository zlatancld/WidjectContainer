import 'package:widject_container/example/message_provider.dart';

class HelloWorldProvider implements MessageProvider {
  @override
  String getMessage() => "Hello world!";
}
