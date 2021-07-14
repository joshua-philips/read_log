import 'package:books_log/components/image_dialog.dart';
import 'package:books_log/models/book.dart';
import 'package:books_log/pages/book_details_page.dart';
import 'package:flutter/material.dart';

class MyBooksImage extends StatelessWidget {
  final Book book;
  final String documentId;
  const MyBooksImage({Key? key, required this.book, required this.documentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (context) => BookDetailsPage(
                  book: book,
                  documentId: documentId,
                ));
        Navigator.push(context, route);
      },
      child: Container(
        height: 180,
        width: 90,
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
    );
  }
}

class BookImageToDialog extends StatelessWidget {
  final Book book;
  const BookImageToDialog({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}

class BookImage extends StatelessWidget {
  final Book book;
  const BookImage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 70,
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
    );
  }
}
