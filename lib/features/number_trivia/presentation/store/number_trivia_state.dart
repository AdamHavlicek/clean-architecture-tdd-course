import 'package:equatable/equatable.dart';

import 'number_trivia_data/number_trivia_data_state.dart';
import 'number_trivia_form/number_trivia_form_store.dart';

class NumberTriviaState extends Equatable {
  final NumberTriviaFormState numberTriviaFormState;
  final NumberTriviaDataState numberTriviaDataState;

  const NumberTriviaState({
    required this.numberTriviaFormState,
    required this.numberTriviaDataState,
  });

  static NumberTriviaState initial = NumberTriviaState(
    numberTriviaFormState: NumberTriviaFormState.initial,
    numberTriviaDataState: NumberTriviaDataState.initial,
  );

  @override
  List<Object?> get props => [
        numberTriviaFormState,
        numberTriviaDataState,
      ];
}
