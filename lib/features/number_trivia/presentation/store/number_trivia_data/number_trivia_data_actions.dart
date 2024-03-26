import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/concrete_number_trivia_params.dart';
import '../../../domain/entities/number_trivia.dart';

part 'number_trivia_data_actions.freezed.dart';

@Freezed(
    map: FreezedMapOptions.none,
    when: FreezedWhenOptions.none
)
sealed class NumberTriviaDataAction with _$NumberTriviaDataAction {
  const NumberTriviaDataAction._();

  const factory NumberTriviaDataAction.fetchRandom() = FetchRandomAction;

  const factory NumberTriviaDataAction.fetchConcrete(
    ConcreteNumberTriviaParams params,
  ) = FetchConcreteAction;

  const factory NumberTriviaDataAction.fetchingSuccess(
    NumberTrivia trivia,
  ) = FetchingSuccessAction;

  const factory NumberTriviaDataAction.fetchingFailed(
    Failure failure,
  ) = FetchingFailedAction;
}
