import 'dart:convert';

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
      print(response.body);
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

      print(response.body);
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
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (fetchOngoing && fetchCompleted == false) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (fetchOngoing == false && fetchCompleted) {
      return Scrollbar(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 12),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 12),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.openLibrarySearchDoc.title,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'WRITTEN BY',
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                          Text(
                            widget.openLibrarySearchDoc.authorName.isNotEmpty
                                ? widget.openLibrarySearchDoc.authorName.first
                                : 'Unknown',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.openLibrarySearchDoc.firstPublishYear
                                .toString(),
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                          Text(
                            bookResult.publishers.first.name.toUpperCase(),
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 150,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                          color: Colors.white70,
                        ),
                        color: Colors.black54,
                      ),
                      child: Image.network(
                        bookResult.cover.large,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    worksResult.description.toString(),
                  ),
                ],
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GENRE',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CHARACTERS',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PUBLISHERS',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              MaterialButton(
                color: Colors.green,
                child: Text('Add to your books'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
    } else if (fetchOngoing == false && error) {
      return Center(
        child: Text('Cannot get complete data \n Add anyway?'),
      );
    } else {
      return Container();
    }
  }
}
