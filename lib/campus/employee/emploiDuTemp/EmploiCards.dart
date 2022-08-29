import 'dart:math';

import 'package:flutter/material.dart';
import 'package:enamconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class EmploiCards extends StatefulWidget {
  final emploiDuJour;


  EmploiCards(this.emploiDuJour);
  @override
  _EmploiCardsState createState() => _EmploiCardsState();
}


class _EmploiCardsState extends State<EmploiCards> {

  final Random _random = Random();
  List<String> time;



  Widget _buildTimeItem(BuildContext context, int index) {
    // List<String> time = widget.emploiDuJour.keys.toList();


    print(widget.emploiDuJour.keys.toList());
    print(time);


    return widget.emploiDuJour[time[index]] != null
        ? Card(

            clipBehavior: Clip.antiAliasWithSaveLayer,
            semanticContainer: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.0),side: BorderSide(width: 0.1,color: Fonts.border_col,style: BorderStyle.solid)
            ),
            elevation: 1.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Fonts.col_cl,
                // border: Border(
                //   left: BorderSide(
                //       width: 6.0,
                //       color: Color.fromARGB(
                //         //or with fromRGBO with fourth arg as _random.nextDouble(),
                //         _random.nextInt(266),
                //         _random.nextInt(266),
                //         _random.nextInt(266),
                //         _random.nextInt(266),
                //       ).withOpacity(0.9)),
                // ),
              ),
              child: ListTile(
              contentPadding: EdgeInsets.all(0.0),

                //contentPadding:
                   // EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(left:8.0,right: 8),
                  decoration: new BoxDecoration(
                  //  color:  const Color(0xffe4f1fd),
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.black12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          " ${formatTimeString(widget.emploiDuJour[time[index]]["time_t"])[0]}"
                        ,style: TextStyle(color: Fonts.col_app_grey,fontSize: 12.sp ,fontWeight: FontWeight.w500),),
                     SizedBox(height: 4,),
                      Image.asset(
                        "assets/images/clock.png",width: 19.w,
                      ),
                      SizedBox(height: 4,),
                      Text(
                          "${formatTimeString(widget.emploiDuJour[time[index]]["time_t"])[1]}",style: TextStyle(color: Fonts.col_app_grey,fontSize: 12.sp ,fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
                title: Text(
                  "${widget.emploiDuJour[time[index]]["subject"]}",
                  style: TextStyle(
                      color: Fonts.col_text , fontSize: 10.sp , fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                            "Classe : ${widget.emploiDuJour[time[index]]["batch"]}",
                          style: TextStyle(
                              color: Fonts.col_app_grey , fontSize: 10.sp , fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
        : Container(child: Text(""));
  }

  Widget _buildTimeList(len) {
    Widget timeCards;
    if (widget.emploiDuJour.length > 0) {
      timeCards = ListView.builder(
        itemBuilder: _buildTimeItem,
        itemCount:len,
      );
    } else {
      timeCards = Container();
    }
    return timeCards;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    time = widget.emploiDuJour.keys.toList();
    for(String t in time){
        time.sort((a, b) {
          return a.compareTo(b.toLowerCase());
        });
    }
    // widget.emploiDuJour.forEach((k,v){
    //
    //   time.add(k);
    //   time.sort((a, b) {
    //     return a.compareTo(b.toLowerCase());
    //   });
    //
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          child: _buildTimeList(widget.emploiDuJour.keys.toList().length),
        )
      ],
    ));
  }

  List formatTimeString(String string) {
    var st;
    st = string.split("-");
    return st;
  }
}
