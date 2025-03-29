import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/post.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'posts.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts(
        id INTEGER PRIMARY KEY,
        userId INTEGER,
        title TEXT,
        body TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT
      )
    ''');
  }

  Future<void> cachePosts(List<Post> posts) async {
    final db = await database;
    final batch = db.batch();

    // Clear old data first
    await clearCache();

    // Insert new data
    for (final post in posts) {
      batch.insert(
        'posts',
        post.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (post.user != null) {
        batch.insert(
          'users',
          post.user!.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    await batch.commit();
  }

  // Add this clearCache method
  Future<void> clearCache() async {
    final db = await database;
    await db.delete('posts');
    await db.delete('users');
  }

  Future<List<Post>> getCachedPosts() async {
    final db = await database;
    final posts = await db.query('posts');
    final users = await db.query('users');

    return posts.map((post) {
      final userMap = users.firstWhere(
        (user) => user['id'] == post['userId'],
        orElse: () => {},
      );
      return Post(
        id: post['id'] as int,
        userId: post['userId'] as int,
        title: post['title'] as String,
        body: post['body'] as String,
        user: userMap.isNotEmpty ? User.fromJson(userMap) : null,
      );
    }).toList();
  }
}
