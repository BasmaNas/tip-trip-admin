import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tip_trip_admin/constant.dart';
import 'package:tip_trip_admin/screens/add_trip.dart';
import 'package:tip_trip_admin/screens/log_in.dart';
import 'package:tip_trip_admin/screens/orders.dart';
import 'package:tip_trip_admin/screens/profile.dart';
import 'package:tip_trip_admin/widget/list_tile_drawer.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  // List<Asset> personalImage = <Asset>[];
  // String PersonalImageUrl;
  // Future<void> loadAssets1() async {
  //   List<Asset> resultList = <Asset>[];
  //   String error = 'No Error Detected';
  //
  //   try {
  //     resultList = await MultiImagePicker.pickImages(
  //       maxImages: 1,
  //       enableCamera: true,
  //       selectedAssets: personalImage,
  //       cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
  //       materialOptions: MaterialOptions(
  //         actionBarColor: "#2196F3",
  //         actionBarTitle: "Upload image",
  //         allViewTitle: "Choose Your Image",
  //         useDetailsView: false,
  //         selectCircleStrokeColor: "#000000",
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     error = e.toString();
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     personalImage = resultList;
  //   });
  //
  //   for (var imageFile in personalImage) {
  //     await postImage(imageFile).then((downloadUrl) {
  //       PersonalImageUrl=downloadUrl.toString();
  //     }).catchError((err) {
  //       print(err);
  //     });
  //   }
  //   // if(image.startsWith('gs://') || image.startsWith('http')){}
  //      try {
  //
  //     await firebase_storage.FirebaseStorage.instance
  //         .refFromURL(image)
  //         .delete();
  //   } catch (e) {
  //     print('///////////////////////////////${e.toString()}');
  //     if (e.toString() == '[firebase_storage/object-not-found]') {
  //       for (var imageFile in personalImage) {
  //         await postImage(imageFile).then((downloadUrl) {
  //           PersonalImageUrl=downloadUrl.toString();
  //         }).catchError((err) {
  //           print(err);
  //         });
  //       }
  //    }
  //
  //       await adminsCollection
  //           .doc(adminId)
  //           .update({
  //         'image': PersonalImageUrl,
  //       }).then((value) {
  //         setState(() {
  //           personalImage = [];
  //         });
  //       });
  //
  //     }
  //
  //
  //   await adminsCollection.doc(adminId).update({
  //     'image': PersonalImageUrl,
  //   }).then((value) {
  //     setState(() {
  //       personalImage = [];
  //     });
  //   });
  //
  // }
  //
  // Future<dynamic> postImage(Asset imageFile) async {
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   firebase_storage.Reference ref =
  //   firebase_storage.FirebaseStorage.instance.ref().child(fileName);
  //
  //   UploadTask uploadTask =
  //   ref.putData((await imageFile.getByteData()).buffer.asUint8List());
  //   TaskSnapshot storageTaskSnapshot = await uploadTask;
  //   return storageTaskSnapshot.ref.getDownloadURL();
  // }
  //
  //
  //

  final password = TextEditingController();

  @override
  void initState() {
    adminEmail = FirebaseAuth.instance.currentUser.email;
    adminId = FirebaseAuth.instance.currentUser.uid;

    super.initState();
    // userAdmin();
    // getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 250,
            child: DrawerHeader(
              child: Container(
                height: 250.0,
                //  color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: new Stack(fit: StackFit.loose, children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    image: image == '.'
                                        ? ExactAssetImage('images/as.png')
                                        : Image.network(image.toString(),
                                                fit: BoxFit.fill)
                                            .image,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ],
                        ),
                        // Padding(
                        //     padding: EdgeInsets.only(top: 90.0, right: 100.0),
                        //     child: new Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: <Widget>[
                        //         new CircleAvatar(
                        //           backgroundColor: Colors.white,
                        //           radius: 25.0,
                        //           child: IconButton(
                        //             icon: Icon(
                        //               Icons.camera_alt,
                        //               color: Colors.black,
                        //             ),
                        //             onPressed: loadAssets1,
                        //           ),
                        //         ),
                        //       ],
                        //     )),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            adminEmail,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  // color: Color(0xFFD32F2F),
                  // color: Colors.greenAccent
                  color: Colors.lightBlue[900]

              ),
            ),
          ),
          ListTileDrawer(
            icon: Icons.directions_bus,
            listTileName: 'Add Trip',
            onPressed: () async {
              Navigator.popAndPushNamed(context, AddTrip.id);
            },
          ),
          ListTileDrawer(
            icon: Icons.reorder_outlined,
            listTileName: 'Profile',
            onPressed: () async {
              Navigator.popAndPushNamed(context, Profile.id);
            },
          ),
          ListTileDrawer(
            icon: Icons.reorder_outlined,
            listTileName: 'Orders',
            onPressed: () async {
              Navigator.popAndPushNamed(context, Orders.id);
            },
          ),
          ListTileDrawer(
            icon: Icons.logout,
            listTileName: 'Log out',
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacementNamed(context, Login.id);
                if (mounted) {
                  setState(() {
                    name = null;
                    adminEmail = '';
                    phone = null;
                    image = '.';
                    adminId = null;
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
