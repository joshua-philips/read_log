import 'package:books_log/components/auth_text_formfield.dart';
import 'package:books_log/pages/my_books.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController cPasswordController = TextEditingController();
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
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 60,
                        child: Icon(
                          Icons.add_a_photo_rounded,
                          size: 40,
                        ),
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
            registerButton(formKey, context),
            SizedBox(height: 30),
            loginButton(context),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

Widget registerButton(GlobalKey<FormState> formKey, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      TextButton(
        style: TextButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
          backgroundColor: Color(0xff07446C),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            print('Register button');
            // TODO: Register
            Route route = MaterialPageRoute(builder: (context) => MyBooks());
            Navigator.popUntil(context, (route) => !Navigator.canPop(context));
            Navigator.of(context).pushReplacement(route);
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
    ],
  );
}

Widget loginButton(BuildContext context) {
  return Row(
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
  );
}
