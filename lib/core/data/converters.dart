import 'package:json_annotation/json_annotation.dart';

class NumberConvertor implements JsonConverter<int, num> {
  const NumberConvertor();

  @override
  int fromJson(num json) {
    return json.toInt();
  }

  @override
  num toJson(int object) {
    return object;
  }
}
