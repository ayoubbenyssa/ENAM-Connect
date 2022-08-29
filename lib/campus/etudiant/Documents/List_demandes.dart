import 'package:enamconnect/widgets/custom_widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:enamconnect/campus/etudiant/Documents/Relves_des_notes.dart';
import 'package:enamconnect/campus/etudiant/Documents/attestaion_reussite.dart';
import 'package:enamconnect/campus/etudiant/Documents/attestation_scolarite.dart';
import 'package:enamconnect/services/Fonts.dart';


class List_document extends StatefulWidget {

  @override
  _List_documentState createState() => _List_documentState();
}

class _List_documentState extends State<List_document> {
  var select = "";
  bool add ;

  tap(choix) {
    if(choix == "Relvés des notes" ) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Demander_relve()
          ));
    } else  if(choix == "Attestation de scolarité" ) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Attestation_scolarite()
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Attestation_reussite()
          ));

    }

  }


  row(name, icon, wid, he) => new ListTile(
      onTap: () {
        tap(name);
      },
      title: Row(children: [
        Image.asset(
          icon,
          width: 26.w,
          height: 26.w,
          color: Colors.white,
        ),
        Container(
          width: 16.0,
        ),
        new Text(
          name,
          style: TextStyle(fontSize: 14.5, color: Colors.white),
        )
      ]));

  Widget  boton_appbar(){
    PreferredSize(preferredSize : Size.fromHeight(0.h));
  }

  show() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => new Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22.r),
                            border: Border.all(
                                color: Fonts.col_app.withOpacity(0.5),
                                width: 1)),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 16,
                              ),
                              Center(
                                  child: Text("Nouvelle demande:" ,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700))),
                              Container(
                                height: 16,
                              ),
                              row("Relvés des notes", "images/ot.png", 40.0,
                                  40.0),
                              row(
                                  "Attestation de scolarité",
                                  "images/mission.png",

                                  35.0,
                                  35.0,
                                  ),
                              row("Attestation de réussite", "images/lost.png",
                                  30.0, 30.0),

                            ]))))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:  true ,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        heroTag: null,
        highlightElevation: 7.0,
        elevation: 0.0,
        //iconSize: 62,
        child: Container(
          decoration: BoxDecoration(
              color: Fonts.col_app,
              borderRadius: BorderRadius.all(Radius.circular(14.r))
          ),
          width: 60.w,
          height: 60.h,
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.add, color: Colors.white, size: 40.r)),
        ),
        onPressed: () {
              show();
        },
      ),

      appBar: PreferredSize(
          preferredSize : Size.fromHeight(128.h),
          child: ApBar("assets/images/app1.svg" ,"images/document.png", "List des Documents",boton_appbar())),
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: Fonts.col_app),
      //   toolbarHeight: 70.h ,
      //   elevation: 0.0,
      //
      //   // iconTheme: IconThemeData(color: Fonts.col_app),
      //   // titleSpacing: double.infinity,
      //   titleSpacing: 0,
      //   backgroundColor: Fonts.col_gr3,
      //   leading: Container(
      //     color: Fonts.col_gr3,
      //     child: IconButton(
      //       icon: Icon(
      //         Icons.arrow_back,
      //         color: Fonts.col_app,
      //       ),
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //     ),
      //   ),
      //   title: Container(
      //     padding: const EdgeInsets.only(top: 10,bottom:10),
      //     color: Fonts.col_gr3,
      //     child: Row(
      //       children: [
      //         Image.asset(
      //           "images/documents-folder.png",
      //           color: Fonts.col_app,
      //           width: 35.5.w,
      //           height: 30.5.h,
      //         ), Container(width: 7.w,),
      //         Padding(
      //           padding: const EdgeInsets.only(top: 10,bottom:10),
      //           child: Row(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Text(
      //                 "List des Documents",
      //                 style: TextStyle(
      //                     color: Fonts.col_app,
      //                     fontWeight: FontWeight.bold,
      //                     fontSize: 18.0.sp),
      //               ),
      //             ],
      //           ),
      //         ),
      //
      //         Expanded(child: Container()),
      //         Padding(
      //             padding: EdgeInsets.all(8.w),
      //             child: ClipRRect(
      //                 borderRadius: BorderRadius.all(Radius.circular(10.r)),
      //                 child: Container(
      //                     height: 44.w,
      //                     width: 44.w,
      //                     color: Colors.white.withOpacity(0.9),
      //                     padding: EdgeInsets.all(0.w),
      //                     child: Image.asset(
      //                       "images/lg.png",
      //                     )))),
      //         SizedBox(width: 22.w,),
      //       ],
      //
      //     ),
      //   ),
      //
      // ),

      body: Container(
        color: Fonts.col_gr3,
        child: ClipRRect(
          // borderRadius: BorderRadius.only(
          //     topRight :  Radius.circular(39.r)),
          child: Container (
            color: Colors.white,
            child :
        Column(
          children: [
            SizedBox(height: 130.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
          children: [Container(child: Text("Total des demandes :"" 00",
            style: TextStyle(fontSize: 16.0.sp,fontWeight: FontWeight.bold,color: Fonts.col_text),

          ),)],
            ),
            SizedBox(height: 15.h,),


            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.h),
              decoration: BoxDecoration(
                  color: Fonts.col_cl,
                  border: Border.all(color: Fonts.col_app_fon ,width: 1.w),
                  borderRadius: BorderRadius.all(Radius.circular(22.r))
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Container(
                  height: 40.h,
                  child: Center(
                    child: Text("Type documents",
                        style: TextStyle(fontSize: 16.0.sp,fontWeight: FontWeight.bold,color: Fonts.col_app),

                      ),
                  ),)],
                  ),
                  Divider(color: Fonts.col_app_fon,height: 1,thickness: 0.5,)  ,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.20.w,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                              height: 35.h,
                                decoration: BoxDecoration(
                          // border: Border.all(color: Colors.black),
                          //         color: Colors.red
                        ),
                                child: Center(child: Text("Statut",
                                    style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.bold,color: Fonts.col_text)
                                    ,)),),
                              Container(
                                height: 60.h,
                                decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Fonts.col_app_fon ,width: 0.5.w ),
                                      bottom: BorderSide(color: Fonts.col_app_fon ,width: 0.5.w )

                                )
                                ),
                                child: Center(child: Text("false")),),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              height: 35.h,

                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: Fonts.col_app_fon ,width: 0.5.w ),

                                    bottom: BorderSide(color: Fonts.col_app_fon ,width: 0.5.w )
                              )
                                  // border: Border.all(color: Colors.black)
                              ),
                              child: Center(child: Text("Motif" ,
                                  style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.bold,color: Fonts.col_text)
                              )),),

                            Container(
                              height: 60.h,
                              padding: EdgeInsets.only(left: 2.w),

                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(color: Fonts.col_app_fon ,width: 0.5.w ),

                                      bottom: BorderSide(color: Fonts.col_app_fon ,width: 0.5.w )
                                  )                              ),
                              child: Center(child: Text("Motif Motif Motif Motif Motif Motif Motif Motif Motif Motif ")),),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.3.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 35.h,
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: Fonts.col_app_fon ,width: 0.5.w ),
                                        bottom: BorderSide(color: Fonts.col_app_fon ,width: 0.5.w )
                                    )
                                ),
                                child: Center(child: Text("Date de récupération",
                                  style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.bold,color: Fonts.col_text),
                                  maxLines: 1,)),),

                              Container(
                                height: 60.h,
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: Fonts.col_app_fon ,width: 0.5.w ),
                                        bottom: BorderSide(color: Fonts.col_app_fon ,width: 0.5.w )
                                    )
                                ),
                                child: Center(child: Text("01/01/2022")),),                            ],
                          ),
                        ),
                      ),
                    ],

                  ),

                  SizedBox(height: 10.h,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 7.5.w),

                        child: Text("Observation :",
                            style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.bold,color: Fonts.col_text)
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.68.w,
                        child: Text("  Observatio Observation Observation Observation ObservationObservation Observation Observation Observation Observation Observation Observation Observation Observation Observation Observation",
                          maxLines: 2,),

                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),

                  Divider(color: Colors.black,height: 1,)  ,

                  SizedBox(height: 10.h,),


                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 7.5.w),
                        child: Text("Date de la demande : ",
                            style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.bold,color: Fonts.col_text)
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.535.w,
                        child: Center(
                          child: Text("01/01/2022",
                            maxLines: 2,),
                        ),

                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),

                  Divider(color: Colors.black,height: 1,)  ,
                  SizedBox(height: 10.h,),

                  Row(
                    children: [
                      Expanded(child: Container()),
                      Container(child: Text("Télécharger",
                          style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.bold,color: Fonts.col_text)
                      ),),
                      SizedBox(width: 20.w,),
                    ],
                  ),
                  SizedBox(height: 10.w,),

                ],
              ),
            ),

          ],
        ),
        ),
        ),
      ),

    );
  }
}
