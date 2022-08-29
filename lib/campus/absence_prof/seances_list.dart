import 'package:enamconnect/widgets/custom_widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:enamconnect/campus/absence_prof/absence_repository.dart';
import 'package:enamconnect/models/detail.dart';
import 'package:enamconnect/models/student.dart';
import 'package:enamconnect/models/user.dart';
import 'package:enamconnect/services/Fonts.dart';

class ChoiceSeances extends StatefulWidget {
  ChoiceSeances(this.prof, this.student, this.date, this.batch_id, {Key key})
      : super(key: key);
  User prof;
  Student student;
  DateTime date;
  var batch_id;

  @override
  _ChoiceSeancesState createState() => _ChoiceSeancesState();
}

class _ChoiceSeancesState extends State<ChoiceSeances> {
  List<Detail> cats = new List<Detail>();
  bool load = true;
  var json = {};
  Absence_repository home_repos = Absence_repository();

  getList() async {
    var a = await home_repos.get_details_seances(
        widget.prof, widget.student, widget.date, widget.batch_id);

    if (!this.mounted) return;
    setState(() {
      cats = a;
      load = false;
    });

    for(Detail d in cats){
      if(d.check == true){
        setState(() {
          choice_category.add(d);
        });
      }
    }
  }

  List<Detail> choice_category = [];

  click_cat(Detail category) {
    if (!choice_category.contains(category)) {
      setState(() {
        /* for (Service ct in cats) {
          setState(() {
            ct.check = false;
          });
        }*/
        category.check = true;
        choice_category.add(category);
      });
    } else {
      setState(() {
        category.check = false;
        choice_category.remove(category);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getList();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle text4(e) => TextStyle(
        color: Colors.black,
        fontSize: ScreenUtil().setSp(e.check == true ? 18 : 18),
        fontWeight: e.check == true ? FontWeight.w800 : FontWeight.w500);

    Widget divid = Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(12),
        right: ScreenUtil().setWidth(12),
      ),
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Fonts.col_grey.withOpacity(0.06),
    );

    Widget row_widget(Detail e, onPressed) => Container(
        color: e.check == true ? Fonts.col_app.withOpacity(0.06) : Colors.white,
        child: InkWell(
          child: Column(children: [
            Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 16,
                  left: ScreenUtil().setWidth(23),
                  right: ScreenUtil().setWidth(23),
                ),
                child: Row(children: [
                  Container(
                    width: ScreenUtil().setWidth(12),
                  ),
                  Container(
                      color: e.check != true ? Colors.grey[400] : Fonts.col_app,
                      width: 22,
                      height: 22,
                      child: Icon(
                        Icons.check,
                        color:
                            e.check != true ? Colors.white : Colors.grey[300],
                        size: 18,
                      )),
                  Container(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    e.name,
                    style: text4(e),
                  )),
                  Text(e.time.toString()),
                  Container(
                    width: 10,
                  ),
                  SvgPicture.asset("images/next.svg")
                ])),
            divid
          ]),
          onTap: () {
            onPressed(e);
          },
        ));

    Widget text(String text) => Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(28),
          top: ScreenUtil().setHeight(16),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: Fonts.col_grey,
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w900),
        ));

    Widget text2(String text) => Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(28),
            bottom: ScreenUtil().setHeight(21)),
        child: Text(
          text,
          style: TextStyle(
              color: Fonts.col_grey,
              fontSize: ScreenUtil().setSp(12.5),
              fontWeight: FontWeight.w400),
        ));
    Widget  boton_appbar(){
      PreferredSize(preferredSize : Size.fromHeight(0.h));
    }

    return Scaffold(
        bottomNavigationBar: Container(
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 12, top: 12),
            //width: ScreenUtil().setWidth(135),
            child: RaisedButton(
              color:
                  choice_category == null ? Color(0xffF1F0F5) : Fonts.col_app,
              elevation: 0,
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              onPressed: () {
                if (choice_category != []) {
                  /* json["category"]=choice_category;*/

                  List<String> ids= [];
                  for(Detail d in choice_category){
                    ids.add(d.id);
                  }
                  var params = {
                    'params':  {
                      "user_id": "${widget.prof.user_id}",
                      "employee_id": "${widget.prof.employee_id}",
                      "auth_token": "${widget.prof.token_user}",
                      "date": widget.date.toString(),
                      "student_id": "${widget.student.student_id}",
                      "batch_id": "${widget.batch_id}",
                      "tte_ids": ids
                    },
                    "student":widget.student,
                    "details": choice_category


                  };

                  Navigator.pop(context, params);
                  Navigator.pop(context, params);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "CONFIRMER",
                    style: TextStyle(
                        color: choice_category == null
                            ? Color(0xffcccccc)
                            : Colors.white),
                  ),
                ],
              ),
            )),
        appBar: PreferredSize(
            preferredSize : Size.fromHeight(128.h),
            child: ApBar("assets/images/ABCENCE.svg" ,"images/absences.png", widget.student.first_name + " " + widget.student.last_name ,boton_appbar())),
        // AppBar(
        //   iconTheme: IconThemeData(color: Colors.white),
        //   elevation: 1,
        //   backgroundColor: Fonts.col_app,
        //   title: Text(
        //     widget.student.first_name + " " + widget.student.last_name,
        //     maxLines: 2,
        //     style: TextStyle(
        //         color: Colors.white,
        //         fontWeight: FontWeight.w500,
        //         fontSize: 16.0.sp),
        //   ),
        // ),
        body: load == true
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : ListView(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cats.map((e) => row_widget(e, click_cat)).toList(),
                ),
                Container(
                  height: ScreenUtil().setHeight(52),
                ),
              ]));
  }
}
