import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/post.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0), // Added left padding
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Post details',
              style: TextStyle(
                fontWeight: FontWeight.bold, // Made text bold
              ),
            ),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        toolbarHeight: 60, // Slightly taller app bar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author with avatar
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Title section
            const Text(
              'Title:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(post.title, style: const TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 24),

            // Body section
            const Text(
              'body:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.body.replaceAll(r'\n', '\n'),
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // IDs section
            Row(
              children: [
                Text(
                  'POST ID:${post.id}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(width: 16),
                Text(
                  'USER ID:${post.userId}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
