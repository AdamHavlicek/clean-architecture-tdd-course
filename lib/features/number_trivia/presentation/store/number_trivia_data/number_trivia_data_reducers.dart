import 'number_trivia_data_store.dart';

NumberTriviaDataState numberTriviaDataReducer(
  NumberTriviaDataState state,
  dynamic action,
) {
  if (action is NumberTriviaDataAction) {
    return action.maybeWhen(
      fetchConcrete: (_) => const NumberTriviaDataState.loading(),
      fetchRandom: () => const NumberTriviaDataState.loading(),
      fetchingSuccess: NumberTriviaDataState.loaded,
      fetchingFailed: NumberTriviaDataState.error,
      orElse: () => state,
    );
  }

  return state;
}
