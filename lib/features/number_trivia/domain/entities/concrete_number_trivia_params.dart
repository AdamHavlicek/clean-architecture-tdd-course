import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/unsigned_integer.dart';

part 'concrete_number_trivia_params.freezed.dart';

@freezed
class ConcreteNumberTriviaParams with _$ConcreteNumberTriviaParams {
  const ConcreteNumberTriviaParams._();

  const factory ConcreteNumberTriviaParams({
    required UnsignedInteger number,
  }) = _ConcreteNumberTriviaParams;

  factory ConcreteNumberTriviaParams.empty() {
    return ConcreteNumberTriviaParams(
      number: UnsignedInteger(''),
    );
  }
}
