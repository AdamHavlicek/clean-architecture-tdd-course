import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';

abstract interface class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

final class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

const noParams = NoParams();