import 'package:flutter/material.dart';
import 'package:widject_container/example/app_scope.dart';

void main() {
  var app = AppScope().getWidget();
  runApp(app);
}
