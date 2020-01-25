import 'package:flutter/material.dart';
import './rounded_app_bar.dart';
//import 'package:carousel_slider/carousel_slider.dart';
import '../util/carousel.dart';

class HomePageHeader extends StatefulWidget {
  _HomePageHeaderState createState() => _HomePageHeaderState();
}

class _HomePageHeaderState extends State<HomePageHeader> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 18.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    Widget carousel = new Carousel(
      boxFit: BoxFit.fill,
      autoplay: true,
      autoplayDuration: Duration(seconds: 5),
      images: [
        new NetworkImage('https://scontent-sea1-1.cdninstagram.com/vp/0e1e8b350a17ef318755b138a029306e/5CC91138/t51.2885-15/sh0.08/e35/p750x750/47020322_2275525582766294_2375382516748229639_n.jpg?_nc_ht=scontent-sea1-1.cdninstagram.com&ig_cache_key=MTk0MTExODk2NTMzNTI5MDMxMQ%3D%3D.2'),
//        new AssetImage('images/walk_by_faith.jpg'),
        new AssetImage('images/verse.jpg'),
        new AssetImage('images/walk_by_faith.jpg'),
        new AssetImage('images/walk_by_faith.jpg'),
      ],
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(seconds: 1),
    );

    return new Container(
        height: screenHeight / 2.5,
        child: carousel
      );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildTimeline() {
    return new Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 32.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }


}
