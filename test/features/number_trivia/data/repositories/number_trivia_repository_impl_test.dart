import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_dto.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NumberTriviaRemoteDataSource>(),
  MockSpec<NumberTriviaLocalDataSource>(),
  MockSpec<NetworkInfo>()
])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('devices is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('devices is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const int number = 1;
    const numberTriviaDTO = NumberTriviaDTO(
      text: 'test trivia',
      number: number,
    );
    final NumberTrivia numberTrivia = numberTriviaDTO.toDomain();

    test('should check if the device is online', () async {
      // Arrange
      // Mock
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getConcreteNumberTrivia(any),
      ).thenAnswer(
        (_) async => numberTriviaDTO,
      );

      // Act
      await repository.getConcreteNumberTrivia(number);

      // Assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // Arrange
        final expectedResult = Right(numberTrivia);

        // Mock
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => numberTriviaDTO);

        // Act
        final result = await repository.getConcreteNumberTrivia(number);

        // Assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(number));
        expect(result, equals(expectedResult));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // Arrange
        final expectedResult = Right(numberTrivia);

        // Mock
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => numberTriviaDTO);

        // Act
        final result = await repository.getConcreteNumberTrivia(number);

        // Assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(number));
        verify(mockLocalDataSource.cacheNumberTrivia(numberTriviaDTO));
        expect(result, equals(expectedResult));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // Arrange
        const expectedMessage = 'Invalid Server Response';
        const expectedResult = Left(ServerFailure(expectedMessage));

        // Mock
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(const ServerException(expectedMessage));

        // Act
        final result = await repository.getConcreteNumberTrivia(number);

        // Assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(number));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(expectedResult));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // Arrange
        final expectedResult = Right(numberTrivia);

        // Mock
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => numberTriviaDTO);

        // Act
        final result = await repository.getConcreteNumberTrivia(number);

        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(expectedResult));
      });

      test('should return [CacheFailure] when there is no cached data present',
          () async {
        // Arrange
        const expectedMessage = 'Invalid Cache';
        const expectedResult = Left(CacheFailure(expectedMessage));

        // Mock
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(const CacheException(expectedMessage));

        // Act
        final result = await repository.getConcreteNumberTrivia(number);

        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(expectedResult));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    const numberTriviaDTO = NumberTriviaDTO(text: 'test trivia', number: 123);
    final NumberTrivia numberTrivia = numberTriviaDTO.toDomain();

    test('should check if the device is online', () {
      // Arrange
      // Mock
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockRemoteDataSource.getRandomNumberTrivia(),
      ).thenAnswer(
        (_) async => numberTriviaDTO,
      );

      // Act
      repository.getRandomNumberTrivia();

      // Assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // Arrange
        final expectedResult = Right(numberTrivia);

        // Mock
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => numberTriviaDTO);

        // Act
        final result = await repository.getRandomNumberTrivia();

        // Assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(expectedResult));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // Arrange
        final expectedResult = Right(numberTrivia);

        // Mock
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => numberTriviaDTO);

        // Act
        final result = await repository.getRandomNumberTrivia();

        // Assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(numberTriviaDTO));
        expect(result, equals(expectedResult));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // Arrange
        const expectedMessage = 'Invalid Server Response';
        const expectedResult = Left(ServerFailure(expectedMessage));

        // Mock
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(const ServerException(expectedMessage));

        // Act
        final result = await repository.getRandomNumberTrivia();

        // Assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(expectedResult));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // Arrange
        final expectedResult = Right(numberTrivia);

        // Mock
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => numberTriviaDTO);

        // Act
        final result = await repository.getRandomNumberTrivia();

        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(expectedResult));
      });

      test('should return [CacheFailure] when there is no cached data present',
          () async {
        // Arrange
        const expectedMessage = 'Invalid Cache';
        const expectedResult = Left(CacheFailure(expectedMessage));

        // Mock
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(const CacheException(expectedMessage));

        // Act
        final result = await repository.getRandomNumberTrivia();

        // Assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(expectedResult));
      });
    });
  });
}
