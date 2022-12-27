import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/number_trivia.dart';

part 'number_trivia_data_state.freezed.dart';

@freezed
class NumberTriviaDataState with _$NumberTriviaDataState {
  const NumberTriviaDataState._();

  const factory NumberTriviaDataState.empty() = _Empty;
  const factory NumberTriviaDataState.loading() = _Loading;
  const factory NumberTriviaDataState.loaded(
    NumberTrivia trivia,
  ) = _Loaded;
  const factory NumberTriviaDataState.error(
    Failure failure,
  ) = _Error;

  static const NumberTriviaDataState initial = NumberTriviaDataState.empty();
}
