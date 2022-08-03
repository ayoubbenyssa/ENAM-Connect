

import 'package:flutter/material.dart';
import 'package:enamconnect/models/user.dart';

class   UserResponse {
  final int responseCode;
  final String message;
  final List<User> user;


  UserResponse ({
    @required this.responseCode,
    @required this.message,
    @required this.user,

  });
}