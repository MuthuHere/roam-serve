import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roam_serve_user/main.dart';
import 'package:roam_serve_user/model/entity_model.dart';
import 'package:roam_serve_user/model/request_model.dart';
import 'package:roam_serve_user/screens/login_screen.dart';
import 'package:roam_serve_user/utils/app_message.dart';
import 'package:roam_serve_user/utils/app_pref.dart';
import 'package:roam_serve_user/utils/hint_text.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';

class AddScreen extends StatefulWidget {
  static const id = 'AddScreen';

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  AppPref pref = getIt<AppPref>();
  String imageUrl;
  File _file;
  bool _isLoading = false;
  TextEditingController _addressController;
  TextEditingController _additionalInfoController;
  CollectionReference requestDb = FirebaseFirestore.instance.collection('requests');


  final firestoreInstance = FirebaseFirestore.instance;

  List<EntityModel> listOfCategoryEntity = [
    new EntityModel('Pick Category', ''),
    new EntityModel('Pets ', ''),
    new EntityModel('Aged people', ''),
    new EntityModel('Mentally challenged people', ''),
    new EntityModel('Needy children', ''),
  ];
  int _indexForCategorySelection = 0;

  @override
  void initState() {
    _addressController = TextEditingController();
    _additionalInfoController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Roam Serve'),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.exit_to_app_outlined),
                onPressed: () {
                   pref.isLoggedIn = false;
                  Get.offAllNamed(LoginScreen.id);
                })
          ],
        ),
        body: Container(
          width: Get.size.width,
          height: Get.size.height,
          color: Colors.white,
          padding: const EdgeInsets.all(
            15,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(5),
                        child: (_file != null)
                            ? CircleAvatar(
                                backgroundImage: FileImage(_file),
                              )
                            : Image.asset(
                                'assets/image_upload.png',
                              ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 1,
                        child: CircleAvatar(
                          child: IconButton(
                            color: Colors.blue,
                            onPressed: () {
                              uploadImage();
                            },
                            icon: Icon(
                              Icons.photo_camera_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                HintText(
                  'Pick the Location',
                ),
                TextField(
                  controller: _addressController,
                  maxLines: 4,
                  minLines: 3,
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () async {
                        var status = await Permission.location.request();
                        print(status);

                        if (status.isGranted) {
                          final data = await Geolocator.getCurrentPosition();

                          final coordinates =
                              new Coordinates(data.latitude, data.longitude);
                          var addresses = await Geocoder.local
                              .findAddressesFromCoordinates(coordinates);

                          setState(() {
                            _addressController.text =
                                addresses.first.addressLine;
                          });
                        } else {
                          showErrorToast(
                              'Permission needed to load the location');
                        }
                      },
                      child: Icon(
                        Icons.gps_fixed_sharp,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                HintText(
                  'Pick the category',
                ),
                categoryDropdown(),
                SizedBox(
                  height: 10,
                ),
                HintText(
                  'Additional information',
                ),
                TextField(
                  controller: _additionalInfoController,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(hintText: 'eg., near public '),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      uploadData().then((value) {});
                    },
                    child: Text(
                      'Save Life',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future uploadData() async {
    DateTime now = DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy • hh:mm a');
    String formattedDate = formatter.format(now);


    RequestData requestModel = new RequestData(
      dateTime: formattedDate,
      imageUrl: imageUrl,
      location: _addressController.text.toString(),
      category: listOfCategoryEntity[_indexForCategorySelection].title,
      additionalInfo: _additionalInfoController.text.toString(),
    );

    CollectionReference category =
        FirebaseFirestore.instance.collection('requests');
    return category.add(requestModel.toJson()).then((value) {
      requestDb.doc(value.id).set(requestModel.toJson()).then((value) {
          setState(() {
            _isLoading = false;
          });
          Get.back();
        });
    }).catchError((error) => print("Failed to add products: $error"));
  }

  Future uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.gallery);

      setState(() {
        _file = File(image.path);
      });
      dynamic currentTime =
          DateFormat('dd_MM-yyyy_hh_mm_ss').format(DateTime.now());
      setState(() {
        _isLoading = true;
      });

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path + '/${pref.userMobile+'_'+currentTime}.jpg';
      print(tempPath);
      _file = await testCompressAndGetFile(_file, tempPath);

      if (image != null) {
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('images/$currentTime')
            .putFile(_file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
          print(imageUrl);
        });
      } else {
        showErrorToast('No Image Path Received');
      }
    } else {
      showErrorToast(
          'Permission not granted. Try Again with permission access');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 15,
      rotate: 0,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  categoryDropdown() {
    return DropdownButton(
      isExpanded: true,
      value: listOfCategoryEntity[_indexForCategorySelection],
      items: listOfCategoryEntity.map((EntityModel value) {
        return new DropdownMenuItem(
          value: value,
          child: new Row(
            children: <Widget>[
              Expanded(
                child: new Text(
                  value.title,
                  style: TextStyle(
                    color: value.title.toString().contains('Pick')
                        ? Colors.grey
                        : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (EntityModel value) {
        setState(() {
          FocusScope.of(context).requestFocus(new FocusNode());
          _indexForCategorySelection = listOfCategoryEntity.indexOf(value);
        });
      },
    );
  }
}
