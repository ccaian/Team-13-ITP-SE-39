import 'dart:io';
import '../milkpage.dart';
import 'pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

/// PdfMilkApi builds the Milk file data and format
class PdfMilkApi {
  /// Main function that builds the document
  /// Receives the data from the Milk page and passes on the data [milkFile] to other functions
  static Future<File> generate(Milk milkFile) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildTitle(milkFile),
        buildMilk(milkFile),
      ],
    ));

    return PdfApi.saveDocument(name: 'milk.pdf', pdf: pdf);
  }
  /// Builds the header section of the document
  static Widget buildTitle(Milk milkFile) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Milk Volume Pumped',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
    ],
  );
  /// Builds the body section of the document with the retrieved data from [milkFile]
  static Widget buildMilk(Milk milkFile) {
    final headers = [
      'Title & Timestamp',
      'Left Volume',
      'Right Volume',
      'Total Volume',
    ];
    /// Map the data from [milkFile] to loop through list into the Table format
    final data = milkFile.items.map((item) {
      return [
        item.title + "\n" + item.timestamp.toString(),
        item.leftBreast + " ml",
        item.rightBreast + " ml",
        item.totalVolume + " ml",
      ];
    }).toList();
    /// Returns the table with the data mapped
    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
      },
    );
  }
}