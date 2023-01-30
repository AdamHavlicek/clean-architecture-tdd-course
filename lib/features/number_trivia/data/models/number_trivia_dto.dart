import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/data/converters.dart';
import '../../domain/entities/number_trivia.dart';

part 'number_trivia_dto.freezed.dart';
part 'number_trivia_dto.g.dart';

@freezed
class NumberTriviaDTO with _$NumberTriviaDTO {
  const factory NumberTriviaDTO({
    required String text,
    @NumberConvertor() required int number,
  }) = _NumberTriviaDTO;

  const NumberTriviaDTO._();

  factory NumberTriviaDTO.fromJson(Map<String, dynamic> json) =>
      _NumberTriviaDTO.fromJson(json);

  NumberTrivia toDomain() {
    return NumberTrivia(
      text: text,
      number: number,
    );
  }
}
