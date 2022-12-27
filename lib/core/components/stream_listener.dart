import 'dart:async';

import 'package:flutter/material.dart';

typedef StreamListenerCallback<T> = void Function(T value);

class StreamListener<T> extends StatefulWidget {
  final Stream<T> stream;
  final StreamListenerCallback<T> listener;
  final Widget child;

  const StreamListener({
    Key? key,
    required this.stream,
    required this.listener,
    required this.child,
  }) : super(key: key);

  @override
  StreamListenerState<T> createState() => StreamListenerState<T>();
}

class StreamListenerState<T> extends State<StreamListener<T>> {
  late final StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.stream.listen(widget.listener);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}