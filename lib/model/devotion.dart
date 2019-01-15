final String tableDevotion = 'devotion';
final String columnDay = 'day';
final String columnWeekday = 'week_day';
final String columnDate = 'date';
final String columnBook = 'book';
final String columnTotalRead = 'total_read';
final String columnTotalShare = 'total_share';
final String columTotalDiscussion = 'total_discussion';
final String columnBookParam = 'book_param';
final String columnIsFinished = 'is_finished';

class Devotion {
  int _rowId;

  int get rowId => _rowId;
  num _id;
  int _day;
  String _weekDay;
  String _date;
  String _book;
  int _totalRead;
  int _totalShare;
  int _totalDiscussion;
  String _bookParam;
  bool _isFinished;

  Devotion(
      this._id,
      this._day,
      this._weekDay,
      this._date,
      this._book,
      this._totalRead,
      this._totalShare,
      this._totalDiscussion,
      this._bookParam,
      this._isFinished);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["day"] = _day;
    map["week_day"] = _weekDay;
    map["date "] = _date;
    map["book"] = _book;
    map["total_read"] = _totalRead;
    map["total_share"] = _totalShare;
    map["total_discussion"] = _totalDiscussion;
    map["book_param"] = _bookParam;
    map["is_finished"] = _isFinished;
    if (rowId != null) {
      map["row_id"] = _rowId;
    }
    return map;
  }

  Map<String, dynamic> toMapDb() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["day"] = _day;
    map["week_day"] = _weekDay;
    map["date "] = _date;
    map["book"] = _book;
    map["total_read"] = _totalRead;
    map["total_share"] = _totalShare;
    map["total_discussion"] = _totalDiscussion;
    map["book_param"] = _bookParam;
    map["is_finished"] = _isFinished ? 1 : 0;
    if (rowId != null) {
      map["row_id"] = _rowId;
    }
    return map;
  }

  Devotion.fromMap(Map<String, dynamic> map)
      : _rowId = map['row_id'],
        _id = map['id'],
        _day = map['day'],
        _weekDay = map['week_day'],
        _date = map['date'],
        _book = map['book'],
        _totalRead = map['total_read'],
        _totalShare = map['total_share'],
        _totalDiscussion = map['total_discussion'],
        _bookParam = map['book_param'],
        _isFinished = map['is_finished'];

  Devotion.fromMapDb(Map<String, dynamic> map)
      : _rowId = map['row_id'],
        _id = map['id'],
        _day = map['day'],
        _weekDay = map['week_day'],
        _date = map['date'],
        _book = map['book'],
        _totalRead = map['total_read'],
        _totalShare = map['total_share'],
        _totalDiscussion = map['total_discussion'],
        _bookParam = map['book_param'],
        _isFinished = map['is_finished'] == 1 ? true : false;

  @override
  String toString() {
    return "{"
        '"row_id": $_rowId,'
        '"id": $_id,'
        '"day": "$_day",'
        '"week_day": "$_weekDay",'
        '"date": "$_date",'
        '"book": "$_book",'
        '"total_read": "$_totalRead",'
        '"total_share": "$_totalShare",'
        '"total_discussion": "$_totalDiscussion",'
        '"book_param": "$_bookParam",'
        '"is_finished": "$_isFinished"'
        '}';
  }

  num get id => _id;

  int get day => _day;

  String get weekDay => _weekDay;

  String get date => _date;

  String get book => _book;

  int get totalRead => _totalRead;

  int get totalShare => _totalShare;

  int get totalDiscussion => _totalDiscussion;

  String get bookParam => _bookParam;

  bool get isFinished => _isFinished;

  set isFinished(bool val) {
    _isFinished = val;
  }

}
