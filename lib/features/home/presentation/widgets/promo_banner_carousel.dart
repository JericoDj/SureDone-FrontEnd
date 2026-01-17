import 'dart:async';
import 'package:flutter/material.dart';

import '../../domain/entities/promo.dart';

class PromoBannerCarousel extends StatefulWidget {
  final List<Promo> promos;
  final double height; // optional override
  final Duration autoPlayInterval;

  const PromoBannerCarousel({
    super.key,
    required this.promos,
    this.height = 160,
    this.autoPlayInterval = const Duration(seconds: 4),
  });

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  late final PageController _pageController;
  late int _currentIndex;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController(viewportFraction: 0.92, initialPage: 0);

    if (widget.promos.length > 1) {
      _autoTimer = Timer.periodic(widget.autoPlayInterval, (_) {
        final next = (_currentIndex + 1) % widget.promos.length;
        if (mounted) {
          _pageController.animateToPage(
            next,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double resolvedHeight = widget.height;
    final promos = widget.promos;

    if (promos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Promotions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: resolvedHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: promos.length,
            onPageChanged: (idx) {
              setState(() => _currentIndex = idx);
            },
            itemBuilder: (context, index) {
              final promo = promos[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: promo.onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Row(
                      children: [
                        // image (left) - keeps aspect ratio and fills vertically
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: _buildImage(promo.imageUrl),
                        ),

                        // text area
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  promo.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  promo.subtitle,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                // CTA
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Use Now',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // Dots indicator
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(promos.length, (i) {
              final isActive = i == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                  isActive ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String path) {
    // simple heuristic: treat as network if starts with http
    if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
        return Container(color: Colors.grey.shade200);
      });
    }

    // else assume asset
    return Image.asset(path, fit: BoxFit.cover);
  }
}
