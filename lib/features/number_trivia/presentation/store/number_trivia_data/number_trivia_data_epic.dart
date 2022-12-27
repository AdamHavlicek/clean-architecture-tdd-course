import 'package:clean_architecture_tdd_course/core/usecases/usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../core/store/app_state.dart';
import '../../../../../core/store/epic_filtered_class.dart';
import '../../../domain/usecases/get_concrete_number_trivia.dart';
import '../../../domain/usecases/get_random_number_trivia.dart';
import 'number_trivia_data_actions.dart';

@lazySingleton
class NumberTriviaDataEpic extends EpicFilteredClass<AppState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  NumberTriviaDataEpic({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
  });

  @override
  Stream mapAction(Stream actions, EpicStore<AppState> store) {
    return actions
        .whereType<NumberTriviaDataAction>()
        .switchMap((action) async* {
      yield* action.maybeWhen(
        fetchConcrete: (params) async* {
          final triviaOrFailure = await getConcreteNumberTrivia(params);
          yield triviaOrFailure.fold(
            NumberTriviaDataAction.fetchingFailed,
            NumberTriviaDataAction.fetchingSuccess,
          );
        },
        fetchRandom: () async* {
          final triviaOrFailure = await getRandomNumberTrivia(
            const NoParams(),
          );
          yield triviaOrFailure.fold(
            NumberTriviaDataAction.fetchingFailed,
            NumberTriviaDataAction.fetchingSuccess,
          );
        },
        orElse: () async* {},
      );
    });
  }
}
