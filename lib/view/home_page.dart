import 'package:flutter/material.dart';

import './home_page_body.dart';
import './home_page_header.dart';
import './task_row.dart';
import '../util/task.dart';
import '../util/diagonal_clipper.dart';
import '../model/user.dart';
import '../model/devotion.dart';
import '../presenter/devotion_presenter.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  final List<Devotion> devotions;
  final User user;

  HomePage({Key key, @required this.devotions, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> with WidgetsBindingObserver implements DevotionContract  {
  AppLifecycleState _lastLifecycleState;
  double _imageHeight = 256.0;
  ScrollController _scrollController = new ScrollController();
  DevotionPresenter _devotionPresenter;
  int currentPageId = 11;
  int prevPageId = 0;
  int nextPageId = 1;
  PageController controller = PageController();
  int initialNum = 0;
  Widget _widget;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        currentPageId = controller.page.toInt();
        print(currentPageId);
      });
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
  }


  _HomePageState() {
    _devotionPresenter = new DevotionPresenter(this);
  }

  Widget _getWidget() {
    print('TESTTT ' + widget.devotions.toString());
    List<Devotion> january = widget.devotions.where((l) => l.id >= 368 && l.id < 399).toList();
    List<Devotion> february = widget.devotions.where((l) => l.id >= 399 && l.id < 427).toList();
    List<Devotion> march = widget.devotions.where((l) => l.id >= 427 && l.id < 458).toList();
    List<Devotion> april = widget.devotions.where((l) => l.id >= 458 && l.id < 488).toList();
    List<Devotion> may = widget.devotions.where((l) => l.id >= 488 && l.id < 519).toList();
    List<Devotion> june = widget.devotions.where((l) => l.id >= 519 && l.id < 549).toList();
    List<Devotion> july = widget.devotions.where((l) => l.id >= 549 && l.id < 580).toList();
    List<Devotion> august = widget.devotions.where((l) => l.id >= 580 && l.id < 611).toList();
    List<Devotion> september = widget.devotions.where((l) => l.id >= 611 && l.id < 641).toList();
    List<Devotion> october = widget.devotions.where((l) => l.id >= 641 && l.id < 672).toList();
    List<Devotion> november = widget.devotions.where((l) => l.id >= 672 && l.id < 702).toList();
    List<Devotion> december = widget.devotions.where((l) => l.id >= 702 && l.id < 733).toList();

//    User user = new User()
//    _getDevotional();
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(
        children: <Widget>[
//            _buildTopHeader(),
          _buildTimeline(),
          _buildImage(),
          new PageView(
            controller: controller,
            pageSnapping: true,
            onPageChanged: (pageId) {
              setState(() {
                currentPageId = pageId;
                if (currentPageId == 0) prevPageId = 11;
                else prevPageId = currentPageId - 1;
                if (currentPageId == 11) nextPageId = 0;
                else nextPageId = currentPageId + 1;
              });
            },
            children: <Widget>[
              _buildBottomPart(january, 'Januari', 'Des', 'Feb'),
              _buildBottomPart(february, 'Februari', 'Jan', 'Mar'),
              _buildBottomPart(march, 'Maret', 'Feb', 'Apr'),

              _buildBottomPart(april, 'April', 'Mar', 'Mei'),
              _buildBottomPart(may, 'Mei', 'Apr', 'Jun'),
              _buildBottomPart(june, 'Juni', 'Mei', 'Jul'),

              _buildBottomPart(july, 'Juli', 'Jun', 'Agu'),
              _buildBottomPart(august, 'Agustus', 'Jul', 'Sep'),
              _buildBottomPart(september, 'September', 'Agu', 'Okt'),

              _buildBottomPart(october, 'Oktober', 'Sep', 'Nov'),
              _buildBottomPart(november, 'November', 'Okt', 'Des'),
              _buildBottomPart(december, 'Desember', 'Nov', 'Jan'),
            ],
          ),
//            _buildBottomPart(),




          //LANJUT DI SINI , BIKIN CARDVIEW / LISTVIEW BUAT DAFTAR RENUNGAN TIAP HARI
        ],
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
//    if (_widget == null) {
//      _widget = _getWidget();
//    }
    _widget = _getWidget();
//    return Text('Last notification: $_notification');
    if (_lastLifecycleState == null)
      print('This widget has not observed any lifecycle changes.');
    else print('The most recent lifecycle state this widget observed was: $_lastLifecycleState.');
    return _widget;
  }

  Widget _buildMyTasksHeader(String prevMonth, String nextMonth) {
    return new Padding(
      padding: new EdgeInsets.only(left: 55.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Icon(Icons.arrow_left),
          new Text(prevMonth),
          new Padding(padding: EdgeInsets.only(left: 5.0, right: 5.0)),
          new Text(nextMonth),
          new Icon(Icons.arrow_right)

        ],
      )
    );
  }

  Widget _buildImage() {
    return new ClipPath(
      clipper: new DiagonalClipper(),
      child: new Image.asset(
        'images/rain.jpg',
        fit: BoxFit.fitHeight,
        height: _imageHeight,
      ),
    );
  }

  Widget _buildTopHeader() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.menu, size: 32.0, color: Colors.white),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                "Timeline",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          new Icon(Icons.linear_scale, color: Colors.white),
        ],
      ),
    );
  }

  Widget _leftRightGuideline() {
    double screenHeight = MediaQuery.of(context).size.height;

    final double _imageHeight = screenHeight / 2.5;

    return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight),
      child: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.arrow_left),
                new Text('Des'),
                new Padding(padding: const EdgeInsets.only(left: 10.0, right: 10.0)),
                new Text('Feb'),
                Icon(Icons.arrow_right)
              ],
            ),



          ],
        ),
      )
    );
  }

  Color _getColor() {
    Color color;
    switch (initialNum) {
      case 0 : color = Colors.orange;break;
      case 1 : color = Colors.red;break;
      case 2 : color = Colors.green;break;
      case 3 : color = Colors.purple;break;
      case 4 : color = Colors.cyan;break;
    }

    if (initialNum >= 4) initialNum = 0;
    else initialNum++;

    return color;
  }

  Future<Null> _getDevotional(User user) async {
    _devotionPresenter.getDevotion(user);

  }

  Widget _buildBottomPart(List<Devotion> devotions, String month,
      String prevMonth, String nextMonth) {
    double screenHeight = MediaQuery.of(context).size.height;

    final double _imageHeight = screenHeight / 2.75;

    return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(prevMonth, nextMonth),
          _buildTasksList(devotions, month),
        ],
      ),
    );
  }

  Widget _buildTasksList(List<Devotion> devotions, String month) {
    return new Expanded(
//      child: ListView.builder(
//        shrinkWrap: true,
//          physics: ClampingScrollPhysics(),
//          itemCount: widget.devotions.length,
//          itemBuilder: (BuildContext context, int index) {
//
//          }),
      child: new ListView(
        controller: _scrollController,
        children: devotions.map((devotion) => new TaskRow(devotion: devotion, color: _getColor(),
            month: month, userId: widget.user.id,)).toList(),
      ),
    );
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

  List<Task> tasks = [
    new Task(
        name: "Kejadian 1",
        category: "Jan 1",
        time: "5pm",
        color: Colors.orange,
        completed: false),
    new Task(
        name: "Kejadian 2",
        category: "Jan 2",
        time: "3pm",
        color: Colors.red,
        completed: true),
    new Task(
        name: "Kejadian 3",
        category: "Jan 3",
        time: "2pm",
        color: Colors.green,
        completed: false),
    new Task(
        name: "Kejadian 4",
        category: "Jan 4",
        time: "12pm",
        color: Colors.purple,
        completed: true),
    new Task(
        name: "Kejadian 5",
        category: "Jan 5",
        time: "10am",
        color: Colors.cyan,
        completed: true),
    new Task(
        name: "Teem WEWEW",
        category: "Jan 6",
        time: "10am",
        color: Colors.cyan,
        completed: true),
  ];

  @override
  void onDownloaded(List<Devotion> devotions) {
    setState(() {
      print("COMPLETE NEH");
//      _upsertUser(_user);
//      _getUser(id);
    });
  }

  @override
  void onError() {
    setState(() {
      print("ERROR NEH");
//      _upsertUser(_user);
//      _getUser(id);
    });
  }

  @override
  void onFinishRead(Map map) {
    // TODO: implement onFinishRead
  }
}