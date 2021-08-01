class MyReadingList {
  List<String> myReadingListTitles = [];
  List<String> myReadingListAuthors = [];

  MyReadingList({
    required this.myReadingListAuthors,
    required this.myReadingListTitles,
  });

  void addToReadingList(String title, String firstAuthor) {
    if (!myReadingListTitles.contains(title.toLowerCase()) &&
        !myReadingListAuthors.contains(firstAuthor.toLowerCase())) {
      myReadingListTitles.add(title.toLowerCase());
      myReadingListAuthors.add(firstAuthor.toLowerCase());
    }
  }

  void removeFromReadingList(String title, String firstAuthor) {
    if (myReadingListTitles.contains(title.toLowerCase()) &&
        myReadingListAuthors.contains(firstAuthor.toLowerCase())) {
      myReadingListTitles.remove(title.toLowerCase());
      myReadingListAuthors.remove(firstAuthor.toLowerCase());
    }
  }

  bool isInReadingList(String title, String firstAuthor) {
    if (myReadingListTitles.contains(title.toLowerCase()) &&
        myReadingListAuthors.contains(firstAuthor.toLowerCase())) {
      return true;
    } else {
      return false;
    }
  }
}
