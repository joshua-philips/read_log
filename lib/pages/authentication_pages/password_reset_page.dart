import 'package:books_log/components/auth_text_formfield.dart';
import 'package:flutter/material.dart';

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
                backgroundColor: Color(0xff07446C),
              ),
              child: Text(
                "Send reset email",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  print('Reset button');
                  // TODO: Password Reset
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
