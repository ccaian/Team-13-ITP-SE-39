import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MilestonePDF extends StatefulWidget {

  const MilestonePDF({
    Key? key,
    required this.pdfurl,
  }) : super(key: key);
  final String pdfurl;

  @override
  _MilestonePDFState createState() => _MilestonePDFState();
}

class _MilestonePDFState extends State<MilestonePDF> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  String remotePDFpath = "";
  @override
  Widget build(BuildContext context) {

    bool _isLoading = true;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SfPdfViewer.network(
            widget.pdfurl,
            key: _pdfViewerKey,
          ),

        )
      ),
    );
  }

  @override
  void initState() {

  }

}
