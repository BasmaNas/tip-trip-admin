import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tip_trip_admin/constant.dart';
import 'package:tip_trip_admin/screens/add_trip.dart';
import 'package:tip_trip_admin/screens/log_in.dart';
import 'package:tip_trip_admin/widget/snac.dart';

class Register extends StatefulWidget {
  static const id = 'Register';

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final nationalIdController = TextEditingController();
  Future register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      if (mounted) {
        setState(() {
          adminId = userCredential.user.uid;
        });
      }
      await uploadUserData().then(() {
        Navigator.pushReplacementNamed(context, Login.id);
      });
      print('success register');
      nameController.clear();
      nationalIdController.clear();
      phoneController.clear();
      emailController.clear();
      passwordController.clear();

      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(snac('weak password'));
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          ScaffoldMessenger.of(context)
              .showSnackBar(snac('email already in use'));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  uploadUserData() {
    adminsCollection.doc(adminId).set({
      'name': nameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'id': adminId,
      'image': '.',
      'national id': nationalIdController.text,
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(snac('Account Added succefully'));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    if (mounted) {
      nameController.dispose();
      nationalIdController.dispose();
      phoneController.dispose();
      emailController.dispose();
      passwordController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, Login.id);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [

              Text(
                'Sign Up',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    // color: Color(0xFF2196F3)
                    color: Colors.black

                ),
              ),
              SizedBox(
                height: 25,
              ),

              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  suffixIcon: Icon(Icons.person),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25)),
                  labelText: ' Enter Your Full Name',
                  //hintStyle: TextStyle(fontSize: 20)
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  suffixIcon: Icon(Icons.email),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25)),
                  labelText: ' Enter Your Email',
                  //hintStyle: TextStyle(fontSize: 20)
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  suffixIcon: Icon(Icons.phone),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25)),
                  labelText: ' Enter Your Phone number',
                  //hintStyle: TextStyle(fontSize: 20)
                ),
              ),
              SizedBox(
                height: 10,
              ),

              TextFormField(
                controller: nationalIdController,
                decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  suffixIcon: Icon(Icons.assignment_ind_outlined),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25)),
                  labelText: 'Enter Your National Id',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  suffixIcon: Icon(Icons.lock),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25)),
                  labelText: 'Enter Your Password',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue[900],
                      borderRadius: BorderRadius.circular(20)),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                      onPressed: () {
                        register();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 30,
                            ),
                            Spacer(),
                            Text('SIGN UP',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
