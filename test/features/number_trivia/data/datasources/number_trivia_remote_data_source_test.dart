import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_dto.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Client>()])
void main() {
  late NumberTriviaRemoteDataSourceImpl tDataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();

    tDataSource = NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(String responseString) {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer(
      (_) async => Response(responseString, 200),
    );
  }

  void setUpMockHttpClientNotFound404({String responseString = 'Something went wrong'}) {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer(
      (_) async => Response(responseString, 404),
    );
  }

  group(
    'getConcreteNumberTrivia',
    () {
      const number = 1;
      final fixtureString = fixture('trivia.json');

      test(
        '''should perform a GET request on URL with number being the endpoint 
        & with application/json header''',
        () async {
          // Arrange
          final Uri expectedUri =
              Uri(scheme: 'http', host: 'numberapi.com', path: '$number');
          final Map<String, String> expectedHeaders = {
            'Content-Type': 'application/json'
          };

          // Mock
          setUpMockHttpClientSuccess200(fixtureString);

          // Act
          await tDataSource.getConcreteNumberTrivia(number);

          // Assert
          verify(
            mockHttpClient.get(expectedUri, headers: expectedHeaders),
          ).called(1);
        },
      );

      test(
        'should return [NumberTriviaDTO] when the response code is 200',
        () async {
          // Arrange
          final expectedResult =
              NumberTriviaDTO.fromJson(json.decode(fixtureString));

          // Mock
          setUpMockHttpClientSuccess200(fixtureString);

          // Act
          final result = await tDataSource.getConcreteNumberTrivia(number);

          // Assert
          expect(result, equals(expectedResult));
        },
      );

      test(
        'should throw [ServerException] when the response code is 404 or other',
        () async {
          // Arrange
          // Mock
          setUpMockHttpClientNotFound404();

          // Act
          result() => tDataSource.getConcreteNumberTrivia(number);

          // Assert
          expect(
            result,
            throwsA(const TypeMatcher<ServerException>()),
          );
        },
      );
    },
  );

  group(
    'getRandomNumberTrivia',
    () {
      final fixtureString = fixture('trivia.json');

      test(
        '''should perform a GET request on URL with number being the endpoint 
        & with application/json header''',
        () async {
          // Arrange
          final Uri expectedUri =
              Uri(scheme: 'http', host: 'numberapi.com', path: 'random');
          final Map<String, String> expectedHeaders = {
            'Content-Type': 'application/json'
          };

          // Mock
          setUpMockHttpClientSuccess200(fixtureString);

          // Act
          await tDataSource.getRandomNumberTrivia();

          // Assert
          verify(
            mockHttpClient.get(expectedUri, headers: expectedHeaders),
          ).called(1);
        },
      );

      test(
        'should return [NumberTriviaDTO] when the response code is 200',
        () async {
          // Arrange
          final expectedResult =
              NumberTriviaDTO.fromJson(json.decode(fixtureString));

          // Mock
          setUpMockHttpClientSuccess200(fixtureString);

          // Act
          final result = await tDataSource.getRandomNumberTrivia();

          // Assert
          expect(result, equals(expectedResult));
        },
      );

      test(
        'should throw [ServerException] when the response code is 404 or other',
        () async {
          // Arrange
          // Mock
          setUpMockHttpClientNotFound404();

          // Act
          result() => tDataSource.getRandomNumberTrivia();

          // Assert
          expect(
            result,
            throwsA(const TypeMatcher<ServerException>()),
          );
        },
      );
    },
  );
}
