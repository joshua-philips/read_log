import 'package:books_log/pages/my_books.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Log',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey[900],
        accentColor: Colors.green,
        scaffoldBackgroundColor: Colors.grey[900],
        indicatorColor: Colors.green,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.green,
        ),
      ),
      home: MyBooks(),
    );
  }
}
