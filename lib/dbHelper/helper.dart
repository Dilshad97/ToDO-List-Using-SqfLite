import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todolist/model/notes.dart';

class DatabaseHelper {
  static const _databaseName = "Database.db";
  static const _databaseVersion = 1;
  static const table = "ToDo";
  static const columnId = '_id';
  static const columnTittle = "tittle";
  static const columnDescription = "Description";
  static const columnisChecked = "isChecked";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  /// CHECKING DATABASE IS NULL OR NOT
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  /// INITIALIZING DATABASE
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  /// CREATING TABLE
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTittle TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnisChecked INTEGER 
            
          )
          ''');
  }

  /// INSERTING TO DATABASE
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  /// QUERYING OR FETCHING FROM DATABASE
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  ///UPDATING DATABASE

  Future updateTable(Map<String, dynamic> row, Notes notes) async {
    Database db = await instance.database;
    return await db.update(DatabaseHelper.table, row,
        where: '${DatabaseHelper.columnId}= ?', whereArgs: [notes.id]);
  }

  /// DELETING FROM DATABASE

  Future deleteTable(Map<String, dynamic> row, Notes notes) async {
    Database db = await instance.database;
    return await db.delete(DatabaseHelper.table,
        where: '${DatabaseHelper.columnId}= ?', whereArgs: [notes.id]);
  }
}
