import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:enamconnect/services/Fonts.dart';
import 'package:enamconnect/services/routes.dart';
import 'package:enamconnect/slides2/pages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:enamconnect/widgets/custom_widgets/primary_button.dart';
import 'package:enamconnect/widgets/custom_widgets/round_button_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homeslides extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Homeslides> {
  int currentIndex = 0;
  PageController _controller;
  PageController _controller2;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    _controller2 = PageController(initialPage: 0);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /**

        /* Container(
        child: Text(
        "ENAM Connect",
        style: GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        color: Fonts.col_app,
        letterSpacing: 1,
        shadows: [
        Shadow(
        color: Colors.grey.shade300,
        offset: Offset(3.0, 3.0),
        blurRadius: 3.0),
        Shadow(
        color: Colors.white,
        offset: Offset(-3.0, 3.0),
        blurRadius: 3.0),
        ],
        fontSize: 41),
        ),
        ),*/
        Container(
        height: 360.h,
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Image.asset(
        pages[index].heroAssetPath,
        height: 360.h,
        //height: 400,
        ),
        ),
        Expanded(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

        SizedBox(
        height: 10.h,
        ),
        Row(
        children: [
        Row(
        children: List.generate(
        3,
        (index) => Container(
        height: 5,
        width:
        currentIndex == index ? 20 : 8,
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(20),
        color: Color(0xff65f4d8)),
        )),
        ),
        Expanded(
        child: Container(),
        ),
        index == 2
        ? GestureDetector(
        onTap: () {},
        child: Container(
        decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(15),
        color: Color(0xff65f4d8),
        ),
        child: Padding(
        padding: const EdgeInsets.symmetric(
        horizontal: 10, vertical: 5),
        child: Text(
        "Next",
        style: GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: 19),
        ),
        ),
        ),
        )
        : GestureDetector(
        onTap: () {
        _controller.nextPage(
        duration:
        Duration(milliseconds: 100),
        curve: Curves.bounceIn);
        },
        child: Container(
        child: Row(
        children: [
        Text(
        "Skip",
        style: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight:
        FontWeight.w500),
        ),
        Icon(Icons.arrow_forward)
        ],
        ),
        ),
        )
        ],
        )
        ],
        ),
        ),
        ),
        )
        ],
        );
        }),
     */

    Widget demar = Container(
        width: 160.w,
        // height: ScreenUtil().setHeight(50),
        padding: new EdgeInsets.only(left: 12.0, right: 12.0),
        child: PrimaryButton(
          disabledColor: Fonts.col_grey,
          fonsize: 14.5.sp,
          icon: "",
          prefix: Container(),
          color: Color(0xff92BA92),
          text: "Démarrer",
          isLoading: false,
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("enter", "yess");

            Routes.go_login(context);
          },
        ));

    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            body: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(),
                child: Column(children: [
                  Container(
                    height: 130.h,
                      width: size.height,
                      child: currentIndex == 0 || currentIndex == 2 ? Image.asset(
                        "assets/images/slid1.png",fit: BoxFit.cover,
                        height: 130.h,
                        width: size.height,
                        //height: 400,
                      ) : currentIndex == 1  || currentIndex == 3? Image.asset(
                        "assets/images/slid2.png",fit: BoxFit.cover,
                        height: 80.h,
                        width: size.height,

                        //height: 400,
                      ) : Container()
                  ),
                  // Center(
                  //     child: Image.asset(
                  //   "assets/images/ifd.png",
                  //   width: 200.w,
                  // )),
                  // Container(
                  //   height: 24.h,
                  // ),

                  Container(
                      margin: EdgeInsets.only(left: 15.w,right: 15.w),
                      alignment: Alignment.bottomCenter,
                      height: 240.h,
                      child: PageView.builder(
                          controller: _controller2,
                          physics: BouncingScrollPhysics(),
                          itemCount: 4,
                          onPageChanged: (int index) {
                            setState(() {
                              currentIndex = index;
                            });
                            _controller.animateToPage(index,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.ease);
                          },
                          itemBuilder: (ctx, index) {
                            return Container(
                              // color: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: Image.asset(
                                  pages[index].heroAssetPath,fit: BoxFit.cover,
                                  height: 240.h,
                                  //height: 400,
                                ));
                          })),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 400.h,
                    decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //     colors: [
                        //       Fonts.col_app,
                        //       Color(0xff95DCFF),
                        //     ],
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomRight),
                        // color: Colors.green,
                        // borderRadius:
                        //     BorderRadius.only(topRight: Radius.circular(50))
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: 20.h, right: 16.w, left: 30.w, bottom: 20.h),
                        child: Column(children: [
                          Container(
                              height: 240.h,
                              child: PageView.builder(
                                  controller: _controller,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: 4,
                                  onPageChanged: (int index) {
                                    setState(() {
                                      currentIndex = index;
                                    });
                                    _controller2.animateToPage(index,
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.ease);
                                  },
                                  itemBuilder: (ctx, index) {
                                    return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 20.h,
                                          ),
                                          Text(
                                            pages[index].title,
                                            style: TextStyle(
                                                fontFamily: "Hbold",
                                                color: Fonts.col_app,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25.sp),
                                          ),
                                          SizedBox(
                                            height: 24.h,
                                          ),
                                          Text(
                                            pages[index].body,
                                            style: TextStyle(
                                                color: Fonts.col_text,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18.sp),
                                          ),
                                          Container(height: 24.h),
                                        ]);
                                  })),
                          Expanded(
                            child: Container(),
                          ),
                          Center(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                4,
                                (index) => Container(
                                      height: 10.w,
                                      width: currentIndex == index ? 10.w : 10.w,
                                      margin: EdgeInsets.only(right: 5),

                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color(currentIndex == index
                                            ? 0xff78938A
                                            : 0xffFFFFFF )  ,width: 1 ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color(currentIndex == index
                                              ? 0xff78938A
                                              : 0xff92BA92)),
                                    )),
                          )),
                          Container(height: 40.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              currentIndex == 3
                                  ? demar
                                  : RoundButtonIcon(
                                      color: Color(0xff92BA92),
                                      onPress: () {
                                        _controller.nextPage(
                                            duration:
                                                Duration(milliseconds: 100),
                                            curve: Curves.bounceIn);
                                        _controller2.nextPage(
                                            duration:
                                                Duration(milliseconds: 100),
                                            curve: Curves.bounceIn);
                                      },
                                    )
                            ],
                          )
                        ])),
                  ),
                  // Expanded(child: Container(),),
                ]))));
  }
}
