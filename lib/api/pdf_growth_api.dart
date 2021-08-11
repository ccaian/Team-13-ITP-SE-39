import '../growthpage.dart';
import 'dart:io';
import 'pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

/// PdfGrowthApi builds the Growth file data and format
class PdfGrowthApi {
  /// Main function that builds the document
  /// Receives the data from the Growth page and passes on the data [growthFile] to other functions
  static Future<File> generate(Growth growthFile) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildTitle(growthFile),
        buildGrowth(growthFile),
      ],
    ));
    return PdfApi.saveDocument(name: 'growth.pdf', pdf: pdf);
  }
  /// Builds the header section of the document
  static Widget buildTitle(Growth growthFile) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Growth Measurements For ' + growthFile.name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
    ],
  );
  /// Builds the body section of the document with the retrieved data from [growthFile]
  static Widget buildGrowth(Growth growthFile) {
    final headers = [
      'Date',
      'Weight (g)',
      'Height/Length (cm)',
      'Head Circumference (cm)',
    ];
    /// Map the data from [growthFile] to loop through list into the Table format
    final data = growthFile.items.map((item) {
      return [
        item.date,
        item.weight + " g",
        item.height + " cm",
        item.head + " cm",
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