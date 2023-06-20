import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Task<bool> get isConnected;
}

@LazySingleton(as: NetworkInfo)
final class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl({
    required this.connectionChecker,
  });

  @override
  Task<bool> get isConnected => Task(() => connectionChecker.hasConnection);
}
