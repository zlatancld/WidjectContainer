# WidjectContainer
Dependency Injection package for Flutter

Simple DI package to help structure your Flutter application in loosely coupled components.

## Features

- Explicit constructor injection within scopes.
  - No use of reflection/mirrors.
- Nested scope support to isolate dependencies by widget type.
- Async initialization of scoped dependencies.

## Installation

Add the package with the command: ```flutter pub add widject_container``` or adding ```widject_container``` to your project's pubspec.yaml dependencies.

## Basic Usage

Create a scope connected to a widget and register the required types. The type references are automatically resolved when requested within the scope.

```dart
class AppScope extends Scope<AppWidget> {
  AppScope(): super(null);

  @override
  void configure(ContainerRegister register) {
    register.add((r) => HelloWorldProvider(), Lifetime.transient).as<MessageProvider>();
    register.addWidget((r, key, _) => AppWidget(r.get(), key: key));
  }
}
```

Where classes are:

```dart
abstract class MessageProvider {
  String getMessage();
}
```

```dart
class HelloWorldProvider implements MessageProvider {
  @override
  String getMessage()
    => "Hello world!";
}
```

```dart
class AppWidget extends StatelessWidget {
  final MessageProvider _messageProvider;
  
  const AppWidget(this._messageProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WidjectContainer Demo',
      home: Scaffold(
        body: Text(_messageProvider.getMessage())
      )
    );
  }
}
```

Example of scope usage in main function is:

```dart
void main() {
  var app = AppScope().getWidget();
  runApp(app);
}
```

### Widget Provider

Use ```WidgetProvider``` to instantiate widget types that have been registered within a scope. Dependencies are resolved and explicitly injected, as defined in the scope registration.

Example of registration:

```dart
class AppScope extends Scope<AppWidget> {
  ...

  @override
  void configure(ContainerRegister register) {
    ...
    register.addWidget((r, key, _) => NewWidget(r.get(), args, key: key));
  }
}
```

Example of usage through ```WidgetProvider```:

```dart
class AppWidget extends StatelessWidget {
  final MessageProvider _messageProvider;
  final WidgetProvider _widgetProvider;
  
  const AppWidget(this._messageProvider, this._widgetProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WidjectContainer Demo',
      home: Scaffold(
        body: _widgetProvider.getWidget<NewWidget>())
      )
    );
  }
}
```

### Nested Scopes

Connect the instantiation of a widget to a new scope, registering types and inheriting references from ancestor scopes.
This can be useful when creating a new screen that requires a whole new set of dependencies.

```dart
class ScreenScope extends Scope<ScreenWidget>{
  ScreenScope(super.parentContainer);

  @override
  void configure(ContainerRegister register) {
    register.addWidget((r, key, args) => ScreenWidget(...));
  }
}
```

Where the scoped widget binding in the parent scope is:

```dart
class AppScope extends Scope<AppWidget> {
  ...

  @override
  void configure(ContainerRegister register) {
    ...
    register.addScopedWidget((r, key, _) => ScreenScope(r));
  }
}
```

Example of usage through ```WidgetProvider```:

```dart
class AppWidget extends StatelessWidget {
  final MessageProvider _messageProvider;
  final WidgetProvider _widgetProvider;
  
  const AppWidget(this._messageProvider, this._widgetProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => _openChildWidget(context), 
        child: Text(_messageProvider.getMessage())
    );
  }
  
  _openChildWidget(BuildContext context){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => _widgetProvider.getWidget<ScreenWidget>()));
  }
}
```

## Credits

WidjectContainer is inspired by:

- [VContainer](https://github.com/hadashiA/VContainer).

## Author

[@zlatancld](https://www.linkedin.com/in/zlatancld)

## License

MIT
