import 'dart:ffi';

import 'package:clean_architecture_tdd_course/core/domain/value_object.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../error/failures.dart';

// part 'input_converter.freezed.dart';

@singleton
class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String string) {
    final int parsedInteger;
    try {
      parsedInteger = int.parse(string);
    } on FormatException {
      return const Left(InvalidInputFailure('Value must be valid Unsigned integer'));
    }

    if (parsedInteger < 0) {
      return const Left(InvalidInputFailure('Integer must be positive'));
    }

    return Right(parsedInteger);
  }
}

Either<Failure, int> validateUnsignedIntegerString(String string) {
  final int parsedInteger;
  try {
    parsedInteger = int.parse(string);
  } on FormatException {
    return const Left(InvalidInputFailure('Value must be valid Unsigned integer'));
  }

  if (parsedInteger < 0) {
    return const Left(InvalidInputFailure('Integer must be positive'));
  }

  return Right(parsedInteger);
}

class UnsignedInteger extends ValueObject<int> {
  @override
  final Either<Failure, int> value;

  factory UnsignedInteger(String inputValue) {
    return UnsignedInteger._(validateUnsignedIntegerString(inputValue));
  }

  const UnsignedInteger._(this.value);
}