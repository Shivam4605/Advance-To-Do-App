import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HelperDatabase {
  Future<Database> createDB() async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), "TODODB.db"),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          create table todo(
            id integer primary key autoincrement,
            title text,
            description text,
            date text,
            iscompletedcheck integer
          )
      ''');
      },
    );
    return database;
  }

  Future<List<Map>> gettododata() async {
    Database localDB = await createDB();
    List<Map> list = await localDB.query("todo");
    return list;
  }

  Future insertdata(Map<String, dynamic> obj) async {
    Database localDB = await createDB();
    await localDB.insert(
      "todo",
      obj,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatetododata(Map<String, dynamic> obj) async {
    Database localDB = await createDB();
    await localDB.update(
      "todo",
      obj,
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: "id=?",
      whereArgs: [obj['id']],
    );
  }

  Future<void> deletetdata(int id) async {
    Database localDB = await createDB();
    await localDB.delete("todo", where: "id=?", whereArgs: [id]);
  }
}
