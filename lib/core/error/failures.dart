import 'package:equatable/equatable.dart';

import 'exceptions.dart';

typedef FailureFactory = Failure Function();

abstract class Failure extends Equatable {
  final List<dynamic> fields;
  final String message;

  const Failure(this.message, [this.fields = const []]);

  factory Failure.fromBaseException(BaseException exception) {
    final message = exception.message;

    final factories = {
      ServerException: () => ServerFailure(message),
      CacheException: () => CacheFailure(message),
    };

    final FailureFactory? failureFactory = factories[exception.runtimeType];

    if (failureFactory == null) throw exception;

    return failureFactory();
  }

  @override
  List<Object?> get props => [...fields, message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure(String message) : super(message);
}
