import 'dart:async';

import 'package:enamconnect/widgets/custom_widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:enamconnect/models/sector.dart';
import 'package:enamconnect/models/user.dart';
import 'package:enamconnect/parc_events_stream/parc_events_stream.dart';
import 'package:enamconnect/services/Fonts.dart';
import 'package:enamconnect/services/sector_services.dart';
import 'package:enamconnect/teeeeest.dart';
import 'package:enamconnect/widgets/fixdropdown.dart';
import 'package:enamconnect/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Conventions extends StatefulWidget {
  Conventions(this.lat, this.lng, this.user, this.list_partner,this.analytics);

  var lat, lng;
  User user;
  List list_partner;
  var analytics;


  @override
  _ParcState createState() => _ParcState();
}

class _ParcState extends State<Conventions>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _menuShown = false;

  List<Sector> _list = [];
  bool loading = false;

  String selectedValue = "";

  getSectors() async {
    List<Sector> sect = await SectorsServices.get_list_sectors();
    setState(() {
      _list = sect;
    });
  }

  @override
  initState() {
    super.initState();


    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    getSectors();
    display_slides();
  }

  Reload() {
    setState(() {
      loading = true;
    });
    new Timer(const Duration(seconds: 1), () {
      try {
        setState(() => loading = false);
      } catch (e) {
        e.toString();
      }
    });
  }



  Widget drop_down() => new Container(
      color: Colors.white,
      width: 700.0,
      height: 60.0,
      child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          decoration: new BoxDecoration(

            color: Colors.white,
            border: new Border.all(color: Fonts.col_app, width: 1.0),
            borderRadius: new BorderRadius.all(Radius.circular(22.r)),
          ),
          child: new FixDropDown(
              iconSize: 32.0,
              isDense: false,
              items: _list.map((Sector value) {
                return new FixDropdownMenuItem(
                  value: value,
                  child: new Text(
                    value.name.toString(),
                    style: TextStyle(color: Fonts.col_text),
                    maxLines: 2,
                    softWrap: true,
                  ),
                );
              }).toList(),
              hint: new Text(
                selectedValue != "" ? selectedValue : "Secteur",
                maxLines: 1,
                softWrap: true,
                style: new TextStyle(color: Fonts.col_text),
              ),
              onChanged: (Sector value) {
                setState(() {
                  selectedValue = value.nme;
                  Reload();
                });
              })));

  display_slides() async {
    //Restez inform??s sur  tout ce qui se passe au sein de votre communaut?? ?? travers l???actualit?? et les ??v??nements.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("con") != "con") {
      new Timer(new Duration(seconds: 1), () {
        setState(() {
          _menuShown = true;
        });

        prefs.setString("con", "con");
      });
    }
  }

  onp() {
    setState(() {
      _menuShown = false;
    });
  }
  Widget bottom_appbar (){
  return  PreferredSize(
      preferredSize: new Size.fromHeight(50.h),
      child:  drop_down(),);

  }

  @override
  Widget build(BuildContext context) {
    Animation opacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(animationController);
    if (_menuShown)
      animationController.forward();
    else
      animationController.reverse();

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: new Size.fromHeight(180.h),

            child: ApBar("assets/images/ABCENCE.svg","images/mic.png" ,"Conventions" , bottom_appbar() )),
        body: Stack(children: <Widget>[
          new Column(
            children: <Widget>[
              // drop_down(),
              new Expanded(
                  child: loading
                      ? Center(
                      child:  Widgets.load())
                      : new StreamParcPub(
                          new Container(),
                          widget.lat,
                          widget.lng,
                          widget.user,
                          "1",
                          widget.list_partner,
                          widget.analytics,
                          sector: selectedValue,
                          category: "promotion",
                          favorite: false,
                          boutique: false,
                        ))
            ],
          ),

        ]));
  }
}
