import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  TaskEither<Failure, NumberTrivia> getConcreteNumberTrivia(int number);

  TaskEither<Failure, NumberTrivia> getRandomNumberTrivia();
}
