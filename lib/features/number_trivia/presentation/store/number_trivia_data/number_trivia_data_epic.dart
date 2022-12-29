import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/store/epic_filtered_class.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/concrete_number_trivia_params.dart';
import '../../../domain/entities/number_trivia.dart';
import '../../../domain/usecases/get_concrete_number_trivia.dart';
import '../../../domain/usecases/get_random_number_trivia.dart';
import 'number_trivia_data_actions.dart';

typedef _UseCaseInvoke = Future<Either<Failure, NumberTrivia>> Function();

@lazySingleton
class NumberTriviaDataEpic<T> extends EpicFilteredClass<T> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  NumberTriviaDataEpic({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
  });

  Stream<NumberTriviaDataAction> _handleConcrete(
      ConcreteNumberTriviaParams params) {
    return _handleAction(() => getConcreteNumberTrivia(params));
  }

  Stream<NumberTriviaDataAction> _handleRandom() {
    return _handleAction(() => getRandomNumberTrivia(const NoParams()));
  }

  Stream<NumberTriviaDataAction> _handleAction(_UseCaseInvoke useCase) async* {
    final triviaOrFailure = await useCase();

    yield triviaOrFailure.fold(
      NumberTriviaDataAction.fetchingFailed,
      NumberTriviaDataAction.fetchingSuccess,
    );
  }

  @override
  Stream mapAction(Stream actions, EpicStore<T> store) {
    return actions.whereType<NumberTriviaDataAction>().switchMap(
      (action) async* {
        yield* action.maybeWhen(
          fetchConcrete: _handleConcrete,
          fetchRandom: _handleRandom,
          orElse: () async* {},
        );
      },
    );
  }
}
