import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

void main() {
  late InputConverter tInputConvert;

  setUp(() {
    tInputConvert = InputConverter();
  });

  group('stringToUnsignedInteger', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () {
      // Arrange
      const String string = '1';
      const expectedResult = Right(1);

      // Act
      final result = tInputConvert.stringToUnsignedInteger(string);

      // Assert
      expect(result, expectedResult);
    });

    test('should return a [Failure] when the string is not an integer', () {
      // Arrange
      const String string = '1.11';
      const expectedResult = Left(InvalidInputFailure('Value must be valid Unsigned integer'));

      // Act
      final result = tInputConvert.stringToUnsignedInteger(string);

      // Assert
      expect(result, expectedResult);
    });

    test('should return a [Failure] when the string is a negative integer', () {
      // Arrange
      const String string = '-1';
      const expectedResult = Left(InvalidInputFailure('Integer must be positive'));

      // Act
      final result = tInputConvert.stringToUnsignedInteger(string);

      // Assert
      expect(result, expectedResult);
    });
  });
}
