import 'package:rxdart/rxdart.dart';

import '../store/change.dart';

extension ChangeState<S> on Stream<S> {
  Stream<Change<S>> get changes {
    return distinct().pairwise().map(
          (event) => Change(
            previousState: event.first,
            currentState: event.last,
          ),
        );
  }
}