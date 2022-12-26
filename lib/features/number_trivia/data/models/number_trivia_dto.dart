
import '../../domain/entities/number_trivia.dart';

class NumberTriviaDTO extends NumberTrivia {
  final String text;
  final int number;

  const NumberTriviaDTO({
    required this.text,
    required this.number
  }) : super(
    text: text,
    number: number
  );

  factory NumberTriviaDTO.fromJson(Map<String, dynamic> json) {
    return NumberTriviaDTO(
      text: json['text'], 
      number: (json['number'] as num).toInt()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number
    };
  }

}