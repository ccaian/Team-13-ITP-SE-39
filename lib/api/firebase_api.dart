
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:growth_app/model/firebase_file.dart';
import 'package:growth_app/model/week_file.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseApi {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());




  //get a list of the FIRST images in each week
  static Future<List<FirebaseFile>> listWeek(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();
    late Future<List<FirebaseFile>> futureList;
    final list = await result.prefixes[0].listAll();

    final refItem = list.items[0];
    final tempurl = (await refItem.getDownloadURL()).toString();
    result.prefixes.forEach((Reference ref) {
    });
    return result.prefixes.asMap()
        .map((index, prefix) {
      final ref = result.prefixes[index];
      final name = ref.name;
      final file = FirebaseFile(ref: ref, name: name, url: tempurl);

      return MapEntry(index, file);
    })
        .values
        .toList();
  }

  //get the first image in a week
  static Future<FirebaseFile> listFirst(String path) async{
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();
    final refItem = result.items[0];
    final name = refItem.name;
    final url = (await refItem.getDownloadURL()).toString();
    return FirebaseFile(ref: refItem, name: name, url: url);

  }


  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();
    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);
  }
}