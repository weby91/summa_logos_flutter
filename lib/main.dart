import 'package:flutter/material.dart';

import './view/splash_page.dart';
import './view/landing_page.dart';
import './view/home_page.dart';
import './view/reading_bible_page.dart';

void main() {
  runApp(new MaterialApp(
    title: 'Summa Logos',
    home: SplashPage(),
    theme: new ThemeData(fontFamily: 'Montserrat'),
    routes: {
      SplashPage.routeName: (BuildContext context) => new SplashPage(),
      HomePage.routeName: (BuildContext context) => new HomePage(),
      LandingPage.routeName: (BuildContext context) => new LandingPage(),
      ReadingBiblePage.routeName: (BuildContext context) => new ReadingBiblePage(),
//      LandingPage.routeName: (BuildContext context) => new LandingPage(),
    },
  ));
}
