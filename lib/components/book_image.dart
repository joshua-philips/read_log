import 'package:books_log/models/book.dart';
import 'package:books_log/pages/book_details_page.dart';
import 'package:flutter/material.dart';

class BookImage extends StatelessWidget {
  final Book book;
  const BookImage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (context) => BookDetailsPage(book: book));
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
