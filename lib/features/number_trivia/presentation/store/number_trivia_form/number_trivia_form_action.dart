import 'package:freezed_annotation/freezed_annotation.dart';

part 'number_trivia_form_action.freezed.dart';

@Freezed(
  map: FreezedMapOptions.none,
  when: FreezedWhenOptions.none
)
sealed class NumberTriviaFormAction with _$NumberTriviaFormAction {
  const NumberTriviaFormAction._();

  const factory NumberTriviaFormAction.numberChanged(String? number) =
      NumberChangedAction;
}
