class Post {
  int _id;
  int _userId;
  String _title;
  String _body;

  Post(this._id, this._userId, this._title, this._body);

  String get body => _body;

  set body(String value) {
    _body = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
