import 'package:books_log/pages/search_page.dart';
import 'package:books_log/services/auth_service.dart';
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
                  margin: EdgeInsets.all(12),
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
                Container(
                  child:
                      context.read<AuthService>().getCurrentUser().photoURL !=
                              null
                          ? Image.network(
                              context
                                  .read<AuthService>()
                                  .getCurrentUser()
                                  .photoURL!,
                              errorBuilder: (context, error, stackTrace) =>
                                  Text('Error'),
                            )
                          : Container(),
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
