import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/milestoneguidance.dart';
import 'package:growth_app/register.dart';
import 'package:growth_app/route_generator.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:growth_app/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedInStatus = true;
  var admin = false;

  if(prefs.getString('email') == null) {
    isLoggedInStatus = false;
  } else {
    if(prefs.getBool('admin') == true){
      admin = true;
    } else {
      admin = false;
    }
  }

  if(isLoggedInStatus == false) {
    runApp(GrowthApp());
  } else {
    runApp(admin ? AdminLogin() : ParentLogin());
  }
}

class AdminLogin extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Growth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      initialRoute: '/selectFamily',
      onGenerateRoute: RouteGenerator.generateRoute,
      home: LandingPage()
    );
  }
}

class ParentLogin extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Growth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      initialRoute: '/selectChild',
      onGenerateRoute: RouteGenerator.generateRoute,
      home: LandingPage()
    );
  }
}

class GrowthApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Growth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      home: LandingPage()
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
    return new Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
          Widget>[
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          new Image.asset('assets/splashimage.png', width: 300.0),
        ]),
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
              child: new Text("Track Your Baby",
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ))),
        ]),
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                  "Share your babies growth journey with your \nhealthcare worker and keep each other in touch",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[700],
                  ))),
        ]),
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(80.0, 20.0, 80.0, 0.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: secondaryTheme,
                      minimumSize: Size(50, 50),
                      shape: shape,
                    ),
                    child: new Text(
                      "Log In",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      print('pressed log in');
                      Navigator.of(context).pushNamed('/login');
                    },
                  )))
        ]),
        new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(80.0, 0.0, 80.0, 0.0),
                  child: TextButton(
                    child: new Text(
                      "Register Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[700],
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register');
                    },
                  )))
        ]),
        new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              child: IconButton(
                icon: const Icon(Icons.announcement_rounded),
                color: mainTheme,
                tooltip: 'Increase volume by 10',
                onPressed: () {
                  Navigator.of(context).pushNamed('/milestoneGuideline');
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 15.0, 0.0),
                child: TextButton(
                  child: new Text(
                    "Milestone Guidance",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/milestoneGuideline');
                  },
                )),
          ],
        )
      ]),
    ));
  }
}
