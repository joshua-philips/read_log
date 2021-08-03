import 'package:flutter/material.dart';

class MyBooks extends ChangeNotifier {
  List<String> myBooksTitles = [];
  List<String> myBooksAuthors = [];

  MyBooks({
    required this.myBooksTitles,
    required this.myBooksAuthors,
  });

  void addToMyBooks(String title, String firstAuthor) {
    myBooksTitles.add(title.toLowerCase());
    myBooksAuthors.add(firstAuthor.toLowerCase());
  }

  void addNewToMyBooks(String title, String firstAuthor) {
    myBooksTitles.add(title.toLowerCase());
    myBooksAuthors.add(firstAuthor.toLowerCase());

    notifyListeners();
  }

  void removeFromMyBooks(String title, String firstAuthor) {
    myBooksTitles.remove(title.toLowerCase());
    myBooksAuthors.remove(firstAuthor.toLowerCase());

    notifyListeners();
  }

  bool isInMyBooks(String title, String firstAuthor) {
    if (myBooksTitles.contains(title.toLowerCase()) &&
        myBooksAuthors.contains(firstAuthor.toLowerCase())) {
      return true;
    } else {
      return false;
    }
  }
}
