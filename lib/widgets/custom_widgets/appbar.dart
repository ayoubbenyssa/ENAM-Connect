import 'package:flutter/material.dart';
import 'package:enamconnect/services/Fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common.dart';


class ApBar extends StatelessWidget implements PreferredSizeWidget {
  String path_image_app ;
  String icon_fonctionnement ;
  String fonction ;
  Widget bottom ;



  ApBar(this.path_image_app ,this.icon_fonctionnement ,this.fonction  ,this.bottom);

  Widget title_widget;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize : Size.fromHeight(128.h),
      child : Stack(
        children: <Widget>[
          SvgPicture.asset(
            path_image_app,
            fit : BoxFit.cover,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            // height: 128.h,
          ),
          // Container(
          //   padding: EdgeInsets.only(top: 15.h,left: 5.h),
          //
          //   child: Image.asset(
          //     icon_fonctionnement,
          //     color: Fonts.col_grey.withOpacity(0.2),
          //     width: 80.w,
          //     height: 70.h,
          //   ),
          // ),

          // Container(
          //   child: Row(
          //     children: [
          //
          //     ],
          //   ),
          // )
          AppBar(
            toolbarHeight: 70.h,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
            // iconTheme: IconThemeData(color: Fonts.col_app),
            // titleSpacing: double.infinity,
            titleSpacing: 0,
            leading: Container(
              padding:  EdgeInsets.only(left: 15.w, top: 10.h,bottom:20.h),

              // color: Fonts.col_app,
              child: IconButton(
                icon: FadingImage.asset(
                  "images/arrow_back.png",
                  width:  28.3.w,
                  height : 18.62.h,
                  fit: BoxFit.cover,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            title: Container(
              padding:  EdgeInsets.only(left: 5.w, top: 10.h,bottom:20.h),
              // color: Fonts.col_app,
              child: Row(
                children: [
                  Image.asset(
                    icon_fonctionnement,
                    color: Colors.white,
                    width: 25.w,
                    height: 28.58.h,
                    fit: BoxFit.fill,
                  ),
                  Container(width: 7.w,),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom:10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.475.w,
                      child: Text(
                        fonction,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Helvetica Neue",
                            fontSize: 20.0.sp),
                      ),
                    ),
                  ),

                  Expanded(child: Container()),
                  Padding(
                      padding: EdgeInsets.only(left: 8.w,right: 8.w,top: 20.h),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          child: Container(
                              height: 65.h,
                              width: 65.w,
                              // color: Colors.white.withOpacity(0.9),
                              padding: EdgeInsets.all(0.w),
                              child: Image.asset(
                                "assets/images/enam.png",
                              )))),
                  // SizedBox(width: 10.w,),
                ],

              ),
            ),
            bottom: bottom)
        ],
      ),
    );
  }

  static final _appBar = AppBar();

  @override
  Size get preferredSize => _appBar.preferredSize;
}
