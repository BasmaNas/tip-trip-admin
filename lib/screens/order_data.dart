import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:tip_trip_admin/constant.dart';
import 'package:tip_trip_admin/widget/design_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderTripData extends StatefulWidget {
  static const id = 'OrderTripData';

  DocumentSnapshot orderDetail;
  OrderTripData({this.orderDetail});
  @override
  _OrderTripDataState createState() => _OrderTripDataState();
}

class _OrderTripDataState extends State<OrderTripData> {
  final dateController = TextEditingController();
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dateController.dispose();
  }
  _makingPhoneCall(String num) async {
    String url = 'tel:${num}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor:Colors.lightBlue[900]
          ,
          actions: [
        IconButton(
            onPressed: () async {
              await adminsCollection
                  .doc(adminId)
                  .collection('orders trip')
                  .doc(widget.orderDetail.id)
                  .delete()
                  .then((value) {
                Navigator.pop(context);
              });
            },
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ))
      ]),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.lightBlue[100]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DesignDetail(
                            keyData: 'Name',
                            value: widget.orderDetail.data()['name'],
                          ),
                          DesignDetail(
                            keyData: 'Email',
                            value: widget.orderDetail.data()['email'],
                          ),
                          DesignDetail(
                            keyData: 'Natioal Id',
                            value: widget.orderDetail.data()['national id'],
                          ),
                          DesignDetail(
                            keyData: 'Name Of Trip',
                            value: widget.orderDetail.data()['trip name'],
                          ),
                          DesignDetail(
                            keyData: 'Days',
                            value: widget.orderDetail.data()['days'],
                          ),
                          DesignDetail(
                            keyData: 'Time Of Order',
                            value: widget.orderDetail.id,
                          ),
                          DesignDetail(
                            keyData: 'No. OF Persons',
                            value: widget.orderDetail.data()['no of person'],
                          ),
                          GestureDetector(
                            onTap: (){
                              _makingPhoneCall(widget.orderDetail.data()['phone']);                            },
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DesignDetail(
                                  keyData: 'Phone',
                                  value: widget.orderDetail.data()['phone'],
                                ),
                                Icon(Icons.call)
                              ],
                            ),
                          ),
                          DesignDetail(
                            keyData: 'Trip Price',
                            value: widget.orderDetail
                                .data()['trip price']
                                .toString(),
                          ),
                          DesignDetail(
                            keyData: 'Date Of Trip',
                            value: widget.orderDetail
                                        .data()['date trip']
                                        .toString() ==
                                    'null'
                                ? "Not Determined Yet "
                                : widget.orderDetail
                                    .data()['date trip']
                                    .toString(),
                          ),
                          // Padding(padding: EdgeInsets.symmetric(vertical: 8),
                          // child: Row(
                          //   children: [
                          //     Text('Name Of Trip -',
                          //     style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 20
                          //     ),),
                          //
                          //   ],
                          // ),),
                          // Row(mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text('Name Of Trip -',
                          //       style: TextStyle(
                          //           fontSize: 18
                          //       ),),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: 370,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[50],
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: TextField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: dateController,
                            decoration: InputDecoration(
                                icon: Icon(
                              Icons.date_range,
                              size: 30,
                              color: Colors.lightBlue[900],
                            ),
                            labelText: 'Date Of Trip'),
                          ),
                        ),

                      ),
                    ),
                    ElevatedButton(onPressed: ()async{
                 await adminsCollection.doc(adminId)
                     .collection('orders trip').
                 doc(widget.orderDetail.id).update({
                   'date trip' :dateController.text
                 });
                 await usersCollection.doc(widget.orderDetail.data()['id'])
                     .collection('orders trip').
                 doc(widget.orderDetail.id).update({
                   'date trip' :dateController.text
                 }).then((va){


                 });

                    },
                      child: Text('Send Date'),
                      style: ButtonStyle(
                          backgroundColor:MaterialStateProperty.all(Colors.lightBlue[900])
                      ),)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
