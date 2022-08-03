import 'package:enamconnect/models/offers.dart';
import 'package:enamconnect/models/reply.dart';
import 'package:enamconnect/models/user.dart';

class Detail {
  var time;
  var name;
  var id;
  bool check;

  Detail({this.id, this.name, this.check, this.time});

  Detail.fromMap(map)
      : time = map['time'].toString(),
        name = map['name'].toString(),
        id = map['id'].toString(),
        check = map['absent'];
}
