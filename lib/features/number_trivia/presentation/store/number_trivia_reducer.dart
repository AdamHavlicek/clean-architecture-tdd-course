import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/store/number_trivia_data/number_trivia_data_store.dart';

import 'number_trivia_form/number_trivia_form_store.dart';
import 'number_trivia_store.dart';

NumberTriviaState numberTriviaReducer(NumberTriviaState state, dynamic action) {
  return NumberTriviaState(
    numberTriviaFormState: numberTriviaFormReducer(
      state.numberTriviaFormState,
      action,
    ),
    numberTriviaDataState: numberTriviaDataReducer(
      state.numberTriviaDataState,
      action,
    ),
  );
}
