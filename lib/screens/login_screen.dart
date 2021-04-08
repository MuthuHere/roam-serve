import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:roam_serve_user/screens/add_screen.dart';
import 'package:roam_serve_user/utils/app_button.dart';
import 'package:roam_serve_user/utils/app_utils.dart';
import 'package:roam_serve_user/utils/hint_text.dart';
import 'package:roam_serve_user/utils/app_pref.dart';

import '../main.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  bool _isLoading = false;
  TextEditingController _mobileController, _pwdController;
  bool isRegister = false;

  AppPref appPref = getIt<AppPref>();

  @override
  void initState() {
    _mobileController = TextEditingController();
    _pwdController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/ic_logo.jpg',
                        ),
                      ),
                    ),
                  ),
                  HintText(
                    'Mobile',
                  ),
                  TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration:
                        InputDecoration(prefixText: '+91  ', counterText: ''),
                    maxLength: 10,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  HintText(
                    'Password',
                  ),
                  TextField(
                    controller: _pwdController,
                    obscureText: true,
                    autocorrect: false,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RaisedGradientButton(
                    child: Text(
                      isRegister ? 'Register' : 'Login',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      final mobile = _mobileController.text.trim();
                      final pwd = _pwdController.text.trim();
                      if (mobile.length < 10) {
                        showFailureToast('Enter a valid Mobile number');
                        return;
                      }
                      if (pwd.length == 0) {
                        showFailureToast('Enter your desire password');
                        return;
                      }
                      if (isRegister) {
                        firestoreInstance.collection("users").add({
                          'phone': _mobileController.text.trim(),
                          'password': _pwdController.text.trim()
                        }).then((value) {
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      } else {
                        setState(() {
                          _isLoading = true;
                        });
                        firestoreInstance
                            .collection("users")
                            .get()
                            .then((querySnapshot) {
                          setState(() {
                            _isLoading = false;
                          });
                          int length = querySnapshot.docs.length;
                          int count = 0;
                          querySnapshot.docs.forEach((result) {
                            print('RESULT --> '+result.data()['phone']);
                            print('RESULT --> '+result.data()['password']);
                            count = count+1;
                            if (result.data()['phone'] == mobile) {
                              if (result.data()['password'] == pwd) {
                                try {
                                  appPref.isLoggedIn = true;
                                  appPref.userMobile = result.data()['phone'];
                                  print('User mobile ==> ${appPref.userMobile}');
                                } catch (e) {
                                  print('-----> '+e);
                                }
                                Get.offAllNamed(DashboardScreen.id);
                                //return;
                              } else {
                                showFailureToast(isRegister
                                    ? 'Mobile number is already exist'
                                    : 'Invalid credentials');
                              }
                            }else{

                              if(length == count) {
                                showFailureToast('password or mobile invalid');
                              }else if (length == 0 ){
                                showFailureToast('password or mobile not register with us');
                              }
                            }
                          });
                        });
                      }
                    },
                  ),
                  Center(
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          isRegister = !isRegister;
                        });
                      },
                      child: Text(isRegister
                          ? 'Existing user? Login now.'
                          : 'New User? Register now.'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*                          Get.defaultDialog(
                              title: 'New User?',
                              content: Text(
                                  'Are you interested to register with us?'),
                              confirm: FlatButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  Navigator.pop(context);
                                  firestoreInstance.collection("users").add({
                                    'phone': _mobileController.text.trim(),
                                    'password': _pwdController.text.trim()
                                  }).then((value) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  });
                                },
                              ),
                              cancel: FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Not Now')));
*/
