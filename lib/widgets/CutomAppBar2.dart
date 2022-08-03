

import 'package:flutter/material.dart';

class CustomAppBar2 extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.lineTo(0,0.3375 * size.height) ;



    var x1 = Offset(0.07246 * size.width,0.575 * size.height );
    var x2 = Offset(0.1328 * size.width,0.725 * size.height);

    path.quadraticBezierTo(x1.dx, x1.dy, x2.dx, x2.dy);

    var x3 = Offset(0.1787 * size.width,0.8125  * size.height  );
    var x4 = Offset(0.256 * size.width, 0.85 * size.height  );

    path.quadraticBezierTo(x3.dx, x3.dy, x4.dx, x4.dy);

    var x5 = Offset(0.3405 * size.width, 0.8125 * size.height  );
    var x6 = Offset(0.43 * size.width, 0.7125 * size.height  );

    path.quadraticBezierTo(x5.dx, x5.dy, x6.dx, x6.dy);

    var x7 = Offset(0.5102 * size.width, 0.5375 * size.height  );
    var x8 = Offset(0.5942 * size.width, 0.4375 * size.height  );

    path.quadraticBezierTo(x7.dx, x7.dy, x8.dx, x8.dy);


    var x9 = Offset(0.6570 * size.width, 0.3875 * size.height  );
    var x10 = Offset(0.71497 * size.width, 0.3875 * size.height  );

    path.quadraticBezierTo(x9.dx, x9.dy, x10.dx, x10.dy);


    var x11 = Offset(0.767 * size.width, 0.418 * size.height  );
    var x12 = Offset(0.849 * size.width, 0.625 * size.height  );

    path.quadraticBezierTo(x11.dx, x11.dy, x12.dx, x12.dy);


    var x13 = Offset(0.9227 * size.width, 0.8 * size.height  );
    var x14 = Offset(0.9806 * size.width, 0.8687 * size.height  );

    path.quadraticBezierTo(x13.dx, x13.dy, x14.dx, x14.dy);

    // var x15 = Offset(0.9192 * size.width, 6.5/10 * size.height  );
    // var x16 = Offset(0.9482 * size.width, 6.9/10 * size.height  );
    //
    // path.quadraticBezierTo(x15.dx, x15.dy, x16.dx, x16.dy);
    //
    // var x17 = Offset(0.9782 * size.width, 7/10 * size.height  );
    // path.quadraticBezierTo(x16.dx, x16.dy, x17.dx, x17.dy);


    // var x9 = Offset(0.6594 * size.width, 3.3/10 * size.height  );
    // var tx = Offset(0.6763 * size.width, 3.1/10 * size.height  );
    //
    //
    // path.quadraticBezierTo(x9.dx, x9.dy, tx.dx, tx.dy);
    //
    // var x10 = Offset(0.6908 * size.width, 3.1/10 * size.height  );
    // var x11 = Offset(0.7173 * size.width, 3.2/10 * size.height);
    //
    // path.quadraticBezierTo(x10.dx, x10.dy, x11.dx, x11.dy);

    // var x11 = Offset(0.7173 * size.width, 3.2/10 * size.height);
    // var x12 = Offset(0.7512 * size.width, 3.5/10 * size.height  );
    //
    // path.quadraticBezierTo(x11.dx, x11.dy, x12.dx, x12.dy);






    // var x14 = Offset(0.6787 * size.width, 3.2/10 * size.height  );
    // path.quadraticBezierTo(x7.dx, x7.dy, x14.dx, x14.dy);
    //
    // var x15 = Offset(0.6932 * size.width, 3.15/10 * size.height  );
    // var x8 = Offset(0.707 * size.width, 3.1/10 * size.height  );
    //
    // path.quadraticBezierTo(x15.dx, x15.dy, x8.dx, x8.dy);
    //
    //
    // var x9 = Offset(0.736 * size.width, 3.3/10 * size.height  );
    // var x10 = Offset(0.797 * size.width, 4/10 * size.height  );
    //
    // path.quadraticBezierTo(x9.dx, x9.dy, x10.dx, x10.dy);
    //
    // var x11 = Offset(0.86 * size.width, 5.1/10 * size.height  );
    // var x12 = Offset(0.917 * size.width, 6.2/10 * size.height  );
    //
    // path.quadraticBezierTo(x11.dx, x11.dy, x12.dx, x12.dy);



    // var x13 = Offset(0.98 * size.width, 8/10 * size.height  );
    // var x14 = Offset(size.width, 6.4/10 * size.height  );
    //
    // path.quadraticBezierTo(x13.dx, x13.dy, x14.dx, x14.dy);

    path.lineTo(size.width, 0.87 * size.height);
    path.lineTo(size.width, 0) ;


    return path ;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}