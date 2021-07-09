import 'dart:convert';

import 'package:books_log/components/book_details.dart';
import 'package:books_log/models/book.dart';
import 'package:books_log/models/openlibrary_book.dart';
import 'package:books_log/models/openlibrary_search.dart';
import 'package:books_log/models/openlibrary_works.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchDetailsPage extends StatefulWidget {
  final Docs openLibrarySearchDoc;
  const FetchDetailsPage({Key? key, required this.openLibrarySearchDoc})
      : super(key: key);

  @override
  _FetchDetailsPageState createState() => _FetchDetailsPageState();
}

class _FetchDetailsPageState extends State<FetchDetailsPage> {
  bool fetchOngoing = false;
  bool fetchCompleted = false;
  bool error = false;
  late OpenLibraryWorks worksResult;
  late OpenLibraryBook bookResult;

  void initState() {
    super.initState();
    fullFetch();
  }

  Future fullFetch() async {
    setState(() {
      fetchOngoing = true;
      fetchCompleted = false;
      error = false;
    });
    try {
      await fetchLibraryWork(widget.openLibrarySearchDoc.key);
      await fetchLibraryBook(widget.openLibrarySearchDoc.lccn
          .lastWhere((element) => element.length > 4));
      setState(() {
        fetchOngoing = false;
        fetchCompleted = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        fetchOngoing = false;
        error = true;
      });
    }
  }

  Future fetchLibraryWork(String key) async {
    String workUrl = 'https://openlibrary.org$key.json';
    try {
      http.Response response = await http.get(Uri.parse(workUrl));
      OpenLibraryWorks newWorks =
          OpenLibraryWorks.fromJson(json.decode(response.body));
      setState(() {
        worksResult = newWorks;
      });
    } catch (e) {
      throw e;
    }
  }

  Future fetchLibraryBook(String lccn) async {
    String bookUrl =
        'https://openlibrary.org/api/books?bibkeys=LCCN:$lccn&jscmd=data&format=json';
    try {
      http.Response response = await http.get(Uri.parse(bookUrl));
      OpenLibraryBook newBook =
          OpenLibraryBook.fromJson(json.decode(response.body)['LCCN:$lccn']);
      setState(() {
        bookResult = newBook;
      });
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.openLibrarySearchDoc.title),
        backgroundColor: Colors.transparent,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (fetchOngoing && fetchCompleted == false) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      );
    } else if (fetchOngoing == false && fetchCompleted) {
      Book newBook = Book(
        title: widget.openLibrarySearchDoc.title,
        author: List<String>.from(widget.openLibrarySearchDoc.authorName),
        summary: worksResult.description.toString(),
        coverImage: bookResult.cover.large,
        firstPublishYear: widget.openLibrarySearchDoc.firstPublishYear,
        person: List<String>.from(widget.openLibrarySearchDoc.person),
        publishYear: List<int>.from(widget.openLibrarySearchDoc.publishYear),
        subject: List<String>.from(widget.openLibrarySearchDoc.subject),
        place: List<String>.from(widget.openLibrarySearchDoc.place),
        time: List<String>.from(widget.openLibrarySearchDoc.time),
        publisher: List<String>.from(widget.openLibrarySearchDoc.publisher),
        links: bookResult.links,
        review: '',
        dateAdded: DateTime.now(),
      );
      return BookDetails(
        book: newBook,
        newBook: true,
      );
    } else if (fetchOngoing == false && error) {
      worksResult = OpenLibraryWorks.noValues();
      bookResult = OpenLibraryBook.noValues();
      Book newBook = Book(
        title: widget.openLibrarySearchDoc.title,
        author: List<String>.from(widget.openLibrarySearchDoc.authorName),
        summary: worksResult.description.toString(),
        coverImage: bookResult.cover.large,
        firstPublishYear: widget.openLibrarySearchDoc.firstPublishYear,
        person: List<String>.from(widget.openLibrarySearchDoc.person),
        publishYear: List<int>.from(widget.openLibrarySearchDoc.publishYear),
        subject: List<String>.from(widget.openLibrarySearchDoc.subject),
        place: List<String>.from(widget.openLibrarySearchDoc.place),
        time: List<String>.from(widget.openLibrarySearchDoc.time),
        publisher: List<String>.from(widget.openLibrarySearchDoc.publisher),
        links: bookResult.links,
        review: '',
        dateAdded: DateTime.now(),
      );
      return BookDetails(
        book: newBook,
        newBook: true,
      );
    } else {
      return Container();
    }
  }
}