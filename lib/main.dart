import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      future: _initialization,
      builder: (context, futureSnapshot) {
        return MaterialApp(
          title: 'Flutter Chat',
          theme: ThemeData(
            primarySwatch: Colors.pink,
            accentColor: Colors.deepPurple,
            backgroundColor: Colors.pink,
            accentColorBrightness: Brightness.dark,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 25, vertical: 10)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              ),
            ),
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.yellow,
              textTheme: ButtonTextTheme.primary,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          darkTheme: ThemeData.dark(),
          home: futureSnapshot.connectionState != ConnectionState.done ? SplashScreen() : StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return snapshot.hasData ? ChatScreen() : AuthScreen();
            }
          ),
        );
      }
    );
  }
}
