import 'dart:convert';

import 'package:books_log/models/openlibrary_search.dart';
import 'package:books_log/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  late OpenLibrarySearch results;
  bool searchOngoing = false;
  bool searchCompleted = false;

  String searchUrl = 'http://openlibrary.org/search.json?q=';

  Future openLibrarySearch(String title) async {
    setState(() {
      searchOngoing = true;
      searchCompleted = false;
    });
    try {
      http.Response response = await http.get(Uri.parse(searchUrl + title));
      OpenLibrarySearch searchResults =
          OpenLibrarySearch.fromJson(json.decode(response.body));
      setState(() {
        results = searchResults;
        searchOngoing = false;
        searchCompleted = true;
      });
    } catch (e) {
      print('Error: ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.2),
            ),
            child: TextField(
              controller: searchController,
              onSubmitted: (text) {
                if (searchController.text.isNotEmpty) {
                  openLibrarySearch(searchController.text);
                }
              },
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                hintText: 'Search title, author',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: Icon(Icons.close),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 15, top: 5, bottom: 5),
              child: ElevatedButton(
                onPressed: () {
                  if (searchController.text.isNotEmpty) {
                    openLibrarySearch(searchController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Search'),
              ),
            ),
          ]),
      body: buildSearchBody(),
    );
  }

  Widget buildSearchBody() {
    if (searchOngoing && searchCompleted == false) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (searchOngoing == false && searchCompleted) {
      return results.numFound <= 0
          ? Center(
              child: Text('No Results'),
            )
          : Scrollbar(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: results.docs.length,
                itemBuilder: (context, index) => GestureDetector(
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      title: Text(
                        results.docs[index].title,
                        style: TextStyle(fontSize: 25),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          results.docs[index].authorName.isNotEmpty
                              ? results.docs[index].authorName.first
                              : results.docs[index].authorAlternativeName
                                      .isNotEmpty
                                  ? results
                                      .docs[index].authorAlternativeName.first
                                  : 'Unknown',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                      builder: (_) => DetailsPage(
                        openLibrarySearchDoc: results.docs[index],
                      ),
                    );
                    Navigator.push(context, route);
                  },
                ),
              ),
            );
    } else {
      return Container();
    }
  }
}
