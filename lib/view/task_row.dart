import 'package:flutter/material.dart';

import '../model/devotion.dart';
import '../view/reading_bible_page.dart';
import '../presenter/devotion_presenter.dart';
import '../database/database_helper.dart';

class TaskRow extends StatefulWidget {
  final Devotion devotion;
  final double dotSize = 12.0;
  final Color color;
  final String month;
  final int userId;

  const TaskRow(
      {Key key,
      @required this.devotion,
      @required this.color,
      @required this.month,
        @required this.userId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TaskRowState();
  }
}

class TaskRowState extends State<TaskRow> implements DevotionContract {
  var db = new DatabaseHelper();
  DevotionPresenter _devotionPresenter;

  TaskRowState() {
    _devotionPresenter = new DevotionPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: new Row(
        children: <Widget>[
          new Padding(
            padding:
                new EdgeInsets.symmetric(horizontal: 32.0 - widget.dotSize / 2),
            child: new Container(
              height: widget.dotSize,
              width: widget.dotSize,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle, color: widget.color),
            ),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Text(
                      widget.devotion.book.replaceAll("#", "\n"),
                      style: new TextStyle(fontSize: 18.0),
                    ),
                    new Padding(padding: EdgeInsets.only(left: 5.0)),
                    new IconButton(
                        icon: new Icon(Icons.library_books),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReadingBiblePage(
                                      endpoint: widget.devotion.bookParam)));
                        })
                  ],
                ),
                new Text(
                  '${widget.devotion.weekDay}, ${widget.devotion.day} ${widget.month}',
                  style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                )
              ],
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: new IconButton(
              onPressed: () => !widget.devotion.isFinished ? _addReadLog() : {},
                icon: new Icon(
                  widget.devotion.isFinished
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: Colors.lightGreen,
            )),
//            child: new Icon(
//              widget.devotion.isFinished ? Icons.check_box : Icons.check_box_outline_blank,
//              color: Colors.lightGreen,
//            ),
          ),
        ],
      ),
    );
  }

  Future _addReadLog() async {
    Map map = new Map();
    map['user_id'] = widget.userId;
    map['devotional_id'] = widget.devotion.id;
    map['action'] = 'Finished reading - ${widget.devotion.book}';
    _devotionPresenter.finishRead(map);
  }

  @override
  void onDownloaded(List<Devotion> devotions) {
    // TODO: implement onDownloaded
  }

  @override
  void onError() {
    // TODO: implement onError
  }

  Future _updateDevotion() async {
    widget.devotion.isFinished = !widget.devotion.isFinished;
    await db.upsertDevotion(widget.devotion);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void onFinishRead(Map map) {
    if (map != null && map.containsKey('status')) {
      if (map['status'] == 'success') {
        _updateDevotion().then((_) {
          setState(() {
            widget.devotion.isFinished = widget.devotion.isFinished;
          });
        });
      }
    }
//    setState(() {
//      widget.devotion.isFinished = true;
//    });
    // TODO: implement onFinishRead
  }
}
