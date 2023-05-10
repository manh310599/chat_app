import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _repass = TextEditingController();

  Future register() async {
    try {
     await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text, password: _pass.text);
      Fluttertoast.showToast(msg: "Đăng ký thành công");
    }
    catch(e){
        Fluttertoast.showToast(msg: "Đăng ký không thành công");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Center(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/mess.png'),
                SizedBox(height: 10,),
                const Text('Đăng ký', style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 26, shadows: [
                  Shadow(
                    offset: Offset(0, 5),
                    color: Colors.grey,
                    blurRadius: 9,

                  )
                ], letterSpacing: 8),),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(

                        controller: _email,

                        decoration: InputDecoration(
                          hintText: 'Nhập vào gmail',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: _pass,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Nhập vào mật khẩu',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: _repass,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Nhập lại mật khẩu',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {
                    if (_email.text.isEmpty || _pass.text.isEmpty ||
                        _repass.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Bạn không được để trống bất kì trường nào");
                    }
                    else if (_pass.text != _repass.text) {
                      Fluttertoast.showToast(
                          msg: "Nhập lại mật khẩu không khớp");
                    }
                    else {
                      register();
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.pink, width: 2),

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Đăng ký', style: TextStyle(color: Colors
                          .white, fontWeight: FontWeight.bold, fontSize: 18),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
