import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';
import 'validators.dart';
import 'value_object.dart';

class UnsignedInteger extends ValueObject<int> {
  @override
  final Either<Failure, int> value;

  factory UnsignedInteger(String? inputValue) {
    return UnsignedInteger._(validateUnsignedInteger(inputValue));
  }

  const UnsignedInteger._(this.value);
}
