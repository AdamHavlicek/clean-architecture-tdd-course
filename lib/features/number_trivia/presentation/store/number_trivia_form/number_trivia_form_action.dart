import 'package:freezed_annotation/freezed_annotation.dart';

part 'number_trivia_form_action.freezed.dart';

@freezed
sealed class NumberTriviaFormAction with _$NumberTriviaFormAction {
  const NumberTriviaFormAction._();

  const factory NumberTriviaFormAction.numberChanged(String? number) =
      _NumberChanged;
}
