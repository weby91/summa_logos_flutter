import 'dart:async';
import '../model/user.dart';
import './base_repository.dart';

abstract class UserRepository extends FetchDataException {
  UserRepository(String message) : super(message);

  Future<Map> login(User user);
}