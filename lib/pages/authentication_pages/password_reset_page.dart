import 'package:books_log/components/auth_text_formfield.dart';
import 'package:books_log/components/dialogs_and_snackbar.dart';
import 'package:books_log/configuration/constants.dart';
import 'package:books_log/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
                        "Reset Password",
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
              margin: EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 70),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            TextButton(
              style: TextButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                backgroundColor: myBlue,
              ),
              child: Text(
                "Send reset email",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  String returnedString =
                      await sendResetEmail(emailController.text, context);
                  if (returnedString != done) {
                    showMessageDialog(context, 'Error', returnedString);
                  } else {
                    showMessageSnackBar(context,
                        'Password reset email sent. Check your inbox.');
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> sendResetEmail(String email, BuildContext context) async {
    try {
      await context.read<AuthService>().sendPasswordResetMail(email);
      return done;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message!;
    } on Exception catch (e) {
      print(e);
      return e.toString();
    }
  }
}
