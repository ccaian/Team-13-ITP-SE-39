import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/milkpage.dart';
import 'package:growth_app/photopage.dart';
import 'package:growth_app/setting.dart';
import 'package:growth_app/theme/colors.dart';
import 'package:growth_app/userprofile.dart';
import 'package:growth_app/workerhome.dart';

import 'growthpage.dart';


class Nav extends StatefulWidget {

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    WorkerHome(),
    PhotoPage(),
    GrowthPage(),
    MilkPage(),
    SettingPage(),
  ];

  void _onItemTap(int index){
    setState((){
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              title: Text('Photo'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              title: Text('Growth'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.airline_seat_flat),
              title: Text('Milk'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
          selectedItemColor: mainTheme,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
        ),
    );
  }
}
