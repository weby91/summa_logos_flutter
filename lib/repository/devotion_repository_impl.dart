import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/user.dart';
import '../model/devotion.dart';
import '../repository/base_repository.dart';
import '../repository/devotion_repository.dart';
import '../util/constant.dart';

class DevotionRepositoryImpl implements DevotionRepository {

  Future<Map> getDevotional(User user) async {
    var response = await http.post(Constant.DEVOTION_API_V1,
        headers: {"Content-Type": "application/json"},
        body: user.toString(),
        encoding: Encoding.getByName("utf-8"));
    print("response body ${response.body}");
    return json.decode(response.body);
  }

  @override
  Future<Map> finishRead(Map map) async {
    var response = await http.post(Constant.DEVOTION_API_V1,
        headers: {"Content-Type": "application/json"},
        body: json.encode(map),
        encoding: Encoding.getByName("utf-8"));
    print("response body ${response.body}");
    return json.decode(response.body);
  }
}
