import 'package:flutter/material.dart';
import '../models/post.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Added author section
            if (post.user != null) ...[
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  post.user!.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(post.user!.email),
              ),
              const Divider(),
            ],
            Text(
              post.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              post.body.replaceAll('\n', '\n\n'),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Post ID: ${post.id}')),
                Chip(label: Text('User ID: ${post.userId}')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
