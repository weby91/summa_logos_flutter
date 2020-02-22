import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import './landing_page.dart';

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

class SplashPage extends StatefulWidget {
  static const String routeName = '/splash';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var db = new DatabaseHelper();
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return new Scaffold(
        body: new Container(
      child: new Image.asset(
        'images/faith-can-move-mountains.png',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    ));
  }

  Future<bool> _isLogin() async {
    prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return isLogin;
  }

  Future<User> _checkIsLogin() async {
    var isLogin = await _isLogin();
    if (isLogin) {
      var latestDevotionDate = await db.getLatestDevotionDate();
      if (latestDevotionDate != "") {
        var latestYear = latestDevotionDate.split("-")[0].trim();
        var now = DateTime.now();
        if (latestYear == now.year.toString()) {
          var users = await db.getAllUsers();
          if (users != null) {
            return User.fromMap(users[0]);
          }
        }
      }
//      var users = await db.getAllUsers();
//      if (users != null) {
//        return User.fromMap(users[0]);
//      }
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
    super.initState();
    startTime();

  }

  checkLogin() {
    _checkIsLogin().then((user) {
      if (user == null) {
        navigationPage();
      } else {
        _getDevotions().then((devotions) {
          if (devotions.isNotEmpty) {
            if (devotions.first.month != null) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                      HomePage(devotions: devotions, user: user,)));
            } else navigationPage();
          } else navigationPage();
        });
      }
    });
  }



  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, checkLogin);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(LandingPage.routeName);
  }
}
