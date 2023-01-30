import 'package:reselect/reselect.dart';

import '../../../../../core/store/app_state.dart';
import '../number_trivia_store.dart';
import 'number_trivia_form_state.dart';

final numberTriviaFormStateSelector =
    createSelector1<AppState, NumberTriviaState, NumberTriviaFormState>(
  numberTriviaStateSelector,
  (state) => state.numberTriviaFormState,
);
