import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager_maidss/features/tasks/task_model.dart';
import 'package:task_manager_maidss/utils/constants.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;
  DbService._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, Constants.dbTodos);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Constants.tableTodos}(
        id INTEGER PRIMARY KEY,
        todo TEXT,
        completed INTEGER,
        userId INTEGER
      )
    ''');
    print('created DB successfully');
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await database;
    await db.insert(Constants.tableTodos, todo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    final todos = await db.query(Constants.tableTodos);
    return todos.map((todo) => Todo.fromJson(todo)).toList();
  }

  Future<void> insertTodosBulk(List<Todo> todos) async {
    final db = await database;
    Batch batch = db.batch();

    for (Todo todo in todos) {
      batch.insert(
        Constants.tableTodos,
        todo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    await db.update(Constants.tableTodos, todo.toJson(),
        where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<void> deleteTodo(int id) async {
    final db = await database;
    await db.delete(Constants.tableTodos, where: 'id = ?', whereArgs: [id]);
  }
}
