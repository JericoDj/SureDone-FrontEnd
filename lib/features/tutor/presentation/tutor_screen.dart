import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suredone/features/tutor/domain/tutor_models.dart';

class TutorScreen extends StatelessWidget {
  const TutorScreen({super.key});

  static final List<Tutor> _tutors = [
    Tutor(
      id: "1",
      name: "Maria Santos",
      avatarUrl: "https://via.placeholder.com/150",
      subjects: ["Math", "Algebra", "Geometry"],
      pricePerHour: 350.0,
      rating: 4.9,
      about: "I am a licensed professional teacher with 5 years of experience in teaching Mathematics to High School students. I specialize in making complex math concepts easy to understand.",
      achievements: [
        "Licensed Professional Teacher (LPT)",
        "Top 5 in Board Exam",
        "Best in Math Awardee"
      ],
      availability: ["Mon", "Wed", "Fri", "Sat"],
      reviews: [
        Review(userName: "John D.", comment: "Very patient and clear!", rating: 5.0, date: "2 days ago"),
        Review(userName: "Sarah M.", comment: "Helped my son pass his finals.", rating: 5.0, date: "1 week ago"),
      ],
    ),
    Tutor(
      id: "2",
      name: "Juan Reyes",
      avatarUrl: "https://via.placeholder.com/150",
      subjects: ["Science", "Physics", "Chemistry"],
      pricePerHour: 400.0,
      rating: 4.7,
      about: "Passionate about science and technology. I have a degree in Physics and have been tutoring college students for 3 years.",
      achievements: [
        "BS Physics Graduate",
        "Science Quiz Bee Champion Coach"
      ],
      availability: ["Tue", "Thu", "Sun"],
      reviews: [
        Review(userName: "Mike T.", comment: "Great explanations for physics problems.", rating: 4.5, date: "3 days ago"),
      ],
    ),
    Tutor(
      id: "3",
      name: "Ana Cruz",
      avatarUrl: "https://via.placeholder.com/150",
      subjects: ["English", "Creative Writing", "ESL"],
      pricePerHour: 300.0,
      rating: 4.8,
      about: "Experienced English teacher offering lessons in grammar, writing, and conversation. Perfect for students wanting to improve their communication skills.",
      achievements: [
        "TESOL Certified",
        "Published Writer"
      ],
      availability: ["Mon", "Tue", "Thu", "Fri"],
      reviews: [
        Review(userName: "Lisa K.", comment: "My writing improved so much!", rating: 5.0, date: "5 days ago"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find a Tutor")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tutors.length,
        itemBuilder: (context, index) {
          final tutor = _tutors[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: () {
                context.push('/tutor/details', extra: tutor);
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(tutor.avatarUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tutor.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: tutor.subjects.take(3).map((s) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(s, style: TextStyle(fontSize: 10, color: Theme.of(context).primaryColor)),
                            )).toList(),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(" ${tutor.rating}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              const Spacer(),
                              Text("₱${tutor.pricePerHour}/hr", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
