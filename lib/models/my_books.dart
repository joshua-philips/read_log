class MyBooks {
  List<String> myBooksTitles = [];
  List<String> myBooksAuthors = [];

  MyBooks({
    required this.myBooksTitles,
    required this.myBooksAuthors,
  });

  void addToMyBooks(String title, String firstAuthor) {
    if (!myBooksTitles.contains(title.toLowerCase()) &&
        !myBooksAuthors.contains(firstAuthor.toLowerCase())) {
      myBooksTitles.add(title.toLowerCase());
      myBooksAuthors.add(firstAuthor.toLowerCase());
    }
  }

  void removeFromMyBooks(String title, String firstAuthor) {
    if (myBooksTitles.contains(title.toLowerCase()) &&
        myBooksAuthors.contains(firstAuthor.toLowerCase())) {
      myBooksTitles.remove(title.toLowerCase());
      myBooksAuthors.remove(firstAuthor.toLowerCase());
    }
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
