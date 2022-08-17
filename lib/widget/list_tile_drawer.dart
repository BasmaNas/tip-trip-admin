import 'package:flutter/material.dart';

class ListTileDrawer extends StatelessWidget {
  ListTileDrawer({this.icon,this.listTileName,this.onPressed});
  String  listTileName;
  IconData icon ;
  Function onPressed ;
  @override
  Widget build(BuildContext context) {
    return  ListTile(leading: Icon(icon,color: Color(0xFF212121),),
        title: Text(listTileName,
          style: TextStyle(
            fontSize: 19.0,
            color: Color(0xFF212121),
          ),),
        onTap:
        //Navigator.pop(context);

        onPressed

      // Update the state of the app.
      // ...

    );
  }
}
