import 'package:flutter/material.dart';


import 'package:tip_trip_admin/constant.dart';
import 'package:tip_trip_admin/screens/order_data.dart';

class Orders extends StatefulWidget {
  static const id = 'Order';

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text('Orders'),
        backgroundColor: Colors.lightBlue[900]
        ,

      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
        child: StreamBuilder(
            stream:adminsCollection
                .doc(adminId).collection('orders trip').snapshots() ,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('error');
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          GestureDetector(

                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(right: 10,left: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.lightBlue[50]
                              ),
                              child
                                  : Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(snapshot.data.docs[i].id,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold
                                          ),),
                                      ],
                                    ),
                                    // Row(mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //
                                    //   ],
                                    // )
                                  ],
                                ),
                              ),

                            ),
                            onTap: (){ Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return OrderTripData(orderDetail: snapshot.data.docs[i],
                              );
                            }));},
                          ),
                          SizedBox(width: 200,
                            child: Divider(
                              thickness: 2,
                              color: Colors.black,
                            ),),
                        ],
                      );


                    }

                );

              }

              return Center(child: CircularProgressIndicator());

            }

        ),
      ),
    );
  }
}
