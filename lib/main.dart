import 'package:flutter/material.dart';

import 'pages/notes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
          primaryColor: Colors.orange,
          appBarTheme: AppBarTheme(
              //primarySwatch: Colors.blue,
              )),
      home: NotesPage(title: 'eNotes'),
    );
  }
}