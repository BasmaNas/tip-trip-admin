import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tip_trip_admin/constant.dart';
import 'package:tip_trip_admin/screens/TripDetails.dart';
import 'package:tip_trip_admin/screens/log_in.dart';
import 'package:tip_trip_admin/widget/drawer.dart';

class Trips extends StatefulWidget {
  static const id = 'Trips';

  @override
  _TripsState createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  CollectionReference tripsCollections =
      FirebaseFirestore.instance.collection('trips');
  getdata() async {
    await adminsCollection.doc(adminId).snapshots().listen((event) {
      if(mounted)
      setState(() {
        image = event.data()['image'].toString();
        phone = event.data()['phone'].toString();
        name = event.data()['name'].toString();
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     adminId  =FirebaseAuth.instance.currentUser.uid;

     adminEmail =  FirebaseAuth.instance.currentUser.email;
    getdata();
  }
  final searchController = TextEditingController();
  String search ;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),

      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Colors.lightBlue[900],
        /* title: Text(
          'Choose your destination',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),*/
        actions: [
          Container(
            width: 300,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (vaiue){
                    setState(() {
                      search=vaiue;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(25.0)),
                      hintText: 'search',

                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                      ),
                      fillColor: Colors.white,
                      filled: true
                  ),
                ),
              ),
            ),
          )
        ],
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          height: MediaQuery.of(context).size.height * .89,
          child: StreamBuilder(
              // stream: tripsCollections.snapshots(),
              stream: (search != "" && search != null)?
              tripCollection.where('search' , arrayContains:search ).snapshots():
              tripCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error'),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('No Data'),
                  );
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 15, 8.0, 0),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder:(context){
                                    return TripDetails(
                                      detailTrip:snapshot.data.docs[i]);
                                  }));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35.0),
                              child: Card(
                                elevation: 20,
                                child: Wrap(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 200,
                                      child: Image.network(
                                        snapshot.data.docs[i]
                                            .data()['image trip'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(snapshot
                                          .data.docs[i]
                                          .data()['name']),
                                      subtitle: Text(
                                        ' ${snapshot
                                            .data.docs[i]
                                            .data()['price']} ',
                                        style: TextStyle(
                                            backgroundColor: Colors.white60,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }
                return CircularProgressIndicator();
              }),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
