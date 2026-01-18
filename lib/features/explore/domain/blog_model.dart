class BlogPost {
  final String id;
  final String title;
  final String snippet;
  final String content;
  final String imageUrl;
  final String author;
  final String date;
  final String category;

  const BlogPost({
    required this.id,
    required this.title,
    required this.snippet,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.date,
    required this.category,
  });
}
