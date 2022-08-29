import 'dart:io';
import 'dart:typed_data';
import 'package:enamconnect/widgets/custom_widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:enamconnect/campus/absence_prof/absence_repository.dart';
import 'package:enamconnect/campus/absence_prof/classe_list.dart';
import 'package:enamconnect/campus/absence_prof/student_list.dart';
import 'package:enamconnect/models/classe.dart';
import 'package:enamconnect/models/user.dart';
import 'package:enamconnect/services/Fonts.dart';
import 'package:enamconnect/widgets/primaryButton.dart';
import 'package:enamconnect/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

class AddAbsence extends StatefulWidget {
  AddAbsence(this.currentUser, {Key key}) : super(key: key);
  User currentUser;

  @override
  _AddAbsenceState createState() => _AddAbsenceState();
}

class _AddAbsenceState extends State<AddAbsence> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  String type = "";
  final _resumecontroller = new TextEditingController();
  FocusNode _focusresume = new FocusNode();
  DateTime date = DateTime.now();
  Absence_repository home_repos = Absence_repository();

  FocusNode _focuspassword = new FocusNode();
  FocusNode _focusemail = new FocusNode();
  final _passcontroller = new TextEditingController();
  final _emailcontroller = new TextEditingController();
  var params = null;

  var uuid = Uuid();
  Classe classe;

  choose_type(String title) {
    setState(() {
      type = title;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  bool load = false;

  add_post() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.

    } else if (params == null) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("Veuillez choisir l'absence !")));
    } else if (classe == null) {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text("Veuillez choisir la classe !")));
    } else {
      setState(() {
        load = true;
      });
      home_repos.add_absence(params["params"]);
      setState(() {
        load = false;
      });
      Navigator.pop(context);
      //params

      /*  final pair = await e2ee.X25519().generateKeyPair();
      var a = await UserRepository.register(
          _emailcontroller.text, _passcontroller.text);


      if (a["code"] == 1) {
        UserData userData = UserData(
            stage_educatrice: [],
            active_token: true,
            email: _emailcontroller.text,
            fullName: _resumecontroller.text,
            uuid: a["uid"],
            password: _passcontroller.text,
            privateKey: pair.secretKey.toBase64(),
            publicKey: pair.publicKey.toBase64(),
            stage: classe,
            type: type == "Enfant" ? "student" : "educatrice");

        await UserRepository.storeNewUser(userData);

        setState(() {
          load = false;
        });
        Navigator.pop(context);
      }
      else {
        setState(() {
          load = false;
        });
        _scaffoldKey.currentState!.showSnackBar(new SnackBar(
            content: new Text(a["uid"])));
      }
    }*/

    }
  }

  choose_date_start() async {
    DateTime newDateTime = await showRoundedDatePicker(
      context: context,
      locale: Locale("fr"),
      initialDate: date,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      borderRadius: 33.r,
      fontFamily: "Montserrat-Regular",
      theme: ThemeData(primaryColor: Fonts.col_app,
        textTheme: TextTheme(
        body1: TextStyle(color: Color(0xff939393),fontWeight: FontWeight.normal ,fontSize: 15.sp,fontFamily: "Montserrat-Regular"),
        caption: TextStyle(color: Color(0xff939393),fontWeight: FontWeight.bold ,fontSize: 15.sp,fontFamily: "Helvetica Neue"),
      ),
        disabledColor: Colors.yellow,
        accentTextTheme: TextTheme(
          body2 : TextStyle(color: Colors.white),
        ),),
        textPositiveButton: "Accepte",
        textNegativeButton: "Annuler ",
        styleDatePicker: MaterialRoundedDatePickerStyle(
          paddingDatePicker: EdgeInsets.all(0),
          paddingMonthHeader: EdgeInsets.all(20),
          marginLeftArrowPrevious: 5,
          marginTopArrowPrevious: 5,
          marginTopArrowNext: 5,
          marginRightArrowNext: 5,
          backgroundHeaderMonth: Colors.white,
          backgroundActionBar : Fonts.col_app.withOpacity(0.2),
          sizeArrow: 30.r,
          colorArrowNext: Color(0xff939393),
          colorArrowPrevious: Color(0xff939393),
          textStyleMonthYearHeader: TextStyle(fontSize: 15.sp,
              color: Color(0xff939393),fontWeight: FontWeight.bold,fontFamily: "Montserrat-SemiBold"
          ) ,
          textStyleButtonNegative: TextStyle(fontSize: 15.sp, color: Color(0xff939393),fontWeight: FontWeight.bold),
            textStyleButtonPositive: TextStyle(fontSize: 15.sp, color: Color(0xff92BA92),fontWeight: FontWeight.bold),
            textStyleDayButton : TextStyle(fontSize: 25.sp,
                color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Montserrat-SemiBold"
            ) ,
          textStyleYearButton: TextStyle(fontSize: 20.sp,
            // color: Color(0xff939393),
            color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Montserrat-SemiBold"),

          textStyleDayHeader: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xff939393),
          ),
        ),
        height: 440.h,
        builderDay: (DateTime dateTime, bool isCurrentDay, bool isSelected, TextStyle defaultTextStyle) {
          if (isSelected) {
            return Container(
              // height: 15.h,
              // padding: EdgeInsets.all(0),
              decoration: BoxDecoration(color: Color(0xff92BA92),
                  // borderRadius: BorderRadius.all(Radius.circular(4.r)),
                  shape: BoxShape.circle
                  // shape: BoxShape.rectangle
              ),
              child: Center(
                child: Text(
                  dateTime.day.toString(),
                  style: defaultTextStyle,
                ),
              ),
            );
          }
      }
    );

    if (!this.mounted) return;
    setState(() {
      date = newDateTime;
    });
    print(newDateTime.toString());
  }

  row(a,b)=>  Container(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.29,
              child: Row(

                children: [
                  Text(a,
                    style:  TextStyle(fontWeight: FontWeight.w400 ,fontSize: 15.sp ,color: Fonts.col_app_grey),),
                  Expanded(child: Container()),
                  Text(" :  ",
                    style:  TextStyle(fontWeight: FontWeight.w400 ,fontSize: 15.sp ,color: Fonts.col_app_grey),),
                ],
              ),
            ),
            // Expanded(
            //   child: Container(),
            // ),
            Container(
              width: MediaQuery.of(context).size.width * 0.54,
              child: Text(b,
                style:  TextStyle(fontWeight: FontWeight.bold ,fontSize: 15.sp ,color: Color(0xffA4B2CC)),),
            ),
          ],
        ),
            SizedBox(height: 10.h,),
        a !=  "Heure " ? Divider(color: Fonts.border_col,height: 0.5.h,) : Container(),
        a !=  "Heure " ? SizedBox(height: 10.h,) : Container(),

      ],
    ),
  );
  Widget recap() {
  String time =   params["details"].map((a)=> a.time).toList().toString();
    return Card(
      elevation: 0.0,
        color: Fonts.col_cl ,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0.r)),
        child: Container(
            decoration: BoxDecoration(
                color: Fonts.col_cl ,
                border: Border.all(color: Fonts.col_app,width: 0.5.w),
                borderRadius: BorderRadius.all(Radius.circular(18.r))
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text("Récapitulatif ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp , color: Fonts.col_text),),
                SizedBox(height: 30.h,),
                row("Nom complet ", params["student"].first_name.toString()),
                Container(height: 8,),
                row("Classe ", classe.name.toString()),
                Container(height: 8,),
                row("Date ", new DateFormat('dd/MM/yyyy').format(date)),
                Container(height: 8,),
                row("Heure ", time),


              ],
            )));
  }

  choose_studentsfunc() async {
    var servs = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              StudentsListOneChoice(widget.currentUser, classe.batch_id, date),
        ));

    if (servs != null) print(servs);

    setState(() {
      params = servs;
      //  list_s = service.name;
    });
  }

  choose_classe() async {
    Classe servs = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClassListOneChoice(widget.currentUser),
        ));

    if (servs != null)
      setState(() {
        classe = servs;
        //  list_s = service.name;
      });
  }

  @override
  Widget build(BuildContext context) {
    Widget classe_widget = InkWell(
        onTap: () {
          // choose_date_start();
          choose_classe();
        },
        child: Container(
          // height: 52.h,
            padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Fonts.col_app,
                width: 0.5.w,
              ),
              borderRadius: BorderRadius.all(Radius.circular(22.r)),
            ),
            child: Row(children: [
              Container(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 4.h,
                  ),
                  Text("Choisir la classe",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.sp,color: Fonts.col_text)
                  ),
                  Container(height: 4.h)
                ],
              ),
              Expanded(child: Container()),
              classe == null
                  ? Container()
                  : Container(alignment: Alignment.centerRight, width: MediaQuery.of(context).size.width * 0.39.w ,
                child: Text(classe.name,maxLines: 1,
                    style:
                    TextStyle(fontWeight: FontWeight.w100,fontSize: 13.sp,color: Fonts.col_app_fon)
                ),
              ),
              Container(width: 12.w),
              Container(
                height: 40.h,
                width: 40.w,
                child: Icon(Icons.arrow_right,size: 35.r,color: Fonts.col_text,),
              ),
              Container(
                width: 8.w,
              )
            ]))
    );

    Widget choose_students = InkWell(
        onTap: () {
          if (classe == null) {
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                content: new Text("Veuillez choisir la classe !")));
          } else {
            print("classe.batch_id  ${classe.batch_id}");
            print("widget.currentUser ${widget.currentUser}");

            print("date ${date}");

            choose_studentsfunc();
          }
        },
        child: Container(
          // height: 52.h,
            padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Fonts.col_app,
                width: 0.5.w,
              ),
              borderRadius: BorderRadius.all(Radius.circular(22.r)),
            ),
            child: Row(children: [
              Container(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 4,
                  ),
                  Text("Choisir un étudiant",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.sp,color: Fonts.col_text)
                  ),
                  Container(height: 4.h)
                ],
              ),
              Expanded(child: Container()),
              Text("", style: TextStyle()),
              Container(width: 12.w),
              Container(
                height: 40.h,
                width: 40.w,
                child: Icon(Icons.arrow_right,size: 35.r,color: Fonts.col_text,),
              ),
              Container(
                width: 8.w,
              )
            ])));

    Widget debut = InkWell(
        onTap: () {
          choose_date_start();
        },
        child: Container(
          // height: 52.h,
            padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Fonts.col_app,
                width: 0.5.w,
              ),
              borderRadius: BorderRadius.all(Radius.circular(22.r)),
            ),
            child: Row(children: [
              Container(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 4.h,
                  ),
                  Text("Date d'absence",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.sp,color: Fonts.col_text)
                  ),
                  Container(height: 4.h)
                ],
              ),
              Expanded(child: Container()),
              Text(new DateFormat('dd/MM/yyyy').format(date),
                  style:
                  TextStyle(fontWeight: FontWeight.w100,fontSize: 13.sp,color: Fonts.col_app_fon)
              ),
              Container(width: 12.w),
              Container(
                height: 40.h,
                width: 40.w,
                child: Icon(Icons.arrow_right,size: 35.r,color: Fonts.col_text,),
              ),
              Container(
                width: 8.w,
              )
            ])));

    /* Widget resume = Widgets.textfield(
      "Raison ",
      _focusresume,
      "",
      _resumecontroller,
      TextInputType.text,
      null,
    );*/

    /**
        text/plain application/msword  application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet '
        'application/vnd.ms-powerpoint application/vnd.openxmlformats-officedocument.presentationml.presentation'
        ' application/vnd.openxmlformats-officedocument.wordprocessingml.document application/vnd.openxmlformats-officedocument.wordprocessingml.template
     */
    Widget  boton_appbar(){
      PreferredSize(preferredSize : Size.fromHeight(0.h));
    }
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
    preferredSize : Size.fromHeight(128.h),
    child: ApBar("assets/images/ABCENCE.svg" ,"images/absences.png", "Ajouter une absence" ,boton_appbar())),
        body: Container(
            child: ListView(padding: EdgeInsets.all(8), children: [
          new Form(
              key: _formKey,
              autovalidate: _autovalidate,
              child: new Container(
                  padding: new EdgeInsets.all(8.0),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 12,
                        ),
                        debut,

                        new Container(height: 12.0),
                        classe_widget,
                        new Container(height: 12.0),

                        choose_students,
                        new Container(height: 12.0),

                        // DropDownClasse(choose_type_classe),
                        new Container(
                          height: 12.0,
                        ),
                        params == null ? Container() : recap(),
                        Container(
                          height: 12.h,
                        ),
                        Center(
                          child: Container(
                              padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 1.h, top: 1.h),
                              width: 200.w,
                              height: 40.h,
                              // margin: EdgeInsets.symmetric(horizontal: 50.w ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(22.r))
                              ),

                              child: RaisedButton(
                                color:
                                Fonts.col_app,
                                elevation: 0,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(22.r),
                                  ),
                                ),
                                onPressed: () {
                                  print("_--------------------------------____ 1") ;
                                  print("confirmation abs");
                                  add_post();                                        print("_--------------------------------____ 2") ;

                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Confirmer",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize: 18.sp,
                                          color: Colors.white
                                      ),)
                                  ],
                                ),
                              )
                          ),
                        ),
                      ]))),
        ])));
  }
}
