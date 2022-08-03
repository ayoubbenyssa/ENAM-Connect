

import 'package:flutter/material.dart';

class CustomAppBar extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.lineTo(0, size.height) ;


    var x1 = Offset(0.0555 * size.width, 1 * size.height );
    var x2 = Offset(0.0961 * size.width,0.8625 * size.height);

    path.quadraticBezierTo(x1.dx, x1.dy, x2.dx, x2.dy);


    var x3 = Offset(0.1908 * size.width, 0.55 * size.height  );
    var x4 = Offset(0.2415 * size.width, 0.48 * size.height  );

    path.quadraticBezierTo(x3.dx, x3.dy, x4.dx, x4.dy);

    var x5 = Offset(0.2826 * size.width, 0.4625 * size.height  );
    var x6 = Offset(0.3033 * size.width, 0.471 * size.height  );

    path.quadraticBezierTo(x5.dx, x5.dy, x6.dx, x6.dy);

    var x17 = Offset(0.326 * size.width, 0.475 * size.height  );
    var x18 = Offset(0.3574 * size.width, 0.5125 * size.height  );

    path.quadraticBezierTo(x17.dx, x17.dy, x18.dx, x18.dy);


    var x7 = Offset(0.5072 * size.width, 0.7687 * size.height  );
    var x8 = Offset(0.5507 * size.width, 0.8375 * size.height  );

    path.quadraticBezierTo(x7.dx, x7.dy, x8.dx, x8.dy);


    var x9 = Offset(0.65 * size.width, 0.9125 * size.height  );
    var x10 = Offset(0.6932 * size.width, 0.9125 * size.height  );

    path.quadraticBezierTo(x9.dx, x9.dy, x10.dx, x10.dy);

    var x11 = Offset(0.7512 * size.width, 0.875 * size.height  );
    var x12 = Offset(0.8063 * size.width, 0.7375 * size.height  );

    path.quadraticBezierTo(x11.dx, x11.dy, x12.dx, x12.dy);

    var x13 = Offset(0.8574 * size.width, 0.6 * size.height  );
    var x14 = Offset(0.9106 * size.width, 0.375 * size.height  );

    path.quadraticBezierTo(x13.dx, x13.dy, x14.dx, x14.dy);


    var x15 = Offset(0.9492 * size.width, 0.2 * size.height  );
    var x16 = Offset(0.9806 * size.width, 0 * size.height  );

    path.quadraticBezierTo(x15.dx, x15.dy, x16.dx, x16.dy);



    path.lineTo(size.width, 0 * size.height ) ;
    path.lineTo(size.width, 0) ;


    return path ;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}