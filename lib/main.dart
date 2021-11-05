//import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:greenaction/wrapper.dart';
import 'package:provider/provider.dart';
import 'authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // await FirebaseAppCheck.instance
  //     .activate(webRecaptchaSiteKey: 'AIzaSyDQ6hFiuuR4mYLEAx6XmvMANjOXFt5_DK0');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CustomAuthentication>(create: (context) {
          return CustomAuthentication();
        }),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Wrapper(),
      ),
    );
  }
}
