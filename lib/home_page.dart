import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user!.email.toString()),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                  borderRadius:BorderRadius.circular(12)
                ),
                  padding: EdgeInsets.all(20),

                  child: Text('Sign Out')),
            )
          ],
        ),
      ),
    );
  }
}
