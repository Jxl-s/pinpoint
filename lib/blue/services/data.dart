import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  // kinda like singleton
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference collection(String path) {
    return _firestore.collection(path);
  }
}
