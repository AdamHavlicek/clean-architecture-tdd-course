
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

@lazySingleton
class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {

  final NumberTriviaRepository repository;

  const GetRandomNumberTrivia({
    required this.repository
  });

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }

}