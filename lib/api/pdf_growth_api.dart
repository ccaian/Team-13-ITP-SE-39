import '../growthpage.dart';
import 'dart:io';
import 'pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfGrowthApi {

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

  static Widget buildTitle(Growth growthFile) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Growth Measurements',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
    ],
  );

  static Widget buildGrowth(Growth growthFile) {
    final headers = [
      'Week No',
      'Weight (kg)',
      'Height (cm)',
      'Head (cm)',
    ];
    final data = growthFile.items.map((item) {
      return [
        //item.date,
        "Week " + item.week,
        item.weight + " kg",
        item.height + " cm",
        item.head + " cm",
      ];
    }).toList();

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

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}