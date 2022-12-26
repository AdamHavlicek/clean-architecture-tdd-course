import 'dart:convert';

import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_dto.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {

  test('should be a subclass of [NumberTrivia] Entity', () async {
    // Arrange

    // Act
    const result = NumberTriviaDTO(number: 1, text: 'Test Text');

    // Assert
    expect(result, isA<NumberTrivia>());
  });

  group('fromJson', () {
    const tNumberTriviaDTO = NumberTriviaDTO(number: 1, text: 'Test Text');

    test('shoud return a valid model when JSON number is an integer', () {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      // Act
      final result = NumberTriviaDTO.fromJson(jsonMap);

      // Assert
      expect(result, tNumberTriviaDTO);

    });

    test('shoud return a valid model when JSON number is an double', () {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));

      // Act
      final result = NumberTriviaDTO.fromJson(jsonMap);

      // Assert
      expect(result, tNumberTriviaDTO);

    });
  });
  
  group('toJson', () {
    const tNumberTriviaDTO = NumberTriviaDTO(number: 1, text: 'Test Text');

    test('should return a JSON map containing proper data', () {
      // Arrange
      final Map<String, dynamic> expectedResult = {
        'text': 'Test Text',
        'number': 1,
      };

      // Act
      final result = tNumberTriviaDTO.toJson();

      // Assert
      expect(result, expectedResult);
    });
  });

}
