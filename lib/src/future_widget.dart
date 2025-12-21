import 'package:flutter/material.dart';

class FutureWidget extends StatelessWidget {
  final Future<Widget> Function() _widgetFactory;

  const FutureWidget(this._widgetFactory, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
        initialData: null,
        future: _widgetFactory(),
        builder: (buildContext, snapshot) {
          if (snapshot.hasError) {
            throw Exception(
                "Error while loading _ScopeWidgetState - error:${snapshot.error} - stacktrace:${snapshot.stackTrace}");
          }

          return Center(
            child: snapshot.data ??
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      snapshot.hasError
                          ? const Icon(Icons.error)
                          : const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 4))
                    ],
                  ),
                ),
          );
        });
  }
}
