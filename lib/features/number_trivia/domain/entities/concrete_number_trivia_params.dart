
import 'package:equatable/equatable.dart';

import '../../../../core/domain/unsigned_integer.dart';

class ConcreteNumberTriviaParams extends Equatable {
  final UnsignedInteger number;

  ConcreteNumberTriviaParams({
    required String number
  }) : number = UnsignedInteger(number);

  
  @override
  List<Object?> get props => [number];
}