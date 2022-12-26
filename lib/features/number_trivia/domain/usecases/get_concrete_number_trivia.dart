import 'package:clean_architecture_tdd_course/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

@lazySingleton
class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params>{
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia({
    required this.repository
  });

  @override
  Future<Either<Failure, NumberTrivia>> call(
    Params params 
  ) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
  
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});
  
  @override
  List<Object?> get props => [number];
  
}