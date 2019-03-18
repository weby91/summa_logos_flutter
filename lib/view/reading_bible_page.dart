import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml2json/xml2json.dart';

import '../model/bible.dart';

class ReadingBiblePage extends StatefulWidget {
  static const String routeName = '/reading_bible';
  final Bible bible;

  ReadingBiblePage({Key key, @required this.bible}) : super(key: key);

  @override
  _ReadingBiblePageState createState() => _ReadingBiblePageState();
}

class _ReadingBiblePageState extends State<ReadingBiblePage> {
  final Xml2Json xml2json = Xml2Json();
  double titleSize = 24.0;
  double childSize = 15.0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return new GestureDetector(
      onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
        setState(() {
          titleSize = (titleSize * scaleDetails.scale);
        });
      },
      child: new Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            title: new Row(
              children: <Widget>[],
            ),
            backgroundColor: Colors.white24,
          ),
          backgroundColor: Colors.black87,
          body: new Column(
            children: <Widget>[
              _showBible(widget.bible),
            ],
          )),
    );
  }

  Widget _whiteText(String text) {
    return new Text(
      text,
      style: new TextStyle(color: Colors.white70, fontSize: 17.0),
    );
  }

  Widget _blueText(String text) {
    return new Text(
      text,
      style: new TextStyle(color: Colors.blueAccent),
    );
  }

  Widget _showVerses(Verses verses) {
    Widget widget;
    String text;
    Verse verse;
    String number;

    if (verses != null) {
      if (verses.verse != null) {
        verse = verses.verse;
        number = '${verse.number}. ';
        text = '${verse.text}';
        widget = new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _blueText(number),
                new Padding(padding: EdgeInsets.only(left: 4.0)),
                new Expanded(child: _whiteText(text))
              ],
            )
          ],
        );
      } else if (verses.verseList != null) {
        List<Verse> verseList = verses.verseList;
        widget = ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: verseList.length,
            itemBuilder: (BuildContext context, int index) {
              verse = verseList[index];
              number = '${verse.number}. ';
              text = '${verse.text}';
              return new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  index > 0 && index - 1 != verseList.length
                      ? new Padding(padding: EdgeInsets.only(top: 5.0))
                      : new Padding(padding: EdgeInsets.all(0.0)),
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _blueText(number),
                      new Padding(padding: EdgeInsets.only(left: 4.0)),
                      new Expanded(child: _whiteText(text))
                    ],
                  ),
                ],
              );
            });
      }
    }

    return widget != null ? widget : new Container();
  }

  Widget _showTitle(Book book) {
    bool isNum = false;
    var indexOfSpace = book.title.indexOf(" ");
    String title =
        book.title.substring(0, indexOfSpace) + " " + book.chapter.chap;
    return new Text(
      title,
      style: new TextStyle(
          color: Colors.white70, fontSize: 24.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _showBible(Bible bible) {
    Widget widget;
    if (bible.bookList.isNotEmpty) {
      widget = new Expanded(
          child: Scrollbar(
              child: ListView.builder(
                  padding: EdgeInsets.all(titleSize),
                  itemCount: bible.bookList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(
                      children: <Widget>[
                        index != 0
                            ? new Padding(padding: EdgeInsets.only(top: 30.0))
                            : new Padding(padding: EdgeInsets.all(0.0)),
                        _showTitle(bible.bookList[index]),
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        _showVerses(bible.bookList[index].chapter.verses),
                      ],
                    );
                  })));
    } else if (bible.book != null) {
      widget = new Expanded(
          child: Scrollbar(
              child: ListView.builder(
                  padding: EdgeInsets.all(24.0),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return new Column(
                      children: <Widget>[
                        index != 0
                            ? new Padding(padding: EdgeInsets.only(top: 30.0))
                            : new Padding(padding: EdgeInsets.all(0.0)),
                        _showTitle(bible.book),
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        _showVerses(bible.book.chapter.verses),
                      ],
                    );
                  })));
    }

    return widget != null ? widget : new Container();
  }
}
