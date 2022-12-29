import 'package:dartz/dartz.dart';

import '../error/failures.dart';

Either<Failure, String> validateNotEmptyString(
  String? input, [
  String errorMessage = 'Must be a non-empty string',
]) {
  if (input == null) {
    return const Left(InvalidInputFailure('Must be string'));
  }

  input = input.trim();
  if (input.isEmpty) {
    return Left(InvalidInputFailure(errorMessage));
  }

  return right(input);
}

Either<Failure, int> validateInteger(
  String? input, [
  String errorMessage = 'Must be an integer',
]) {
  Either<Failure, int> validate(String value) {
    final int? parsedInteger = int.tryParse(value);

    if (parsedInteger == null) {
      return Left(InvalidInputFailure(errorMessage));
    }

    return Right(parsedInteger);
  }

  return validateNotEmptyString(
    input,
  ).flatMap(
    validate,
  );
}

Either<Failure, int> validateUnsignedInteger(
  String? input, [
  String errorMessage = 'Must be an unsigned integer',
]) {
  Either<Failure, int> validate(int value) {
    if (value < 0) {
      return Left(InvalidInputFailure(errorMessage));
    }
    return Right(value);
  }

  return validateInteger(
    input,
  ).flatMap(
    validate,
  );
}
