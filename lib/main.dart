import 'package:books_log/configuration/grid_settings.dart';
import 'package:books_log/models/my_books.dart';
import 'package:books_log/models/my_reading_list.dart';
import 'package:books_log/pages/authentication_pages/login_page.dart';
import 'package:books_log/pages/my_books_page.dart';
import 'package:books_log/services/auth_service.dart';
import 'package:books_log/services/firestore_service.dart';
import 'package:books_log/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Text('Error');
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return MaterialApp(
        title: 'Read Log',
        home: LoadingScreen(),
      );
    }

    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        Provider<StorageService>(create: (_) => StorageService()),
        ChangeNotifierProvider<MyBooks>(
            create: (_) => MyBooks(myBooksTitles: [], myBooksAuthors: [])),
        ChangeNotifierProvider<MyReadingList>(
            create: (_) => MyReadingList(
                myReadingListAuthors: [], myReadingListTitles: [])),
        ChangeNotifierProvider<GridSettings>(create: (_) => GridSettings()),
      ],
      builder: (context, child) => MaterialApp(
        title: 'Read Log',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.grey[900],
          accentColor: Colors.green,
          scaffoldBackgroundColor: Colors.grey[900],
          indicatorColor: Colors.green,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.green,
          ),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            },
          ),
          dividerTheme: DividerThemeData(thickness: 1.5),
        ),
        home: HomeController(),
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  const HomeController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<AuthService>().onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return MyBooksPage();
          } else {
            return LoginPage();
          }
        }
        return LoadingScreen();
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          scale: 2,
          filterQuality: FilterQuality.none,
        ),
      ),
    );
  }
}
