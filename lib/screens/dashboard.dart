import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roam_serve_user/model/response_model.dart';
import 'package:roam_serve_user/screens/add_screen.dart';
import 'package:roam_serve_user/utils/app_pref.dart';

import '../main.dart';
import 'empty_message.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const id = '/DashboardScreen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  CollectionReference requestDb =
      FirebaseFirestore.instance.collection('requests');

  List<ResponseModel> arrayResponse = [];
  final firestoreInstance = FirebaseFirestore.instance;
  AppPref pref = getIt<AppPref>();

  @override
  void initState() {
    arrayResponse = [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
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
        child: StreamBuilder(
            stream: requestDb.snapshots(),
            builder: (context, stream) {
              if (stream.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (stream.hasError) {
                return Center(child: Text(stream.error.toString()));
              }

              //having data
              arrayResponse = [];
              QuerySnapshot querySnapshot = stream.data;
              querySnapshot.docs.forEach((element) {
                final responseModel = ResponseModel.fromJson(element.data());
                arrayResponse.add(responseModel);
              });


              return arrayResponse.isEmpty
                  ? Center(child: EmptyMessage('No request found.'))
                  : ListView.builder(
                      itemCount: arrayResponse.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: Get.size.height * .3,
                            width: Get.size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  arrayResponse[index].imageUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                      10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(
                                          15,
                                        ),
                                        bottomRight: Radius.circular(
                                          15,
                                        ),
                                      ),
                                    ),
                                    height: 85,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${arrayResponse[index].category}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${arrayResponse[index].location}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '${arrayResponse[index].additionalInfo}',
                                          maxLines: 2,
                                          softWrap: true,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AddScreen.id);
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
