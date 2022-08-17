import 'package:flutter/material.dart';

SnackBar snac(String mssg) {
  final snackBar = SnackBar(
    backgroundColor: Color(0xFF757575),
    elevation: 2.0,
    content: Text(mssg, style: TextStyle(
        color: Colors.white
    ),),

  );
  return snackBar;
}