import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 25.0,
      width: 1.0,
      color: Colors.white,
      margin: const EdgeInsets.only(left: 10.0, right: 30.0),
    );
  }
}