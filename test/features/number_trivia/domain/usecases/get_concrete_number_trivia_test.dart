import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/concrete_number_trivia_params.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
void main() {
  late GetConcreteNumberTrivia tUseCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

    
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();

    tUseCase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });
  
  test('should get trivia for the number from the repository', () async {
    // Arrange
    const int expectedNumber = 1;
    const expectedNumberTrivia = NumberTrivia(number: expectedNumber, text: 'test');

    // Mock
    when(
      mockNumberTriviaRepository.getConcreteNumberTrivia(any)
    ).thenAnswer(
      (_) async => const Right(expectedNumberTrivia)
    );

    // Act
    final result = await tUseCase(ConcreteNumberTriviaParams(number: expectedNumber.toString()));

    // Assert
    expect(result, const Right(expectedNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(expectedNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });

}