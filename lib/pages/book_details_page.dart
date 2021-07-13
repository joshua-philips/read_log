import 'package:books_log/components/book_details.dart';
import 'package:books_log/models/book.dart';
import 'package:flutter/material.dart';

class BookDetailsPage extends StatefulWidget {
  final Book book;
  const BookDetailsPage({Key? key, required this.book}) : super(key: key);

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
      body: BookDetails(book: widget.book, newBook: false),
    );
  }
}
