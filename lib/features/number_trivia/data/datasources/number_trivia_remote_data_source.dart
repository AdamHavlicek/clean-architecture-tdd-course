import 'dart:convert';

import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_dto.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaDTO> getConcreteNumberTrivia(int number);

  Future<NumberTriviaDTO> getRandomNumberTrivia();
}

@LazySingleton(as: NumberTriviaRemoteDataSource)
class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Client httpClient;
  final Map<String, String> headers = {'Content-Type': 'application/json'};

  Function get concreteNumberUrl => _getBaseNumberApiUri;
  Uri get randomNumberUrl => _getBaseNumberApiUri('random');

  NumberTriviaRemoteDataSourceImpl({
    required this.httpClient,
  });

  Uri _getBaseNumberApiUri(String path) => Uri(
        scheme: 'http',
        host: 'numberapi.com',
        path: path,
      );

  Future<NumberTriviaDTO> _getTriviaFromUrl(
    Uri concreteOrRandomUrl,
  ) async {
    final response =
        await httpClient.get(concreteOrRandomUrl, headers: headers);

    if (response.statusCode != 200) {
      throw const ServerException('Invalid Server Response');
    }

    return NumberTriviaDTO.fromJson(json.decode(response.body));
  }

  @override
  Future<NumberTriviaDTO> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl(concreteNumberUrl('$number'));

  @override
  Future<NumberTriviaDTO> getRandomNumberTrivia() =>
      _getTriviaFromUrl(randomNumberUrl);
}
