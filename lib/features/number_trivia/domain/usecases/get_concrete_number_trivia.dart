import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/extensions/traverse_future_either.dart';
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
    return params.number.value.traverseEitherFuture(
      (number) => repository.getConcreteNumberTrivia(number),
    );
  }
}
