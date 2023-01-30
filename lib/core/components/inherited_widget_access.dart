import 'package:flutter/material.dart';

/// Generic inherited widget for storing any value which need
/// to be accessible in widget tree
class InheritedWidgetAccess<T> extends InheritedWidget {
  final T value;

  const InheritedWidgetAccess({
    required this.value,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return value != value;
  }

  static InheritedWidgetAccess<T> of<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedWidgetAccess<T>>()!;
  }
}
