import 'package:equatable/equatable.dart';

import 'exceptions.dart';

sealed class Failure extends Equatable {
  final List<dynamic> fields;
  final String message;

  const Failure(this.message, [this.fields = const []]);

  factory Failure.fromBaseException(BaseException exception) {
    final Failure failure = switch (exception) {
      final UnexpectedException e => UnexpectedFailure(e.message),
      final ServerException e => ServerFailure(e.message),
      final CacheException e => CacheFailure(e.message),
    };

    return failure;
  }

  @override
  List<Object?> get props => [...fields, message];
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

final class InvalidInputFailure extends Failure {
  const InvalidInputFailure(super.message);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([message = 'Unexpected Failure']) : super(message);
}