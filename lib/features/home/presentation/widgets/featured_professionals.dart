import 'package:flutter/material.dart';

class FeaturedProfessionalsWidget extends StatelessWidget {
  const FeaturedProfessionalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final professionals = [
      {
        "name": "Maria Santos",
        "service": "Home Cleaning",
        "rating": 4.9,
        "image": "https://randomuser.me/api/portraits/women/44.jpg",
      },
      {
        "name": "John Rivera",
        "service": "Fitness Coach",
        "rating": 5.0,
        "image": "https://randomuser.me/api/portraits/men/32.jpg",
      },
      {
        "name": "Grace Lim",
        "service": "Pet Grooming",
        "rating": 4.8,
        "image": "https://randomuser.me/api/portraits/women/48.jpg",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: EdgeInsets.symmetric(horizontal: 16,),
          child: Text(
            "Featured Professionals",
            style: TextStyle(
              fontSize: MediaQuery.sizeOf(context).height * .020,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10,),

        SizedBox(
          height: MediaQuery.sizeOf(context).height * .21,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: professionals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final pro = professionals[index];

              return _ProfessionalCard(
                name: pro["name"] as String,
                service: pro["service"] as String,
                rating: pro["rating"] as double,
                imageUrl: pro["image"] as String,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  final String name;
  final String service;
  final double rating;
  final String imageUrl;

  const _ProfessionalCard({
    super.key,
    required this.name,
    required this.service,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(

          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(rating.toString()),
              ],
            ),

            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              service,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 10,),



            // ACTION BUTTON
            GestureDetector(
              onTap: () {
                // TODO: Navigate to provider profile or booking
              },
              child: Container(
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Book",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
