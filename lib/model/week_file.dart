import 'package:firebase_storage/firebase_storage.dart';

class Week {
  final Reference ref;
  final String name;
  final String firstPicUrl;

  const Week({
    required this.ref,
    required this.name,
    required this.firstPicUrl,
  });
}