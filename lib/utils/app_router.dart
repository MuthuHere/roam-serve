import 'package:flutter/material.dart';
import 'package:roam_serve_user/screens/dashboard.dart';
import 'package:roam_serve_user/screens/add_screen.dart';
import 'package:roam_serve_user/screens/login_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AddScreen.id:
        {
          return MaterialPageRoute(
            builder: (_) => AddScreen(),
            settings: settings,
          );
        }
        break;
      case DashboardScreen.id:
        {
          return MaterialPageRoute(
            builder: (_) => DashboardScreen(),
            settings: settings,
          );
        }
        break;
      case LoginScreen.id:
        {
          return MaterialPageRoute(
            builder: (_) => LoginScreen(),
            settings: settings,
          );
        }
        break;
      default:
        {
          return MaterialPageRoute(
            builder: (_) => LoginScreen(),
            settings: settings,
          );
        }
        break;
    }
  }
}
