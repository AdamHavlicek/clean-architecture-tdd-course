import 'package:dartz/dartz.dart';

extension TraverseEitherFuture<L, R> on Either<L, R> {
  Future<Either<L, R2>> traverseEitherFuture<R2>(
    Future<Either<L, R2>> Function(R) future,
  ) async {
    return traverseFuture<Either<L, R2>>(future)
        .then((value) => value.flatMap((a) => a));
  }
}