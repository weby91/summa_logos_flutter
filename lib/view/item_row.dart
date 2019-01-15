import 'package:flutter/material.dart';

class ItemRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0
      ),
      child: new Stack(
        children: <Widget>[
          itemCard,
          itemThumbnail
        ],
      ),
    );
  }

  final itemThumbnail = new Container(
    margin: new EdgeInsets.symmetric(
        vertical: 16.0
    ),
    alignment: FractionalOffset.centerLeft,
    child: new Image.asset("images/facebook_icon.png"),
    height
    :
    92.0,
    width: 92.0,
  );

  final itemCard = new Container(
    margin: new EdgeInsets.only(left: 46.0),
    decoration: new BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: new Offset(0.0, 10.0)
          )
        ]
    ),
    child: new Column(
      children: <Widget>[
        new Text("asd"),
        new Text("asd"),
        new Text("asd"),
        new Text("asd"),
        new Text("asd"),


      ],
    ),
  );
}
