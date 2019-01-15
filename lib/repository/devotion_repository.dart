import 'dart:async';
import '../model/devotion.dart';
import '../model/user.dart';

import './base_repository.dart';

abstract class DevotionRepository extends FetchDataException {
  DevotionRepository(String message) : super(message);

  Future<Map> getDevotional(User user);

  Future<Map> finishRead(Map map);

}