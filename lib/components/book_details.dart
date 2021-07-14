import 'package:books_log/components/book_image.dart';
import 'package:books_log/components/dialogs_and_snackbar.dart';
import 'package:books_log/components/horizontal_list.dart';
import 'package:books_log/components/list_section.dart';
import 'package:books_log/models/book.dart';
import 'package:books_log/pages/my_books.dart';
import 'package:books_log/services/auth_service.dart';
import 'package:books_log/services/firestore_service.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetails extends StatefulWidget {
  final Book book;
  final bool newBook;
  final String documentId;
  final bool alreadyLogged;
  BookDetails(
      {Key? key,
      required this.book,
      required this.newBook,
      required this.documentId,
      required this.alreadyLogged})
      : super(key: key);

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  late TextEditingController reviewController;

  @override
  void initState() {
    super.initState();
    reviewController = TextEditingController(text: widget.book.review);
  }

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
                        widget.book.title,
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
                        widget.book.firstPublishYear.toString(),
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      Text(
                        widget.book.publisher.isNotEmpty
                            ? widget.book.publisher.first.toUpperCase()
                            : '',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                BookImageToDialog(book: widget.book),
              ],
            ),
          ),
          SizedBox(height: 20),
          widget.book.summary.isNotEmpty ? Divider() : Container(),
          widget.book.summary.isNotEmpty
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
                        widget.book.summary,
                        expandText: 'Read more',
                        collapseText: 'Show less',
                        maxLines: 5,
                        linkColor: Colors.white.withOpacity(0.7),
                      )
                    ],
                  ),
                )
              : Container(),
          widget.book.subject.isNotEmpty ? Divider() : Container(),
          widget.book.subject.isNotEmpty
              ? ListSection(
                  sectionTitle: 'SUBJECTS',
                  children: horizontalDetailList(widget.book.subject),
                )
              : Container(),
          widget.book.place.isNotEmpty ? Divider() : Container(),
          widget.book.place.isNotEmpty
              ? ListSection(
                  sectionTitle: 'PLACES',
                  children: horizontalDetailList(widget.book.place),
                )
              : Container(),
          widget.book.time.isNotEmpty ? Divider() : Container(),
          widget.book.time.isNotEmpty
              ? ListSection(
                  sectionTitle: 'TIME',
                  children: horizontalDetailList(widget.book.time),
                )
              : Container(),
          widget.book.person.isNotEmpty ? Divider() : Container(),
          widget.book.person.isNotEmpty
              ? ListSection(
                  sectionTitle: 'CHARACTERS',
                  children: horizontalDetailList(widget.book.person),
                )
              : Container(),
          widget.book.publisher.isNotEmpty ? Divider() : Container(),
          widget.book.publisher.isNotEmpty
              ? ListSection(
                  sectionTitle: 'PUBLISHERS',
                  children: horizontalDetailList(widget.book.publisher),
                )
              : Container(),
          widget.book.publishYear.isNotEmpty ? Divider() : Container(),
          widget.book.publishYear.isNotEmpty
              ? ListSection(
                  sectionTitle: 'YEARS PUBLISHED',
                  children: horizontalDetailListSorted(widget.book.publishYear),
                )
              : Container(),
          widget.book.links.isNotEmpty ? Divider() : Container(),
          widget.book.links.isNotEmpty
              ? ListSection(
                  sectionTitle: 'EXTERNAL LINKS',
                  children: listOfLinks(widget.book.links, context),
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
              child: Text(widget.newBook
                  ? widget.alreadyLogged
                      ? 'Already Logged'
                      : 'Add to your books'
                  : 'Update'),
              onPressed: () async {
                if (widget.newBook && !widget.alreadyLogged) {
                  String returnedString = await addToBooks(context);
                  if (returnedString != 'done') {
                    showMessageDialog(context, 'Error adding book',
                        'Could not add to my books. Please try again');
                  } else {
                    showMessageSnackBar(
                        context, widget.book.title + ' added to your books');
                    Navigator.popUntil(
                        context, (route) => !Navigator.canPop(context));
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyBooks()));
                  }
                } else if (!widget.newBook) {
                  String returnedString = await updateBook(context);
                  if (returnedString != 'done') {
                    showMessageDialog(context, 'Error updating book',
                        'Could not update book. Please try again');
                  } else {
                    showMessageSnackBar(
                        context, 'Updated ' + widget.book.title);
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ),
          SizedBox(height: 10),
          !widget.newBook
              ? Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: MaterialButton(
                    color: Colors.red,
                    child: Text('Remove from your books'),
                    onPressed: () async {
                      String returnedString = await removeBook(context);
                      if (returnedString != 'done') {
                        showMessageDialog(context, 'Error',
                            'Could not remove from my books. Please try again');
                      } else {
                        showMessageSnackBar(context,
                            widget.book.title + ' removed from your books');
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => MyBooks()));
                      }
                    },
                  ),
                )
              : Container(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Column writersColumn() {
    List<Widget> writers = [];

    if (widget.book.author.isNotEmpty) {
      for (int count = 0; count < widget.book.author.length; count++) {
        writers.add(
          Text(
            widget.book.author[count],
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
      widget.book.updateReview(reviewController.text);
    }
    widget.book.setDateAdded(DateTime.now());

    try {
      firestoreService.uploadBook(
          widget.book, authService.getCurrentUser().uid);
      return 'done';
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  // TODO: Cant update Review in firestore
  Future<String> updateBook(BuildContext context) async {
    AuthService authService = context.read<AuthService>();
    FirestoreService firestoreService = context.read<FirestoreService>();

    try {
      widget.book.updateReview(reviewController.text);
      firestoreService.updateBookReview(authService.getCurrentUser().uid,
          widget.documentId, reviewController.text);
      return 'done';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> removeBook(BuildContext context) async {
    AuthService authService = context.read<AuthService>();
    FirestoreService firestoreService = context.read<FirestoreService>();
    try {
      firestoreService.removeFromMyBooks(
          authService.getCurrentUser().uid, widget.documentId);
      return 'done';
    } catch (e) {
      return e.toString();
    }
  }
}
