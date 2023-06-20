import 'package:equatable/equatable.dart';

sealed class BaseException extends Equatable implements Exception {
  final String message;

  const BaseException({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class ServerException extends BaseException {
  const ServerException({required super.message});
}

sealed class UnexpectedException extends BaseException {
  const UnexpectedException({required super.message});
}

final class UnexpectedServerException extends UnexpectedException {
  const UnexpectedServerException({required super.message});
}

final class CacheException extends BaseException {
  const CacheException({required super.message});
}
