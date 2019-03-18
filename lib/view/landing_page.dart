import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './home_page.dart';
import '../database/database_helper.dart';
import '../model/devotion.dart';
import '../model/user.dart';
import '../presenter/user_presenter.dart';
import '../util/constant.dart';

const String appId = "785432221652641";
const String appSecret = "df1fd6022bc9972a622dc4a3e80f236d";

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LandingPage extends StatefulWidget {
  static const String routeName = '/landing';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> implements UserContract {
  GoogleSignInAccount _currentUser;
  SharedPreferences prefs;
  static const platform = const MethodChannel('AndroidChannel');
  var db = new DatabaseHelper();

  UserPresenter _presenter;
  UserProvider _userProvider;
  List<Devotion> _devotions;
  User _user;
  String _platform;
  bool isLogin = false;
//  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  String _message = 'Log in/out by pressing the buttons below.';

//  Future<Null> _fbLogin() async {
//    final FacebookLoginResult result =
//        await facebookLogin.logInWithReadPermissions(['email']);
//
//    switch (result.status) {
//      case FacebookLoginStatus.loggedIn:
//        final FacebookAccessToken accessToken = result.accessToken;
//        var graphResponse = await http.get(
//            'https://graph.facebook.com/v3.0/me?fields='
//            'name,first_name,last_name,gender,email&access_token=${accessToken.token}');
//        var profile = json.decode(graphResponse.body);
//        _initFacebookUser(profile);
//        _presenter.login(_user);
////        _summaLogosLogin();
//        break;
//      case FacebookLoginStatus.cancelledByUser:
//        _showMessage('Login cancelled by the user.');
//        break;
//      case FacebookLoginStatus.error:
//        _showMessage('Something went wrong with the login process.\n'
//            'Here\'s the error Facebook gave us: ${result.errorMessage}');
//        break;
//    }
//
//    Navigator.pop(context);
//  }

  _initFacebookUser(profile) {
    _user = new User(0, profile['name'], profile['email'], "", profile['id'],
        "", "", _platform, "", _deviceData['model'], "1.0", "", "", "", null);
  }

  _initGoogleUser() {
    _user = new User(0, _currentUser.displayName, _currentUser.email, "", _currentUser.id,
        "", "", _platform, "", _deviceData['model'], "1.0", "", "", "", null);
  }

  Future<Null> _summaLogosLogin() async {
    var res = await http.post(Constant.USER_API,
        headers: {"Content-Type": "application/json"},
        body: _user.toString(),
        encoding: Encoding.getByName("utf-8"));

    if (res.body != null) {}
  }

  Future<Null> _initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        _platform = "Android";
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        _platform = "iOS";
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  String _batteryLevel = 'Unknown battery level.';

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
      Navigator.pop(context);
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<Null> _logOut() async {
//    await facebookLogin.logOut();
    _showMessage('Logged out.');
  }

  _LandingPageState() {
    _presenter = new UserPresenter(this);
  }

  _setLoginState() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
  }

  Future<bool> _isLogin() async {
    prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return isLogin;
  }

  Widget TransparentButtonWithImage(String text, String imagePath, Color color,
      Color textColor, String type) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new InkWell(
          onTap: () {
//            _getBatteryLevel();
//            _presenter.fetchUser(_user);
            showDialog(
              context: context,
              builder: (_) => CupertinoActivityIndicator(),
            );
            if (type == 'Facebook') {
//              _fbLogin();
            } else {
              _handleSignIn();
            }
          },
          child: new Container(
            height: 40.0,
            width: 300.0,
            decoration: new BoxDecoration(
              color: color,
              border: new Border.all(color: Colors.white30, width: 0.8),
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: new Row(
              children: <Widget>[
                new Padding(padding: const EdgeInsets.only(left: 30.0)),
                new Image.asset(
                  imagePath,
                  height: 25.0,
                ),
                new Padding(padding: const EdgeInsets.only(left: 20.0)),
//                VerticalDivider(),
                new Text(
                  text,
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: textColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget ShowLoading() {
    return ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.blue,
      borderRadius: 5.0,
    );
  }

//  _initFirebaseMessaging() {
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) {
//      },
//      onLaunch: (Map<String, dynamic> message) {
//        print("onLaunch: ${message['notification']}");
//
//        setState(() {});
////        _navigateToItemDetail(message);
//      },
//      onResume: (Map<String, dynamic> message) {
//        print("onResume: $message");
////        _navigateToItemDetail(message);
//      },
//    );
//    _firebaseMessaging.requestNotificationPermissions(
//        const IosNotificationSettings(sound: true, badge: true, alert: true));
//    _firebaseMessaging.onIosSettingsRegistered
//        .listen((IosNotificationSettings settings) {
//      print("Settings registered: $settings");
//    });
//    _firebaseMessaging.getToken().then((String token) {
//      assert(token != null);
//      setState(() {
////        _homeScreenText = "Push Messaging token: $token";
//      });
//      print('TOKEN : $token');
////      print(_homeScreenText);
//    });
//  }

  Future<User> _checkIsLogin() async {
    var isLogin = await _isLogin();
    if (isLogin) {
      var users = await db.getAllUsers();
      return User.fromMap(users[0]);
    }
    return null;
  }

  Future<List<Devotion>> _getDevotions() async {
    List<Devotion> devotions = new List();
    var obj = await db.getAllDevotions();
    obj.forEach((f) {
      devotions.add(new Devotion.fromMapDb(f));
    });
    return devotions;
  }

  @override
  void initState() {
//    _initFirebaseMessaging();
    _initPlatformState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _initGoogleUser();
        _presenter.login(_user);
      }
    });
    _googleSignIn.signInSilently();
//   _checkIsLogin().then((user) {
//     _getDevotions().then((devotions) {
//       Navigator.push(context, MaterialPageRoute(
//           builder: (context) => HomePage(devotions: devotions, user: user,)));
//     });
//   });
    super.initState();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
    }
  }

  _goToHomePage(List<Devotion> devotions, int userId) async {
    showDialog(
      context: context,
      builder: (_) => CupertinoActivityIndicator(),
    );
    await db.deleteAllDevotions();
    _user.id = userId;
    await db.upsertUser(_user);
    for (Devotion dev in devotions) await db.saveDevotionList(dev);
    _setLoginState();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
              devotions: devotions,
              user: _user,
            )));
  }

  @override
  void onComplete(List<Devotion> devotions, int userId) async {
    _goToHomePage(devotions, userId);
  }

  _upsertUser(User user) async {
    await db.upsertUser(_user);
    User asd = await db.getUser(1);
    int count = await db.getCount();
  }

  @override
  void onError() {
    setState(() {
      print("ERROR NEHE");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new ExactAssetImage('images/walk_by_faith.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TransparentButtonWithImage(
                    'Connect with Google',
                    'images/google_icon.png',
                    Colors.white,
                    Colors.black87,
                    'Google'),
                new Padding(padding: const EdgeInsets.only(bottom: 60.0)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
