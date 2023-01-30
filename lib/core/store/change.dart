class Change<State> {
  final State previousState;
  final State currentState;

  Change({
    required this.previousState,
    required this.currentState,
  });
}
