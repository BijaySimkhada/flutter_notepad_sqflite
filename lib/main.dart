import 'package:bee_note_fy/Screen/Note/createNote.dart';
import 'package:bee_note_fy/local_storage/service/NoteDatabaseService.dart';
import 'package:bee_note_fy/routeHelper/Helper.dart';
import 'package:flutter/material.dart';
import 'Screen/List/ListNote.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DataBaseService db = DataBaseService();
  db.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // home: ListNoteScreen(),
      navigatorObservers: [Helper.routeObserver],
      routes: {
        '/': (context) => ListNoteScreen(),
        '/create-note': (context) => CreateNoteScreen(),
      },
    );
  }
}
