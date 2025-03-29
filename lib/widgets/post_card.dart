import 'package:flutter/material.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.user != null)
                Text(
                  'Author: ${post.user!.name}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                post.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
