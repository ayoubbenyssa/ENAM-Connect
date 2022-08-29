import 'dart:developer';

import 'package:enamconnect/widgets/custom_widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:enamconnect/campus/absence_prof/absence_repository.dart';
import 'package:enamconnect/campus/absence_prof/seances_list.dart';
import 'package:enamconnect/models/classe.dart';
import 'package:enamconnect/models/student.dart';
import 'package:enamconnect/models/user.dart';
import 'package:enamconnect/services/Fonts.dart';

class StudentsListOneChoice extends StatefulWidget {
  StudentsListOneChoice(this.user, this.batch_id, this.date);

  User user;
  var batch_id;
  DateTime date;

  @override
  _ClassListOneChoiceState createState() => _ClassListOneChoiceState();
}

class _ClassListOneChoiceState extends State<StudentsListOneChoice> {
  List<Student> cats = [];
  bool load = true;
  var json = {};
  Absence_repository home_repos = Absence_repository();
  final TextEditingController _searchQuery = new TextEditingController();
  List<String> _list;
  bool _IsSearching;
  String _searchText = "";
  bool affichage = true;


  getList() async {
    var a = await home_repos.students_list(widget.user, widget.batch_id);
    if (!this.mounted) return;
    setState(() {
      cats = a;
      load = false;
    });
  }

  _ClassListOneChoiceState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";

          print("_searchText");
          print(_searchText);
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;

          print("_searchText");
          print(_searchText);
        });
      }
    });
  }

  Student choice_category =
      Student(first_name: "", check: false, batch_id: "-1", last_name: "");

  click_cat(Student category) {
    if (choice_category.first_name != category.first_name) {
      setState(() {
        for (Student ct in cats) {
          setState(() {
            ct.check = false;
          });
        }
        category.check = true;
        choice_category = category;
      });
    } else {
      setState(() {
        category.check = false;
        choice_category = Student(
            first_name: "", last_name: "", check: false, batch_id: "-1");
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
        fontSize: ScreenUtil().setSp(e.check == true ? 16 : 13),
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
    Widget row_widget( Student e , onPressed) => Container(
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

                  Expanded(
                      child: Text(
                    e.first_name + " " + e.last_name,
                    style: text4(e),
                  )),
                  // SvgPicture.asset("images/next.svg"),
                  Image.asset(
                    "images/check.png", color: e.check == true ? Fonts.green_app : Fonts.col_grey , fit: BoxFit.cover, width:  e.check ? 23.w : 20.w,
                  )
                ])),
            divid
          ]),
          onTap: () {
            onPressed(e);
          },
        )
    );


    Widget cart_etud(BuildContext context , int index) =>
        InkWell(
          child: Container(
          // color: cats[index].check == true ? Fonts.col_app.withOpacity(0.06) : Colors.white,
          height: MediaQuery.of(context).size.width * 0.3.w,
          decoration: BoxDecoration(
            color: cats[index].check == true ? Fonts.green_app : Fonts.col_app.withOpacity(0.06),
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
                    height: MediaQuery
                        .of(context)
                        .size
                        .width * 0.2.w,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.2.w,
                    child: new Image.asset(
                      "images/user.png",
                      color: Fonts.col_text,
                      fit: BoxFit.cover,
                      // width: 25.0,
                      // height: 25.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  Container(
                    // color: Colors.red,
                    alignment: Alignment.center,

                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.25,
                    child: Text(
                      "${ cats[index].first_name + " " + cats[index].last_name}",
                      maxLines: 1,
                      style: TextStyle(fontWeight: FontWeight.w500,
                          color: Fonts.col_text,
                          fontSize: 11.sp),
                    ),
                  ),
                  Expanded(child: Container()),

                ],
              ),

              // SizedBox(height: 10.h,),
              //
              // Row(
              //
              //   children: [
              //     Expanded(child: Container()),
              //
              //     Container(
              //       padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(50.0),
              //           color: Fonts.col_app),
              //       child: (data["student"][index]["nb_abs"] != null &&
              //           data["student"][index]["nb_abs"] != 0)
              //           ? Text(
              //         "${data["student"][index]["nb_abs"]} heures",
              //         style: TextStyle(fontSize: 15.0, color: Colors.white),
              //       )
              //           : Text("100 heures"),
              //     ),
              //     Expanded(child: Container()),
              //
              //   ],
              // ),
            ],
          ),
      ),  onTap: () {
          click_cat(cats[index]);
        },
        );



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
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 8, top: 4),
            //height: ScreenUtil().setHeight(66),
            //width: ScreenUtil().setWidth(135),
            child: RaisedButton(
              color: choice_category.first_name == ""
                  ? Color(0xffF1F0F5)
                  : Fonts.col_app,
              elevation: 0,
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              onPressed: () {
                if (choice_category.first_name != "" &&
                    choice_category.last_name != "") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChoiceSeances(widget.user,
                            choice_category, widget.date, widget.batch_id),
                      ));
                } else {
                  Navigator.pop(context, choice_category);

                  // Navigator.pop(context, null);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Suivant",
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
            child: ApBar("assets/images/ABCENCE.svg" ,"images/absences.png", "Étudiants" ,boton_appbar())),
        // appBar: AppBar(
        //   // shape: RoundedRectangleBorder(
        //   //     borderRadius: BorderRadius.vertical(
        //   //       bottom: Radius.circular(30),
        //   //     )),
        //   elevation: 0.0,
        //   titleSpacing: 0.0,
        //   toolbarHeight: 70.h ,
        //   leading: Container(
        //     // color: Fonts.col_app,
        //     child: IconButton(
        //       icon: Icon(
        //         Icons.arrow_back,
        //         color: Colors.white,
        //       ),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     ),
        //   ),
        //
        //   title: Container(
        //     padding: const EdgeInsets.only(top: 10,bottom:10),
        //     // color: Fonts.col_app,
        //     child: Row(
        //       children: [
        //
        //         Padding(
        //           padding: const EdgeInsets.only(top: 10,bottom:10),
        //           child: Container(
        //             // width: MediaQuery.of(context).size.width * 0.54.w,
        //             child: Text(
        //               "Étudiants",
        //               maxLines: 2,
        //               style: TextStyle(
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.w500,
        //                   fontSize: 16.0.sp),
        //             ),
        //           ),
        //         ),
        //       ],
        //
        //     ),
        //   ),
        // ),
        body: load == true
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            :
        Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.81.w,
                    margin: const EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 8.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: TextField(
                      controller: _searchQuery,
                      decoration: InputDecoration(
                          counterStyle: TextStyle(color: Colors.white),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 6.0,
                          ),
                          hintText: '  Chercher un étudiant...',
                          enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide:
                            BorderSide(color: Colors.grey[600], width: 0.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          suffixIcon: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                end: 12.0, start: 12.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey[600],
                              size: 30.0,
                            ), // icon is 48px widget.
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey[50], width: 0.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.05.w,

                    child:  InkWell(
                      child: Container(
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
                      onTap: (){
                      setState(() {
                        affichage = affichage ? false : true ;
                      });
                    },
                    )
                    ,),
                ],
              ),
            ),
            /**
                (!e.first_name || !e.last_name)
                .toLowerCase()
                .contains(_searchText.toLowerCase()) &&
                _searchText.isNotEmpty)
                ? new Container()
                :
             **/


                SizedBox(height: 15.sp,),


                Container(
                  // color: Colors.red,
                  height:MediaQuery.of(context).size.height * 0.81.h,
                  child: affichage
                      ?
                  Scrollbar(
                    child: ListView(

                      children:cats.map((e) => (!e.first_name
                          .toLowerCase()
                          .contains(_searchText.toLowerCase()) &&
                          _searchText.isNotEmpty) ||
                          (!e.last_name
                              .toLowerCase()
                              .contains(_searchText.toLowerCase()) &&
                              _searchText.isNotEmpty)
                          ? Container()
                          :

                      row_widget(e, click_cat)).toList(),
                    ),
                  )
                      :
    Scrollbar(
    child: GridView.builder(
      gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 170,
          // childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: cart_etud,
      itemCount: cats.length,
    ),
    )


                )





          ],
        )

    //
    //     ListView(children: [
    //
    //           Container(
    //             height: MediaQuery.of(context).size.height * 0.8.h,
    //             child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: affichage ?
    //
    //                 cats.map((e) => (!e.first_name
    //                                     .toLowerCase()
    //                                     .contains(_searchText.toLowerCase()) &&
    //                                 _searchText.isNotEmpty) ||
    //                             (!e.last_name
    //                                     .toLowerCase()
    //                                     .contains(_searchText.toLowerCase()) &&
    //                                 _searchText.isNotEmpty)
    //                         ? Container()
    //                         :
    //
    //                 row_widget(e, click_cat)).toList()
    //                 :
    //
    //         cats.map((e) => (!e.first_name
    //               .toLowerCase()
    //               .contains(_searchText.toLowerCase()) &&
    //               _searchText.isNotEmpty) ||
    //               (!e.last_name
    //                   .toLowerCase()
    //                   .contains(_searchText.toLowerCase()) &&
    //                   _searchText.isNotEmpty)
    //               ? Container()
    //               : Container(
    //           height: MediaQuery.of(context).size.height * 0.8.h,
    //
    //           child: GridView.builder(
    //             gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
    //                   maxCrossAxisExtent: 170,
    //                   // childAspectRatio: 3 / 2,
    //                   crossAxisSpacing: 10,
    //                   mainAxisSpacing: 10),
    //                   itemBuilder: cart_etud,
    //                   itemCount: cats.length,
    //         ),
    //               ),).toList(),
    //             ),
    //           ),
    //
    //
    //             Container(
    //               height: ScreenUtil().setHeight(52),
    //             ),
    //           ]
    // )
    );
  }
}
