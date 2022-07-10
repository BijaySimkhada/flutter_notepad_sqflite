import 'package:bee_note_fy/local_storage/model/NoteModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseService {
  var database;

  //database connection
  Future<Database> initDB() async {
    database = openDatabase(join(await getDatabasesPath(), 'beeNote.db'),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE notes( id INTEGER PRIMARY KEY, title TEXT, content TEXT, createdAt TEXT, updatedAt TEXT)');
      db.execute(
          'CREATE TABLE reminder( id INTEGER PRIMARY KEY, date TEXT, time TEXT , title TEXT, payload TEXT)');
    }, version: 1);
    if (database != null) {
      print('successfully connected to the db');
      return database;
    } else {
      print('unable to connect to the db');
      return database;
    }
  }

  //create Note
  Future<void> createNote(NoteModel note) async {
    final Database db = await initDB();
    var result = db.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NoteModel>> getNotes() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> queryResult = await db.query('notes');
    return List.generate(
        queryResult.length,
        (index) => NoteModel(
            queryResult[index]['id'],
            queryResult[index]['title'],
            queryResult[index]['content'],
            queryResult[index]['createdAt'],
            queryResult[index]['updatedAt']));
  }

  Future<NoteModel> getNote(int id) async {
    final Database db = await initDB();
    var note = await db.rawQuery('SELECT * FROM notes WHERE id = $id');
    NoteModel noteModel = NoteModel(
        note[0]['id'] as int,
        note[0]['title'] as String,
        note[0]['content'] as String,
        note[0]['createdAt'] as String,
        note[0]['updatedAt'] as String);
    return noteModel;
  }

  Future<int> deleteNote(int id) async {
    final Database db = await initDB();
    var result = await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    return result;
  }
}
