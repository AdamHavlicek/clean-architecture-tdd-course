import 'package:equatable/equatable.dart';

abstract class BaseException extends Equatable implements Exception {
  final String message;

  const BaseException({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class ServerException extends BaseException {
  const ServerException(String message) : super(message: message);
}

class CacheException extends BaseException {
  const CacheException(String message) : super(message: message);
}
