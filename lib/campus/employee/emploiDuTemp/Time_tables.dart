import 'package:enamconnect/services/Fonts.dart';
import 'package:enamconnect/widgets/custom_widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:enamconnect/campus/employee/emploiDuTemp/EmploiCards.dart';
import 'package:enamconnect/campus/etudiant/classPackge/emploiDuTemps.dart';
import 'dart:convert';

import 'package:enamconnect/campus/shared/fixdropdown.dart';
import 'package:enamconnect/widgets/custom_widgets/buttons_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:enamconnect/config/config.dart';





class TimeTableEmployee extends StatefulWidget {
  final int _userId;
  final int _employeeId;
  final int _token;

  TimeTableEmployee(this._userId, this._employeeId, this._token);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTableEmployee>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<FixDropdownMenuItem<String>> listItem = [];
  TimeTableList ttList;
  var data;
  var dataDetails = null;
  bool loading = true;
  bool loading2 = true;
  String selected;
  String message = "Choisissez une période";
  bool seulFois = false;
  TimeTablee initialVal;
  List list = [];
  var selectedValue = null;
  int indx = 0;

  Future<http.Response> getTimeTables(
      int user_id, int employee_id, int token) async {
    final param = {
      "user_id": "$user_id",
      "employee_id": "$employee_id",
      "auth_token": "$token",
    };

    final timeTablesData = await http.post(
      "${Config.url_api_scole}/timetables_employee",
      body: param,
    );
    setState(() {
      data = json.decode(timeTablesData.body);
      ttList = new TimeTableList.fromJson(data["student"]);
      loading = false;
      loading2 = false;
    });
    print("___------------");
    print(ttList);
    print("___------------");

    return timeTablesData;
  }

  Future<http.Response> getTimeTablesDetails(
      int user_id, int student_id, int token, int tt_id) async {
    loading2 = true;
    final param = {
      "user_id": "$user_id",
      "employee_id": "$student_id",
      "auth_token": "$token",
      "tt_id": "$tt_id"
    };

    final timeTablesDetailsData = await http.post(
      "${Config.url_api_scole}/timetable_employee_details",
      body: param,
    );

    setState(() {
      dataDetails = json.decode(timeTablesDetailsData.body);
      print(dataDetails);
      message = "Aucun emploi du temps";
      loading2 = false;
    });

    return timeTablesDetailsData;
  }

  @override
  void initState() {
    int weekday = DateTime.now().weekday - 1;
    getTimeTables(widget._userId, widget._employeeId, widget._token);
    list = [
      {"name": "Lun"},
      {"name": "Mar"},
      {"name": "Mer"},
      {"name": "Jeu"},
      {"name": "Ven"},
    ];
    tabController = TabController(
        length: 5,
        vsync: this,
        initialIndex: weekday > 4 ? 0 : DateTime.now().weekday - 1);
    super.initState();
  }
  st(i) {
    setState(() {
      indx = i;
    });
    ld(i);
  }
  ld(i) {
    setState(() {
      selectedValue = list[i]["name"];
    });
    //com = value;
    // Reload();
  }
/*
  @override
  void initState() {
    int weekday = DateTime.now().weekday - 1;
    tabController = TabController(
        length: 5,
        vsync: this,
        initialIndex: weekday > 4 ? 0 : DateTime.now().weekday - 1);
    getTimeTables(widget._userId, widget._studentId, widget._token);
    super.initState();
  }*/

  void load() {
    listItem = [];
    for (var tt in ttList.timeTables) {
      listItem.add(new FixDropdownMenuItem(
        child: Text(
          "De ${_formatDate(tt.start_date)} à ${_formatDate(tt.end_date)}",
          maxLines: 2,
          softWrap: true,
        ),
        value: "${tt.id}",
      ));
    }
  }

  ggg() {
    var dd = DateTime.now();
    for (var tt in ttList.timeTables) {
      bool dateStart = dd.isAfter(DateTime.parse(tt.start_date));
      bool dateEnd = DateTime.parse(tt.end_date).isAfter(dd);
      if (dateStart && dateEnd) {
        setState(() {
          selected = tt.id.toString();
          initialVal = tt;
        });
        getTimeTablesDetails(widget._userId, widget._employeeId, widget._token,
            int.parse(selected));
      }
    }
  }

  _getTableTime(String id) {
    for (var tt in ttList.timeTables) {
      if (tt.id == int.parse(id)) {
        setState(() {
          initialVal = tt;
        });
      }
    }
  }

  Widget bottom_appbar (){
   return PreferredSize(
        preferredSize: new Size.fromHeight(80.h),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [

              Container(
                  width: 700.0,
                  height: 60.0,
                  child: Container(
                      margin:  EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),

                      // padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                      decoration: new BoxDecoration(
                        color: Fonts.col_cl,

                        border: new Border.all(color: Fonts.col_text, width: 1.0),
                        borderRadius: new BorderRadius.all(Radius.circular(22.r)),
                      ),
                      child: new FixDropDown(
                          iconSize: 32.0,
                          isDense: false,
                          hint: new Text(
                            initialVal != null
                                ? "De ${_formatDate(initialVal.start_date)} à ${_formatDate(initialVal.end_date)}"
                                : "  Choisir un calendrier",
                            maxLines: 1,
                            softWrap: true,
                            style: new TextStyle(letterSpacing: 2 ,color: Fonts.col_text , fontSize: 15.sp ,fontWeight: FontWeight.bold),
                          ),
                          items: listItem,
                          onChanged: (value) {
                            selected = value;
                            setState(() {
                              _getTableTime(value);
                            });
                            getTimeTablesDetails(widget._userId, widget._employeeId,
                                widget._token, int.parse(value));
                          }))),

              Container(
                width: MediaQuery.of(context).size.width * 1.w,
                color: Colors.white,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h ),
                    // height: 50.0.h,
                    child: ButtonsTabBar(
                      backgroundColor: Fonts.col_app_fon,
                      radius: 10.r,
                      contentPadding: EdgeInsets.all(6.w),
                      borderWidth: 1.0,
                      controller: tabController,
                      borderColor: Color(0xff707070),
                      unselectedBorderColor: Fonts.col_app_fon,
                      unselectedBackgroundColor: Colors.white,
                      unselectedLabelStyle:
                      TextStyle(color: Fonts.col_app_fon, fontSize: 16.sp),
                      labelStyle: TextStyle(
                          fontSize: 15.0.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      onPressed: st,
                      tabs: list.map((a) => new
                      Tab(text: a["name"])).toList(),
                    )),
              ),
            ],
          ),
        ));
  }



  @override
  Widget build(BuildContext context) {
    if (loading == false) {
      load();
      if (seulFois == false) {
        ggg();
        setState(() {
          seulFois = true;
        });
      }
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: new Size.fromHeight(230.h),

          child: ApBar("assets/images/EMP.svg","images/appointment.png" ,"Emploi du temps " , bottom_appbar() )),

      // AppBar(
      //   iconTheme: IconThemeData(color: Colors.white),
      //
      //   // iconTheme: IconThemeData(color: Fonts.col_app),
      //
      //
      //   leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
      //
      //     Navigator.pop(context);
      //   },),
      //   backgroundColor: Fonts.col_app, //Color.fromRGBO(240,248,255,1),
      //   automaticallyImplyLeading: false,
      //   centerTitle: true,
      //   elevation: 0.0,
      //     title: Container(
      //       // color: Colors.white,
      //       child: Container(
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.only(bottomRight: Radius.circular(35.r)),
      //           color: Fonts.col_app,
      //
      //         ),
      //         // color: Fonts.col_app,
      //         child: Container(
      //           // padding: const EdgeInsets.only(top: 10,bottom:10),
      //           child: Row(
      //             children: [
      //               Image.asset(
      //                 "images/appointment.png",
      //                 color: Colors.white,
      //                 width: 23.5.w,
      //                 height: 25.5.h,
      //               ),              Container(width: 7.w,),
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 10,bottom:10),
      //                 child: Text(
      //                   "Emploi du temps ",
      //                   style: TextStyle(
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.bold,
      //                       fontSize: 18.0.sp),
      //                 ),
      //               ),
      //
      //               Expanded(child: Container()),
      //               Padding(
      //                   padding: EdgeInsets.all(8.w),
      //                   child: ClipRRect(
      //                       borderRadius: BorderRadius.all(Radius.circular(10.r)),
      //                       child: Container(
      //                           height: 44.w,
      //                           width: 44.w,
      //                           // color: Colors.white.withOpacity(0.9),
      //                           padding: EdgeInsets.all(0.w),
      //                           child: Image.asset(
      //                             "images/enam.png",
      //                           )))),
      //               SizedBox(width: 22.w,),
      //             ],
      //
      //           ),
      //         ),
      //       ),
      //     ),
      //
      // ),
      body:  loading2?Center(child: CircularProgressIndicator(),):dataDetails== null?Center(
        child: Text(
          "${message}",
          style: TextStyle(color: Fonts.col_text),
        ),
      ):(dataDetails["student"].toString() == "null" )
          ? Center(
        child: Text(
          "${message}",
          style: TextStyle(color: Fonts.col_text),
        ),
      )
          : /*loading2?Center(child: CircularProgressIndicator(),):(dataDetails["student"].toString() == "null" )
          ? Center(
        child: Text(
          "${message}",
          style: TextStyle(color: Colors.blueGrey),
        ),
      )
          : */Container(
        // margin: EdgeInsets.all(10.0),
        child: TabBarView(controller: tabController, children: [
          dataDetails["student"]["Lun"] == null
              ? Center(
            child: Text(
              "Aucun cours trouvé !",
              style:
              TextStyle(fontSize: 17.0, color: Colors.blueGrey),
            ),
          )
              : EmploiCards(dataDetails["student"]["Lun"]),
          dataDetails["student"]["Mar"] == null
              ? Center(
            child: Text("Aucun cours trouvé !",
                style: TextStyle(
                    fontSize: 17.0, color: Colors.blueGrey)),
          )
              : EmploiCards(dataDetails["student"]["Mar"]),
          dataDetails["student"]["Mer"] == null
              ? Center(
            child: Text("Aucun cours trouvé !",
                style: TextStyle(
                    fontSize: 17.0, color: Colors.blueGrey)),
          )
              : EmploiCards(dataDetails["student"]["Mer"]),
          dataDetails["student"]["Jeu"] == null
              ? Center(
            child: Text("Aucun cours trouvé !",
                style: TextStyle(
                    fontSize: 17.0, color: Colors.blueGrey)),
          )
              : EmploiCards(dataDetails["student"]["Jeu"]),
          dataDetails["student"]["Ven"] == null
              ? Center(
            child: Text("Aucun cours trouvé !",
                style: TextStyle(
                    fontSize: 17.0, color: Colors.blueGrey)),
          )
              : EmploiCards(dataDetails["student"]["Ven"]),
        ]),
      ),
    );
  }

  String _formatDate(String date) {
    String day = DateTime.parse(date).day.toString();
    String month = DateTime.parse(date).month.toString();
    String year = DateTime.parse(date).year.toString();
    String m = int.parse(month) < 10 ? "0$month" : "$month";
    String d = int.parse(day) < 10 ? "0$day" : "$day";

    return "$d/$m/$year";
  }
}
/*DropdownButton(
            isDense: true,
              value: selected,
              items: listItem,
              iconSize: 30.0,
              disabledHint: LinearProgressIndicator(),
              onChanged: (value) {
                selected = value;
                setState(() {});
                getTimeTablesDetails(widget._userId, widget._studentId,
                    widget._token, int.parse(value));
              }),*/
