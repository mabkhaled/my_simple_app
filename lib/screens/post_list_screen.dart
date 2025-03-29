import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import '../models/post.dart';
import '../services/api_service.dart';
import 'login_screen.dart'; // Your login screen
import 'post_detail_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<List<Post>> _postsFuture;
  final ApiService _apiService = ApiService();
  List<Post> _allPosts = [];
  List<Post> _filteredPosts = [];
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 1;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _postsFuture = _loadPosts();
    _searchController.addListener(() {
      _searchPosts(_searchController.text);
    });
  }

  Future<List<Post>> _loadPosts() async {
    try {
      _allPosts = await _apiService.fetchPostsWithUsers();
      _filteredPosts = _allPosts;
      return _allPosts;
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  void _searchPosts(String query) {
    setState(() {
      _filteredPosts =
          _allPosts.where((post) {
            final titleMatch = post.title.toLowerCase().contains(
              query.toLowerCase(),
            );
            final bodyMatch = post.body.toLowerCase().contains(
              query.toLowerCase(),
            );
            final authorMatch =
                post.user?.name.toLowerCase().contains(query.toLowerCase()) ??
                false;
            return titleMatch || bodyMatch || authorMatch;
          }).toList();
    });
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: null),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Browser posts',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/ServerError.svg',
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Failed to load posts',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: _filteredPosts.length,
                  itemBuilder: (context, index) {
                    final post = _filteredPosts[index];
                    return _buildPostCard(post, context);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/home.svg',
              width: 33,
              height: 33,
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? Colors.blue : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/posts.svg',
              width: 33,
              height: 33,
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? Colors.blue : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/explore.svg',
              width: 33,
              height: 33,
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? Colors.blue : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/account.svg',
              width: 33,
              height: 33,
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? Colors.blue : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Post post, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(post: post),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/User.svg',
                    width: 48,
                    height: 48,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    post.user?.name ?? 'Unknown Author',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                post.body,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/post-icon.svg',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'POST ID: ${post.id}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(post: post),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Detail',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
