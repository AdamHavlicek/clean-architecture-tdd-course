import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/concrete_number_trivia_params.dart';

part 'number_trivia_form_state.freezed.dart';

@freezed
class NumberTriviaFormState with _$NumberTriviaFormState {
  const NumberTriviaFormState._();

  const factory NumberTriviaFormState({
    required ConcreteNumberTriviaParams params,
  }) = _NumberTriviaFormState;

  static NumberTriviaFormState initial = NumberTriviaFormState(
    params: ConcreteNumberTriviaParams.empty(),
  );

}
