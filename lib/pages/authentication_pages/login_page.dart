import 'package:books_log/components/auth_text_formfield.dart';
import 'package:books_log/main.dart';
import 'package:books_log/pages/authentication_pages/password_reset_page.dart';
import 'package:books_log/pages/authentication_pages/register_page.dart';
import 'package:books_log/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
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
                        "Books Log",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Lorem ipsum dolor sit amet, consetetur",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "sadipscing elitr, sed diam nonumy eirmod",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "tempor invidunt ut labore et dolore",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(30),
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
                    SizedBox(height: 30),
                    AuthTextFormField(
                      controller: passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.password,
                      validator: (val) =>
                          val!.isEmpty ? 'Enter password' : null,
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (context) => PasswordResetPage());
                            Navigator.push(context, route);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            loginButton(formKey, emailController.text, passwordController.text,
                context),
            SizedBox(height: 50),
            register(context),
          ],
        ),
      ),
    );
  }
}

Widget loginButton(GlobalKey<FormState> formKey, String email, String password,
    BuildContext context) {
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
        child: Text(
          "Login",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            await login(email, password, context);
            // Route route = MaterialPageRoute(builder: (context) => MyBooks());
            Navigator.popUntil(context, (route) => !Navigator.canPop(context));
            // Navigator.of(context).pushReplacement(route);
          }
        },
      ),
    ],
  );
}

Future<void> login(String email, String password, BuildContext context) async {
  try {
    await context
        .read<AuthService>()
        .loginWithEmailAndPassword(email, password);
    initializeProfile(context);
  } catch (e) {
    print(e);
  }
}

Widget register(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Don\'t have an account? ",
        style: TextStyle(fontSize: 20, color: Color(0xff757575)),
      ),
      GestureDetector(
        child: Text(
          "Register",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        onTap: () {
          Route route = MaterialPageRoute(builder: (context) => RegisterPage());
          Navigator.push(context, route);
        },
      )
    ],
  );
}
