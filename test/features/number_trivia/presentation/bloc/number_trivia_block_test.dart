import 'package:clean_architecture_tdd_course/core/domain/unsigned_integer.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/concrete_number_trivia_params.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_block_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
])
void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late NumberTriviaBloc tBloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();

    tBloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
    );
  });

  test(
    'initial state should be empty',
    () {
      // Arrange
      const expectedState = Empty();

      // Act
      final result = tBloc.state;

      // Assert
      expect(result, equals(expectedState));
    },
  );

  group('GetTriviaForConcreteNumber', () {
    const String validNumberString = '1';
    const int numberParsed = 1;
    const numberTrivia = NumberTrivia(
      text: 'test trivia',
      number: numberParsed,
    );

    test(
      'should get data from the concrete use case',
      () async {
        // Arrange
        final expectedResult =
            ConcreteNumberTriviaParams(number: UnsignedInteger(validNumberString));
        // Mock
        when(mockGetConcreteNumberTrivia(any)).thenAnswer(
          (_) async => const Right(numberTrivia),
        );

        // Act
        tBloc.add(const GetTriviaForConcreteNumber(validNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));

        // Assert
        verify(mockGetConcreteNumberTrivia(expectedResult)).called(1);
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // Arrange
        const expectedStates = [
          Loading(),
          Loaded(trivia: numberTrivia),
        ];
        final result = tBloc.stream;

        // Mock
        when(mockGetConcreteNumberTrivia(any)).thenAnswer(
          (_) async => const Right(numberTrivia),
        );

        // Act
        tBloc.add(const GetTriviaForConcreteNumber(validNumberString));

        // Assert
        expectLater(result, emitsInOrder(expectedStates));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // Arrange
        const expectedMessage = 'Invalid Server Response';
        const expectedStates = [
          Loading(),
          Error(message: expectedMessage),
        ];
        final result = tBloc.stream;

        // Mock
        when(mockGetConcreteNumberTrivia(any)).thenAnswer(
          (_) async => const Left(ServerFailure(expectedMessage)),
        );

        // Act
        tBloc.add(const GetTriviaForConcreteNumber(validNumberString));

        // Assert
        expectLater(result, emitsInOrder(expectedStates));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error  when getting data fails',
      () async {
        // Arrange
        const expectedMessage = 'Invalid Cache';
        const expectedStates = [
          Loading(),
          Error(message: expectedMessage),
        ];
        final result = tBloc.stream;

        // Mock
        when(mockGetConcreteNumberTrivia(any)).thenAnswer(
          (_) async => const Left(CacheFailure(expectedMessage)),
        );

        // Act
        tBloc.add(const GetTriviaForConcreteNumber(validNumberString));

        // Assert
        expectLater(result, emitsInOrder(expectedStates));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    const numberTrivia = NumberTrivia(
      text: 'test trivia',
      number: 1,
    );

    test(
      'should get data from the random use case',
      () async {
        // Arrange
        const expectedResult = NoParams();
        // Mock
        when(mockGetRandomNumberTrivia(any)).thenAnswer(
          (_) async => const Right(numberTrivia),
        );

        // Act
        tBloc.add(const GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));

        // Assert
        verify(mockGetRandomNumberTrivia(expectedResult)).called(1);
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // Arrange
        const expectedStates = [
          Loading(),
          Loaded(trivia: numberTrivia),
        ];
        final result = tBloc.stream;

        // Mock
        when(mockGetRandomNumberTrivia(any)).thenAnswer(
          (_) async => const Right(numberTrivia),
        );

        // Act
        tBloc.add(const GetTriviaForRandomNumber());

        // Assert
        expectLater(result, emitsInOrder(expectedStates));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // Arrange
        const expectedMessage = 'Invalid Server Response';
        const expectedStates = [
          Loading(),
          Error(message: expectedMessage),
        ];
        final result = tBloc.stream;

        // Mock
        when(mockGetRandomNumberTrivia(any)).thenAnswer(
          (_) async => const Left(ServerFailure(expectedMessage)),
        );

        // Act
        tBloc.add(const GetTriviaForRandomNumber());

        // Assert
        expectLater(result, emitsInOrder(expectedStates));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error  when getting data fails',
      () async {
        // Arrange
        const expectedMessage = 'Invalid Cache';
        const expectedStates = [
          Loading(),
          Error(message: expectedMessage),
        ];
        final result = tBloc.stream;

        // Mock
        when(mockGetRandomNumberTrivia(any)).thenAnswer(
          (_) async => const Left(CacheFailure('Invalid Cache')),
        );

        // Act
        tBloc.add(const GetTriviaForRandomNumber());

        // Assert
        expectLater(result, emitsInOrder(expectedStates));
      },
    );
  });
}
