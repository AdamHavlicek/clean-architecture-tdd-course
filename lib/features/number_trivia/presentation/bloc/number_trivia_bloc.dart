import 'package:clean_architecture_tdd_course/core/domain/unsigned_integer.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/concrete_number_trivia_params.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

typedef _UseCaseInvoke = Future<Either<Failure, NumberTrivia>> Function();

@injectable
class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  Future<void> _handleUseCase(
      Emitter<NumberTriviaState> emit, _UseCaseInvoke useCase) async {
    emit(const Loading());

    final failureOrTrivia = await useCase();

    failureOrTrivia.fold(
      (failure) {
        final message = failure.message;
        emit(Error(message: message));
      },
      (trivia) => emit(Loaded(trivia: trivia)),
    );
  }

  Future<void> _handleGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    await _handleUseCase(
      emit,
      () => getConcreteNumberTrivia(
        ConcreteNumberTriviaParams(number: UnsignedInteger(event.numberString)),
      ),
    );
  }

  Future<void> _handleGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    await _handleUseCase(
      emit,
      () => getRandomNumberTrivia(const NoParams()),
    );
  }

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
  }) : super(const Empty()) {
    on<GetTriviaForConcreteNumber>(_handleGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_handleGetTriviaForRandomNumber);
  }
}
