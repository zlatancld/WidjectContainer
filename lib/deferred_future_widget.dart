import 'package:flutter/material.dart';

class DeferredFutureWidget extends StatelessWidget {
  final Future<Widget> _futureWidget;

  const DeferredFutureWidget(this._futureWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      initialData: null,
      future: _futureWidget,
      builder: (buildContext, snapshot) {
        if (snapshot.hasError) {
          handleInitializationError(buildContext, snapshot.error!, snapshot.stackTrace!);
        }

        if (snapshot.hasData && snapshot.data != null) {
          return snapshot.data!;
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                snapshot.hasError
                    ? buildInitializationErrorWidget(buildContext, snapshot.error!)
                    : buildInitializationInProgressWidget(buildContext)
              ],
            ),
          ),
        );
      },
    );
  }

  @protected
  void handleInitializationError(BuildContext context, Object error, StackTrace stackTrace) {
    throw Exception(
        "Error while loading future widget - error:$error - stacktrace:$stackTrace");
  }

  @protected
  Widget buildInitializationErrorWidget(BuildContext context, Object error) {
    return const Icon(Icons.error);
  }

  @protected
  Widget buildInitializationInProgressWidget(BuildContext context) {
    return const SizedBox.square(
        dimension: 16, child: CircularProgressIndicator(strokeWidth: 4));
  }
}
