import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:growth_app/nav.dart';
import 'package:growth_app/theme/colors.dart';


class MilestonePage extends StatelessWidget {
  const MilestonePage({
    Key? key,
    required this.pdfurl,
  }) : super(key: key);
  final String pdfurl;
  @override
  Widget build(BuildContext context) {


    double c_width = MediaQuery.of(context).size.width*0.9;
    final shape = RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(25)
    );
    return Material(
      child: Container(
        color: mainTheme,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 80,
                left: 30,
                child: Text(
                    "Welcome Address",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                )
            ),
            Positioned(
              top: 40,
              right: -10,
              child: new Image.asset('assets/healthcare.png', width: 140.0),
            ),
            Positioned(
              bottom: 0,
              child: Text("hi")
            )
          ],
        ),
      ),
    );
  }
}
