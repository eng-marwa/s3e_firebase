import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void navigateTo(String routeName, [Object? args]) {
    Navigator.pushNamed(this, routeName, arguments: args);
  }
}
