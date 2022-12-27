import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/concrete_number_trivia_params.dart';

part 'number_trivia_form_state.freezed.dart';

@freezed
class NumberTriviaFormState with _$NumberTriviaFormState {

  const factory NumberTriviaFormState({
    required ConcreteNumberTriviaParams params,
  }) = _NumberTriviaFormState;

  const NumberTriviaFormState._();

  static NumberTriviaFormState initial = NumberTriviaFormState(
    params: ConcreteNumberTriviaParams.empty(),
  );

}
