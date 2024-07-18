// ignore_for_file: unnecessary_string_interpolations

import 'package:appsqflite/models/task.dart';
import 'package:appsqflite/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "userTasks.db";

  static Future<Database> _getDb() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: ((db, version) async {
      // ignore: prefer_interpolation_to_compose_strings
      await db.execute('''
          CREATE TABLE Users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email VARCHAR(50) NOT NULL,
            user VARCHAR(20) NOT NULL,
            password VARCHAR(20) NOT NULL,
            token VARCHAR(4),
            tokenDuration VARCHAR(20)
          );
          ''');
      // Devido à versão atual do sqflite não suportar BOOL o status será armazenado como INTEGER (0/1)
      await db.execute('''
          CREATE TABLE Tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            title VARCHAR(30) NOT NULL,
            description TEXT,
            dueTime DATETIME NOT NULL,
            status INTEGER NOT NULL,
            lastAltered DATETIME NOT NULL,
            FOREIGN KEY (user_id) REFERENCES Users (id)
          );
          ''');
      await db.execute('''
          CREATE TABLE States(
            state TINYINT PRIMARY KEY,
            currentUser_id INT
          );
          ''');
      await db.execute(
          "INSERT INTO States (state, currentUser_id) VALUES (0, NULL);");
    }), version: _version);
  }

  // *Remake Database
  static Future<void> deleteDatabase() async =>
      databaseFactory.deleteDatabase(join(await getDatabasesPath(), _dbName));

  // ... CRUD User ...

  static Future insertUser(User user) async {
    final db = await _getDb();
    return await db.execute(
        "INSERT INTO Users (email, user, password) VALUES ('${user.email}', '${user.user}', '${user.password}');");
  }

  /*
  // NO_CURRENT_USE
  static Future updateUser(User user) async {
    final db = await _getDb();
    return await db.update(
      "Users",
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  */

  /*
  // NO_CURRENT_USE
  static Future deleteUser(User user) async {
    final db = await _getDb();
    return await db.delete(
      "Users",
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
  */

  static Future updatePassword(String password, int id) async {
    final db = await _getDb();
    await db.rawUpdate(
        "UPDATE Users SET password = ?, token = ?, tokenDuration = ? WHERE id = ?",
        ['$password', '', 'used', id]);
    return;
  }

  static Future<bool> checkDbforEmail(String email) async {
    final db = await _getDb();
    final query =
        await db.query('Users', where: 'email = ?', whereArgs: [email]);

    if (query.isEmpty) return false;
    return true;
  }

  static Future<bool> checkDbforUser(String username) async {
    final db = await _getDb();
    final query =
        await db.query('Users', where: 'user = ?', whereArgs: [username]);

    if (query.isEmpty) return false;
    return true;
  }

  static Future<User> selectUserByUsername(String username) async {
    final db = await _getDb();

    final query =
        await db.query('Users', where: 'user = ?', whereArgs: [username]);

    return User.fromJson(query.first);
  }

  static Future<String> selectUserById(int id) async {
    final db = await _getDb();

    final query =
        await db.rawQuery("SELECT user FROM Users WHERE id = ?", [id]);

    return query.first['user'] as String;
  }

  static Future<int?> selectUserByEmail(String email) async {
    final db = await _getDb();

    final query =
        await db.query('Users', where: 'email = ?', whereArgs: [email]);
    int? result = User.fromJson(query.first).id;

    return result;
  }

  static Future changeLoginState(int? id) async {
    final db = await _getDb();
    await db.rawUpdate(
        "UPDATE States SET currentUser_id = ? WHERE state = ?", [id, 0]);
  }

  static Future<int> getCurrentUserId() async {
    final db = await _getDb();

    final query = await db
        .rawQuery("SELECT currentUser_id FROM States WHERE state = ?", [0]);

    return query.first['currentUser_id'] as int;
  }

  /*
  // NO_CURRENT_USE
  static Future<List<User>?> selectAllUsers() async {
    final db = await _getDb();
    final List<Map<String, dynamic>> table = await db.query('Users');

    if (table.isEmpty) {
      return null;
    }

    return List.generate(table.length, (index) => User.fromJson(table[index]));
  }
  */

  static Future<String> generateToken(String email) async {
    const int digitsInToken = 4;
    int power10 = 10 ^ digitsInToken;

    Random random = Random();
    int randomNumber = random.nextInt(power10);
    String token = randomNumber.toString();
    if (token.length < 4) {
      String temp = "";
      for (int i = token.length; i < 4; i++) {
        temp += "0";
      }
      for (int i = 0; i < token.length; i++) {
        temp += token[i];
      }
      token = temp;
    }

    DateTime now = DateTime.now();
    Duration duration = const Duration(minutes: 30);
    DateTime tokenExpiration = now.add(duration);

    String tokenDuration = tokenExpiration
        .toString()
        .substring(0, 19)
        .replaceAll(RegExp(r"[ :.]"), "-");

    final db = await _getDb();
    final String sql =
        "UPDATE Users SET token = '$token', tokenDuration = '$tokenDuration' WHERE email = '$email';";
    await db.execute(sql);

    return token;
  }

  // ... CRUD Task ...

  static Future insertTask(Task task) async {
    int userId = await getCurrentUserId();

    String now = DateTime.now().toString().substring(0, 19);
    String dueTime = task.dueTime.toString().substring(0, 19);

    String? description;
    if (task.description != null) description = "'${task.description}'";

    int status = 0;
    if (task.status) status = 1;

    final db = await _getDb();
    return await db.rawInsert(
        "INSERT INTO Tasks(user_id, title, description, dueTime, status, lastAltered) VALUES($userId, '${task.title}', $description, '$dueTime', $status, '$now')");
  }

  static Future updateTask(Task task) async {
    String now = DateTime.now().toString().substring(0, 19);
    String dueTime = task.dueTime.toString().substring(0, 19);

    String? description;
    if (task.description != null) description = "${task.description}";

    int status = 0;
    if (task.status) status = 1;

    final db = await _getDb();
    return await db.rawUpdate(
        "UPDATE Tasks SET title = ?, description = ?, dueTime = ?, status = ?, lastAltered = ? WHERE id = ?",
        ['${task.title}', description, '$dueTime', status, '$now', task.id]);
  }

  static Future checkTask(int id, bool value) async {
    int status = 0;
    if (value) status = 1;
    final db = await _getDb();
    return await db
        .rawUpdate("UPDATE Tasks SET status = ? WHERE id = ?", [status, id]);
  }

  static Future deleteTask(int id) async {
    final db = await _getDb();
    return await db.delete(
      "Tasks",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<Task> getTask(int id) async {
    final db = await _getDb();
    final List<Map<String, dynamic>> query =
        await db.query("Tasks", where: "id = ?", whereArgs: [id]);
    return Task.fromJson(query.first);
  }

  static Future<List<Task>?> selectAllTasksFromCurrentUser() async {
    int userId = await getCurrentUserId();
    final db = await _getDb();
    final List<Map<String, dynamic>> table = await db.query('Tasks',
        where: 'user_id = ?', whereArgs: [userId], orderBy: 'lastAltered DESC');

    if (table.isEmpty) {
      return null;
    }
    return List.generate(table.length, (index) => Task.fromJson(table[index]));
  }
}
