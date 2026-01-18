import 'package:flutter/material.dart';
import 'package:suredone/features/explore/domain/blog_model.dart';

// Note: For real HTML rendering we would use flutter_html,
// but for now we will just display the text or simple parsing.
// To keep no deps issues, I'll strip simple tags if needed or just show the string if content is simple.

class BlogDetailScreen extends StatelessWidget {
  final BlogPost post;

  const BlogDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                post.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          post.category,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post.date,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[300],
                        child: Text(post.author[0]),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Written by",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          Text(
                            post.author,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 40),

                  // Simple Content Renderer
                  _SimpleHtmlRenderer(content: post.content),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// A very basic widget to render the text content, removing basic tags for cleaner text
// or could handle simple styling if we wanted to expand.
class _SimpleHtmlRenderer extends StatelessWidget {
  final String content;

  const _SimpleHtmlRenderer({required this.content});

  @override
  Widget build(BuildContext context) {
    // This is a placeholder. Real apps use flutter_widget_from_html or flutter_html.
    // For this prototype, we'll strip HTML or just display it cleanly.
    // Let's doing a manual parse for key tags to make it look decent without deps.

    // Split by lines or simple tags
    final parts = content
        .replaceAll('</p>', '\n\n')
        .replaceAll('<p>', '')
        .replaceAll('<ul>', '')
        .replaceAll('</ul>', '')
        .replaceAll('</li>', '\n')
        .replaceAll('<li>', '• ');

    // Remove other tags
    final cleanText = parts.replaceAll(RegExp(r'<[^>]*>'), '');

    return Text(
      cleanText.trim(),
      style: TextStyle(fontSize: 16, height: 1.8, color: Colors.grey[800]),
    );
  }
}
