import 'dart:ui';

class Promo {
  final String imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const Promo({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
