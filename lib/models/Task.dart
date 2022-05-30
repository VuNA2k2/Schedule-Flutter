class Task {
  String _day;
  String _name;
  DateTime _time;
  String? _description;
  bool _isPending;
  bool _isCompleted;


  Task(this._day, this._name, this._time, this._description, this._isPending,
      this._isCompleted);

  String get day => _day;

  bool get isCompleted => _isCompleted;

  set isCompleted(bool value) {
    _isCompleted = value;
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

  DateTime get time => _time;

  set time(DateTime value) {
    if(value.isAfter(DateTime.now())) {
      value.add(Duration(days: 7));
    }
    _time = value;
  }
}