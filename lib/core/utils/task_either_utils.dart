
import 'package:fpdart/fpdart.dart';

class TaskEitherUtils<L, R> {
  const TaskEitherUtils._();

  static TaskEither<L, R> tryCatchG<L extends Exception, R>(
    Future<R> Function() run,
    L Function(L error, StackTrace stackTrace) onError,
  ) {
    final inner = () async {
      try {
        return Either<L, R>.right(await run());
      } on L catch(exception, stack){
        return Either<L, R>.left(onError(exception, stack));
      }

    };

    return TaskEither(inner);
  }
  
}
