final String tableName = "user";
final String columnRowId = "row_id";
final String columnId = "id";
final String columnFullName = "full_name";
final String columnEmail = "email";
final String columnGender = "gender";
final String columnSocialMediaId = "social_media_id";
final String columnSocialMediaPicture = "social_media_picture";
final String columnSocialMediaLink = "social_media_link";
final String columnRegisteredVia = "registered_via";
final String columnAndroidId = "android_id";
final String columnIosId = "ios_id";
final String columnDeviceModel = "device_model";
final String columnAppVersion = "app_version";
final String columnReadingProgress = "reading_progress";
final String columnFcmToken = "fcm_token";
final String columnDevotions = "devotions";

class User {
  int _rowId;
  num _id;
  String _fullName;
  String _email;
  String _gender;
  String _socialMediaId;
  String _socialMediaPicture;
  String _socialMediaLink;
  String _registeredVia;
  String _androidId;
  String _iosId;
  String _deviceModel;
  String _appVersion;
  String _readingProgress;
  String _fcmToken;
  List<dynamic> _devotions;

  User(
      this._id,
      this._fullName,
      this._email,
      this._gender,
      this._socialMediaId,
      this._socialMediaPicture,
      this._socialMediaLink,
      this._registeredVia,
      this._androidId,
      this._iosId,
      this._deviceModel,
      this._appVersion,
      this._readingProgress,
      this._fcmToken,
      this._devotions);

//  Map toMap() {
////    Map map = {
////      columnFullName: _fullName,
////      columnEmail: _email,
////      columnGender: _gender,
////      columnSocialMediaId: _socialMediaId,
////      columnSocialMediaPicture: _socialMediaPicture,
////      columnSocialMediaLink: _socialMediaLink,
////      columnRegisteredVia: _registeredVia,
////      columnAndroidId: _androidId,
////      columnIosId: _iosId,
////      columnDeviceModel: _deviceModel,
////      columnAppVersion: _appVersion,
////      columnReadingProgress: _readingProgress,
////      columnFcmToken: _fcmToken,
////      columnDevotions: _devotions
////    };
//
////    Map map = {
////      "full_name": _fullName,
////      "_email": _email,
////      "_gender": _gender,
////      "social_media_id": _socialMediaId,
////      "social_media_picture": _socialMediaPicture,
////      "social_media_link": _socialMediaLink,
////      "registered_via": _registeredVia,
////      "android_id": _androidId,
////      "ios_id": _iosId,
////      "device_model": _deviceModel,
////      "app_version": _appVersion,
////      "reading_progress": _readingProgress,
////      "fcm_token": _fcmToken
////    };
//
//    Map map = {
//      "id": 1,
//      "full_name": "s",
//      "email": "s",
//      "gender": "s",
//      "social_media_id": "s",
//      "social_media_picture": "s",
//      "social_media_link": "s",
//      "registered_via": "s",
//      "android_id": "s",
//      "ios_id": "s",
//      "device_model": "s",
//      "app_version": "s",
//      "reading_progress": "s",
//      "fcm_token": "s"
//    };
//    if (id != null) {
//      map["id"] = id;
//    }
//    return map;
//  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["full_name"] = _fullName;
    map["email"] = _email;
    map["gender "] = _gender;
    map["social_media_id"] = _socialMediaId;
    map["social_media_picture"] = _socialMediaPicture;
    map["social_media_link"] = _socialMediaLink;
    map["registered_via"] = _registeredVia;
    map["android_id"] = _androidId;
    map["ios_id"] = _iosId;
    map["device_model"] = _deviceModel;
    map["app_version"] = _appVersion;
    map["reading_progress"] = _readingProgress;
    map["fcm_token"] = _fcmToken;
    map["devotions"] = _devotions;
    if (rowId != null) {
      map["row_id"] = _rowId;
    }
    return map;
  }

  User.fromMap(Map<String, dynamic> map)
      : _rowId = map['row_id'],
        _id = map['id'],
        _fullName = map['full_name'],
        _email = map['_email'],
        _gender = map['_gender'],
        _socialMediaId = map['social_media_id'],
        _socialMediaPicture = map['social_media_picture'],
        _socialMediaLink = map['social_media_link'],
        _registeredVia = map['registered_via'],
        _androidId = map['android_id'],
        _iosId = map['ios_id'],
        _deviceModel = map['device_model'],
        _appVersion = map['app_version'],
        _readingProgress = map['reading_progress'],
        _fcmToken = map['fcm_token'],
        _devotions = map['devotions'];

//        _devotions = map['_devotions'];

  @override
  String toString() {
    return "{"
        '"row_id": $_rowId,'
        '"id": $_id,'
        '"full_name": "$_fullName",'
        '"email": "$_email",'
        '"gender": "$_gender",'
        '"social_media_id": "$_socialMediaId",'
        '"social_media_picture": "$_socialMediaPicture",'
        '"social_media_link": "$_socialMediaLink",'
        '"registered_via": "$_registeredVia",'
        '"android_id": "$_androidId",'
        '"ios_id": "$_iosId",'
        '"device_model": "$_deviceModel",'
        '"app_version": "$_appVersion",'
        '"reading_progress": "$_readingProgress",'
        '"fcm_token": "$_fcmToken",'
        '"devotions": "$_devotions"'
        '}';
  }

  int get rowId => _rowId;

  num get id => _id;

  List<dynamic> get devotions => _devotions;

  String get fcmToken => _fcmToken;

  String get readingProgress => _readingProgress;

  String get appVersion => _appVersion;

  String get deviceModel => _deviceModel;

  String get iosId => _iosId;

  String get androidId => _androidId;

  String get registeredVia => _registeredVia;

  String get socialMediaLink => _socialMediaLink;

  String get socialMediaPicture => _socialMediaPicture;

  String get socialMediaId => _socialMediaId;

  String get gender => _gender;

  String get email => _email;

  String get fullName => _fullName;

  set id(int userId) {
    _id = userId;
  }

}

class UserProvider {
  String createTable() {
    return '''
    create table $tableName (
        $columnRowId integer primary key autoincrement,
        $columnId integer not null,
        $columnFullName text not null,
        $columnEmail text not null,
        $columnGender text,
        $columnSocialMediaId text,
        $columnSocialMediaPicture text,
        $columnSocialMediaLink text,
        $columnRegisteredVia text not null,
        $columnAndroidId text,
        $columnIosId text,
        $columnDeviceModel text,
        $columnAppVersion text,
        $columnReadingProgress text,
        $columnFcmToken text,
        $columnDevotions text)
    ''';
  }
//  Future create(Database db) async {
//    return await db.execute('''
//create table $tableName (
//  $columnRowId integer primary key autoincrement,
//  $columnId integer not null,
//  $columnFullName text not null,
//  $columnEmail text not null,
//  $columnGender text,
//  $columnSocialMediaId text,
//  $columnSocialMediaPicture text,
//  $columnSocialMediaLink text,
//  $columnRegisteredVia text not null,
//  $columnAndroidId text,
//  $columnIosId text,
//  $columnDeviceModel text,
//  $columnAppVersion text,
//  $columnReadingProgress text,
//  $columnFcmToken text,
//  $columnDevotions text)
//''');
//  }

//  Future open(String path) async {
//    db = await openDatabase(path, version: 1,
//        onCreate: (Database db, int version) async {
//      await db.execute('''
//create table $tableName (
//  $columnId integer primary key autoincrement,
//  $columnFullName text not null,
//  $columnEmail text not null,
//  $columnGender text,
//  $columnSocialMediaId text,
//  $columnSocialMediaPicture text,
//  $columnSocialMediaLink text,
//  $columnRegisteredVia text not null,
//  $columnAndroidId text,
//  $columnIosId text,
//  $columnDeviceModel text,
//  $columnAppVersion text,
//  $columnReadingProgress text,
//  $columnFcmToken text)
//''');
//    });
//  }

//  Future<User> insert(User user) async {
//    print('before insert ${user.toString()}');
//
//    user.id = await db.insert(tableName, user.toMap());
//    print('abis insert ${user.toString()}');
//    return user;
//  }
//
//  Future<User> upsertUser(User user) async {
//    var count = Sqflite.firstIntValue(await db
//        .rawQuery("SELECT COUNT(*) FROM $tableName WHERE id = ?", [user.id]));
//    if (count == 0) {
//      user.id = await db.insert(tableName, user.toMap());
//    } else {
//      await db.update(tableName, user.toMap(),
//          where: "id = ?", whereArgs: [user.id]);
//    }
//
//    return user;
//  }
//
//  Future<User> getUser(int id) async {
//    List<Map> maps = await db.query(tableName,
//        columns: [
//          columnId,
//          columnFullName,
//          columnEmail,
//          columnGender,
//          columnSocialMediaId,
//          columnSocialMediaPicture,
//          columnSocialMediaLink,
//          columnRegisteredVia,
//          columnAndroidId,
//          columnIosId,
//          columnDeviceModel,
//          columnAppVersion,
//          columnReadingProgress,
//          columnFcmToken,
//          columnDevotions
//        ],
//        where: "$columnId = ?",
//        whereArgs: [id]);
//    if (maps.length > 0) {
//      return new User.fromMap(maps.first);
//    }
//    return null;
//  }
//
//  Future<int> delete(int id) async {
//    return await db.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
//  }
//
//  Future<int> update(User user) async {
//    return await db.update(tableName, user.toMap(),
//        where: "$columnId = ?", whereArgs: [user.id]);
//  }
//
//  Future close() async => db.close();
}
