import 'package:books_log/pages/reading_list_page.dart';
import 'package:books_log/pages/search_page.dart';
import 'package:books_log/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum CurrentPage { SEARCH, PROFILE, MY_BOOKS, READING_LIST }

class MyDrawer extends StatelessWidget {
  final CurrentPage currentPage;
  const MyDrawer({Key? key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = context.read<AuthService>().getCurrentUser();
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(80),
                    child: CircleAvatar(
                      foregroundImage: NetworkImage(user.photoURL!),
                      radius: 70,
                      onForegroundImageError: (exception, stackTrace) =>
                          Text(user.displayName![0]),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.displayName!,
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 10),
                  Text(user.email!, style: TextStyle(fontSize: 18)),
                ],
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.search),
                title: Text('Search and add', style: TextStyle(fontSize: 20)),
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                horizontalTitleGap: 0,
                onTap: () {
                  Route route =
                      MaterialPageRoute(builder: (context) => SearchPage());
                  Navigator.pop(context);
                  if (currentPage != CurrentPage.SEARCH) {
                    Navigator.push(context, route);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.person_rounded),
                title: Text('Profile', style: TextStyle(fontSize: 20)),
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                horizontalTitleGap: 0,
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.book_rounded),
                title: Text('My Books', style: TextStyle(fontSize: 20)),
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                horizontalTitleGap: 0,
                onTap: () {
                  Navigator.popUntil(
                      context, (route) => !Navigator.canPop(context));
                },
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Reading List', style: TextStyle(fontSize: 20)),
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                horizontalTitleGap: 0,
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => ReadingListPage());
                  Navigator.pop(context);
                  if (currentPage != CurrentPage.READING_LIST) {
                    Navigator.push(context, route);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.lock_rounded),
                title: Text('Log Out', style: TextStyle(fontSize: 20)),
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                horizontalTitleGap: 0,
                onTap: () async {
                  await context.read<AuthService>().signOut();
                  Navigator.popUntil(
                      context, (route) => !Navigator.canPop(context));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
