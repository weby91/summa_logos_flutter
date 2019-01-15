import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/user.dart';
import '../repository/base_repository.dart';
import '../repository/user_repository.dart';
import '../util/constant.dart';

class UserRepositoryImpl implements UserRepository {

  Future<Map> login(User user) async {
    var response = await http.post(Constant.USER_API,
        headers: {"Content-Type": "application/json"},
        body: user.toString(),
        encoding: Encoding.getByName("utf-8"));
    print("response body ${response.body}");
    return json.decode(response.body);
  }

//  Future<User> fetch() {
//    return http.get(_kRandomUserUrl).then((http.Response response) {
//      final String jsonBody = response.body;
//      final statusCode = response.statusCode;
//
//      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
//        throw new FetchDataException(
//            "Error while getting contacts [StatusCode:$statusCode, Error:${response
//                .reasonPhrase}]");
//      }
//
//      final contactsContainer = _decoder.convert(jsonBody);
//      final User contactItems = contactsContainer['results'];
//
//      return contactItems;
//    });
//  }
}
