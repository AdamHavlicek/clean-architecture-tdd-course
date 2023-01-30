import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../error/failures.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();

  Either<Failure, T> get value;

  T get get {
    return value.fold(
      (valueFailure) => throw Exception(
        'Tried to get value invalid [ValueObject]',
      ),
      id,
    );
  }

  Option<Failure> get failure {
    return value.fold(some, (_) => none());
  }

  Either<Failure, Unit> get failureOrUnit {
    return value.fold(
      left,
      (r) => right(unit),
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (other is ValueObject) {
      return value == other.value;
    } else if (other is Option<ValueObject<T>>) {
      return other.fold(
        () => false,
        (a) => value == a.value,
      );
    }

    return other == this;
  }

  @override
  String toString() {
    return value.fold(
      (failure) => '${failure.runtimeType}(${failure.message})',
      (value) => '$value',
    );
  }

  bool get isValid => value.isRight();

  @override
  int get hashCode => value.fold(
        (failure) => failure.hashCode,
        (value) => value.hashCode,
      );
}
