import 'package:enamconnect/campus/absence_prof/add_absence_form.dart';
import 'package:enamconnect/models/user.dart';
import 'package:enamconnect/services/Fonts.dart';
import 'package:enamconnect/widgets/common.dart';
import 'package:enamconnect/widgets/custom_widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sticky_headers/sticky_headers.dart';
import 'Absences_Edutients.dart';
import 'package:enamconnect/config/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'Notes_Etudiant.dart';
import 'Notes_Absences.dart';

class BatchesPage_Absences extends StatefulWidget {
  final int _userId;
  final int _employeeId;
  final int _token;
  User user;

  BatchesPage_Absences(this.user, this._userId, this._employeeId, this._token);

  @override
  _BatchesPage_AbsencesState createState() => _BatchesPage_AbsencesState();
}

class _BatchesPage_AbsencesState extends State<BatchesPage_Absences> {
  var data;
  bool loading = true;
  List<String> keyList = [];

  Future<http.Response> getResultBatches(
      int user_id, int student_id, int token) async {
    final param = {
      "user_id": "$user_id",
      "employee_id": "$student_id",
      "auth_token": "$token",
    };
    print("employee_id = ${student_id}");

    final batchData = await http.post(
      "${Config.url_api_scole}/employee_batches",
      body: param,
    );
    setState(() {
      data = json.decode(batchData.body);
      print(data);
      print("ayoub loading");

      // print(data["result"].keys);
      print("data ${data["result"]}");

      print("ayoub loading 2");

      for (var k in data["result"].keys) {
        keyList.add(k);
      }
      loading = false;
      //print(data["result"][keyList[1]][1]);
    });

    return batchData;
  }
  Widget  boton_appbar(){
    PreferredSize(preferredSize : Size.fromHeight(0.h));
  }

  @override
  void initState() {
    getResultBatches(widget._userId, widget._employeeId, widget._token);
    super.initState();
  }

  Widget _builBatchList(String batch) {
    Widget timeCards;
    List<Map<String, dynamic>> vv = [];
    data["result"][batch].forEach((val) {
      vv.add(val);
    });

    if (vv.length > 0) {
      Container(
          child: timeCards = Column(
            children: vv
                .map((Map<String, dynamic> val) =>
                InkWell(
                  child:  Container(
                      alignment: Alignment.center,
                      height: 50.h,
                      padding: EdgeInsets.only(top: 0.h,bottom: 0.h,left: 15.w,right: 7.w),
                      margin: EdgeInsets.symmetric(horizontal: 27.w,vertical: 5.h),
                      decoration: BoxDecoration(
                          color: Color(0xffFAFAFA),
                          borderRadius: BorderRadius.all(Radius.circular(29.r)),
                          border: Border.all(color: Fonts.col_app,width: 0.5,style: BorderStyle.solid)
                      ),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.64.w,
                              // color: Colors.red,
                              child: Text(
                                "${val["subject"]}",
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.sp,
                                    color: Fonts.col_text,
                                    fontFamily: "Helvetica"
                                ),
                              ),),

                            Container(
                              child:
                              Icon(Icons.arrow_right,color: Fonts.col_text,size: 35.r,),
                            )

                          ],
                        ),
                      )

                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Absences_Etud(
                                batch,
                                widget._userId,
                                widget._employeeId,
                                widget._token,
                                val["subject_id"],
                                val["batch_id"])));
                  },
                ))
                .toList(),
          )
      );
    } else {
      timeCards = Container();
    }
    return timeCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          highlightElevation: 7.0,
          backgroundColor:  Fonts.col_app ,
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(22.0.r))
          ),

          elevation: 0.0,
          //iconSize: 62,

            child: Container(
              height: 50.h,
              width: 50.h,
              decoration: BoxDecoration(
                color: Fonts.col_app
              ),
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.add, color: Colors.white, size: 30)),
            ),

          // CircleAvatar(
          //
          //     radius: 44,
          //     backgroundColor: Fonts.col_app,
          //     child: ),
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (BuildContext context) {
              return new AddAbsence(widget.user);
            }));
          },
        ),
        appBar: PreferredSize(
    preferredSize : Size.fromHeight(128.h),
    child: ApBar("assets/images/ABCENCE.svg" ,"images/absences.png", "Absences",boton_appbar())),

    //     AppBar(
    //         iconTheme: IconThemeData(color: Colors.white),
    //         backgroundColor: Fonts.col_app,
    //         elevation: 0.0,
    //       toolbarHeight: 70.h ,
    //
    //       // iconTheme: IconThemeData(color: Fonts.col_app),
    //       // titleSpacing: double.infinity,
    //       titleSpacing: 0,
    //       leading: Container(
    //         color: Colors.white,
    //         child: Container(
    //           decoration: BoxDecoration(
    //             // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.r)),
    //             color: Fonts.col_app,
    //
    //           ),
    //           // color: Fonts.col_app,
    //           child: IconButton(
    //             icon: Icon(
    //               Icons.arrow_back,
    //               color: Colors.white,
    //             ),
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //           ),
    //         ),
    //       ),
    //       title: Container(
    //       color: Colors.white,
    //       child: Container(
    //         decoration: BoxDecoration(
    //           // borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.r)),
    //           color: Fonts.col_app,
    //
    //         ),
    //         padding: const EdgeInsets.only(top: 0,bottom:10),
    //         // color: Fonts.col_app,
    //         child: Row(
    //           children: [
    //             Image.asset(
    //               "images/absences.png",
    //               color: Colors.white,
    //               width: 23.5.w,
    //               height: 25.5.h,
    //             ), Container(width: 7.w,),
    //             Padding(
    //               padding: const EdgeInsets.only(top: 10,bottom:10),
    //               child: Text(
    //                 "Absences",
    //                 style: TextStyle(
    //                     color: Colors.white,
    //                     fontWeight: FontWeight.w500,
    //                     fontSize: 18.0.sp),
    //               ),
    //             ),
    //
    //             Expanded(child: Container()),
    //             Padding(
    //                 padding: EdgeInsets.all(8.w),
    //                 child: ClipRRect(
    //                     borderRadius: BorderRadius.all(Radius.circular(10.r)),
    //                     child: Container(
    //                         height: 44.w,
    //                         width: 44.w,
    //                         color: Colors.white.withOpacity(0.9),
    //                         padding: EdgeInsets.all(0.w),
    //                         child: Image.asset(
    //                           "images/enam.png",
    //                         )))),
    //             SizedBox(width: 22.w,),
    //           ],
    //
    //         ),
    //       ),
    //     ),
    // ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : new ListView.builder(
                itemCount: data["result"].length,
                itemBuilder: (context, index) {
                  return new Column(
                    children: [
                      Container(
                        height: 80.0.h,
                        margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 15.h),
                        decoration: BoxDecoration(
                            color: Fonts.col_cl,
                            borderRadius: BorderRadius.all(Radius.circular(29.r)),
                            border: Border.all(color: Fonts.col_app,width: 1,style: BorderStyle.solid)
                        ),
                        //Colors.lightGreen,
                        padding: new EdgeInsets.symmetric(horizontal: 25.0.w,vertical: 15.h),
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          "${keyList[index]}",
                          style: TextStyle(color: Fonts.col_text, fontSize: 16.sp,fontWeight: FontWeight.bold,fontFamily: "Helvetica Neue"),
                        ),
                      ),
                      new Container(child: _builBatchList(keyList[index])),
                    ],

                  );
                }));
  }
}
