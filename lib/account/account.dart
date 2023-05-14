import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';

class Account {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  registerInToFireStore(String UidUser,String Name,String Email,String LinkAvartar) {
    final account = <String, String>{
      "name": Name,
      "email": Email,
      "avartar": LinkAvartar
    };

    db
        .collection("account")
        .doc(UidUser)
        .set(account)
        .onError((e, _) => print("Lỗi phát sinh: $e"));
  }

  Stream<List<String>> getListAccount(String uid) async* {
    final collectionRef = FirebaseFirestore.instance.collection('account');
    yield* collectionRef.snapshots().map((querySnapshot) {
      try {
        return querySnapshot.docs
            .where((doc) =>
        doc.id != uid) // Chỉ lấy những tài khoản khác với uid
            .map((doc) => doc.data().toString())

            .toList();
      }
      catch(e){
        return ['null'];
      }
    });
  }



}
