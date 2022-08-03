
import 'package:flutter/material.dart';

class CustomAppBar3 extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.lineTo(0,0.5125 * size.height) ;


    var x1 = Offset(0.0507 * size.width,0.7125 * size.height );
    var x9 = Offset(0.0966 * size.width,0.85 * size.height );

    path.quadraticBezierTo(x1.dx, x1.dy, x9.dx, x9.dy);

    var x10 = Offset(0.128 * size.width,0.95 * size.height );
    var x2 = Offset(0.1545 * size.width,1 * size.height);


    path.quadraticBezierTo(x10.dx, x10.dy, x2.dx, x2.dy);


    var x3 = Offset(0.4251 * size.width, 1 * size.height  );

    path.lineTo(0.4251 * size.width, 1 * size.height  ) ;


    var x4 = Offset(0.5507 * size.width, 0.8375 * size.height  );

    path.quadraticBezierTo(x3.dx, x3.dy, x4.dx, x4.dy);


    var x5 = Offset(0.657 * size.width, 0.75 * size.height  );
    var x6 = Offset(0.7004 * size.width, 0.75 * size.height  );

    path.quadraticBezierTo(x5.dx, x5.dy, x6.dx, x6.dy);


    var x7 = Offset(0.7681 * size.width, 0.85 * size.height  );
    var x8 = Offset(0.8285 * size.width, 1 * size.height  );

    path.quadraticBezierTo(x7.dx, x7.dy, x8.dx, x8.dy);


    // var x9 = Offset(0.6714 * size.width, 0.7043 * size.height  );
    // var x10 = Offset(0.7004 * size.width, 0.695 * size.height  );
    //
    // path.quadraticBezierTo(x9.dx, x9.dy, x10.dx, x10.dy);
    //
    // var x11 = Offset(0.7318 * size.width, 0.7043 * size.height  );
    // var x12 = Offset(0.7777 * size.width, 0.7652 * size.height  );
    //
    // path.quadraticBezierTo(x11.dx, x11.dy, x12.dx, x12.dy);
    //
    // var x13 = Offset(0.8285 * size.width, 0.8173 * size.height  );
    // var x14 = Offset(0.91 * size.width, 0.98 * size.height  );
    //
    // path.quadraticBezierTo(x13.dx, x13.dy, x14.dx, x14.dy);



    path.lineTo(size.width,size.height ) ;
    path.lineTo(size.width, 0) ;


    return path ;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}