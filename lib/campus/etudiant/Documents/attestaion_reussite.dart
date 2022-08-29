import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:enamconnect/services/Fonts.dart';
import 'package:enamconnect/widgets/custom_widgets/app_textfield.dart';
class Attestation_reussite extends StatefulWidget {

  @override
  _Attestation_reussiteState createState() => _Attestation_reussiteState();
}

class _Attestation_reussiteState extends State<Attestation_reussite> {
  FocusNode _cfoucs = new FocusNode();
  var motif = TextEditingController();
   var Observation = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 54.h,
        child: RaisedButton(
            child: Text("Demander",style: TextStyle(fontWeight: FontWeight.bold,color: Fonts.col_app),),
            elevation: 1.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
            color: Fonts.col_gr3,
            onPressed: (){}
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Fonts.col_app),
        toolbarHeight: 70.h ,
        elevation: 0.0,

        // iconTheme: IconThemeData(color: Fonts.col_app),
        // titleSpacing: double.infinity,
        titleSpacing: 0,
        backgroundColor: Fonts.col_gr3,
        leading: Container(
          color: Fonts.col_gr3,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Fonts.col_app,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Container(
          padding: const EdgeInsets.only(top: 10,bottom:10),
          color: Fonts.col_gr3,
          child: Row(
            children: [
              Image.asset(
                "images/documents-folder.png",
                color: Fonts.col_app,
                width: 35.5.w,
                height: 30.5.h,
              ), Container(width: 7.w,),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom:10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Attestation de réussite",
                      style: TextStyle(
                          color: Fonts.col_app,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0.sp),
                    ),
                  ],
                ),
              ),

              Expanded(child: Container()),
              Padding(
                  padding: EdgeInsets.all(8.w),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      child: Container(
                          height: 44.w,
                          width: 44.w,
                          color: Colors.white.withOpacity(0.9),
                          padding: EdgeInsets.all(0.w),
                          child: Image.asset(
                            "images/lg.png",
                          )))),
              SizedBox(width: 22.w,),
            ],

          ),
        ),

      ),
      body: Container(
          color: Fonts.col_gr3,
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight :   Radius.circular(39.r) ),
              child: Container (
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 50.h,
                        ),
                        Container(
                          child: Text("Observation  :",style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 15, right: 5),
                        margin: EdgeInsets.only(
                          top: 5,
                        ),
                        // width: 130,
                        // decoration: BoxDecoration(
                        //   color: Colors.black12,
                        //   borderRadius: BorderRadius.all(Radius.circular(10)),
                        //   // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                        // ),
                        child:
                        TextFieldWidget(
                          "Observation",
                          _cfoucs,
                          motif,
                          TextInputType.text,
                          null,
                          suffixIcon: "",
                        )
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 50.h,
                        ),
                        Container(
                          child: Text("Motif  :",style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      height: 80,
                        padding: EdgeInsets.only(left: 15, right: 5),
                        margin: EdgeInsets.only(
                          top: 5,
                        ),
                        // width: 130,
                        // decoration: BoxDecoration(
                        //   color: Colors.black12,
                        //   borderRadius: BorderRadius.all(Radius.circular(10)),
                        //   // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                        // ),
                        child:
                        TextFieldWidget(
                          "Motif",
                          _cfoucs,
                          motif,
                          TextInputType.text,
                          null,
                          suffixIcon: "",
                        )
                    ),

                  ],
                ),
              )
          )
      ),

    );
  }
}
