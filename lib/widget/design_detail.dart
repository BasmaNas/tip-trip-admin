import 'package:flutter/material.dart';

class DesignDetail extends StatelessWidget {
  final String keyData , value ;
  const DesignDetail({this.value , this.keyData}) ;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text('${keyData} -',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),),

            ],
          ),),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${value}',
              style: TextStyle(
                  fontSize: 18
              ),),
          ],
        )
      ],
    );
  }
}
