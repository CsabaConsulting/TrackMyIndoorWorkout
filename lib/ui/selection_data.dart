import 'package:meta/meta.dart';

class SelectionData {
  DateTime time;
  String value;

  SelectionData({@required this.time, @required this.value})
      : assert(time != null),
        assert(value != null);
}
