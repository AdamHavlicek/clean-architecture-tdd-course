import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_dto.dart';

abstract class NumberTriviaLocalDataSource {
  IOEither<Exception, NumberTriviaDTO> getLastNumberTrivia();

  Task<void> cacheNumberTrivia(NumberTriviaDTO triviaToCache);
}

@LazySingleton(as: NumberTriviaLocalDataSource)
class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;
  final cacheKey = 'CACHED_NUMBER_TRIVIA';

  NumberTriviaLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  IOEither<Exception, NumberTriviaDTO> getLastNumberTrivia() {
    return IOEither<Exception, String>.fromNullable(
      sharedPreferences.getString(cacheKey),
      () => const CacheException('Cache is empty'),
    ).map(
      (jsonString) => NumberTriviaDTO.fromJson(json.decode(jsonString)),
    );

    // final jsonString = sharedPreferences.getString(cacheKey);
    // if (jsonString == null) {
    //   throw const CacheException('Cache is empty');
    // }
    //
    // final cachedNumberTriviaDto =
    //     NumberTriviaDTO.fromJson(json.decode(jsonString));
    //
    // return Future.value(cachedNumberTriviaDto);
  }

  @override
  Task<void> cacheNumberTrivia(NumberTriviaDTO triviaToCache) {
    return Task.of(
      json.encode(triviaToCache.toJson()),
    ).flatMap(
      (jsonString) => Task(
        () => sharedPreferences.setString(cacheKey, jsonString),
      ),
    );

    // final jsonString = json.encode(triviaToCache.toJson());
    //
    // await sharedPreferences.setString(cacheKey, jsonString);
  }
}
