import 'package:enamconnect/widgets/custom_widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:enamconnect/services/Fonts.dart';
import 'SousModule1.dart';
import 'package:enamconnect/campus/etudiant/classPackge/Module.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class DetailPage extends StatelessWidget {
  final Module module;

  DetailPage(this.module);


  Widget botton_appbar(){
     PreferredSize(child: Container(),
    ) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize : Size.fromHeight(128.h),
          child: ApBar("assets/images/MODULE.svg" ,"",  module.name, botton_appbar())),
        // appBar: AppBar(
        //   iconTheme: IconThemeData(color: Fonts.col_app),
        //   toolbarHeight: 70.h ,
        //   elevation: 0.0,
        //   backgroundColor: Fonts.col_app,
        //
        //   // iconTheme: IconThemeData(color: Fonts.col_app),
        //   // titleSpacing: double.infinity,
        //   titleSpacing: 0,
        //   leading: Container(
        //     color: Fonts.col_app,
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
        //   title: Container(
        //     padding: const EdgeInsets.only(top: 10,bottom:10),
        //     color: Fonts.col_app,
        //     child: Row(
        //       children: [
        //         // Image.asset(
        //         //   "images/appointment.png",
        //         //   color: Colors.white,
        //         //   width: 23.5.w,
        //         //   height: 25.5.h,
        //         // ),
        //         Container(width: 7.w,),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 10,bottom:10),
        //           child: Container(
        //             width: MediaQuery.of(context).size.width * 0.54.w,
        //             child: Text(
        //               module.name,
        //               maxLines: 2,
        //               style: TextStyle(
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.bold,
        //                   fontSize: 18.0.sp),
        //             ),
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
        //                       "images/enam.png",
        //                     )))),
        //         SizedBox(width: 22.w,),
        //       ],
        //
        //     ),
        //   ),
        // ),
      extendBodyBehindAppBar: true,
      body: Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(height: 100.h,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 74.w,vertical: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w ,vertical: 8.h ),
            decoration: BoxDecoration(
              color: Fonts.col_cl,
              borderRadius: BorderRadius.all(Radius.circular(26.r)),
              border: Border.all(color: Fonts.col_app, width: 1.r),
            ),
            child:  Row(
              children: <Widget>[
                Container(
                  width: 10.0,
                ),
                Text(
                  "La moyenne générale" + " : ",
                  style: TextStyle(fontSize: 16.0.sp,fontWeight: FontWeight.bold,color: Fonts.col_text),
                ),
                Text(
                  "${module.average == "NC" ? "NC" : format(double.parse(module.average))}",
                  style: TextStyle(fontSize: 16.0.sp,fontWeight: FontWeight.bold,
                      color: module.average == "NC" ?  Fonts.col_app_fonn  :
                      double.parse(module.average) >  10 ?Fonts.col_green : Fonts.col_app_red
                  ),
                ),                  // decision()
              ],
            ),
          ),
          // Container(height: 10.h,),

          Expanded(
            child: SousModule(this.module),
          ),
        ],
      ),
      ),
    );
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  Widget decision() {
    return module.average == "NC"
        ? Container()
        : double.parse(module.average) >= 12.0
        ? Image.asset("images/checked.png", width: 25.0, height: 25.0)
        : Image.asset("images/minus.png", width: 25.0, height: 25.0);
  }
}
