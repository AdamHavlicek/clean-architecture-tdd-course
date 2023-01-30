import '../../features/number_trivia/presentation/store/number_trivia_store.dart';
import 'app_state.dart';

AppState appReducer(
  AppState state,
  dynamic action,
) {
  return AppState(
    numberTriviaState: numberTriviaReducer(
      state.numberTriviaState,
      action,
    ),
  );
}
