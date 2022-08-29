import 'package:enamconnect/widgets/custom_widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:enamconnect/services/Fonts.dart';
import 'package:enamconnect/widgets/custom_widgets/buttons_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Notes_Etudiant.dart';
import 'Absences_Etudiant.dart';
import 'Notes_Etudient_Ratt.dart';

class NotesAbsences extends StatefulWidget {
  NotesAbsences(this.batch,this._userId, this._employeeId, this._token,this._subjectId,this._batchId, this.chef_dept);
  final String batch;
  final int _userId;
  final int _employeeId;
  final int _token;
  final int _subjectId;
  final int _batchId;
  bool chef_dept;

  @override
  NotesAbsencesState createState() => NotesAbsencesState();
}

class NotesAbsencesState extends State<NotesAbsences>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  List _list = [];
  String selectedValue = "Semestre 1";
  int indx = 0;


  ld(i) {
    setState(() {
      selectedValue = _list[i]["name"];
    });
    //com = value;
    // Reload();
  }

  st(i) {
    setState(() {
      indx = i;
    });
    ld(i);
  }

  Widget bottom_appbar (){
    return    PreferredSize( child :
    // child: Container(
    //     color: Fonts.col_app,
    //     padding: EdgeInsets.all(0),
    //     margin: EdgeInsets.all(0),
    //     child :  ClipRRect(
    //       borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),
    //       child:
    Container(
      width: MediaQuery.of(context).size.width * 1.w,
      color: Colors.white,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h ),
          // padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h ),

          height: 50.0.h,
          // color: Colors.red,

          child: ButtonsTabBar(

            backgroundColor: Fonts.col_app,
            radius: 42.r,
            contentPadding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 5.h ),
            borderWidth: 1.0,
            controller: tabController,
            borderColor: Fonts.col_app,
            unselectedBorderColor: Fonts.col_app_fon,
            unselectedBackgroundColor: Colors.white,
            unselectedLabelStyle:
            TextStyle(color: Fonts.col_app_fon, fontSize: 16.sp),
            labelStyle: TextStyle(
                fontSize: 16.0.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            onPressed: st,
            tabs: _list.map((a) => new
            Tab(text: a["name"])).toList(),
          )),
    ),
      //     )
      // )
    );
  }
  @override
  void initState() {
    super.initState();
    _list = [
      {"name": "Notes Session Normal"},
      {"name": "Notes Session Rattrapage"},
    ];
    tabController = TabController(length: 2, vsync: this);
  }


  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
    preferredSize: new Size.fromHeight(160.h),

    child: ApBar("assets/images/app1.svg","images/appointment.png" ,"${widget.batch}" , bottom_appbar() )),


      // AppBar(
      //   // shape: RoundedRectangleBorder(
      //   //   borderRadius: BorderRadius.circular(30.0.r),
      //   // ),
      //     iconTheme: IconThemeData(color: Colors.white),
      //     backgroundColor: Fonts.col_app,
      //     elevation: 0.0,
      //     titleSpacing: 0.0,
      //     toolbarHeight: 120.h ,
      //     leading: Container(
      //       // color: Colors.white,
      //       child: Container(
      //
      //         child: IconButton(
      //           icon: Icon(
      //             Icons.arrow_back,
      //             color: Colors.white,
      //           ),
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //         ),
      //       ),
      //     ),
      //
      //     title: Container(
      //       // color: Colors.white,
      //       child: Container(
      //         child: Row(
      //           children: [
      //             Container(width: 7.w,),
      //             Padding(
      //               padding: const EdgeInsets.only(top: 10,bottom:10),
      //               child: Container(
      //                 width: MediaQuery.of(context).size.width * 0.54.w,
      //                 child: Text(
      //                   "${widget.batch}",
      //                   maxLines: 2,
      //                   style: TextStyle(
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.w500,
      //                       fontSize: 16.0.sp),
      //                 ),
      //               ),
      //             ),
      //
      //             SizedBox(width: 22.w,),
      //           ],
      //
      //         ),
      //       ),
      //     ),
      //
      //     bottom:
      //     PreferredSize( child :
      //     // child: Container(
      //     //     color: Fonts.col_app,
      //     //     padding: EdgeInsets.all(0),
      //     //     margin: EdgeInsets.all(0),
      //     //     child :  ClipRRect(
      //     //       borderRadius: BorderRadius.only(topRight : Radius.circular(39.r)),
      //     //       child:
      //     Container(
      //       width: MediaQuery.of(context).size.width * 1.w,
      //       color: Colors.white,
      //       child: Container(
      //           margin: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h ),
      //           // padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 5.h ),
      //
      //           height: 50.0.h,
      //           // color: Colors.red,
      //
      //           child: ButtonsTabBar(
      //
      //             backgroundColor: Fonts.col_app,
      //             radius: 42.r,
      //             contentPadding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 5.h ),
      //             borderWidth: 1.0,
      //             controller: tabController,
      //             borderColor: Fonts.col_app,
      //             unselectedBorderColor: Fonts.col_app_fon,
      //             unselectedBackgroundColor: Colors.white,
      //             unselectedLabelStyle:
      //             TextStyle(color: Fonts.col_app_fon, fontSize: 16.sp),
      //             labelStyle: TextStyle(
      //                 fontSize: 16.0.sp,
      //                 color: Colors.white,
      //                 fontWeight: FontWeight.bold),
      //             onPressed: st,
      //             tabs: _list.map((a) => new
      //             Tab(text: a["name"])).toList(),
      //           )),
      //     ),
      //       //     )
      //       // )
      //     )
      // ),


      body: TabBarView(controller: tabController, children: [
        Notes(widget._userId, widget._employeeId, widget._token,widget._subjectId,widget._batchId,widget.chef_dept),
        Notes_Ratt(widget._userId, widget._employeeId, widget._token,widget._subjectId,widget._batchId, widget.chef_dept),
        // Absences(widget._userId, widget._employeeId, widget._token,widget._subjectId,widget._batchId),
      ]),
    );
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
    color: color,
    child: tabBar,
  );
}
