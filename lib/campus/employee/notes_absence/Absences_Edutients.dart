import 'package:enamconnect/widgets/custom_widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:enamconnect/services/Fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'Absences_Etudiant_carts.dart';
import 'Notes_Etudiant.dart';
import 'Absences_Etudiant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Absences_Etud extends StatefulWidget {
  Absences_Etud(this.batch,this._userId, this._employeeId, this._token,this._subjectId,this._batchId);
  final String batch;
  final int _userId;
  final int _employeeId;
  final int _token;
  final int _subjectId;
  final int _batchId;
  @override
  Absences_EtudState createState() => Absences_EtudState();
}

class Absences_EtudState extends State<Absences_Etud>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  bool affichage = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
  }
  Widget  boton_appbar(){
    PreferredSize(preferredSize : Size.fromHeight(0.h));
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
    preferredSize : Size.fromHeight(128.h),
          child: ApBar("assets/images/ABCENCE.svg" ,"images/absences.png", "Absences",boton_appbar())),

      body: Container(
        color: Colors.white ,
        child :  Column(
          children: [
            Container(
              height: 60.0.h,
              margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 15.h),
              decoration: BoxDecoration(
                  color: Fonts.col_cl,
                  borderRadius: BorderRadius.all(Radius.circular(29.r)),
                  border: Border.all(color: Fonts.col_app,width: 1,style: BorderStyle.solid)
              ),
              //Colors.lightGreen,
              padding: new EdgeInsets.symmetric(horizontal: 16.0.w),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // color: Colors.green,
                    width: MediaQuery.of(context).size.width * 0.665.w,
                    child: new Text(
                      "${widget.batch}",
                      style: TextStyle(color: Fonts.col_text, fontSize: 16.sp, fontWeight: FontWeight.bold,fontFamily: "Helvetica Neue"),
                    ),
                  ),
                  Container(
                    // color: Colors.red,
                    width: MediaQuery.of(context).size.width * 0.115.w,
                    child:
               InkWell(
                 child: Container(
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       Expanded(child: Container()),
                       Container(
                         child:
                       affichage ?
                       SvgPicture.asset(

                         "images/mn.svg",color: Fonts.col_text ,
                         // color: Colors.white,
                         width: 24.w,
                         fit: BoxFit.cover,
                       )  :
                       Image.asset(
                         "images/grid.png",
                         color: Fonts.col_text ,
                         fit: BoxFit.cover,
                         width: 24.w,
                       )

                         ,),

                     ],
                   ),
                 ),onTap: (){
                 setState(() {
                   affichage = affichage ? false : true ;
                 });
               },
               ) ,)
                ],

              ),
            ),
            // SizedBox(height: 5.w,),
            //
            //
            // SizedBox(height: 4.w,),


            affichage ?
            Absences(widget._userId , widget._employeeId, widget._token,widget._subjectId,widget._batchId)
                :
            Absences_cards(widget._userId , widget._employeeId, widget._token,widget._subjectId,widget._batchId)
                // )))
    ,
          ],
        ),
      ),
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
