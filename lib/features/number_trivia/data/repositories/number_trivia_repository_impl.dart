import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';
import '../models/number_trivia_dto.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaDTO> Function();

@LazySingleton(as: NumberTriviaRepository)
class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  TaskEither<Failure, NumberTrivia> getConcreteNumberTrivia(int number) {
    return TaskEither(() => _getTrivia(
          () => remoteDataSource.getConcreteNumberTrivia(number),
        ));
  }

  @override
  TaskEither<Failure, NumberTrivia> getRandomNumberTrivia() {
    return TaskEither(() => _getTrivia(remoteDataSource.getRandomNumberTrivia));
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);

        return Either.right(remoteTrivia.toDomain());
      } on ServerException catch (e) {
        return Either.left(ServerFailure(e.message));
      }
    }
    
    try {
      final localNumberTrivia = await localDataSource.getLastNumberTrivia();

      return Either.right(localNumberTrivia.toDomain());
    } on CacheException catch (e) {
      return Either.left(CacheFailure(e.message));
    }
  }
}
