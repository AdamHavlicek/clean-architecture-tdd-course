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

typedef _ConcreteOrRandomChooser = TaskEither<Exception, NumberTriviaDTO>
    Function();

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
    return _getTrivia(
      () => remoteDataSource.getConcreteNumberTrivia(number),
    );
  }

  @override
  TaskEither<Failure, NumberTrivia> getRandomNumberTrivia() {
    return _getTrivia(remoteDataSource.getRandomNumberTrivia);
  }

  TaskEither<Failure, NumberTrivia> _hitCache() {
    return TaskEither.fromEither(
      localDataSource.getLastNumberTrivia().run(),
    ).bimap(
      (exception) => CacheFailure((exception as CacheException).message),
      (triviaDto) => triviaDto.toDomain(),
    );
  }

  TaskEither<Failure, NumberTrivia> _hitNetwork(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) {
    return getConcreteOrRandom()
        .bimap(
          (exception) => ServerFailure(
            (exception as ServerException).message,
          ),
          (triviaDto) => triviaDto,
        )
        .chainFirst(
          (triviaDto) => TaskEither.fromTask(
            localDataSource.cacheNumberTrivia(triviaDto),
          ),
        )
        .map(
          (triviaDto) => triviaDto.toDomain(),
        );
  }

  TaskEither<Failure, NumberTrivia> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) {
    final triviaOrFailure = networkInfo.isConnected.map(
      (isConnected) => isConnected.match(
        _hitCache,
        () => _hitNetwork(getConcreteOrRandom),
      ),
    );

    return TaskEither.flatten(TaskEither.fromTask(triviaOrFailure));
    // if (await networkInfo.isConnected) {
    //   try {
    //     final remoteTrivia = await getConcreteOrRandom();
    //     localDataSource.cacheNumberTrivia(remoteTrivia);
    //
    //     return Either.right(remoteTrivia.toDomain());
    //   } on ServerException catch (e) {
    //     return Either.left(ServerFailure(e.message));
    //   }
    // }
    //
    // try {
    //   final localNumberTrivia = await localDataSource.getLastNumberTrivia();
    //
    //   return Either.right(localNumberTrivia.toDomain());
    // } on CacheException catch (e) {
    //   return Either.left(CacheFailure(e.message));
    // }
  }
}
