import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:enamconnect/config/config.dart';
import 'dart:convert';

import 'package:enamconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Absences_cards extends StatefulWidget {
  final int _userId;
  final int _employeeId;
  final int _token;
  final int _subjectId;
  final int _batchId;
  Absences_cards(this._userId, this._employeeId, this._token, this._subjectId,
      this._batchId);
  @override
  _Absences_cardsState createState() => _Absences_cardsState();
}

class _Absences_cardsState extends State<Absences_cards> {
  var data;

  Future<http.Response> getAbsences(int user_id, int studentId, int token,
      int subject_id, int batch_id) async {
    final param = {
      "user_id": "$user_id",
      "employee_id": "$studentId",
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
        height: MediaQuery.of(context).size.width * 0.3.w,

        decoration: BoxDecoration(
          color: Fonts.col_cl,
            borderRadius: BorderRadius.all(Radius.circular(22.r)),
            // border: Border(bottom: BorderSide(style: BorderStyle.solid, width: 0.5))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(22.r)),
                    border: Border.all(color: Fonts.col_app),
                  ),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.25.w,
                  width: MediaQuery.of(context).size.width * 0.25.w,
                  child:  new Image.asset(
                    "images/user.png",
                    color: Fonts.col_text,
                    fit: BoxFit.cover,
                    // width: 25.0,
                    // height: 25.0,
                  ),
                ),
              ],
            ) ,
            SizedBox(height: 10.h,),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Container()),
                Container(
                  // color: Colors.red,
                  alignment: Alignment.center,

                  width: MediaQuery.of(context).size.width * 0.4.w,
                  child: Text(
                    "${data["student"][index]["student"]}",
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.normal ,color: Fonts.col_text,fontSize: 10.sp),
                  ),
                ),
                Expanded(child: Container()),

              ],
            ),

            SizedBox(height: 10.h,),

            Row(

              children: [
                Expanded(child: Container()),

                Container(
                  padding: (data["student"][index]["nb_abs"] != null && data["student"][index]["nb_abs"] != 0) ? EdgeInsets.fromLTRB(8, 5, 8, 5) :  EdgeInsets.all(0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0),color: Fonts.col_app),
                  child: (data["student"][index]["nb_abs"] != null && data["student"][index]["nb_abs"] != 0)
                      ? Text(
                    "${data["student"][index]["nb_abs"]} heures",
                    style: TextStyle(fontSize: 15.0,color: Colors.white),
                  )
                      : Text(""),
                ),
                Expanded(child: Container()),

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
        child: GridView.builder(
          gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 170,
              // childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
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
        padding: EdgeInsets.symmetric(horizontal: 10.w ,vertical: 8.h ),

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
