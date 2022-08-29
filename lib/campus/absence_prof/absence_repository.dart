import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:enamconnect/models/classe.dart';
import 'package:enamconnect/models/detail.dart';
import 'package:enamconnect/models/student.dart';
import 'package:enamconnect/models/user.dart';
import 'package:enamconnect/config/config.dart';

class Absence_repository {
  get_details_seances(
      User prof, Student student, DateTime date, batch_id) async {
//
    final param = {
      "user_id": "${prof.user_id}",
      "employee_id": "${prof.employee_id}",
      "auth_token": "${prof.token_user}",
      "date": date.toString(),
      "student_id": "${student.student_id}",
      "batch_id": "${batch_id}"
    };

    print(param);

    /**
        "date"
        "student_id"

     */

    final profileData = await http.post(
      "${Config.url_api_scole}/list_ttes_by_day",
      body: param,
    );

    var data = json.decode(profileData.body)["result"];
    print(data);
    return List<Detail>.from(data.map((i) => Detail.fromMap(i)).toList());
  }

  classe_list(User user) async {
    final param = {
      "user_id": "${user.user_id}",
      "employee_id": "${user.employee_id}",
      "auth_token": "${user.token_user}",
    };

    final profileData = await http.post(
      "${Config.url_api_scole}/list_batches",
      body: param,
    );

    print(profileData.body);

    var data = json.decode(profileData.body)["result"];
    print(data);
    return List<Classe>.from(data.map((i) => Classe.fromMap(i)).toList());
  }

  students_list(User user, var batch_id) async {
    final param = {
      "user_id": "${user.user_id}",
      "employee_id": "${user.employee_id}",
      "auth_token": "${user.token_user}",
      "batch_id": "${batch_id}",
    };

    final profileData = await http.post(
      "${Config.url_api_scole}/list_students",
      body: param,
    );

    var data = json.decode(profileData.body)["result"]["students"];
    for (var i in data) {
      print(i);
    }
    return List<Student>.from(
        data.map((i) => Student.fromMap(i["student"])).toList());
  }

  /**
      ${Config.url_api_scole}/add_attendance
      Params :


      "tte_ids"  ===> si un array des entrées choisies

   */

  add_absence(params) async {
//

  final param = params/*{
    "user_id": "${prof.user_id}",
    "employee_id": "${prof.employee_id}",
    "auth_token": "${prof.token_user}",
    "date": date.toString(),
    "student_id": "${student.student_id}",
    "batch_id": "${batch_id}",
    "tte_ids": ids
  }*/;
  print(json.encode(param));
    final profileData = await http.post(
      "${Config.url_api_scole}/add_attendance",
        headers: {
          "Content-type": "application/json"
        },
      body: json.encode(param)
    );

    print(profileData.body);

  }


}
