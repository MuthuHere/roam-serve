import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:roam_serve_user/screens/dashboard.dart';
import 'screens/add_screen.dart';
import 'screens/login_screen.dart';
import 'utils/app_pref.dart';
import 'utils/app_router.dart';
import 'utils/push_notification_manager.dart';

final getIt = GetIt.I;

Future<void> setupDI() async {
  var instance = await AppPref.getInstance();

  getIt.registerSingleton<AppPref>(instance);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().whenComplete(() {
    setupDI().whenComplete(() {
      runApp(MyApp());
      FlutterImageCompress.showNativeLog = true;
    });
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppPref pref = getIt<AppPref>();
    // PushNotificationsManager manager = new PushNotificationsManager();
    //manager.init();

    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Mona'
      ),
      home: pref.isLoggedIn == null || !pref.isLoggedIn
          ? LoginScreen()
          : DashboardScreen(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
