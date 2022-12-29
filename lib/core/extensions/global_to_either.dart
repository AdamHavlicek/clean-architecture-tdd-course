
import 'package:dartz/dartz.dart';

// TODO: yoink this to the main project
extension GlobalToEither<T> on T {
  Either<T, R> toLeft<R>() {
    return Left(this);
  }

  Either<L, T> toRight<L>() {
    return Right(this);
  }
}