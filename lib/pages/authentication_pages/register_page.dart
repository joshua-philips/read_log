import 'dart:io';

import 'package:books_log/components/auth_text_formfield.dart';
import 'package:books_log/services/auth_service.dart';
import 'package:books_log/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();
  final _picker = ImagePicker();
  late File imageFile;
  bool photoSet = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only()),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectImage();
                      },
                      child: CircleAvatar(
                        radius: 60,
                        child: photoSet
                            ? Container()
                            : Icon(
                                Icons.add_a_photo_rounded,
                                size: 40,
                              ),
                        backgroundImage: photoSet ? FileImage(imageFile) : null,
                      ),
                    ),
                    AuthTextFormField(
                      controller: nameController,
                      hintText: 'Name',
                      prefixIcon: Icons.person,
                      validator: (val) => val!.length < 3
                          ? 'Name must contain at least 3 characters'
                          : null,
                      obscureText: false,
                    ),
                    SizedBox(height: 30),
                    AuthTextFormField(
                      controller: emailController,
                      hintText: 'Email Address',
                      prefixIcon: Icons.email,
                      validator: (val) =>
                          !val!.contains('@') && !val.contains('.')
                              ? 'Invalid Email'
                              : null,
                      obscureText: false,
                    ),
                    SizedBox(height: 30),
                    AuthTextFormField(
                      controller: passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.password,
                      validator: (val) =>
                          val!.length < 6 ? 'Invalid Password' : null,
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    AuthTextFormField(
                      controller: cPasswordController,
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.password,
                      validator: (val) => val != passwordController.text
                          ? 'Password does not match'
                          : null,
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                backgroundColor: Color(0xff07446C),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await register(context);
                  Navigator.popUntil(
                      context, (route) => !Navigator.canPop(context));
                }
              },
              child: Text(
                "Register",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(fontSize: 20, color: Color(0xff757575)),
                ),
                GestureDetector(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> register(BuildContext context) async {
    try {
      await context.read<AuthService>().createUserWithEmailAndPassword(
            emailController.text,
            passwordController.text,
            nameController.text,
          );
      String photoUrl = await context
          .read<StorageService>()
          .uploadProfilePhoto(imageFile, emailController.text)
          .whenComplete(() => print('upload complete'));
      await context.read<AuthService>().setProfilePhoto(photoUrl);
    } catch (e) {
      print(e);
    }
  }

  Future<void> selectImage() async {
    final PickedFile? pickedFile =
        await _picker.getImage(source: ImageSource.gallery);
    final File file = File(pickedFile!.path);
    setState(() {
      imageFile = file;
      photoSet = true;
    });
  }
}
