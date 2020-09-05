import 'package:flutter/material.dart';

import 'Home.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        cursorColor: Colors.deepOrangeAccent,
        textTheme: TextTheme(
          button: TextStyle(
            fontFamily: 'OpenSans',
          ),
        ),

      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
