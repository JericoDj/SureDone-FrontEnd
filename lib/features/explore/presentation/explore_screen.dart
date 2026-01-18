import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/explore/domain/blog_model.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<BlogPost> posts = [
      const BlogPost(
        id: '1',
        title: 'Choosing the Right Tutor for Your Child',
        snippet:
            'Find out what qualities to look for when selecting a tutor to ensure your child gets the best learning experience.',
        content: """
<p>Finding the right tutor can be a daunting task. You want someone who is not only knowledgeable but also patient and capable of connecting with your child.</p>
<h3>1. Qualifications Matter</h3>
<p>Ensure the tutor has the necessary academic background. For math, look for someone with a degree in mathematics or engineering.</p>
<h3>2. Teaching Style</h3>
<p>Every child learns differently. Ask for a trial session to see if the tutor's style matches your child's learning pace.</p>
<h3>3. Reviews and Ratings</h3>
<p>Check reviews from other parents on SureDone. High ratings usually indicate reliability and effectiveness.</p>
""",
        imageUrl:
            'https://images.unsplash.com/photo-1544717305-2782549b5136?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        author: 'Teacher Anna',
        date: 'Jan 15, 2024',
        category: 'Education',
      ),
      const BlogPost(
        id: '2',
        title: '5 Tips for a Spotless Living Room',
        snippet:
            'Quick and effective cleaning hacks to keep your living area welcoming and dust-free.',
        content: """
<p>Your living room is where you relax and entertain. Keep it fresh with these tips:</p>
<ul>
<li><strong>Declutter First:</strong> Remove items that don't belong.</li>
<li><strong>Top to Bottom:</strong> Dust ceiling fans and shelves before vacuuming the floor.</li>
<li><strong>Fresh Air:</strong> Open windows to let fresh air circulate.</li>
</ul>
<p>Don't have time? Book a cleaner on SureDone today!</p>
""",
        imageUrl:
            'https://images.unsplash.com/photo-1527515545081-5db817172677?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        author: 'Maria Santos',
        date: 'Jan 12, 2024',
        category: 'Home Care',
      ),
      const BlogPost(
        id: '3',
        title: 'Why Regular AC Maintenance Saves Money',
        snippet:
            'Learn how a simple cleaning service can lower your electricity bill and extend the life of your air conditioner.',
        content: """
<p>Is your electric bill shooting up? A dirty AC might be the culprit.</p>
<p>When filters and coils are clogged, your unit works harder to cool the room, consuming more energy. Regular cleaning every 3-6 months can save you up to 30% on energy costs and prevent costly repairs down the line.</p>
""",
        imageUrl:
            'https://plus.unsplash.com/premium_photo-1664302152996-2292f7253503?q=80&w=2938&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        author: 'Ben\'s Repairs',
        date: 'Jan 10, 2024',
        category: 'Maintenance',
      ),
      const BlogPost(
        id: '4',
        title: 'How SureDone Keeps You Safe',
        snippet:
            'We prioritize your safety. Read about our vetting process and safety guidelines for all bookings.',
        content: """
<p>At SureDone, trust is our currency.</p>
<h3>Vetted Professionals</h3>
<p>All service providers undergo strict background checks and skill assessments before joining our platform.</p>
<h3>Secure Payments</h3>
<p>Your transactions are protected. We hold payments until the service is satisfactorily completed.</p>
""",
        imageUrl:
            'https://images.unsplash.com/photo-1573164713988-8665fc963095?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        author: 'SureDone Team',
        date: 'Jan 05, 2024',
        category: 'Community',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        separatorBuilder: (ctx, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          return _BlogCard(post: posts[index]);
        },
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  final BlogPost post;

  const _BlogCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/explore/detail', extra: post);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(color: Colors.grey[200]);
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          post.category,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post.date,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.snippet,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          post.author[0],
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post.author,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
