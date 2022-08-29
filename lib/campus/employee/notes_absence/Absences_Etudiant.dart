import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:enamconnect/config/config.dart';
import 'dart:convert';

import 'package:enamconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Absences extends StatefulWidget {
  final int _userId;
  final int _employeeId;
  final int _token;
  final int _subjectId;
  final int _batchId;
  Absences(this._userId, this._employeeId, this._token, this._subjectId,
      this._batchId);

  @override
  _AbsencesState createState() => _AbsencesState();
}

class _AbsencesState extends State<Absences> {
  var data;
  bool affichage = true;
  Future<http.Response> getAbsences(int user_id, int student_id, int token,
      int subject_id, int batch_id) async {
    final param = {
      "user_id": "$user_id",
      "employee_id": "$student_id",
      "auth_token": "$token",
      "subject_id": "$subject_id",
      "batch_id": "$batch_id",
    };

    final batchData = await http.post(
      "${Config.url_api_scole}/employee_subject_attendances",
      body: param,
    );
    setState(() {
      data = json.decode(batchData.body);
      print(data);
    });

    return batchData;
  }

  @override
  void initState() {
    getAbsences(widget._userId, widget._employeeId, widget._token,
        widget._subjectId, widget._batchId);
    super.initState();
  }

  Widget _buildNotesItem(BuildContext context, int index) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            border:
            Border(bottom: BorderSide(style: BorderStyle.solid, width: 0.1))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10,),
                Container(
                  // color: Colors.red,
                  width:(data["student"][index]["nb_abs"] != null && data["student"][index]["nb_abs"] != 0) ?  MediaQuery.of(context).size.width * 0.7 : MediaQuery.of(context).size.width * 0.76,
                  child: Text(
                    "${data["student"][index]["student"]}",
                    style: TextStyle(fontWeight: FontWeight.normal, color: Fonts.col_app_grey,fontFamily: "Helvetica Neue",),
                  ),
                ),
              ],
            ),
            Row(

              children: [
                Container(
                  padding: data["student"][index]["nb_abs"] != 0? EdgeInsets.fromLTRB(8, 5, 8, 5):EdgeInsets.all(0.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0),color: Fonts.col_app),
                  child: (data["student"][index]["nb_abs"] != null && data["student"][index]["nb_abs"] != 0)
                      ? Text(
                    "${data["student"][index]["nb_abs"]} heures",
                    style: TextStyle(fontSize: 15.0,color: Colors.white),
                  )
                      : Text(""),
                ),
                IconButton(icon: Icon(Icons.arrow_right ,color: Fonts.col_text,size: 35.r,), onPressed:(){
                  print("**************");
                  // Navigator.pushReplacement(
                  //     context,
                  //     new MaterialPageRoute(
                  //         builder: (BuildContext context) => new Detail_abs(
                  //             widget._userId,widget._employeeId,widget._token,widget._batchId,data["student"][index]["id"],data["student"][index]["student"]
                  //         )));
                  print("${data}");
                }
                )
              ],
            ),
          ],
        ),
      ),onTap: (){
      print("**************");
      // Navigator.pushReplacement(
      //     context,
      //     new MaterialPageRoute(
      //         builder: (BuildContext context) => new Detail_abs(
      //             widget._userId,widget._employeeId,widget._token,widget._batchId,data["student"][index]["id"],data["student"][index]["student"]
      //         )));
      print("${data}");
    },
    );
  }

  Widget _buildNotesList() {
    Widget timeCards;
    if (data["student"].length > 0) {
      timeCards = Container(
        // decoration: BoxDecoration(
        //     // color: Colors.black,
        //     borderRadius:BorderRadius.all(Radius.circular(22))),
        child: ListView.builder(
          itemBuilder: _buildNotesItem,
          itemCount: data["student"].length,
        ),
      );
    } else {
      timeCards = Container();
    }
    return timeCards;
  }

  @override
  Widget build(BuildContext context) {
    return data != null
        ? Container(
        margin: EdgeInsets.only(top: 10.h,left: 15.w,right: 15.w),
        decoration: BoxDecoration(
          // color: Colors.green,
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(22.r)),
            border: Border.all(color: Fonts.col_app,width: 1.w)
        ),
        height: MediaQuery.of(context).size.height * 0.69.w
        ,child: Container(
        // color: Colors.orange,
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(22)),
            child: Column(
          children: <Widget>[
            Expanded(
              child: _buildNotesList(),
            )
          ],
        ),
      ),
    ))
        : Center(
      child: CircularProgressIndicator(),
    );
  }
}
