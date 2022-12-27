import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../store/app_state.dart';

typedef StateSelector<State> = State Function(AppState state);
typedef StateBuilder<State> = Widget Function(
  BuildContext context,
  State state,
);
typedef ShouldRebuild<State> = bool Function(State state);

class AppStoreConnector<State> extends StatelessWidget {
  final StateSelector<State> selector;
  final StateBuilder<State> builder;
  final ShouldRebuild<State>? shouldRebuild;

  const AppStoreConnector({
    required this.selector,
    required this.builder,
    this.shouldRebuild,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, State>(
      converter: (store) => selector(store.state),
      distinct: true,
      builder: builder,
      ignoreChange: (state) => !(shouldRebuild?.call(selector(state)) ?? true),
    );
  }
}