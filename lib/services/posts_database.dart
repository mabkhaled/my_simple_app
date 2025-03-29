import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/post.dart';

class PostsDatabase {
  static final PostsDatabase instance = PostsDatabase._init();
  static Database? _database;

  PostsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('posts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Incremented version
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY,
        userId INTEGER,
        title TEXT,
        body TEXT,
        cached_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE posts ADD COLUMN cached_at TEXT');
    }
  }

  Future<void> cachePosts(List<Post> posts) async {
    final db = await database;
    final batch = db.batch();

    // Clear old data
    await db.delete('posts');
    await db.delete('users');

    // Insert new data
    final timestamp = DateTime.now().toIso8601String();
    for (final post in posts) {
      batch.insert('posts', {...post.toJson(), 'cached_at': timestamp});

      if (post.user != null) {
        batch.insert('users', post.user!.toJson());
      }
    }

    await batch.commit();
  }

  Future<List<Post>> getCachedPosts() async {
    final db = await database;
    final posts = await db.query('posts');
    final users = await db.query('users');

    return posts.map((postJson) {
      final post = Post.fromJson(postJson);
      final user = users.firstWhere(
        (user) => user['id'] == post.userId,
        orElse: () => {},
      );
      post.user = user.isNotEmpty ? User.fromJson(user) : null;
      return post;
    }).toList();
  }

  Future<DateTime?> getLastCacheTime() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT cached_at FROM posts ORDER BY cached_at DESC LIMIT 1',
    );
    return result.isNotEmpty && result.first['cached_at'] != null
        ? DateTime.parse(result.first['cached_at'] as String)
        : null;
  }

  Future<int> clearCache() async {
    final db = await database;
    return await db.delete('posts');
  }
}
