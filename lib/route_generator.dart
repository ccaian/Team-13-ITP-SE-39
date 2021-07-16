import 'package:flutter/material.dart';
import 'package:growth_app/changepassword.dart';
import 'package:growth_app/login.dart';
import 'package:growth_app/main.dart';
import 'package:growth_app/parentselchild.dart';
import 'package:growth_app/profilesetup.dart';
import 'package:growth_app/register.dart';
import 'package:growth_app/resetpassword.dart';
import 'package:growth_app/setting.dart';
import 'package:growth_app/userprofile.dart';
import 'package:growth_app/workerselfamily.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => GrowthApp());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/profileSetup':
        return MaterialPageRoute(builder: (_) => ProfileSetUpPage());
      case '/resetPassword':
        return MaterialPageRoute(builder: (_) => ResetPasswordPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case '/userProfile':
        return MaterialPageRoute(builder: (_) => UserProfilePage());
      case '/changePassword':
        return MaterialPageRoute(builder: (_) => ChangePasswordPage());
      case '/adminHome':
        return MaterialPageRoute(builder: (_) => WorkerSelFamily());
      case '/parentHome':
        return MaterialPageRoute(builder: (_) => ParentSelChild());
      case '/setting':
        return MaterialPageRoute(builder: (_) => SettingPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
