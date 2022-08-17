
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tip_trip_admin/widget/app_bar.dart';
import 'package:tip_trip_admin/widget/snac.dart';

import '../constant.dart';

class AddTrip extends StatefulWidget {
  static const id = 'AddTrip';

  @override
  _AddTripState createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  final tripNameControler = TextEditingController();
  final tripDetailControler = TextEditingController();
  final tripPriceControler = TextEditingController();
  final daysControler = TextEditingController();
  String _error = 'No Error Dectected';


  List <Asset> imageTrip = <Asset>[];
  List <Asset> imagesTripDetail = <Asset>[];

  List<String> imageUrlsTrip = <String>[];
  List<String> imageUrlsTripDetail = <String>[];
  List<String> nameIndex = <String>[];

  Future<void> loadTripPic() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imageTrip,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#2196F3",
          actionBarTitle: "Upload trip",
          allViewTitle: "All Photos", ////
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imageTrip = resultList;
      _error = error;
    });
  }

  Future<void> loadTripDetailPic() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: imagesTripDetail,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#2196F3",
          actionBarTitle: "Upload image trip",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesTripDetail = resultList;
      _error = error;
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

  uploadData() async {
    for (var imageFile in imageTrip) {
      await postImage(imageFile).then((downloadUrl) {
        imageUrlsTrip.add(downloadUrl.toString());
      }).catchError((err) {
        print(err);
      });
    }
    for (var imageFile in imagesTripDetail) {
      await postImage(imageFile).then((downloadUrl) {
        imageUrlsTripDetail.add(downloadUrl.toString());
      }).catchError((err) {
        print(err);
      });
    }

    await tripCollection.doc(tripNameControler.text.toLowerCase()).set({
      'name': tripNameControler.text,
      'detail': tripDetailControler.text,
      'price': double.parse(tripPriceControler.text),
      'search': nameIndex,
      'image trip': imageUrlsTrip[0].toString(),
      'image trip data': imageUrlsTripDetail,
      'id': adminId,
      'days': daysControler.text
    }).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snac('Uploded trip succefully'));
    });
    setState(() {
      tripNameControler.clear();
      tripDetailControler.clear();
      tripPriceControler.clear();
      daysControler.clear();
      imageTrip = [];
      imagesTripDetail = [];
      imageUrlsTrip = [];
      imageUrlsTripDetail = [];
      nameIndex = [];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tripNameControler.dispose();
    tripDetailControler.dispose();
    tripPriceControler.dispose();
    daysControler.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Custom_Appbar(
          color: Colors.lightBlue[900]
        ,
          textAppBar: 'Adding Trip',
          colorText: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Row(children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Trip Name :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ]),
              Center(
                  child: Card(
                elevation: 2,
                margin: EdgeInsets.all(10),
                child: Container(
                    height: 40,
                    width: double.infinity,
                    child: TextField(
                      keyboardType: TextInputType.name,

                      controller: tripNameControler,
                    )),
              )),
              Row(children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Trip Days :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ]),
              Center(
                  child: Card(
                elevation: 2,
                margin: EdgeInsets.all(10),
                child: Container(
                    height: 40,
                    width: double.infinity,
                    child: TextField(
                      keyboardType: TextInputType.number,

                      controller: daysControler,
                    )),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[900],
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: FlatButton(
                          child: Text(
                            "Add Trip Picture",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045,
                                color: Colors.white),
                          ),
                          onPressed: loadTripPic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[900],
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: FlatButton(
                          child: Text(
                            "Add Trip Picture Details",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045,
                                color: Colors.white),
                          ),
                          onPressed: loadTripDetailPic, // مطعم
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Row(children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Description :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                      child: Card(
                    elevation: 2,
                    margin: EdgeInsets.all(10),
                    child: Container(
                        height: 200,
                        width: double.infinity,
                        child: TextField(
                          controller: tripDetailControler,
                          decoration: InputDecoration(),
                          maxLines: 60,
                        )),
                  )),
                  Row(children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Price :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                  Center(
                      child: Card(
                    elevation: 2,
                    margin: EdgeInsets.all(10),
                    child: Container(
                        height: 40,
                        width: double.infinity,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: tripPriceControler,
                        )),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[900],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: FlatButton(
                              child: Text(
                                "Upload Trip ",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  String x = '';
                                  for (int i = 0;
                                      i < tripNameControler.text.length;
                                      i++) {
                                    for (int j = 0; j <= i; j++) {
                                      x += tripNameControler.text[j];
                                    }
                                    nameIndex.add(x.toLowerCase());
                                    x = '';
                                  }
                                });
                                if (imageTrip.length == 0 ||
                                    imagesTripDetail.length == 0) {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          backgroundColor:
                                              Theme.of(context).backgroundColor,
                                          content: Text("No image selected",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        );
                                      });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snac('Please wait, we are uploading'));
                                  uploadData();
                                }
                              }, // مطعم
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
