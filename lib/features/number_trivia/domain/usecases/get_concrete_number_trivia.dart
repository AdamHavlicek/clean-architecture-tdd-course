import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/concrete_number_trivia_params.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

@lazySingleton
class GetConcreteNumberTrivia
    implements UseCase<NumberTrivia, ConcreteNumberTriviaParams> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia({required this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call(
      ConcreteNumberTriviaParams params) async {
    final number = params.number.value;
    final result =
        number.toTaskEither().flatMap(repository.getConcreteNumberTrivia);

    return result.run();
  }
}
