import 'package:enamconnect/models/offers.dart';
import 'package:enamconnect/models/reply.dart';
import 'package:enamconnect/models/user.dart';

class Classe {
  var batch_id;
  var name;
  bool check;

  Classe({this.batch_id, this.name, this.check});

  Classe.fromMap(map)
      : name = map['batch_name'].toString(),
        batch_id = map['batch_id'].toString(),
        check = false;
}
