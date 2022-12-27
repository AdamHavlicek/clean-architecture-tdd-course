import '../../../../../core/domain/unsigned_integer.dart';
import 'number_trivia_form_store.dart';

NumberTriviaFormState numberTriviaFormReducer(
  NumberTriviaFormState state,
  dynamic action,
) {
  if (action is NumberTriviaFormAction) {
    return action.maybeWhen(
      numberChanged: (number) {
        return state.copyWith.params(number: UnsignedInteger(number!));
      },
      orElse: () => state,
    );
  }

  return state;
}
