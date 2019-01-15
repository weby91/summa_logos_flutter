import '../di/di.dart';
import '../model/devotion.dart';
import '../model/user.dart';
import '../repository/devotion_repository.dart';

abstract class DevotionContract {
  void onDownloaded(List<Devotion> devotions);
  void onFinishRead(Map map);

  void onError();
}

class DevotionPresenter {
  DevotionContract _view;
  DevotionRepository _repo;

  DevotionPresenter(this._view) {
    _repo = new Injector().devotionRepository;
  }

  void getDevotion(User user) {
    assert(_view != null);
    List<dynamic> obj;
    _repo.getDevotional(user).then((map) {
      if (map != null && map.containsKey("devotions")) {
         obj = map["devotions"];
      }
      return _view
          .onDownloaded(obj);
    }).catchError((onError) {
      print(onError);
      _view.onError();
    });
  }

  void finishRead(Map map) {
    assert(_view != null);
    List<dynamic> obj;
    _repo.finishRead(map).then((map) {
      return _view
          .onFinishRead(map);
    }).catchError((onError) {
      print(onError);
      _view.onError();
    });
  }
}
