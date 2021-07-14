import 'package:books_log/components/book_image.dart';
import 'package:books_log/models/book.dart';
import 'package:books_log/pages/search_page.dart';
import 'package:books_log/services/auth_service.dart';
import 'package:books_log/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBooks extends StatefulWidget {
  const MyBooks({Key? key}) : super(key: key);

  @override
  _MyBooksState createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final User user = context.read<AuthService>().getCurrentUser();
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Text(
              'My Books',
              style: TextStyle(fontSize: 25),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              Container(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: user.photoURL != null
                    ? Image.network(
                        user.photoURL!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthService>().signOut();
                  Navigator.popUntil(
                      context, (route) => !Navigator.canPop(context));
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: EdgeInsets.only(left: 8, right: 5),
                  margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search,
                        color:
                            Theme.of(context).iconTheme.color?.withOpacity(0.7),
                      ),
                      hintText: 'Search my books',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context)
                              .iconTheme
                              .color
                              ?.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: context
                        .read<FirestoreService>()
                        .myBooksStream(user.uid),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child:
                              Center(child: Text('Oops! Something went wrong')),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(child: Text("Loading...")),
                        );
                      }

                      if (snapshot.hasData) {
                        return GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.65,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            Book book = Book.fromJson(data);
                            return MyBooksImage(
                              book: book,
                              documentId: document.id,
                            );
                          }).toList(),
                        );
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(child: Text('No books added')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
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
}
