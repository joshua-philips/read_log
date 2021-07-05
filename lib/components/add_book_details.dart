import 'package:books_log/components/horizontal_list.dart';
import 'package:books_log/components/image_dialog.dart';
import 'package:books_log/components/list_section.dart';
import 'package:books_log/models/book.dart';
import 'package:books_log/models/openlibrary_book.dart';
import 'package:books_log/models/openlibrary_search.dart';
import 'package:books_log/models/openlibrary_works.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class AddBookDetails extends StatelessWidget {
  final Docs openLibrarySearchDoc;
  final OpenLibraryBook bookResult;
  final OpenLibraryWorks worksResult;
  AddBookDetails({
    Key? key,
    required this.openLibrarySearchDoc,
    required this.bookResult,
    required this.worksResult,
  }) : super(key: key);

  final TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 2,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        openLibrarySearchDoc.title,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'WRITTEN BY',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      writersColumn(),
                      SizedBox(height: 10),
                      Text(
                        openLibrarySearchDoc.firstPublishYear.toString(),
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      Text(
                        openLibrarySearchDoc.publisher.isNotEmpty
                            ? openLibrarySearchDoc.publisher.first.toUpperCase()
                            : '',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => buildImageDialog(
                        context,
                        bookResult.cover.large,
                        openLibrarySearchDoc.title,
                      ),
                    );
                  },
                  child: Container(
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
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            openLibrarySearchDoc.title,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      openLibrarySearchDoc.title,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          worksResult.description.toString().isNotEmpty
              ? Divider()
              : Container(),
          worksResult.description.toString().isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SUMMARY',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      SizedBox(height: 10),
                      ExpandableText(
                        worksResult.description.toString(),
                        expandText: 'Read more',
                        collapseText: 'Show less',
                        maxLines: 5,
                        linkColor: Colors.white.withOpacity(0.7),
                      )
                    ],
                  ),
                )
              : Container(),
          openLibrarySearchDoc.subject.isNotEmpty ? Divider() : Container(),
          openLibrarySearchDoc.subject.isNotEmpty
              ? ListSection(
                  sectionTitle: 'SUBJECTS',
                  children: horizontalDetailList(openLibrarySearchDoc.subject),
                )
              : Container(),
          openLibrarySearchDoc.place.isNotEmpty ? Divider() : Container(),
          openLibrarySearchDoc.place.isNotEmpty
              ? ListSection(
                  sectionTitle: 'PLACES',
                  children: horizontalDetailList(openLibrarySearchDoc.place),
                )
              : Container(),
          openLibrarySearchDoc.time.isNotEmpty ? Divider() : Container(),
          openLibrarySearchDoc.time.isNotEmpty
              ? ListSection(
                  sectionTitle: 'TIME',
                  children: horizontalDetailList(openLibrarySearchDoc.time),
                )
              : Container(),
          openLibrarySearchDoc.person.isNotEmpty ? Divider() : Container(),
          openLibrarySearchDoc.person.isNotEmpty
              ? ListSection(
                  sectionTitle: 'CHARACTERS',
                  children: horizontalDetailList(openLibrarySearchDoc.person),
                )
              : Container(),
          openLibrarySearchDoc.publisher.isNotEmpty ? Divider() : Container(),
          openLibrarySearchDoc.publisher.isNotEmpty
              ? ListSection(
                  sectionTitle: 'PUBLISHERS',
                  children:
                      horizontalDetailList(openLibrarySearchDoc.publisher),
                )
              : Container(),
          openLibrarySearchDoc.publishYear.isNotEmpty ? Divider() : Container(),
          openLibrarySearchDoc.publishYear.isNotEmpty
              ? ListSection(
                  sectionTitle: 'YEARS PUBLISHED',
                  children: horizontalDetailListSorted(
                      openLibrarySearchDoc.publishYear),
                )
              : Container(),
          bookResult.links.isNotEmpty ? Divider() : Container(),
          bookResult.links.isNotEmpty
              ? ListSection(
                  sectionTitle: 'EXTERNAL LINKS',
                  children: listOfLinks(bookResult.links, context),
                )
              : Container(),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REVIEW',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                SizedBox(height: 10),
                TextFormField(
                  maxLines: 4,
                  controller: reviewController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Book data provided by Open Library',
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: MaterialButton(
              color: Colors.green,
              child: Text('Add to your books'),
              onPressed: () {
                // TODO: Upload to firebase
                try {
                  addToBooks();
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Column writersColumn() {
    List<Widget> writers = [];

    if (openLibrarySearchDoc.authorName.isNotEmpty) {
      for (int count = 0;
          count < openLibrarySearchDoc.authorName.length;
          count++) {
        writers.add(
          Text(
            openLibrarySearchDoc.authorName[count],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        );
      }
    } else {
      writers.add(Text(
        'Unknown',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.7),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: writers,
    );
  }

  void addToBooks() {
    Book newBook = Book(
      title: openLibrarySearchDoc.title,
      author: openLibrarySearchDoc.authorName.first.toString(),
      summary: worksResult.description.toString(),
      coverImage: bookResult.cover.large,
      firstPublishYear: openLibrarySearchDoc.firstPublishYear,
      person: List<String>.from(openLibrarySearchDoc.person),
      publishYear: List<int>.from(openLibrarySearchDoc.publishYear),
      subject: List<String>.from(openLibrarySearchDoc.subject),
      place: List<String>.from(openLibrarySearchDoc.place),
      time: List<String>.from(openLibrarySearchDoc.time),
      publisher: List<String>.from(openLibrarySearchDoc.publisher),
      links: bookResult.links,
      review: reviewController.text,
      dateAdded: DateTime.now(),
    );
  }
}
