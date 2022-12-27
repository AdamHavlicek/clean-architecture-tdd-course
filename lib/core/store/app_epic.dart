import 'package:clean_architecture_tdd_course/core/store/app_state.dart';
import 'package:injectable/injectable.dart';
import 'package:redux_epics/redux_epics.dart';

import '../../features/number_trivia/presentation/store/number_trivia_data/number_trivia_data_epic.dart';

@lazySingleton
class AppEpic {
  final NumberTriviaDataEpic numberTriviaDataEpic;

  AppEpic({
    required this.numberTriviaDataEpic,
  });

  Epic<AppState> get combinedEpic => combineEpics([
    numberTriviaDataEpic
  ]);

}
