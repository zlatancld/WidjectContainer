# WidjectContainer
Dependency Injection package for Flutter

Simple DI package to help structure your Flutter application in loosely coupled components. Inspired by VContainer.

## Features

- Explicit constructor injection within scopes.
  - No use of reflection/mirrors.
- Nested scope support to isolate dependencies by widget type.
- Async initialization of scoped dependencies.
- Automatic disposal of registered instances that implement `Disposable`, triggered by the widget lifecycle.

## Installation

Add the package with the command: ```flutter pub add widject_container``` or adding ```widject_container``` to your project's pubspec.yaml dependencies.

## Basic Usage

A **scope** is itself a widget (`ScopeWidget`). It defines which dependencies are available within that part of the widget tree. Use `install` to register types, and `addWidget` to register the widget that the scope builds.

```dart
class AppScope extends ScopeWidget<AppWidget> {
  const AppScope({super.key}) : super.createImmediate();

  @override
  void install(ContainerRegister register) {
    register.addWidget((p, key, args) => AppWidget(p.get(), key: key));
    register
        .add((p) => TapMessageProvider(), Lifetime.transient)
        .as<MessageProvider>();
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
class TapMessageProvider implements MessageProvider {
  @override
  String getMessage() => "Tap Here!";
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

The scope is the entry point. Pass it directly to `runApp`:

```dart
void main() {
  runApp(const AppScope());
}
```

### Widget Resolver

Use `WidgetResolver` to instantiate widgets registered within a scope. Dependencies are resolved and explicitly injected, as defined in the scope registration.

Example of registration:

```dart
class AppScope extends ScopeWidget<AppWidget> {
  ...

  @override
  void install(ContainerRegister register) {
    ...
    register.addWidget((p, key, args) => AppWidget(p.get(), key: key));
  }
}
```

Example of usage through `WidgetResolver`:

```dart
class AppWidget extends StatelessWidget {
  final WidgetResolver _widgetResolver;

  const AppWidget(this._widgetResolver, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WidjectContainer Demo',
      home: Scaffold(body: _widgetResolver.resolve<HomeScreenWidget>())
    );
  }
}
```

### Nested Scopes

Nest a scope inside a parent scope using `addScopeForWidget`. The child scope inherits all dependencies registered in ancestor scopes and can define its own. This is ideal for screens or features that require an isolated set of dependencies.

```dart
class HomeScope extends ScopeWidget<HomeScreenWidget> {
  const HomeScope({super.args, super.key}) : super.createDeferred();

  @override
  void install(ContainerRegister register) {
    register.addWidget((p, key, args) => HomeScreenWidget(p.get(), p.get()));
    register
        .add((p) => TapMessageProvider(), Lifetime.transient)
        .as<MessageProvider>();
    register.addScopeForWidget(
        (p, key, args) => OtherScreenScope(key: key, args: args));
  }
}
```

In the parent scope, bind the child scope using `addScopeForWidget`:

```dart
class AppScope extends ScopeWidget<AppWidget> {
  ...

  @override
  void install(ContainerRegister register) {
    ...
    register.addScopeForWidget(
        (p, key, args) => HomeScope(key: key, args: args));
  }
}
```

The child widget is then resolved via `WidgetResolver`, which automatically wraps the scope around it:

```dart
class HomeScreenWidget extends StatelessWidget {
  final MessageProvider _messageProvider;
  final WidgetResolver _widgetResolver;

  const HomeScreenWidget(this._messageProvider, this._widgetResolver, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _widgetResolver.resolve<OtherScreenWidget>())),
        child: Text(_messageProvider.getMessage())));
  }
}
```

### Disposal

Any registered instance that implements the `Disposable` interface will have its `dispose` method called automatically when the scope widget is removed from the widget tree.

```dart
class MyService implements Disposable {
  @override
  void dispose() {
    // clean up resources
  }
}
```

Register it as usual within a scope:

```dart
register.add((p) => MyService(), Lifetime.singleton).as<MyService>();
```

### Async Initialization

Register types implementing `Initializable` to perform async work before the scope's widget is shown. Use `createDeferred` in the scope constructor to defer rendering until initialization is complete.

```dart
class MyInitializable implements Initializable {
  @override
  InitializationGroup get group => InitializationGroup.normal;

  @override
  Future initialize() async {
    // async setup
  }
}
```

```dart
class MyScope extends ScopeWidget<MyWidget> {
  const MyScope({super.key}) : super.createDeferred();

  @override
  void install(ContainerRegister register) {
    register.addWidget((p, key, args) => MyWidget(key: key));
    register
        .add((p) => MyInitializable(), Lifetime.singleton)
        .as<Initializable>();
  }
}
```

### Debug Logging

Enable scope lifecycle logs (init, build, dispose) during development via `WidjectSettings`:

```dart
void main() {
  WidjectSettings.enableDebugLogs = true;
  runApp(const AppScope());
}
```

Logs are always disabled in release builds regardless of this setting.

## Credits

WidjectContainer is inspired by:

- [VContainer](https://github.com/hadashiA/VContainer).

## Author

[Claudio Mazza](https://www.linkedin.com/in/zlatancld)

## License

MIT
