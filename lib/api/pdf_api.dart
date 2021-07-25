import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

/// PdfApi generates a PDF file with the given data
/// [name] is the generated file name chosen (e.g. growth.pdf, milk.pdf)
/// [pdf] is the type of file to generate (e.g. Document)

class PdfApi {
  /// Saves the data into a PDF file
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }
  /// Opens the saved PDF file
  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}