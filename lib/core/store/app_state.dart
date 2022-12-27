import 'package:equatable/equatable.dart';

import '../../features/number_trivia/presentation/store/number_trivia_store.dart';

class AppState extends Equatable {
  final NumberTriviaState numberTriviaState;

  const AppState({required this.numberTriviaState});

  static AppState initial = AppState(
    numberTriviaState: NumberTriviaState.initial,
  );

  @override
  List<Object?> get props => [
        numberTriviaState,
      ];
}
