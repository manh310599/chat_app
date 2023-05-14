import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/account/account.dart';
import 'dart:convert';
class ChatScreen extends StatelessWidget {

  final acc = Account();
  final _auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
              child: Icon(
            Icons.logout,
          ))
        ],
      ),
      body:StreamBuilder<List<String>>(
        stream: acc.getListAccount(_auth!.uid.toString()),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final List<String> names = snapshot.data!.map((e) => e as String).toList();
          names.runtimeType;
          print(names.runtimeType);





          return ListView.builder(
            itemCount: names.length,
            itemBuilder: (BuildContext context, int index) {
              List<String> name = [];



              print(names);

              return ListTile(title: Text(names[index]));
            },
          );
        },
      ));


  }
}
