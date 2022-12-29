import 'package:flutter/material.dart';

import '../../../../core/components/store/app_store_connector.dart';
import '../../domain/entities/number_trivia.dart';
import '../store/number_trivia_data/number_trivia_data_store.dart';

part 'number_trivia_display.widgets.dart';

class NumberTriviaDisplay extends StatelessWidget {
  const NumberTriviaDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStoreConnector<NumberTriviaDataState>(
      selector: numberTriviaDataSelector,
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (trivia) => TriviaDisplay(
            trivia: trivia,
          ),
          loading: () => const LoadingWidget(),
          error: (failure) => MessageDisplay(
            message: failure.message,
          ),
          orElse: () => const MessageDisplay(
            message: 'Start searching!',
          ),
        );
      },
    );
  }
}
