import 'package:books_log/components/book_image.dart';
import 'package:books_log/components/horizontal_list.dart';
import 'package:books_log/components/my_drawer.dart';
import 'package:books_log/configuration/grid_settings.dart';
import 'package:books_log/models/book.dart';
import 'package:books_log/models/my_books.dart';
import 'package:books_log/pages/book_details_page.dart';
import 'package:books_log/pages/search_page.dart';
import 'package:books_log/services/auth_service.dart';
import 'package:books_log/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({Key? key}) : super(key: key);

  @override
  _MyBooksPageState createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  @override
  Widget build(BuildContext context) {
    final User user = context.read<AuthService>().getCurrentUser();
    return Scaffold(
      drawer: MyDrawer(currentPage: CurrentPage.MY_BOOKS),
      body: Scrollbar(
        thickness: 2,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: Text('My Books'),
              actions: [
                IconButton(
                  icon: Icon(context.watch<GridSettings>().myBooksGrid
                      ? Icons.list_rounded
                      : Icons.grid_on_rounded),
                  onPressed: () {
                    context.read<GridSettings>().toggleMyBooksGrid();
                  },
                )
              ],
              elevation: 0,
              floating: true,
              backgroundColor: Colors.transparent,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: context
                          .read<FirestoreService>()
                          .myBooksStream(user.uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Container(
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: Center(
                                child: Text('Oops! Something went wrong')),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: Center(child: Text("Loading...")),
                          );
                        }

                        if (snapshot.hasData) {
                          return snapshot.data!.docs.length > 0
                              ? body(snapshot, context)
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: Center(child: Text('No books added')),
                                );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        mini: true,
        child: Icon(Icons.add, color: Colors.white.withOpacity(0.7)),
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => SearchPage());
          Navigator.push(context, route);
        },
      ),
    );
  }

  Widget body(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, BuildContext context) {
    if (context.watch<GridSettings>().myBooksGrid) {
      return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.65,
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          Book book = Book.fromJson(data);
          context.read<MyBooks>().addToMyBooks(book.title, book.author.first);
          return MyBooksImage(
            book: book,
            documentId: document.id,
          );
        }).toList(),
      );
    } else {
      return ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          Book book = Book.fromJson(data);
          context.read<MyBooks>().addToMyBooks(book.title, book.author.first);
          return Card(
            margin: EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (context) =>
                      BookDetailsPage(book: book, documentId: document.id),
                );
                Navigator.push(context, route);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  children: [
                    BookImage(book: book),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: TextStyle(fontSize: 22),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: SizedBox(
                              height: 25,
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: writersRow(book.author),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    }
  }
}
