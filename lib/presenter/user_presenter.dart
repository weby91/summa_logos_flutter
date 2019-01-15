import '../di/di.dart';
import '../model/devotion.dart';
import '../model/user.dart';
import '../repository/user_repository.dart';
import 'dart:core';

abstract class UserContract {
  void onComplete(List<Devotion> devotions, int userId);

  void onError();
}

class UserPresenter {
  UserContract _view;
  UserRepository _repo;

  UserPresenter(this._view) {
    _repo = new Injector().userRepository;
  }

  void login(User user) {
    assert(_view != null);
    List<Devotion> devotions;
    int userId;
    _repo.login(user).then((map) {
      if (map != null) {
        if (map.containsKey("devotions")) {
          devotions = (map['devotions'] as List)
              .map((data) => new Devotion.fromMap(data))
              .toList();
        }

        if (map.containsKey('id')) {
          userId = map['id'];
        }
      }
      return _view
          .onComplete(devotions, userId);
    }).catchError((onError) {
      print(onError);
      _view.onError();
    });
  }
}
