import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tip_trip_admin/screens/add_trip.dart';
import 'package:tip_trip_admin/screens/register.dart';
import 'package:tip_trip_admin/screens/reset_pass.dart';
import 'package:tip_trip_admin/screens/trips.dart';
import 'package:tip_trip_admin/widget/snac.dart';

class Login extends StatefulWidget {
  static const id = 'Login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  StreamSubscription<User> _listener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listener = FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
      } else {
        Navigator.pushReplacementNamed(context, Trips.id);
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _listener.cancel();

    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 10),
                child: Container(
                  height: 230,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('images/logo.png'),
                  )),
                ),
              ),
              // AppBar(
              //   elevation: 0,
              //   backgroundColor: Colors.transparent,
              // ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60.0),
                      topRight: Radius.circular(60.0),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[100],
                        filled: true,
                        suffixIcon: Icon(Icons.email),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25)),
                        labelText: 'Enter Your Email',
                      ),
                      controller: emailController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[100],
                        filled: true,
                        suffixIcon: Icon(Icons.lock),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25)),
                        labelText: 'Set Password',
                        //labelstyle: TextStyle(fontSize: 20)
                      ),
                      controller: passwordController,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * .79,
                          decoration: BoxDecoration(
                              color: Colors.lightBlue[900],
                              borderRadius: BorderRadius.circular(20)),
                          // ignore: deprecated_member_use
                          child: FlatButton(
                              onPressed: () async {
                                try {
                                  await auth.signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text);
                                  Navigator.pushReplacementNamed(
                                      context, Trips.id);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    print('No user found for that email.');
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snac('User not found.'));
                                  } else if (e.code == 'wrong-password') {
                                    print(
                                        'Wrong password provided for that user.');
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snac('Wrong password.'));
                                  }
                                }
                              },
                              child: Container(
                                // padding: EdgeInsets.only(top: 3),
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: TextButton(
                            child: Text('Forget Password',
                                style: TextStyle(
                                    fontSize: 18,
                                    // color: Colors.orangeAccent[400])),
                                    color: Color(0xFF2196F3))),
                            onPressed: () {
                              Navigator.pushNamed(context, ResetPassword.id);
                            },
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Dont have an account?',
                            style: TextStyle(
                              fontSize: 18,
                            )),
                        // Spacer(),
                        TextButton(
                          child: Text('Sign up',
                              style: TextStyle(
                                  fontSize: 18,
                                  // color: Colors.orangeAccent[400])),
                                  color: Color(0xFF2196F3))),
                          onPressed: () {
                            Navigator.pushNamed(context, Register.id);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
