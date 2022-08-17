import 'package:flutter/material.dart';
Widget Custom_Appbar(
    {Color color,
      Color colorText,
      String textAppBar,
      List<Widget> actionWidget,
      Widget widgetLeading}) {
  return AppBar(
    // shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
    title: Text(
      textAppBar,
      style: TextStyle(
          color: colorText
      ),
      //style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
    ),  centerTitle: true,

    leading: widgetLeading,
    backgroundColor: color,
    actions: actionWidget,
  );
}
