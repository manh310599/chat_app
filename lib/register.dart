import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_chat/account/account.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String avartar = 'assets/images/mess.png';
  String? _imagePath;
  final acc = Account();
  final _fireAuth = FirebaseAuth.instance;
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _repass = TextEditingController();
  final storage = FirebaseStorage.instance.ref();
  var downloadUrl;
  Future register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text, password: _pass.text);
      if(_imagePath == null)
        {
          final ByteData imageData = await rootBundle.load('assets/images/mess.png');
          final Uint8List imageBytes = imageData.buffer.asUint8List();

          // Tạo tên tệp hình ảnh trên Firestore (ví dụ: "images/image.png")
          final String fileName = 'images/'+_fireAuth.currentUser!.uid.toString()+'/Avartar${_fireAuth.currentUser!.uid.toString()}.png';

          // Tải lên hình ảnh lên Firestore
          final reference = FirebaseStorage.instance.ref().child(fileName);
          final uploadTask = reference.putData(imageBytes);
          await uploadTask;

           downloadUrl = await reference.getDownloadURL();

        }
      else{
        final file = File(_imagePath!);
        final storageRef = FirebaseStorage.instance.ref().child('images/'+_fireAuth.currentUser!.uid.toString()
        +"/Avartar${_fireAuth.currentUser!.uid.toString()}.png");
        final uploadTask = storageRef.putFile(file);
        await uploadTask.whenComplete(() => print('Upload complete'));

        downloadUrl = await storageRef.getDownloadURL();
      }

      Fluttertoast.showToast(msg: "Đăng ký thành công");
      Navigator.pop(context);

      _fireAuth.currentUser?.updateDisplayName(_repass.text);

      acc.registerInToFireStore(_fireAuth.currentUser!.uid.toString(),
          _repass.text, _fireAuth.currentUser!.email.toString(),downloadUrl);
    } catch (e) {
      Fluttertoast.showToast(msg: "Đăng ký không thành công" + e.toString());
      print(e.toString());

    }
  }

  @override
  Widget build(BuildContext context) {

    final widthScreen = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(


                  onTap: () async {

                    final image = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _imagePath = image.path;
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: widthScreen/4 ,
                    child: _imagePath == null
                        ? Image.asset(avartar,)
                        : ClipOval(child: Image.file(File(_imagePath!),width: widthScreen/2,height: widthScreen/2,fit: BoxFit.cover,)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                const Text(
                  'Đăng ký',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 5),
                          color: Colors.grey,
                          blurRadius: 9,
                        )
                      ],
                      letterSpacing: 8),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white)),
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
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white)),
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
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: _repass,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Nhập vào tên người dùng',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (_email.text.isEmpty ||
                        _pass.text.isEmpty ||
                        _repass.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Bạn không được để trống bất kì trường nào");
                    } else {
                      register();
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
                      child: Text(
                        'Đăng ký',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
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
