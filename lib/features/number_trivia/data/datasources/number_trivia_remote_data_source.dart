import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_dto.dart';

abstract class NumberTriviaRemoteDataSource {
  TaskEither<Exception, NumberTriviaDTO> getConcreteNumberTrivia(int number);

  TaskEither<Exception, NumberTriviaDTO> getRandomNumberTrivia();
}

@LazySingleton(as: NumberTriviaRemoteDataSource)
class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Client httpClient;
  final Map<String, String> headers = {'Content-Type': 'application/json'};
  final String host = 'numberapi.com';
  final String scheme = 'http';

  Function get concreteNumberUrl => _getBaseNumberApiUri;
  Uri get randomNumberUrl => _getBaseNumberApiUri('random');

  NumberTriviaRemoteDataSourceImpl({
    required this.httpClient,
  });

  Uri _getBaseNumberApiUri(String path) => Uri(
        scheme: scheme,
        host: host,
        path: path,
      );

  TaskEither<Exception, NumberTriviaDTO> _getTriviaFromUrl(
    Uri concreteOrRandomUrl,
  ) {
    return TaskEither.tryCatch(
            () => httpClient.get(
                  concreteOrRandomUrl,
                  headers: headers,
                ),
            (err, __) => ServerException('Unexpected Exception $err'))
        .chainEither(
          (response) => Either.fromPredicate(
            response,
            (response) => response.statusCode == 200,
            (_) => const ServerException('Invalid Server Response'),
          ),
        )
        .map(
          (r) => NumberTriviaDTO.fromJson(json.decode(r.body)),
        );

    // final response =
    //     await httpClient.get(concreteOrRandomUrl, headers: headers);
    //
    //
    // if (response.statusCode != 200) {
    //   throw const ServerException('Invalid Server Response');
    // }
    //
    // return NumberTriviaDTO.fromJson(json.decode(response.body));
  }

  @override
  TaskEither<Exception, NumberTriviaDTO> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl(concreteNumberUrl('$number'));

  @override
  TaskEither<Exception, NumberTriviaDTO> getRandomNumberTrivia() =>
      _getTriviaFromUrl(randomNumberUrl);
}
