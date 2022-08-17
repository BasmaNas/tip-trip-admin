

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:tip_trip_admin/constant.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tip_trip_admin/widget/snac.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  static const id = 'Profile';


  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Asset> personalImage = <Asset>[];
  String PersonalImageUrl;
  Future<void> loadAssets1() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: personalImage,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#2196F3",
          actionBarTitle: "Upload image",
          allViewTitle: "Choose Your Image",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      personalImage = resultList;
    });

    for (var imageFile in personalImage) {
      await postImage(imageFile).then((downloadUrl) {
        PersonalImageUrl=downloadUrl.toString();
      }).catchError((err) {
        print(err);
      });
    }
    // if(image.startsWith('gs://') || image.startsWith('http')){}
    try {

      await firebase_storage.FirebaseStorage.instance
          .refFromURL(image)
          .delete();
    } catch (e) {
      print('///////////////////////////////${e.toString()}');
      if (e.toString() == '[firebase_storage/object-not-found]') {
        for (var imageFile in personalImage) {
          await postImage(imageFile).then((downloadUrl) {
            PersonalImageUrl=downloadUrl.toString();
          }).catchError((err) {
            print(err);
          });
        }
      }

      await adminsCollection
          .doc(adminId)
          .update({
        'image': PersonalImageUrl,
      }).then((value) {
        setState(() {
          personalImage = [];
        });
      });

    }


    await adminsCollection.doc(adminId).update({
      'image': PersonalImageUrl,
    }).then((value) {
      setState(() {
        personalImage = [];
      });
    });

  }

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask =
    ref.putData((await imageFile.getByteData()).buffer.asUint8List());
    TaskSnapshot storageTaskSnapshot = await uploadTask;
    return storageTaskSnapshot.ref.getDownloadURL();
  }
  final passwordController = TextEditingController();
  void _changePassword(String password) async{
    //Create an instance of the current user.

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_){
      print("Successfully changed password");
    }).catchError((error){

      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              backgroundColor:
              Colors.white,
              content: Text('You have to retry to login',
                  style: TextStyle(
                      color: Colors.black)),
            );
          });
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }User user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     user =  FirebaseAuth.instance.currentUser;

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.dispose();
  }



@override
  Widget build(BuildContext context) {

return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.lightBlue[900],

          title: Text(
            'Profile',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 20,child: Container(
              color: Colors.lightBlue[900],

            ),),
            Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue[900],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  )),
              height: 200,
              width: 450,
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage:(image=='.'||image==null)?AssetImage('images/as.png') :NetworkImage(image),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          right:90 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20.0,
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                              onPressed: loadAssets1,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 70,
                  width: 370,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue[900],
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[100],
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          Icons.account_circle_outlined,
                          size: 30,
                          color: Colors.lightBlue[900],
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        name,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 70,
                      width: 370,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[900],
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.lightBlue[100],
                                borderRadius: BorderRadius.circular(30)),
                            child: Icon(
                              Icons.email_outlined,
                              size: 30,
                              color: Colors.lightBlue[900],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            adminEmail,
                            style: TextStyle(fontSize: 20,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 70,
                      width: 370,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[900],
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.lightBlue[100],
                                borderRadius: BorderRadius.circular(30)),
                            child: Icon(
                              Icons.call,
                              size: 30,
                              color: Colors.lightBlue[900],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            phone,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 70,
                      width: 370,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[50],
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextField(
controller: passwordController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.password,size: 30,
                            color: Colors.lightBlue[900],)
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(onPressed: (){
                    if(passwordController.text.length >=8){
                      _changePassword(passwordController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                          snac('Successfully changed password.'));
                      passwordController.clear();
                    }
                    else{
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              backgroundColor:
                              Colors.white,
                              content: Text("Password must be 8 digit or more",
                                  style: TextStyle(
                                      color: Colors.black)),
                            );
                          });
                    }

                  },
                      child: Text('Change Password'),
                  style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all(Colors.lightBlue[900])
                  ),)
                 , SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),

          ]),
        ));
  }
}
