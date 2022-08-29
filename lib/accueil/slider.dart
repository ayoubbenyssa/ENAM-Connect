import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:enamconnect/campus/etudiant/absences/AbsencesPage.dart';
import 'package:enamconnect/campus/etudiant/emploiDuTemp/Time_tables.dart';
import 'package:enamconnect/campus/etudiant/releve/Modules.dart';
import 'package:enamconnect/models/user.dart';
import 'package:enamconnect/restauration/RestaurantAccueil.dart';
import 'package:enamconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:enamconnect/widgets/widgets.dart';

class SliderBanner2 extends StatefulWidget {
  SliderBanner2(this.user, {Key key}) : super(key: key);
  User user;

  @override
  _SliderBannerState createState() => _SliderBannerState();
}

class _SliderBannerState extends State<SliderBanner2> {
  int _currentIndex = 0;

  List cardList() => [
        Item1("assets/icons/restau.svg", () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RestoAccuiel(widget.user.user_id,
                      widget.user.student_id, widget.user.token_user)));
        }, "Restauration"),
        Item1("assets/icons/emploi.svg", () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TimeTable(widget.user.user_id,
                      widget.user.student_id, widget.user.token_user)));
        }, "Emploi du temps"),
        Item1("assets/icons/modules.svg", () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePageNote(
                      'Les notes',
                      widget.user.user_id,
                      widget.user.student_id,
                      widget.user.token_user)));
        }, "Modules"),
        Item1("assets/icons/abs.svg", () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AbsencePage(
                      widget.user,
                      widget.user.user_id,
                      widget.user.student_id,
                      widget.user.token_user)));
        }, "Absences")
      ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 26.h,
        ),
        CarouselSlider(

          options: CarouselOptions(

            height: 220.0.h,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 10),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,

            pauseAutoPlayOnTouch: true,
            aspectRatio: 0.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: cardList().map((card) {
            return Builder(builder: (BuildContext context) {
              return Container(
                // color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width,
                child: card,
              );
            });
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(cardList(), (index, url) {
            return Container(
              width: _currentIndex == index ?20.w:7.0.w,
              height: 7.0.w,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(16.0.r),
               // shape: BoxShape.circle,
                color: _currentIndex == index ? Fonts.col_app : Fonts.col_grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class Item1 extends StatelessWidget {
  Item1(this.image, this.click, this.text, {Key key}) : super(key: key);
  String image;
  Function click;
  String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          click();
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(28.0.r),
            child: Container(
              height: 150.h,
              width: 200.w,
              //  decoration: Widgets.boxdecoration_container3(),
              decoration: BoxDecoration(
                // image: new DecorationImage(
                //     fit: BoxFit.contain,
                //
                //     alignment: Alignment.topRight,
                //    /* colorFilter: new ColorFilter.mode(
                //         Colors.transparent, BlendMode.dstATop),*/
                //     image: ew AssetImage("assets/images/logo2.png")),
                border: new Border.all(
                    color: Fonts.border_col.withOpacity(0.5), width: 1.0),
                color: Color(0xff92BA92) ,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(height : 15.w),

                  SvgPicture.asset(
                    image,
                    width: 116.21.w,
                    height: 79.15.h,
                    color: Colors.white, /*,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)*/
                  ),
                  Container(height: 20.h),
                  Container(
                      //  width: 120.w,
                      child: Text(text,
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              height: 1.2,
                              fontSize: 21.0.sp,
                              fontWeight: FontWeight.bold))),
                ],
              ),
            )));
  }
}
