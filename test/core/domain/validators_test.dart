import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/domain/validators.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

typedef _StringToIntValidator = Either<Failure, int> Function(String);

void main() {
  group('validateUnsignedInteger', () {
    late _StringToIntValidator inputValidator;

    setUp(() {
      inputValidator = validateUnsignedInteger;
    });
    test(
        'should return an integer when the string represents an unsigned integer',
        () {
      // Arrange
      const String string = '1';
      const expectedResult = Right(1);

      // Act
      final result = inputValidator(string);

      // Assert
      expect(result, expectedResult);
    });

    test('should return a [Failure] when the string is not an integer', () {
      // Arrange
      const String string = '1.11';
      const expectedResult = Left(InvalidInputFailure('Must be an integer'));

      // Act
      final result = inputValidator(string);

      // Assert
      expect(result, expectedResult);
    });

    test('should return a [Failure] when the string is a negative integer', () {
      // Arrange
      const String string = '-1';
      const expectedResult =
          Left(InvalidInputFailure('Must be an unsigned integer'));

      // Act
      final result = inputValidator(string);

      // Assert
      expect(result, expectedResult);
    });

    test('should return a [Failure] when the string is empty', () {
      // Arrange
      const String string = ' ';
      const expectedResult = Left(
        InvalidInputFailure('Must be a non-empty string'),
      );

      // Act
      final result = inputValidator(string);

      // Assert
      expect(result, expectedResult);
    });
  });
}
