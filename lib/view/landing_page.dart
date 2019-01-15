import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:ui' as ui;

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:progress_hud/progress_hud.dart';

import '../database/database_helper.dart';
import '../model/devotion.dart';
import '../model/user.dart';
import '../presenter/user_presenter.dart';
import '../util/constant.dart';
import '../util/facebook.dart' as fb;
import '../util/auth.dart';
import '../database/database_helper.dart';

import './home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String appId = "785432221652641";
const String appSecret = "df1fd6022bc9972a622dc4a3e80f236d";

class LandingPage extends StatefulWidget {
  static const String routeName = '/landing';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> implements UserContract,
    AuthStateListener
     {
  SharedPreferences prefs;
  static const platform = const MethodChannel('AndroidChannel');
  var db = new DatabaseHelper();


  UserPresenter _presenter;
  UserProvider _userProvider;
  List<Devotion> _devotions;
  User _user;
  fb.Token token;
  fb.FacebookGraph graph;
  fb.PublicProfile profile;
  String _platform;
  bool isLogin = false;
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();


  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  static final FacebookLogin facebookLogin = new FacebookLogin();

  String _message = 'Log in/out by pressing the buttons below.';

  Future<Null> _fbLogin() async {
    final FacebookLoginResult result =
    await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        var graphResponse = await http.get(
            'https://graph.facebook.com/v3.0/me?fields='
                'name,first_name,last_name,gender,email&access_token=${accessToken
                .token}');
        var profile = json.decode(graphResponse.body);
        _initFacebookUser(profile);
        print(_user.toString());
        _presenter.login(_user);
//        _summaLogosLogin();
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }

    Navigator.pop(context);
  }

  _initFacebookUser(profile) {
    _user = new User(
        0,
        profile['name'],
        profile['email'],
        "",
        profile['id'],
        "",
        "",
        _platform,
        "",
        _deviceData['model'],
        "1.0",
        "",
        "",
        "",
        null);
  }

  Future<Null> _summaLogosLogin() async {
    print(_user.toString());
    var res = await http.post(Constant.USER_API,
        headers: {"Content-Type": "application/json"},
        body: _user.toString(),
        encoding: Encoding.getByName("utf-8"));

    if (res.body != null) {}
    print(res.body.toString());
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
      print("batteryLevel ${batteryLevel}");
      Navigator.pop(context);
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
      print("failed");
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  void _showMessage(String message) {
    setState(() {
      print(message);
      _message = message;
    });
  }

  Future<Null> _logOut() async {
    await facebookLogin.logOut();
    _showMessage('Logged out.');
  }

  _initUser() {
//    _user = new User.fromMap(map)
//    _user.fullName = "a";
//    print(_user.fullName);
  }

  _LandingPageState() {
    _presenter = new UserPresenter(this);
    _initUser();
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
      Color textColor) {
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
            _fbLogin();
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

  _initFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("NEH " + message.toString());

//        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: ${message['notification']}");

        setState(() {});
//        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
//        _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
//        _homeScreenText = "Push Messaging token: $token";
      });
      print('TOKEN : $token');
//      print(_homeScreenText);
    });
  }

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
    _initFirebaseMessaging();
    _initPlatformState();
//   _checkIsLogin().then((user) {
//     _getDevotions().then((devotions) {
//       Navigator.push(context, MaterialPageRoute(
//           builder: (context) => HomePage(devotions: devotions, user: user,)));
//     });
//   });
    super.initState();
  }

  @override
  void onComplete(List<Devotion> devotions, int userId) async {
    _user.id = userId;
    await db.upsertUser(_user);
    for (Devotion dev in devotions)
      await db.saveDevotionList(dev);
    _setLoginState();
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => HomePage(devotions: devotions, user: _user,)));

//    print('NIH $asd');
//    setState(() {
////      print(devotions[0].id);
//
////      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(devotions: devotions, user: _user,)));
////      _upsertUser(_user);
////      _getUser(id);
//    });
  }

  _upsertUser(User user) async {
    await db.upsertUser(_user);
    User asd = await db.getUser(1);
    int count = await db.getCount();
    print("user: ${asd.toString()}");
  }

  Future _getUser(int id) async {
//    _user = null;
//    _user = await _userProvider.getUser(id);
//    print(_user.toString());
  }

  @override
  void onError() {
    setState(() {
      print("ERROR NEHE");
    });
  }

  @override
  Widget build(BuildContext context) {

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
                new Padding(padding: const EdgeInsets.only(top: 30.0)),
                TransparentButtonWithImage(
                    'Connect with Facebook', 'images/fb_icon.png',
                    Color(0xFF3B5998),
                    Colors.white),
                new Padding(padding: const EdgeInsets.only(top: 10.0)),
                TransparentButtonWithImage(
                    'Connect with Google', 'images/google_icon.png',
                    Colors.white,
                    Colors.black87),
                new Padding(padding: const EdgeInsets.only(bottom: 60.0)),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void onAuthStateChanged(AuthState state) {
    if(state == AuthState.LOGGED_IN) _checkIsLogin();
  }
}
