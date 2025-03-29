import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import 'database_helper.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Post>> fetchPostsWithUsers({bool forceRefresh = false}) async {
    try {
      final posts = await _fetchFromAPI();
      await _dbHelper.cachePosts(posts);
      return posts;
    } catch (e) {
      final cachedPosts = await _dbHelper.getCachedPosts();
      if (cachedPosts.isNotEmpty) return cachedPosts;
      throw Exception('Failed to load: $e');
    }
  }

  Future<List<Post>> _fetchFromAPI() async {
    try {
      final responses = await Future.wait([
        http.get(Uri.parse('$_baseUrl/posts')),
        http.get(Uri.parse('$_baseUrl/users')),
      ]);

      final postsResponse = responses[0];
      final usersResponse = responses[1];

      if (postsResponse.statusCode != 200 || usersResponse.statusCode != 200) {
        throw Exception(
          'Posts: ${postsResponse.statusCode}, Users: ${usersResponse.statusCode}',
        );
      }

      final List<dynamic> postsData = json.decode(postsResponse.body);
      final List<dynamic> usersData = json.decode(usersResponse.body);

      final users = usersData.map((json) => User.fromJson(json)).toList();

      return postsData.map((postJson) {
        final post = Post.fromJson(postJson);
        final user = users.firstWhere(
          (user) => user.id == post.userId,
          orElse: () => User(id: -1, name: 'Unknown', email: ''),
        );
        return Post(
          id: post.id,
          userId: post.userId,
          title: post.title,
          body: post.body,
          user: user.id != -1 ? user : null,
        );
      }).toList();
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }
}
