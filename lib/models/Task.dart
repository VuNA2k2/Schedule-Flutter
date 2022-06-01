class Task {
  String _day;
  String _name;
  String _time;
  String? _description;
  bool _isPending;
  bool _isCompleted;


  Task(this._day, this._name, this._time, this._description, this._isPending,
      this._isCompleted);

  String get day => _day;

  bool get isCompleted => _isCompleted;

  set isCompleted(bool value) {
    _isCompleted = value;
    if(_isCompleted) _isPending = false;
  }

  bool get isPending => _isPending;

  set isPending(bool value) {
    _isPending = value;
  }

  String get description => _description!;

  set description(String value) {
    _description = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }
}