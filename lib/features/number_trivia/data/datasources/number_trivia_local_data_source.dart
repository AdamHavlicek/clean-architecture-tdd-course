import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_dto.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaDTO> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaDTO triviaToCache);
}

@LazySingleton(as: NumberTriviaLocalDataSource)
class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;
  final cacheKey = 'CACHED_NUMBER_TRIVIA';

  NumberTriviaLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<NumberTriviaDTO> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(cacheKey);
    if (jsonString == null) {
      throw const CacheException('Cache is empty');
    }

    final cachedNumberTriviaDto =
        NumberTriviaDTO.fromJson(json.decode(jsonString));

    return Future.value(cachedNumberTriviaDto);
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaDTO triviaToCache) async {
    final jsonString = json.encode(triviaToCache.toJson());

    await sharedPreferences.setString(cacheKey, jsonString);
  }
}
