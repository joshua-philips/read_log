import 'package:books_log/components/dialogs_and_snackbar.dart';
import 'package:books_log/components/horizontal_list.dart';
import 'package:books_log/components/image_dialog.dart';
import 'package:books_log/components/list_section.dart';
import 'package:books_log/models/book.dart';
import 'package:books_log/services/auth_service.dart';
import 'package:books_log/services/firestore_service.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetails extends StatelessWidget {
  final Book book;
  final bool newBook;
  BookDetails({Key? key, required this.book, required this.newBook})
      : super(key: key);

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
                        book.title,
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
                        book.firstPublishYear.toString(),
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      Text(
                        book.publisher.isNotEmpty
                            ? book.publisher.first.toUpperCase()
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
                        book.coverImage,
                        book.title,
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
                      book.coverImage,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            book.title,
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
                                      book.title,
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
          book.summary.isNotEmpty ? Divider() : Container(),
          book.summary.isNotEmpty
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
                        book.summary,
                        expandText: 'Read more',
                        collapseText: 'Show less',
                        maxLines: 5,
                        linkColor: Colors.white.withOpacity(0.7),
                      )
                    ],
                  ),
                )
              : Container(),
          book.subject.isNotEmpty ? Divider() : Container(),
          book.subject.isNotEmpty
              ? ListSection(
                  sectionTitle: 'SUBJECTS',
                  children: horizontalDetailList(book.subject),
                )
              : Container(),
          book.place.isNotEmpty ? Divider() : Container(),
          book.place.isNotEmpty
              ? ListSection(
                  sectionTitle: 'PLACES',
                  children: horizontalDetailList(book.place),
                )
              : Container(),
          book.time.isNotEmpty ? Divider() : Container(),
          book.time.isNotEmpty
              ? ListSection(
                  sectionTitle: 'TIME',
                  children: horizontalDetailList(book.time),
                )
              : Container(),
          book.person.isNotEmpty ? Divider() : Container(),
          book.person.isNotEmpty
              ? ListSection(
                  sectionTitle: 'CHARACTERS',
                  children: horizontalDetailList(book.person),
                )
              : Container(),
          book.publisher.isNotEmpty ? Divider() : Container(),
          book.publisher.isNotEmpty
              ? ListSection(
                  sectionTitle: 'PUBLISHERS',
                  children: horizontalDetailList(book.publisher),
                )
              : Container(),
          book.publishYear.isNotEmpty ? Divider() : Container(),
          book.publishYear.isNotEmpty
              ? ListSection(
                  sectionTitle: 'YEARS PUBLISHED',
                  children: horizontalDetailListSorted(book.publishYear),
                )
              : Container(),
          book.links.isNotEmpty ? Divider() : Container(),
          book.links.isNotEmpty
              ? ListSection(
                  sectionTitle: 'EXTERNAL LINKS',
                  children: listOfLinks(book.links, context),
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
              child: Text(newBook ? 'Add to your books' : 'Update'),
              onPressed: () async {
                showLoadingDialog(context);
                String returnedString = await addToBooks(context);
                if (returnedString != 'done') {
                  Navigator.pop(context);
                  showMessageDialog(context, 'Error adding book',
                      'Could not add to my books. Please try again');
                } else {
                  showMessageSnackBar(context, 'Added to your books');
                  Navigator.pop(context);
                  Navigator.pop(context);
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

    if (book.author.isNotEmpty) {
      for (int count = 0; count < book.author.length; count++) {
        writers.add(
          Text(
            book.author[count],
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

  Future<String> addToBooks(BuildContext context) async {
    AuthService authService = context.read<AuthService>();
    FirestoreService firestoreService = context.read<FirestoreService>();
    if (reviewController.text.isNotEmpty) {
      book.updateReview(reviewController.text);
    }
    book.setDateAdded(DateTime.now());

    try {
      firestoreService.uploadBook(book, authService.getCurrentUser().uid);
      return 'done';
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> updateBook() async {
    // TODO: Update book
    return 'done';
  }
}
