import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }
  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }
  Future<dynamic> pushNamedAndRemoveUntil(String newRouteName, {Object? arguments}) {
    return Navigator.of(this).pushNamedAndRemoveUntil(newRouteName, (route) => false, arguments: arguments);
  }
  void pop() {
    return Navigator.of(this).pop();
  }
  TextStyle get textStyle=>Theme.of(this).textTheme.displaySmall!;
}

extension StringValidator on String? {
  bool  isNullOrEmpty() => this == null || this!.isEmpty;
}

extension ListExtension<T> on List<T>?{
  bool isNullOrEmpty() => this == null || this!.isEmpty ;
}

extension StringCasingExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}