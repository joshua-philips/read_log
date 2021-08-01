import 'package:books_log/components/book_details.dart';
import 'package:books_log/models/book.dart';
import 'package:books_log/models/my_books.dart';
import 'package:books_log/models/my_reading_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailsPage extends StatefulWidget {
  final Book book;
  final String documentId;
  const BookDetailsPage(
      {Key? key, required this.book, required this.documentId})
      : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        backgroundColor: Colors.transparent,
      ),
      body: BookDetails(
        book: widget.book,
        newBook: false,
        documentId: widget.documentId,
        alreadyLogged: context
            .read<MyBooks>()
            .isInMyBooks(widget.book.title, widget.book.author.first),
        isInReadingList: context
            .read<MyReadingList>()
            .isInReadingList(widget.book.title, widget.book.author.first),
      ),
    );
  }
}
