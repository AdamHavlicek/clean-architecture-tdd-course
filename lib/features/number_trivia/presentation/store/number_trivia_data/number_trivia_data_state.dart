import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/number_trivia.dart';

part 'number_trivia_data_state.freezed.dart';

@Freezed(
    map: FreezedMapOptions.none,
    when: FreezedWhenOptions.none
)
sealed class NumberTriviaDataState with _$NumberTriviaDataState {
  const NumberTriviaDataState._();

  const factory NumberTriviaDataState.empty() = EmptyState;

  const factory NumberTriviaDataState.loading() = LoadingState;

  const factory NumberTriviaDataState.loaded(
    NumberTrivia trivia,
  ) = LoadedState;
  
  const factory NumberTriviaDataState.error(
    Failure failure,
  ) = ErrorState;

  static const NumberTriviaDataState initial = NumberTriviaDataState.empty();
}
