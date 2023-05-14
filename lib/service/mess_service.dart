import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  static String _colection = 'message';
  static final _firestore = FirebaseFirestore.instance;

  static Future senMessage({required String message,required String senderId}) async {
    await _firestore.collection(_colection).add({
      'senderID': senderId,
      'message':message,
      'time': DateTime.now()
    });
  }

  static Stream<QuerySnapshot> messageStream() {
    return _firestore.collection(_colection).orderBy('time',descending: true).snapshots();
  }
}