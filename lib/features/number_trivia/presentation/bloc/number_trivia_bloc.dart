import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

@injectable
class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  void _eitherLoadedOrErrorState(Either<Failure, NumberTrivia> failureOrTrivia, Emitter<NumberTriviaState> emit) {
    failureOrTrivia.fold(
      (failure) {
        final message = failure.message;
        emit(Error(message: message));
      },
      (trivia) => emit(Loaded(trivia: trivia)),
    );
  }

  void _handleGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) {
    final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

    return inputEither.fold(
      (failure) => emit(Error(message: failure.message)),
      (integer) async {
        emit(const Loading());

        final failureOrTrivia = await getConcreteNumberTrivia(
          Params(number: integer),
        );

        _eitherLoadedOrErrorState(failureOrTrivia, emit);
      },
    );
  }

  void _handleGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(const Loading());

    final failureOrTrivia = await getRandomNumberTrivia(
      const NoParams(),
    );

    _eitherLoadedOrErrorState(failureOrTrivia, emit);
  }

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(const Empty()) {
    on<GetTriviaForConcreteNumber>(_handleGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_handleGetTriviaForRandomNumber);
  }
}
