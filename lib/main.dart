import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tip_trip_admin/screens/TripDetails.dart';
import 'package:tip_trip_admin/screens/add_trip.dart';
import 'package:tip_trip_admin/screens/log_in.dart';
import 'package:tip_trip_admin/screens/orders.dart';
import 'package:tip_trip_admin/screens/profile.dart';
import 'package:tip_trip_admin/screens/register.dart';
import 'package:tip_trip_admin/screens/reset_pass.dart';
import 'package:tip_trip_admin/screens/trips.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tip Trip Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        AddTrip.id : (context) =>AddTrip(),
        Login.id : (context) =>Login(),
        Register.id : (context) =>Register(),
        Trips.id : (context) =>Trips(),
        TripDetails.id : (context) =>TripDetails(),
        Profile.id : (context) =>Profile(),
        ResetPassword.id : (context) =>ResetPassword(),
        Orders.id : (context) =>Orders(),

      }
    );
  }
}
