import 'dart:convert';

import 'package:books_log/components/add_book_details.dart';
import 'package:books_log/models/openlibrary_book.dart';
import 'package:books_log/models/openlibrary_search.dart';
import 'package:books_log/models/openlibrary_works.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailsPage extends StatefulWidget {
  final Docs openLibrarySearchDoc;
  const DetailsPage({Key? key, required this.openLibrarySearchDoc})
      : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
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
      return AddBookDetails(
          openLibrarySearchDoc: widget.openLibrarySearchDoc,
          bookResult: bookResult,
          worksResult: worksResult);
    } else if (fetchOngoing == false && error) {
      return AddBookDetails(
        openLibrarySearchDoc: widget.openLibrarySearchDoc,
        bookResult: OpenLibraryBook.noValues(),
        worksResult: OpenLibraryWorks.noValues(),
      );
    } else {
      return Container();
    }
  }
}
