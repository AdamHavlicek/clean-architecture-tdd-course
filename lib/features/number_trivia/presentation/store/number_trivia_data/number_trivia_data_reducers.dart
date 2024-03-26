import 'number_trivia_data_store.dart';

NumberTriviaDataState numberTriviaDataReducer(
  NumberTriviaDataState state,
  dynamic action,
) {
  if (action is NumberTriviaDataAction) {
    return switch (action) {
      FetchConcreteAction() => const NumberTriviaDataState.loading(),
      FetchRandomAction() => const NumberTriviaDataState.loading(),
      FetchingSuccessAction(:final trivia) => NumberTriviaDataState.loaded(
          trivia,
        ),
      FetchingFailedAction(:final failure) => NumberTriviaDataState.error(
          failure,
        ),
    };
  }

  return state;
}
